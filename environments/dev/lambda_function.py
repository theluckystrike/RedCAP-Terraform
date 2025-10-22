"""
REDCap Data Ingestion Lambda with Automatic Carbone Document Generation
Processes Excel files and automatically triggers document generation for new records
"""

import os
import boto3
import pandas as pd
import psycopg2
from psycopg2.extras import execute_batch
import json
import logging
import re
from datetime import datetime

logger = logging.getLogger()
if not logger.hasHandlers():
    handler = logging.StreamHandler()
    logger.addHandler(handler)
logger.setLevel(logging.INFO)


def sanitize_and_truncate(name, used_names):
    """
    Clean and truncate column names to PostgreSQL standards.
    EXACT same logic as schema generation script.
    """
    name = str(name)
    clean = re.sub(r'\W+', '_', name.strip().lower())
    base = clean[:63]
    final = base
    i = 1
    while final in used_names:
        suffix = f"_{i}"
        final = base[:63 - len(suffix)] + suffix
        i += 1
    used_names.add(final)
    return final


def clean_all_column_names(columns):
    """Clean all column names using the exact same logic as schema generation."""
    used_names = set()
    cleaned_columns = []
    
    for col in columns:
        cleaned = sanitize_and_truncate(col, used_names)
        cleaned_columns.append(cleaned)
    
    logger.info(f"Cleaned {len(columns)} column names")
    return cleaned_columns


def get_all_redcap_tables(cursor):
    """Dynamically discover all redcap_form_part_* tables"""
    query = """
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name LIKE 'redcap_form_part_%'
        ORDER BY table_name;
    """
    try:
        cursor.execute(query)
        tables = [row[0] for row in cursor.fetchall()]
        logger.info(f"Found {len(tables)} redcap tables: {tables}")
        return tables
    except Exception as e:
        logger.error(f"Error fetching table list: {str(e)}")
        return []


def get_table_columns_from_db(cursor, table_name):
    """Fetch column names from the database table in order"""
    query = """
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = %s 
        ORDER BY ordinal_position;
    """
    try:
        cursor.execute(query, (table_name,))
        columns = [row[0] for row in cursor.fetchall()]
        logger.info(f"Found {len(columns)} columns in {table_name}")
        return columns
    except Exception as e:
        logger.error(f"Error fetching columns for {table_name}: {str(e)}")
        return []


def prepare_value_for_insert(value, max_length=200):
    """
    Prepare a value for PostgreSQL insertion.
    Empty strings become NULL to save space.
    """
    if pd.isna(value):
        return None
    
    value_str = str(value).strip()
    
    if not value_str or value_str.lower() in ['nan', 'none', '']:
        return None
    
    if len(value_str) > max_length:
        return value_str[:max_length] + "..."
    
    return value_str


def insert_data_to_table(cursor, conn, table_name, df, table_columns):
    """
    Insert data into a specific table using only matching columns.
    Returns (successful_inserts, inserted_ids)
    """
    available_columns = [col for col in table_columns if col in df.columns]
    
    if not available_columns:
        logger.warning(f"⚠️  No matching columns found for {table_name}")
        return 0, []
    
    logger.info(f"📊 Found {len(available_columns)} matching columns for {table_name}")
    
    subset_df = df[available_columns].copy()
    
    if subset_df.empty:
        logger.warning(f"⚠️  No data rows to insert into {table_name}")
        return 0, []
    
    logger.info(f"📊 Preparing to insert {len(subset_df)} rows into {table_name}")
    
    placeholders = ', '.join(['%s'] * len(available_columns))
    column_names = ', '.join([f'"{col}"' for col in available_columns])
    
    # Add RETURNING clause to capture inserted IDs
    insert_query = f'''
        INSERT INTO {table_name} ({column_names}) 
        VALUES ({placeholders})
        RETURNING id
    '''
    
    successful_inserts = 0
    failed_rows = []
    inserted_ids = []
    
    for idx, row in subset_df.iterrows():
        try:
            prepared_values = tuple(
                prepare_value_for_insert(val, max_length=200) 
                for val in row.values
            )
            
            cursor.execute(insert_query, prepared_values)
            
            # Capture the inserted ID
            result = cursor.fetchone()
            if result:
                inserted_id = result[0]
                inserted_ids.append(inserted_id)
            
            conn.commit()
            successful_inserts += 1
            
            if (successful_inserts) % 50 == 0:
                logger.info(f"   Progress: {successful_inserts}/{len(subset_df)} rows inserted...")
                
        except psycopg2.Error as row_error:
            conn.rollback()
            error_msg = str(row_error)
            
            if "row is too big" in error_msg.lower():
                logger.error(f"   ❌ Row {idx} still too big even with {len(available_columns)} columns!")
                logger.error(f"   This table needs to be split further in the schema.")
            
            failed_rows.append(idx)
            logger.warning(f"   ❌ Row {idx} failed: {error_msg[:150]}")
            continue
    
    logger.info(f"✅ Inserted {successful_inserts}/{len(subset_df)} rows into {table_name}")
    
    if inserted_ids:
        logger.info(f"📋 Inserted IDs: {inserted_ids[:10]}{'...' if len(inserted_ids) > 10 else ''} (total: {len(inserted_ids)})")
    
    if failed_rows:
        logger.warning(f"⚠️  Failed to insert {len(failed_rows)} rows: {failed_rows[:5]}")
    
    return successful_inserts, inserted_ids


def trigger_carbone_lambda(lambda_client, function_name, record_ids, metadata=None):
    """
    Trigger Carbone Lambda to generate documents for newly inserted records.
    
    Args:
        lambda_client: Boto3 Lambda client
        function_name: Name of Carbone Lambda function
        record_ids: List of record IDs to process
        metadata: Optional metadata about the trigger
    
    Returns:
        Boolean indicating success
    """
    if not record_ids:
        logger.warning("⚠️  No record IDs provided - skipping Carbone trigger")
        return False
    
    if not function_name:
        logger.warning("⚠️  Carbone Lambda function name not configured")
        return False
    
    logger.info(f"\n{'='*70}")
    logger.info(f"🎯 TRIGGERING CARBONE DOCUMENT GENERATION")
    logger.info(f"{'='*70}")
    
    try:
        logger.info(f"📋 Record IDs to process: {record_ids[:10]}{'...' if len(record_ids) > 10 else ''}")
        logger.info(f"📊 Total records: {len(record_ids)}")
        logger.info(f"🎯 Target function: {function_name}")
        
        # Prepare payload for Carbone Lambda
        carbone_payload = {
            'record_ids': record_ids,
            'template_name': 'patient_report.odt',
            'output_format': 'pdf',
            'trigger_source': 'data_ingestion',
            'triggered_at': datetime.now().isoformat(),
            'metadata': metadata or {}
        }
        
        # Invoke Carbone Lambda asynchronously
        response = lambda_client.invoke(
            FunctionName=function_name,
            InvocationType='Event',  # Asynchronous invocation
            Payload=json.dumps(carbone_payload)
        )
        
        logger.info(f"✅ Carbone Lambda triggered successfully")
        logger.info(f"   Status Code: {response['StatusCode']}")
        logger.info(f"   Request ID: {response['ResponseMetadata']['RequestId']}")
        logger.info(f"{'='*70}")
        
        return True
        
    except Exception as e:
        logger.error(f"❌ Failed to trigger Carbone Lambda: {str(e)}")
        import traceback
        logger.error(traceback.format_exc())
        return False


def lambda_handler(event, context):
    """
    Main Lambda handler for data ingestion with automatic Carbone triggering.
    
    Processes Excel files from S3, inserts data into RDS PostgreSQL,
    and automatically triggers document generation for new records.
    """
    logger.info("🚀 Lambda function started")
    logger.info(f"   Request ID: {context.request_id if context else 'LOCAL'}")
    logger.info(f"   Timestamp: {datetime.now().isoformat()}")
    
    # Environment variables
    DB_NAME = os.environ['DB_NAME']
    DB_PROXY_ENDPOINT = os.environ['DB_PROXY_ENDPOINT']
    SECRET_ARN = os.environ['SECRET_ARN']
    CARBONE_LAMBDA_FUNCTION_NAME = os.environ.get('CARBONE_LAMBDA_FUNCTION_NAME', '')

    # Fetch database credentials
    logger.info("🔐 Fetching database credentials from Secrets Manager...")
    secrets_client = boto3.client('secretsmanager')
    secret = secrets_client.get_secret_value(SecretId=SECRET_ARN)
    creds = json.loads(secret['SecretString'])
    DB_USER = creds['username']
    DB_PASSWORD = creds['password']
    logger.info("✅ Credentials retrieved successfully")
    
    # Initialize AWS clients
    s3 = boto3.client('s3')
    lambda_client = boto3.client('lambda')
    
    # Tracking variables
    total_inserted = {}
    all_inserted_ids = []  # Collect all newly inserted record IDs
    files_processed = 0
    carbone_triggered = False

    # Process each S3 event record
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        local_path = f"/tmp/{key.split('/')[-1]}"
        
        logger.info(f"\n{'='*70}")
        logger.info(f"📥 Processing file: {key}")
        logger.info(f"   Bucket: {bucket}")
        logger.info(f"{'='*70}")
        
        # Download file from S3
        logger.info("⬇️  Downloading file from S3...")
        s3.download_file(bucket, key, local_path)
        logger.info("✅ Download complete")

        # Read Excel file
        logger.info("📖 Reading Excel file...")
        df = pd.read_excel(local_path)
        logger.info(f"✅ Excel file loaded: {df.shape[0]} rows × {df.shape[1]} columns")
        
        # Clean column names
        logger.info("🧹 Cleaning column names...")
        original_columns = df.columns.tolist()
        cleaned_columns = clean_all_column_names(original_columns)
        df.columns = cleaned_columns
        logger.info(f"✅ Columns cleaned: {len(df.columns)} columns")
        
        if df.empty:
            logger.warning("⚠️  DataFrame is empty, skipping insert")
            continue
        
        # Connect to database
        logger.info(f"🔌 Connecting to database...")
        
        conn = None
        cursor = None
        try:
            conn = psycopg2.connect(
                host=DB_PROXY_ENDPOINT,
                database=DB_NAME,
                user=DB_USER,
                password=DB_PASSWORD,
                port=5432,
                connect_timeout=10
            )
            logger.info("✅ Database connection established")
            cursor = conn.cursor()
            
            # Discover all redcap tables
            logger.info(f"\n{'─'*70}")
            logger.info(f"🔍 Discovering redcap tables...")
            logger.info(f"{'─'*70}")
            
            tables = get_all_redcap_tables(cursor)
            
            if not tables:
                logger.error("❌ No redcap_form_part_* tables found!")
                raise Exception("No tables found in database")
            
            # Initialize tracking for all tables
            for table in tables:
                total_inserted[table] = 0
            
            # Fetch all table schemas
            logger.info(f"\n{'─'*70}")
            logger.info(f"📋 Fetching table schemas...")
            logger.info(f"{'─'*70}")
            
            table_schemas = {}
            for table_name in tables:
                logger.info(f"🔍 Fetching schema for {table_name}...")
                table_columns = get_table_columns_from_db(cursor, table_name)
                
                if table_columns:
                    table_schemas[table_name] = table_columns
            
            # Column distribution analysis
            logger.info(f"\n{'─'*70}")
            logger.info(f"📊 COLUMN DISTRIBUTION ANALYSIS")
            logger.info(f"{'─'*70}")
            logger.info(f"Total columns in Excel: {len(df.columns)}")
            logger.info(f"Total tables found: {len(table_schemas)}")
            
            df_columns_set = set(df.columns)
            
            for table_name, table_cols in table_schemas.items():
                matching = [col for col in table_cols if col in df_columns_set]
                logger.info(f"{table_name}: {len(table_cols)} cols, {len(matching)} matching")
            
            logger.info(f"{'─'*70}")
            
            # Process each table
            for table_name in tables:
                logger.info(f"\n{'─'*70}")
                logger.info(f"📋 Processing: {table_name}")
                logger.info(f"{'─'*70}")
                
                if table_name not in table_schemas:
                    logger.warning(f"⚠️  Skipping {table_name} - no schema")
                    continue
                
                try:
                    rows_inserted, inserted_ids = insert_data_to_table(
                        cursor, 
                        conn,
                        table_name, 
                        df, 
                        table_schemas[table_name]
                    )
                    
                    total_inserted[table_name] += rows_inserted
                    
                    # Collect IDs only from first table to avoid duplicates
                    # (assuming all tables represent the same logical records)
                    if table_name == tables[0]:
                        all_inserted_ids.extend(inserted_ids)
                        logger.info(f"📋 Collected {len(inserted_ids)} record IDs from {table_name}")
                    
                    logger.info(f"✅ Completed {table_name}")
                    
                except Exception as e:
                    conn.rollback()
                    logger.error(f"❌ Error processing {table_name}: {str(e)}")
                    import traceback
                    logger.error(f"   Traceback:\n{traceback.format_exc()}")
                    continue
            
            files_processed += 1
            
        except Exception as e:
            if conn:
                conn.rollback()
            logger.error(f"❌ Database error: {str(e)}")
            import traceback
            logger.error(f"Traceback:\n{traceback.format_exc()}")
            raise
            
        finally:
            if cursor:
                cursor.close()
            if conn:
                conn.close()
            logger.info("🔌 Database connection closed")
            
            # Cleanup temporary file
            if os.path.exists(local_path):
                os.remove(local_path)
                logger.info(f"🗑️  Temporary file removed")

    # ===== FINAL SUMMARY =====
    logger.info(f"\n{'='*70}")
    logger.info("📊 INSERTION SUMMARY")
    logger.info(f"{'='*70}")
    logger.info(f"Files processed: {files_processed}")
    
    for table, count in sorted(total_inserted.items()):
        logger.info(f"  • {table}: {count} rows")
    
    total_rows = max(total_inserted.values()) if total_inserted.values() else 0
    logger.info(f"\nTotal unique data rows: {total_rows}")
    logger.info(f"Newly inserted record IDs: {len(all_inserted_ids)}")
    
    if all_inserted_ids:
        logger.info(f"Record ID range: {min(all_inserted_ids)} - {max(all_inserted_ids)}")
    
    logger.info(f"{'='*70}")
    
    # ===== TRIGGER CARBONE LAMBDA FOR DOCUMENT GENERATION =====
    if all_inserted_ids:
        carbone_triggered = trigger_carbone_lambda(
            lambda_client=lambda_client,
            function_name=CARBONE_LAMBDA_FUNCTION_NAME,
            record_ids=all_inserted_ids,
            metadata={
                'source_file': key if 'key' in locals() else 'unknown',
                'total_rows': total_rows,
                'tables_updated': list(total_inserted.keys())
            }
        )
    else:
        logger.warning("⚠️  No new records inserted - skipping Carbone trigger")
    
    logger.info("\n✅ Lambda execution completed successfully")
    
    # Return response
    return {
        "statusCode": 200, 
        "body": json.dumps({
            "message": f"Successfully processed {files_processed} file(s)",
            "insertions": total_inserted,
            "tables": list(total_inserted.keys()),
            "total_rows": total_rows,
            "inserted_record_count": len(all_inserted_ids),
            "inserted_ids": all_inserted_ids[:20],  # Return first 20 IDs
            "carbone_triggered": carbone_triggered,
            "timestamp": datetime.now().isoformat()
        }, indent=2, default=str)
    }

