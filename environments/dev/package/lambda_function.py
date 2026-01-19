"""
REDCap Data Ingestion Lambda with Column Mapping CSV
Uses explicit column_mapping.csv for accurate Excel → RDS column mapping
CORRECTED: Uses proper CSV column names (Table_Name not SQL_Table_Name)
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
import csv
from io import StringIO

logger = logging.getLogger()
if not logger.hasHandlers():
    handler = logging.StreamHandler()
    logger.addHandler(handler)
logger.setLevel(logging.INFO)

def load_column_mapping_from_s3(s3_client, bucket_name, csv_key='column_mapping.csv'):
    """
    Load column_mapping.csv from S3 and parse it.
    
    CSV Format:
        Original_Field_ID,Category,Section,Table_Name,SQL_Column_Name,SQL_Data_Type,Field_Type,Label
    
    Returns:
        Dictionary mapping Excel columns to their database metadata
    """
    logger.info(f"\n{'='*70}")
    logger.info("📋 LOADING COLUMN MAPPING FROM S3")
    logger.info(f"{'='*70}")
    logger.info(f"Bucket: {bucket_name}")
    logger.info(f"Key: {csv_key}")
    
    try:
        # Download CSV from S3
        response = s3_client.get_object(Bucket=bucket_name, Key=csv_key)
        csv_content = response['Body'].read().decode('utf-8')
        
        # Parse CSV
        mapping = {}
        csv_reader = csv.DictReader(StringIO(csv_content))
        
        # Verify headers
        expected_headers = {'Original_Field_ID', 'Table_Name', 'SQL_Column_Name', 'SQL_Data_Type', 'Label'}
        actual_headers = set(csv_reader.fieldnames)
        
        if not expected_headers.issubset(actual_headers):
            missing = expected_headers - actual_headers
            logger.error(f"❌ CSV missing required columns: {missing}")
            logger.error(f"   Found columns: {actual_headers}")
            raise ValueError(f"Invalid CSV format. Missing: {missing}")
        
        logger.info(f"✅ CSV headers validated: {csv_reader.fieldnames}")
        
        for row in csv_reader:
            # Use Original_Field_ID as the key (lowercase for matching)
            excel_col = row['Original_Field_ID'].strip().lower()
            
            mapping[excel_col] = {
                'sql_column': row['SQL_Column_Name'].strip(),
                'sql_table': row['Table_Name'].strip(),  # ✅ CORRECT COLUMN NAME
                'data_type': row.get('SQL_Data_Type', '').strip(),
                'label': row.get('Label', '').strip(),
                'category': row.get('Category', '').strip(),
                'section': row.get('Section', '').strip(),
                'field_type': row.get('Field_Type', '').strip()
            }
        
        logger.info(f"✅ Loaded {len(mapping)} column mappings from CSV")
        
        # Log sample mappings
        sample_size = min(5, len(mapping))
        logger.info(f"\n📋 Sample mappings:")
        for i, (excel_col, data) in enumerate(list(mapping.items())[:sample_size]):
            logger.info(f"   {i+1}. '{excel_col}' → '{data['sql_column']}' in {data['sql_table']}")
        
        # Group by table for statistics
        tables = {}
        for excel_col, data in mapping.items():
            table_name = data['sql_table']
            if table_name not in tables:
                tables[table_name] = []
            tables[table_name].append(excel_col)
        
        logger.info(f"\n📊 Mappings by table:")
        for table_name in sorted(tables.keys())[:10]:  # Show first 10 tables
            logger.info(f"   {table_name}: {len(tables[table_name])} columns")
        
        if len(tables) > 10:
            logger.info(f"   ... and {len(tables) - 10} more tables")
        
        logger.info(f"{'='*70}\n")
        
        return mapping
        
    except Exception as e:
        logger.error(f"❌ Failed to load column mapping from S3: {str(e)}")
        import traceback
        logger.error(traceback.format_exc())
        raise

def group_columns_by_table(column_mapping, available_excel_columns):
    """
    Group Excel columns by their target database tables.
    Only includes columns that exist in the Excel file.
    """
    logger.info(f"\n{'='*70}")
    logger.info("🗂️  GROUPING COLUMNS BY TABLE")
    logger.info(f"{'='*70}")
    
    # Normalize available columns to lowercase for matching
    available_cols_lower = {col.lower(): col for col in available_excel_columns}
    
    tables = {}
    matched_count = 0
    unmatched_excel = set(available_cols_lower.keys())
    unmatched_mapping = []
    
    for excel_col_lower, mapping_data in column_mapping.items():
        table_name = mapping_data['sql_table']
        sql_col = mapping_data['sql_column']
        
        # Check if this Excel column exists in the actual data
        if excel_col_lower in available_cols_lower:
            original_case_col = available_cols_lower[excel_col_lower]
            
            if table_name not in tables:
                tables[table_name] = []
            
            tables[table_name].append((original_case_col, sql_col))
            matched_count += 1
            unmatched_excel.discard(excel_col_lower)
        else:
            unmatched_mapping.append(excel_col_lower)
    
    logger.info(f"✅ Matched {matched_count} Excel columns to database tables")
    logger.info(f"📊 Grouped into {len(tables)} tables")
    
    # Log table summary
    logger.info(f"\n📋 Columns per table:")
    for table_name in sorted(tables.keys())[:10]:  # Show first 10
        logger.info(f"   {table_name}: {len(tables[table_name])} columns")
    
    if len(tables) > 10:
        logger.info(f"   ... and {len(tables) - 10} more tables")
    
    # Warn about unmatched columns
    if unmatched_excel:
        logger.warning(f"\n⚠️  {len(unmatched_excel)} Excel columns not found in mapping:")
        for col in list(unmatched_excel)[:10]:
            logger.warning(f"   - {col}")
        if len(unmatched_excel) > 10:
            logger.warning(f"   ... and {len(unmatched_excel) - 10} more")
    
    if unmatched_mapping:
        logger.info(f"\nℹ️  {len(unmatched_mapping)} mapped columns not present in Excel (expected)")
    
    logger.info(f"{'='*70}\n")
    
    return tables

def validate_data_type(value, expected_type, column_name):
    """
    Validate that a value matches the expected SQL data type.
    
    Returns:
        Tuple of (is_valid, cleaned_value, error_message)
    """
    # Handle NULL/empty values
    if pd.isna(value) or value == '' or str(value).strip() == '':
        return True, None, None
    
    try:
        expected_upper = expected_type.upper()
        
        # INTEGER types
        if 'INTEGER' in expected_upper or 'INT' in expected_upper:
            if isinstance(value, (int, float)):
                return True, int(value), None
            try:
                int_val = int(float(value))
                return True, int_val, None
            except (ValueError, TypeError):
                return False, value, f"Expected integer, got '{value}'"
        
        # NUMERIC/DECIMAL types
        elif 'NUMERIC' in expected_upper or 'DECIMAL' in expected_upper:
            if isinstance(value, (int, float)):
                return True, float(value), None
            try:
                float_val = float(value)
                return True, float_val, None
            except (ValueError, TypeError):
                return False, value, f"Expected number, got '{value}'"
        
        # VARCHAR/TEXT types
        elif 'VARCHAR' in expected_upper or 'TEXT' in expected_upper:
            str_val = str(value).strip()
            
            # Check length for VARCHAR
            if 'VARCHAR' in expected_upper and '(' in expected_type:
                try:
                    max_len = int(expected_type.split('(')[1].split(')')[0])
                    if len(str_val) > max_len:
                        # Truncate with warning
                        logger.warning(f"⚠️  Truncating {column_name}: {len(str_val)} > {max_len} chars")
                        str_val = str_val[:max_len]
                except:
                    pass
            
            return True, str_val, None
        
        # DATE types
        elif 'DATE' in expected_upper:
            if isinstance(value, pd.Timestamp):
                return True, value.date(), None
            
            try:
                date_val = pd.to_datetime(value)
                return True, date_val.date(), None
            except:
                return False, value, f"Invalid date format: '{value}'"
        
        # TIMESTAMP types
        elif 'TIMESTAMP' in expected_upper:
            if isinstance(value, pd.Timestamp):
                return True, value, None
            
            try:
                ts_val = pd.to_datetime(value)
                return True, ts_val, None
            except:
                return False, value, f"Invalid timestamp format: '{value}'"
        
        # BOOLEAN types
        elif 'BOOLEAN' in expected_upper or 'BOOL' in expected_upper:
            if isinstance(value, bool):
                return True, value, None
            
            str_val = str(value).lower().strip()
            if str_val in ['true', '1', 'yes', 't', 'y']:
                return True, True, None
            elif str_val in ['false', '0', 'no', 'f', 'n']:
                return True, False, None
            else:
                return False, value, f"Invalid boolean value: '{value}'"
        
        # Default: accept as string
        else:
            return True, str(value).strip(), None
    
    except Exception as e:
        return False, value, f"Validation error: {str(e)}"

def prepare_value_for_insert(value, data_type=None, column_name=None):
    """
    Prepare a value for PostgreSQL insertion with optional type validation.
    """
    # If data type provided, validate
    if data_type:
        is_valid, cleaned_value, error_msg = validate_data_type(value, data_type, column_name or 'unknown')
        
        if not is_valid:
            logger.warning(f"⚠️  Validation failed for {column_name}: {error_msg}")
            return None
        
        return cleaned_value
    
    # Fallback: basic cleaning
    if pd.isna(value):
        return None
    
    value_str = str(value).strip()
    
    if not value_str or value_str.lower() in ['nan', 'none', '']:
        return None
    
    return value_str

def generate_encounter_id(patient_id, processing_date):
    """
    Generate encounter_id in format: YYYYMMDD_patientID
    """
    try:
        if pd.isna(patient_id):
            logger.warning(f"Missing patient_id for encounter_id generation")
            return None
        
        date_str = processing_date.strftime('%Y%m%d')
        
        # Clean patient ID
        patient_id_str = str(patient_id).strip().replace(' ', '_')
        patient_id_str = re.sub(r'[^\w\-]', '_', patient_id_str)
        
        # Limit length to avoid VARCHAR overflow
        if len(patient_id_str) > 100:
            logger.warning(f"⚠️  Patient ID too long ({len(patient_id_str)} chars), truncating to 100")
            patient_id_str = patient_id_str[:100]
        
        encounter_id = f"{date_str}_{patient_id_str}"
        
        return encounter_id
        
    except Exception as e:
        logger.error(f"Error generating encounter_id: {str(e)}")
        return None

def upsert_encounter_record(cursor, conn, encounter_id, patient_id, processing_date):
    """
    Insert or update the encounters table (master record).
    Returns the encounter's database ID.
    """
    try:
        # Check if encounter already exists
        cursor.execute(
            "SELECT id FROM encounters WHERE encounter_id = %s",
            (encounter_id,)
        )
        existing = cursor.fetchone()
        
        if existing:
            logger.info(f"📋 Encounter {encounter_id} already exists (id={existing[0]})")
            return existing[0]
        
        # Insert new encounter
        insert_query = """
            INSERT INTO encounters (
                encounter_id, 
                patient_id, 
                processing_date,
                encounter_date,
                is_first_visit,
                schema_version
            )
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING id
        """
        
        cursor.execute(insert_query, (
            encounter_id,
            patient_id,
            processing_date.date(),
            processing_date.date(),
            True,
            '1.0'
        ))
        
        encounter_db_id = cursor.fetchone()[0]
        conn.commit()
        
        logger.info(f"✅ Created encounter {encounter_id} (id={encounter_db_id})")
        return encounter_db_id
        
    except Exception as e:
        conn.rollback()
        logger.error(f"❌ Error upserting encounter: {str(e)}")
        raise

def insert_data_using_mapping(cursor, conn, df, column_mapping, tables_grouped, encounter_id_col='encounter_id'):
    """
    Insert data into all tables using explicit column mapping from CSV.
    """
    if encounter_id_col not in df.columns:
        logger.error(f"❌ encounter_id column not found in DataFrame!")
        return {}
    
    results = {}
    
    # Process each table
    for table_name, column_pairs in tables_grouped.items():
        logger.info(f"\n{'─'*70}")
        logger.info(f"📋 Processing table: {table_name}")
        logger.info(f"{'─'*70}")
        logger.info(f"Columns to insert: {len(column_pairs)}")
        
        if not column_pairs:
            logger.warning(f"⚠️  No columns mapped for {table_name}, skipping")
            continue
        
        try:
            # Build column lists for INSERT
            excel_cols = [pair[0] for pair in column_pairs]
            sql_cols = [pair[1] for pair in column_pairs]
            
            # Check which Excel columns exist in DataFrame
            available_excel_cols = [col for col in excel_cols if col in df.columns]
            
            if not available_excel_cols:
                logger.warning(f"⚠️  None of the mapped columns exist in Excel data, skipping {table_name}")
                continue
            
            # Map available Excel columns to their SQL equivalents
            excel_to_sql = {}
            for excel_col, sql_col in column_pairs:
                if excel_col in df.columns:
                    excel_to_sql[excel_col] = sql_col
            
            # Build INSERT statement
            sql_columns_final = ['encounter_id'] + list(excel_to_sql.values())
            columns_str = ', '.join([f'"{col}"' for col in sql_columns_final])
            placeholders = ', '.join(['%s'] * len(sql_columns_final))
            
            insert_query = f"""
                INSERT INTO {table_name} ({columns_str})
                VALUES ({placeholders})
                RETURNING id
            """
            
            logger.info(f"📝 INSERT into {table_name} with {len(sql_columns_final)} columns")
            logger.info(f"   Sample SQL columns: {sql_columns_final[:5]}")
            
            # Insert each row
            rows_inserted = 0
            rows_failed = 0
            inserted_ids = []
            
            for idx, row in df.iterrows():
                try:
                    # Start with encounter_id
                    values = [row[encounter_id_col]]
                    
                    # Add data values with type validation
                    for excel_col, sql_col in excel_to_sql.items():
                        raw_value = row[excel_col]
                        
                        # Get data type from mapping for validation
                        excel_col_lower = excel_col.lower()
                        data_type = column_mapping.get(excel_col_lower, {}).get('data_type', None)
                        
                        # Prepare and validate value
                        cleaned_value = prepare_value_for_insert(
                            raw_value, 
                            data_type=data_type,
                            column_name=excel_col
                        )
                        
                        values.append(cleaned_value)
                    
                    # Execute INSERT
                    cursor.execute(insert_query, tuple(values))
                    
                    # Get inserted ID
                    result = cursor.fetchone()
                    if result:
                        inserted_ids.append(result[0])
                    
                    conn.commit()
                    rows_inserted += 1
                    
                    if rows_inserted % 50 == 0:
                        logger.info(f"  Progress: {rows_inserted}/{len(df)} rows inserted...")
                
                except psycopg2.Error as row_error:
                    conn.rollback()
                    logger.warning(f"  ❌ Row {idx} failed: {str(row_error)[:200]}")
                    rows_failed += 1
                    continue
            
            logger.info(f"✅ Inserted {rows_inserted}/{len(df)} rows into {table_name}")
            
            if inserted_ids:
                logger.info(f"📋 Inserted IDs: {inserted_ids[:10]}{'...' if len(inserted_ids) > 10 else ''}")
            
            if rows_failed > 0:
                logger.warning(f"⚠️  {rows_failed} rows failed to insert")
            
            results[table_name] = rows_inserted
            
        except Exception as table_error:
            conn.rollback()
            logger.error(f"❌ Error processing table {table_name}: {str(table_error)}")
            import traceback
            logger.error(traceback.format_exc())
            results[table_name] = 0
            continue
    
    return results

def trigger_carbone_lambda(lambda_client, function_name, record_ids, metadata=None):
    """
    Trigger Carbone Lambda to generate documents for newly inserted records.
    """
    if not record_ids or not function_name:
        logger.warning("⚠️  Cannot trigger Carbone Lambda - missing record IDs or function name")
        return False
    
    logger.info(f"\n{'='*70}")
    logger.info(f"🎯 TRIGGERING CARBONE DOCUMENT GENERATION")
    logger.info(f"{'='*70}")
    
    try:
        logger.info(f"📋 Record IDs: {record_ids[:10]}{'...' if len(record_ids) > 10 else ''}")
        logger.info(f"📊 Total records: {len(record_ids)}")
        logger.info(f"🎯 Function: {function_name}")
        
        carbone_payload = {
            'record_ids': record_ids,
            'template_name': 'patient_report.docx',
            'output_format': 'docx',
            'trigger_source': 'data_ingestion',
            'triggered_at': datetime.now().isoformat(),
            'metadata': metadata or {}
        }
        
        response = lambda_client.invoke(
            FunctionName=function_name,
            InvocationType='Event',
            Payload=json.dumps(carbone_payload)
        )
        
        logger.info(f"✅ Carbone Lambda triggered")
        logger.info(f"   Status: {response['StatusCode']}")
        logger.info(f"   Request ID: {response['ResponseMetadata']['RequestId']}")
        logger.info(f"{'='*70}")
        
        return True
        
    except Exception as e:
        logger.error(f"❌ Failed to trigger Carbone Lambda: {str(e)}")
        return False

def lambda_handler(event, context):
    """
    Main Lambda handler using column_mapping.csv for explicit field mapping.
    """
    processing_datetime = datetime.now()
    
    logger.info("🚀 Lambda function started (column_mapping.csv mode)")
    logger.info(f"Request ID: {context.aws_request_id if context else 'LOCAL'}")
    logger.info(f"Processing Timestamp: {processing_datetime.isoformat()}")
    
    # Environment variables
    DB_NAME = os.environ['DB_NAME']
    DB_PROXY_ENDPOINT = os.environ['DB_PROXY_ENDPOINT']
    SECRET_ARN = os.environ['SECRET_ARN']
    MAPPING_BUCKET = os.environ.get('MAPPING_BUCKET', os.environ.get('BUCKET_NAME'))
    MAPPING_KEY = os.environ.get('MAPPING_KEY', 'config/column_mapping.csv')
    CARBONE_LAMBDA_FUNCTION_NAME = os.environ.get('CARBONE_LAMBDA_FUNCTION_NAME', '')
    
    # Fetch database credentials
    logger.info("🔐 Fetching database credentials...")
    secrets_client = boto3.client('secretsmanager')
    secret = secrets_client.get_secret_value(SecretId=SECRET_ARN)
    creds = json.loads(secret['SecretString'])
    DB_USER = creds['username']
    DB_PASSWORD = creds['password']
    logger.info("✅ Credentials retrieved")
    
    # Initialize AWS clients
    s3 = boto3.client('s3')
    lambda_client = boto3.client('lambda')
    
    # Load column mapping from S3
    try:
        column_mapping = load_column_mapping_from_s3(s3, MAPPING_BUCKET, MAPPING_KEY)
    except Exception as e:
        logger.error(f"❌ Failed to load column mapping: {str(e)}")
        raise
    
    # Tracking variables
    total_inserted = {}
    all_encounter_ids = []
    files_processed = 0
    
    # Process each S3 event record
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        local_path = f"/tmp/{key.split('/')[-1]}"
        
        logger.info(f"\n{'='*70}")
        logger.info(f"📥 Processing file: {key}")
        logger.info(f"{'='*70}")
        
        # Download and read Excel
        logger.info("⬇️  Downloading from S3...")
        s3.download_file(bucket, key, local_path)
        
        logger.info("📖 Reading Excel...")
        df = pd.read_excel(local_path)
        logger.info(f"✅ Loaded: {df.shape[0]} rows × {df.shape[1]} columns")
        
        if df.empty:
            logger.warning("⚠️  Empty DataFrame, skipping")
            continue
        
        # Log original columns
        original_columns = df.columns.tolist()
        logger.info(f"📋 Excel columns (first 10): {original_columns[:10]}")
        
        # Generate encounter_id
        logger.info(f"\n{'─'*70}")
        logger.info("🆔 GENERATING ENCOUNTER IDs")
        logger.info(f"{'─'*70}")
        
        patient_id_candidates = [
            'record_id', 'patient_id', 'patientid', 
            'mrn', 'medical_record_number', 'patient_number'
        ]
        
        patient_id_col = None
        for candidate in patient_id_candidates:
            for col in original_columns:
                if col.lower() == candidate.lower():
                    patient_id_col = col
                    break
            if patient_id_col:
                break
        
        if patient_id_col:
            logger.info(f"✅ Using patient_id column: {patient_id_col}")
            
            df['encounter_id'] = df[patient_id_col].apply(
                lambda pid: generate_encounter_id(pid, processing_datetime)
            )
            
            valid_count = df['encounter_id'].notna().sum()
            logger.info(f"📊 Generated {valid_count}/{len(df)} encounter IDs")
            
            sample_ids = df['encounter_id'].dropna().head(3).tolist()
            logger.info(f"📋 Sample: {sample_ids}")
        else:
            logger.error(f"❌ No patient_id column found!")
            logger.error(f"   Searched: {patient_id_candidates}")
            continue
        
        # Connect to database
        logger.info(f"\n🔌 Connecting to database...")
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
            logger.info("✅ Connected")
            cursor = conn.cursor()
            
            # Insert encounters
            logger.info(f"\n{'─'*70}")
            logger.info(f"🏥 INSERTING ENCOUNTERS")
            logger.info(f"{'─'*70}")
            
            encounter_ids = []
            valid_rows = df[df['encounter_id'].notna()].copy()
            
            for idx, row in valid_rows.iterrows():
                encounter_id = row['encounter_id']
                patient_id = row[patient_id_col]
                
                try:
                    upsert_encounter_record(cursor, conn, encounter_id, patient_id, processing_datetime)
                    encounter_ids.append(encounter_id)
                except Exception as e:
                    logger.error(f"❌ Failed: {encounter_id}: {str(e)}")
            
            logger.info(f"✅ Processed {len(encounter_ids)} encounters")
            all_encounter_ids.extend(encounter_ids)
            
            # Group columns by table using mapping
            tables_grouped = group_columns_by_table(column_mapping, df.columns.tolist())
            
            # Insert data using mapping
            logger.info(f"\n{'─'*70}")
            logger.info(f"💾 INSERTING DATA TO SPECIALTY TABLES")
            logger.info(f"{'─'*70}")
            
            insertion_results = insert_data_using_mapping(
                cursor, conn, df, column_mapping, tables_grouped
            )
            
            # Merge results
            for table, count in insertion_results.items():
                total_inserted[table] = total_inserted.get(table, 0) + count
            
            files_processed += 1
            
        except Exception as e:
            if conn:
                conn.rollback()
            logger.error(f"❌ Database error: {str(e)}")
            import traceback
            logger.error(traceback.format_exc())
            raise
            
        finally:
            if cursor:
                cursor.close()
            if conn:
                conn.close()
            logger.info("🔌 Connection closed")
        
        # Cleanup
        if os.path.exists(local_path):
            os.remove(local_path)
    
    # Summary
    logger.info(f"\n{'='*70}")
    logger.info("📊 INSERTION SUMMARY")
    logger.info(f"{'='*70}")
    logger.info(f"Files processed: {files_processed}")
    
    for table, count in sorted(total_inserted.items()):
        logger.info(f"  • {table}: {count} rows")
    
    logger.info(f"\nTotal encounters: {len(all_encounter_ids)}")
    logger.info(f"{'='*70}")
    
    # Trigger Carbone
    carbone_triggered = False
    if all_encounter_ids:
        carbone_triggered = trigger_carbone_lambda(
            lambda_client, CARBONE_LAMBDA_FUNCTION_NAME, all_encounter_ids,
            metadata={'processing_date': processing_datetime.strftime('%Y%m%d')}
        )
    
    logger.info("\n✅ Lambda execution completed")
    
    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": f"Processed {files_processed} file(s) using column_mapping.csv",
            "insertions": total_inserted,
            "encounter_count": len(all_encounter_ids),
            "encounter_ids": all_encounter_ids[:20],
            "carbone_triggered": carbone_triggered,
            "timestamp": processing_datetime.isoformat()
        }, indent=2, default=str)
    }