"""
REDCap Data Ingestion Lambda with Automatic Carbone Document Generation
Processes Excel files and automatically triggers document generation for new records
WITH SEMANTIC PREFIX SUPPORT - FIXED VERSION
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

def generate_semantic_prefix(category, section_hint=""):
    """
    Generate semantic prefix based on category and section.
    MUST MATCH schema generator logic exactly!
    """
    category_lower = category.lower()
    section_lower = section_hint.lower()
    
    # Category prefixes
    if category_lower == 'general' or 'demograph' in category_lower:
        return 'dem'  # Demographics/General
    elif category_lower == 'shoulder':
        # Determine section-specific prefix
        if 'diagnosis' in section_lower or 'diag' in section_lower:
            return 'orth_sh_diag'
        elif 'clinical' in section_lower or 'clin' in section_lower or 'exam' in section_lower:
            return 'orth_sh_clin'
        elif 'treatment' in section_lower or 'plan' in section_lower:
            return 'orth_sh_tp'
        elif 'surgery' in section_lower or 'surg' in section_lower or 'operation' in section_lower:
            return 'orth_sh_surg'
        elif 'prom' in section_lower or 'outcome' in section_lower:
            return 'orth_sh_proms'
        else:
            return 'orth_sh'
    elif category_lower == 'elbow':
        # Determine section-specific prefix
        if 'diagnosis' in section_lower or 'diag' in section_lower:
            return 'orth_el_diag'
        elif 'clinical' in section_lower or 'clin' in section_lower or 'exam' in section_lower:
            return 'orth_el_clin'
        elif 'treatment' in section_lower or 'plan' in section_lower:
            return 'orth_el_tp'
        elif 'surgery' in section_lower or 'surg' in section_lower or 'operation' in section_lower:
            return 'orth_el_surg'
        elif 'prom' in section_lower or 'outcome' in section_lower:
            return 'orth_el_proms'
        else:
            return 'orth_el'
    
    return 'gen'  # Default

def infer_table_category(table_name):
    """
    Infer category from table name to determine correct prefix.
    
    Args:
        table_name: Database table name (e.g., 'demographics', 'shoulder_diagnosis')
    
    Returns:
        Tuple of (category, section) strings
    """
    table_lower = table_name.lower()
    
    if 'demographic' in table_lower or table_lower == 'demographics':
        return 'general', ''
    elif 'shoulder' in table_lower:
        if 'diagnosis' in table_lower:
            return 'shoulder', 'diagnosis'
        elif 'clinical' in table_lower:
            return 'shoulder', 'clinical'
        elif 'treatment' in table_lower:
            return 'shoulder', 'treatment'
        elif 'surgery' in table_lower:
            return 'shoulder', 'surgery'
        elif 'prom' in table_lower:
            return 'shoulder', 'proms'
        else:
            return 'shoulder', ''
    elif 'elbow' in table_lower:
        if 'diagnosis' in table_lower:
            return 'elbow', 'diagnosis'
        elif 'clinical' in table_lower:
            return 'elbow', 'clinical'
        elif 'treatment' in table_lower:
            return 'elbow', 'treatment'
        elif 'surgery' in table_lower:
            return 'elbow', 'surgery'
        elif 'prom' in table_lower:
            return 'elbow', 'proms'
        else:
            return 'elbow', ''
    
    return 'general', ''

def sanitize_column_name_with_prefix(field_id, table_name, used_names=None):
    """
    Create clean SQL column name with semantic prefix.
    MUST MATCH schema generator logic exactly!
    
    Args:
        field_id: Original field identifier from Excel
        table_name: Database table name to determine prefix
        used_names: Set of already-used column names to avoid duplicates
    
    Returns:
        Unique column name with appropriate prefix
    """
    if used_names is None:
        used_names = set()
    
    # Infer category and section from table name
    category, section = infer_table_category(table_name)
    prefix = generate_semantic_prefix(category, section)
    
    # Remove existing suffixes like _shoulder, _elbow
    clean_id = re.sub(r'_(shoulder|elbow)$', '', field_id)
    
    # Sanitize
    clean = re.sub(r'\W+', '_', clean_id.strip().lower())
    
    # Remove leading/trailing underscores
    clean = clean.strip('_')
    
    # Add prefix if provided
    if prefix and not clean.startswith(prefix):
        # Check if field already has a category prefix to avoid duplication
        if not (clean.startswith('orth_') or clean.startswith('dem_') or clean.startswith('gen_')):
            clean = f"{prefix}_{clean}"
    
    # Ensure not too long (PostgreSQL limit 63 chars)
    base = clean[:63]
    final = base
    
    # Handle collisions by adding numeric suffix
    counter = 1
    while final in used_names:
        suffix = f"_{counter}"
        # Make room for suffix by truncating base
        final = base[:63 - len(suffix)] + suffix
        counter += 1
    
    used_names.add(final)
    return final

def clean_all_column_names_for_table(columns, table_name):
    """
    Clean all column names with appropriate prefix for the given table.
    
    Args:
        columns: List of original column names from Excel
        table_name: Database table name
    
    Returns:
        List of cleaned column names with semantic prefixes
    """
    used_names = set()
    cleaned_columns = []
    
    for col in columns:
        cleaned = sanitize_column_name_with_prefix(col, table_name, used_names)
        cleaned_columns.append(cleaned)
    
    logger.info(f"✅ Cleaned {len(columns)} column names for table {table_name}")
    if cleaned_columns:
        logger.info(f"   Sample: {columns[0]} → {cleaned_columns[0]}")
    
    return cleaned_columns

def generate_encounter_id(patient_id, processing_date):
    """
    Generate encounter_id in format: YYYYMMDD_patientID
    
    Args:
        patient_id: Patient identifier
        processing_date: datetime object for the processing date
    
    Returns:
        String encounter_id or None if patient_id is missing
    """
    try:
        # Handle missing patient ID
        if pd.isna(patient_id):
            logger.warning(f"Missing patient_id for encounter_id generation")
            return None
        
        # Format date as YYYYMMDD
        date_str = processing_date.strftime('%Y%m%d')
        
        # Clean patient ID (remove whitespace, special chars, convert to string)
        patient_id_str = str(patient_id).strip().replace(' ', '_')
        patient_id_str = re.sub(r'[^\w\-]', '_', patient_id_str)
        
        # Generate encounter_id
        encounter_id = f"{date_str}_{patient_id_str}"
        
        return encounter_id
        
    except Exception as e:
        logger.error(f"Error generating encounter_id: {str(e)}")
        return None

def get_all_specialty_tables(cursor):
    """
    Dynamically discover all specialty tables (excluding encounters table).
    New naming: demographics, shoulder_diagnosis, shoulder_clinical, elbow_diagnosis, etc.
    """
    query = """
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
          AND table_name != 'encounters'
          AND table_name NOT IN ('pg_stat_statements', 'pg_buffercache')
        ORDER BY table_name;
    """
    try:
        cursor.execute(query)
        tables = [row[0] for row in cursor.fetchall()]
        logger.info(f"Found {len(tables)} specialty tables: {tables}")
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
            processing_date.date(),  # Same as processing date initially
            True,  # Default to first visit
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

def insert_data_to_table(cursor, conn, table_name, df_original, table_columns, encounter_id_col='encounter_id'):
    """
    Insert data into a specific specialty table using column name matching with semantic prefixes.
    FIXED: Preserves encounter_id column before cleaning other columns.
    Returns (successful_inserts, inserted_ids)
    """
    # Create a copy of the DataFrame to avoid modifying the original
    df = df_original.copy()
    
    # CRITICAL: Save encounter_id BEFORE cleaning column names
    if encounter_id_col not in df.columns:
        logger.error(f"❌ encounter_id column not found in original DataFrame!")
        logger.error(f"   Available columns: {df.columns.tolist()[:20]}")
        return 0, []
    
    encounter_id_values = df[encounter_id_col].copy()
    logger.info(f"✅ Saved encounter_id column with {len(encounter_id_values)} values")
    
    # Clean Excel column names to match database column names (with semantic prefixes)
    logger.info(f"🔄 Applying semantic prefix mapping for table: {table_name}")
    original_columns = df.columns.tolist()
    
    # Remove encounter_id from columns to be cleaned (it's not in original Excel)
    columns_to_clean = [col for col in original_columns if col != encounter_id_col]
    
    # Clean only the Excel columns (not encounter_id)
    cleaned_excel_columns = clean_all_column_names_for_table(columns_to_clean, table_name)
    
    # Create mapping of cleaned columns
    column_mapping = {}
    for orig, clean in zip(columns_to_clean, cleaned_excel_columns):
        column_mapping[orig] = clean
    
    # Rename columns in DataFrame (except encounter_id)
    df = df.rename(columns=column_mapping)
    
    # Add encounter_id back to the DataFrame (unchanged)
    df['encounter_id'] = encounter_id_values
    
    logger.info(f"📊 Column mapping examples for {table_name}:")
    for orig, clean in list(column_mapping.items())[:5]:
        logger.info(f"   {orig} → {clean}")
    logger.info(f"   encounter_id → encounter_id (preserved)")
    
    # Filter out system columns
    system_columns = {'id', 'created_at', 'updated_at', 'encounter_id'}
    data_columns = [col for col in table_columns if col not in system_columns]
    
    # Find matching columns between cleaned Excel and table
    available_columns = [col for col in data_columns if col in df.columns]
    
    if not available_columns:
        logger.warning(f"⚠️ No matching columns found for {table_name}")
        logger.warning(f"   Table columns (first 10): {data_columns[:10]}")
        logger.warning(f"   Excel columns (first 10): {list(df.columns)[:10]}")
        return 0, []
    
    logger.info(f"✅ Found {len(available_columns)} matching columns for {table_name}")
    logger.info(f"   Sample matches: {available_columns[:10]}{'...' if len(available_columns) > 10 else ''}")
    
    # Add encounter_id to the list
    insert_columns = ['encounter_id'] + available_columns
    
    # Prepare subset DataFrame with encounter_id first
    subset_df = df[['encounter_id'] + available_columns].copy()
    
    if subset_df.empty:
        logger.warning(f"⚠️ No data rows to insert into {table_name}")
        return 0, []
    
    logger.info(f"📊 Preparing to insert {len(subset_df)} rows into {table_name}")
    
    placeholders = ', '.join(['%s'] * len(insert_columns))
    column_names = ', '.join([f'"{col}"' for col in insert_columns])
    
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
                logger.info(f"  Progress: {successful_inserts}/{len(subset_df)} rows inserted...")
                
        except psycopg2.Error as row_error:
            conn.rollback()
            error_msg = str(row_error)
            
            if "row is too big" in error_msg.lower():
                logger.error(f"  ❌ Row {idx} still too big even with {len(available_columns)} columns!")
                logger.error(f"     This table needs to be split further in the schema.")
                failed_rows.append(idx)
            
            logger.warning(f"  ❌ Row {idx} failed: {error_msg[:150]}")
            continue
    
    logger.info(f"✅ Inserted {successful_inserts}/{len(subset_df)} rows into {table_name}")
    if inserted_ids:
        logger.info(f"📋 Inserted IDs: {inserted_ids[:10]}{'...' if len(inserted_ids) > 10 else ''} (total: {len(inserted_ids)})")
    
    if failed_rows:
        logger.warning(f"⚠️ Failed to insert {len(failed_rows)} rows: {failed_rows[:5]}")
    
    return successful_inserts, inserted_ids

def trigger_carbone_lambda(lambda_client, function_name, record_ids, metadata=None):
    """
    Trigger Carbone Lambda to generate documents for newly inserted records.
    
    Args:
        lambda_client: Boto3 Lambda client
        function_name: Name of Carbone Lambda function
        record_ids: List of record IDs (encounter_ids) to process
        metadata: Optional metadata about the trigger
    
    Returns:
        Boolean indicating success
    """
    if not record_ids:
        logger.warning("⚠️ No record IDs provided - skipping Carbone trigger")
        return False
    
    if not function_name:
        logger.warning("⚠️ Carbone Lambda function name not configured")
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
            'template_name': 'patient_report.docx',
            'output_format': 'docx',
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
    # Capture processing timestamp at the start
    processing_datetime = datetime.now()
    
    logger.info("🚀 Lambda function started")
    logger.info(f"Request ID: {context.aws_request_id if context else 'LOCAL'}")
    logger.info(f"Processing Timestamp: {processing_datetime.isoformat()}")
    logger.info(f"Processing Date (for encounter_id): {processing_datetime.strftime('%Y%m%d')}")
    
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
    all_encounter_ids = []  # Collect all encounter IDs for Carbone trigger
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
        
        # Store original columns for later reference
        original_columns = df.columns.tolist()
        logger.info(f"📋 Original columns (first 10): {original_columns[:10]}")
        
        if df.empty:
            logger.warning("⚠️  DataFrame is empty, skipping insert")
            continue
        
        # ===== GENERATE ENCOUNTER_ID =====
        logger.info(f"\n{'─'*70}")
        logger.info("🆔 GENERATING ENCOUNTER IDs")
        logger.info(f"{'─'*70}")
        logger.info(f"📅 Using processing date: {processing_datetime.strftime('%Y-%m-%d')}")
        
        # Try to find patient_id column (before cleaning)
        patient_id_candidates = ['record_id', 'patient_id', 'patientid', 'mrn', 'medical_record_number', 'patient_number', 'pt_id', 'id']

        
        patient_id_col = None
        
        # Find matching patient ID column (case-insensitive)
        for candidate in patient_id_candidates:
            for col in original_columns:
                if col.lower() == candidate.lower():
                    patient_id_col = col
                    break
            if patient_id_col:
                break
        
        if patient_id_col:
            logger.info(f"✅ Found patient_id column: {patient_id_col}")
            
            # Generate encounter_id for each row using current processing date
            df['encounter_id'] = df[patient_id_col].apply(
                lambda pid: generate_encounter_id(pid, processing_datetime)
            )
            
            # Log statistics
            total_rows = len(df)
            valid_encounter_ids = df['encounter_id'].notna().sum()
            logger.info(f"📊 Generated {valid_encounter_ids}/{total_rows} encounter IDs")
            
            if valid_encounter_ids < total_rows:
                missing_count = total_rows - valid_encounter_ids
                logger.warning(f"⚠️  {missing_count} rows missing encounter_id (likely null patient_id)")
            
            # Show sample encounter_ids
            sample_ids = df['encounter_id'].dropna().head(5).tolist()
            logger.info(f"📋 Sample encounter_ids: {sample_ids}")
            
        else:
            logger.error(f"❌ Could not find patient_id column!")
            logger.error(f"   Searched for: {patient_id_candidates}")
            logger.error(f"   Available columns: {original_columns[:20]}...")
            logger.warning(f"⚠️  Proceeding without encounter_id generation")
        
        logger.info(f"{'─'*70}")
        
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
            
            # ===== INSERT ENCOUNTERS (MASTER RECORDS) =====
            logger.info(f"\n{'─'*70}")
            logger.info(f"🏥 INSERTING ENCOUNTER RECORDS")
            logger.info(f"{'─'*70}")
            
            encounter_db_ids = []
            valid_rows = df[df['encounter_id'].notna()].copy()
            
            for idx, row in valid_rows.iterrows():
                encounter_id = row['encounter_id']
                patient_id = row[patient_id_col] if patient_id_col else None
                
                try:
                    encounter_db_id = upsert_encounter_record(
                        cursor, conn, encounter_id, patient_id, processing_datetime
                    )
                    encounter_db_ids.append(encounter_id)
                except Exception as e:
                    logger.error(f"❌ Failed to insert encounter {encounter_id}: {str(e)}")
                    continue
            
            logger.info(f"✅ Processed {len(encounter_db_ids)} encounter records")
            all_encounter_ids.extend(encounter_db_ids)
            
            # Discover all specialty tables
            logger.info(f"\n{'─'*70}")
            logger.info(f"🔍 Discovering specialty tables...")
            logger.info(f"{'─'*70}")
            
            tables = get_all_specialty_tables(cursor)
            
            if not tables:
                logger.error("❌ No specialty tables found!")
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
            
            # Process each specialty table
            for table_name in tables:
                logger.info(f"\n{'─'*70}")
                logger.info(f"📋 Processing: {table_name}")
                logger.info(f"{'─'*70}")
                
                if table_name not in table_schemas:
                    logger.warning(f"⚠️  Skipping {table_name} - no schema")
                    continue
                
                try:
                    rows_inserted, inserted_ids = insert_data_to_table(
                        cursor, conn, table_name, df, table_schemas[table_name]
                    )
                    
                    total_inserted[table_name] += rows_inserted
                    logger.info(f"✅ Completed {table_name}: {rows_inserted} rows inserted")
                    
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
    logger.info(f"Processing Date: {processing_datetime.strftime('%Y-%m-%d %H:%M:%S')}")
    logger.info(f"Files processed: {files_processed}")
    
    for table, count in sorted(total_inserted.items()):
        logger.info(f"  • {table}: {count} rows")
    
    total_rows = max(total_inserted.values()) if total_inserted.values() else 0
    logger.info(f"\nTotal unique data rows: {total_rows}")
    logger.info(f"Encounter IDs created: {len(all_encounter_ids)}")
    
    if all_encounter_ids:
        logger.info(f"Sample encounter IDs: {all_encounter_ids[:5]}")
    
    logger.info(f"{'='*70}")
    
    # ===== TRIGGER CARBONE LAMBDA FOR DOCUMENT GENERATION =====
    if all_encounter_ids:
        carbone_triggered = trigger_carbone_lambda(
            lambda_client=lambda_client,
            function_name=CARBONE_LAMBDA_FUNCTION_NAME,
            record_ids=all_encounter_ids,
            metadata={
                'source_file': key if 'key' in locals() else 'unknown',
                'total_rows': total_rows,
                'tables_updated': list(total_inserted.keys()),
                'processing_date': processing_datetime.strftime('%Y%m%d')
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
            "processing_date": processing_datetime.strftime('%Y%m%d'),
            "insertions": total_inserted,
            "tables": list(total_inserted.keys()),
            "total_rows": total_rows,
            "encounter_count": len(all_encounter_ids),
            "encounter_ids": all_encounter_ids[:20],  # Return first 20 IDs
            "carbone_triggered": carbone_triggered,
            "timestamp": processing_datetime.isoformat()
        }, indent=2, default=str)
    }