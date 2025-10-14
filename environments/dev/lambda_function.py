import os
import boto3
import pandas as pd
import psycopg2
from psycopg2.extras import execute_batch
import json
import logging
import re

logger = logging.getLogger()
if not logger.hasHandlers():
    handler = logging.StreamHandler()
    logger.addHandler(handler)
logger.setLevel(logging.INFO)

def sanitize_and_truncate(name, used_names):
    """EXACT same logic as schema generation script."""
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
    """Insert data into a specific table using only matching columns"""
    available_columns = [col for col in table_columns if col in df.columns]
    
    if not available_columns:
        logger.warning(f"⚠️  No matching columns found for {table_name}")
        return 0
    
    logger.info(f"📊 Found {len(available_columns)} matching columns for {table_name}")
    
    subset_df = df[available_columns].copy()
    
    if subset_df.empty:
        logger.warning(f"⚠️  No data rows to insert into {table_name}")
        return 0
    
    logger.info(f"📊 Preparing to insert {len(subset_df)} rows into {table_name}")
    
    placeholders = ', '.join(['%s'] * len(available_columns))
    column_names = ', '.join([f'"{col}"' for col in available_columns])
    insert_query = f'INSERT INTO {table_name} ({column_names}) VALUES ({placeholders})'
    
    successful_inserts = 0
    failed_rows = []
    
    for idx, row in subset_df.iterrows():
        try:
            prepared_values = tuple(
                prepare_value_for_insert(val, max_length=200) 
                for val in row.values
            )
            
            cursor.execute(insert_query, prepared_values)
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
    if failed_rows:
        logger.warning(f"⚠️  Failed to insert {len(failed_rows)} rows: {failed_rows[:5]}")
    
    return successful_inserts

def lambda_handler(event, context):
    logger.info("🚀 Lambda function started")
    
    DB_NAME = os.environ['DB_NAME']
    DB_PROXY_ENDPOINT = os.environ['DB_PROXY_ENDPOINT']
    SECRET_ARN = os.environ['SECRET_ARN']

    logger.info("🔐 Fetching database credentials from Secrets Manager...")
    secrets_client = boto3.client('secretsmanager')
    secret = secrets_client.get_secret_value(SecretId=SECRET_ARN)
    creds = json.loads(secret['SecretString'])
    DB_USER = creds['username']
    DB_PASSWORD = creds['password']
    logger.info("✅ Credentials retrieved successfully")
    
    s3 = boto3.client('s3')
    
    total_inserted = {}
    files_processed = 0

    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        local_path = f"/tmp/{key.split('/')[-1]}"
        
        logger.info(f"\n{'='*70}")
        logger.info(f"📥 Processing file: {key}")
        logger.info(f"   Bucket: {bucket}")
        logger.info(f"{'='*70}")
        
        logger.info("⬇️  Downloading file from S3...")
        s3.download_file(bucket, key, local_path)
        logger.info("✅ Download complete")

        logger.info("📖 Reading Excel file...")
        df = pd.read_excel(local_path)
        logger.info(f"✅ Excel file loaded: {df.shape[0]} rows × {df.shape[1]} columns")
        
        logger.info("🧹 Cleaning column names...")
        original_columns = df.columns.tolist()
        cleaned_columns = clean_all_column_names(original_columns)
        df.columns = cleaned_columns
        logger.info(f"✅ Columns cleaned: {len(df.columns)} columns")
        
        if df.empty:
            logger.warning("⚠️  DataFrame is empty, skipping insert")
            continue
        
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
            
            # DYNAMIC: Discover all redcap tables
            logger.info(f"\n{'─'*70}")
            logger.info(f"🔍 Discovering redcap tables...")
            logger.info(f"{'─'*70}")
            
            tables = get_all_redcap_tables(cursor)
            
            if not tables:
                logger.error("❌ No redcap_form_part_* tables found!")
                raise Exception("No tables found in database")
            
            # Initialize tracking for all discovered tables
            for table in tables:
                total_inserted[table] = 0
            
            # Fetch all table schemas
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
                    rows_inserted = insert_data_to_table(
                        cursor, 
                        conn,
                        table_name, 
                        df, 
                        table_schemas[table_name]
                    )
                    total_inserted[table_name] += rows_inserted
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
            logger.error(f"❌ Error: {str(e)}")
            import traceback
            logger.error(f"Traceback:\n{traceback.format_exc()}")
            raise
            
        finally:
            if cursor:
                cursor.close()
            if conn:
                conn.close()
            logger.info("🔌 Database connection closed")
            
            if os.path.exists(local_path):
                os.remove(local_path)
                logger.info(f"🗑️  Temporary file removed")

    # Final summary
    logger.info(f"\n{'='*70}")
    logger.info("📊 INSERTION SUMMARY")
    logger.info(f"{'='*70}")
    logger.info(f"Files processed: {files_processed}")
    for table, count in sorted(total_inserted.items()):
        logger.info(f"  • {table}: {count} rows")
    
    total_rows = max(total_inserted.values()) if total_inserted.values() else 0
    logger.info(f"\nTotal unique data rows: {total_rows}")
    logger.info(f"{'='*70}")
    logger.info("✅ Lambda execution completed")

    return {
        "statusCode": 200, 
        "body": json.dumps({
            "message": f"Successfully processed {files_processed} file(s)",
            "insertions": total_inserted,
            "tables": list(total_inserted.keys()),
            "total_rows": total_rows
        }, indent=2)
    }