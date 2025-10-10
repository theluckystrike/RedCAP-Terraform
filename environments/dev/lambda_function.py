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

def clean_column_name(col):
    """Clean column names for PostgreSQL compatibility"""
    # Convert to string and strip whitespace
    col = str(col).strip()
    # Replace spaces with underscores
    col = col.replace(' ', '_')
    # Remove special characters except underscore
    col = re.sub(r'[^a-zA-Z0-9_]', '', col)
    # Convert to lowercase
    col = col.lower()
    # Ensure it doesn't start with a number
    if col and col[0].isdigit():
        col = f'col_{col}'
    return col

def lambda_handler(event, context):
    logger.info("Lambda started")
    DB_NAME = os.environ['DB_NAME']
    DB_PROXY_ENDPOINT = os.environ['DB_PROXY_ENDPOINT']
    SECRET_ARN = os.environ['SECRET_ARN']

    # Get credentials from Secrets Manager
    logger.info("Fetching secrets...")
    secrets_client = boto3.client('secretsmanager')
    secret = secrets_client.get_secret_value(SecretId=SECRET_ARN)
    creds = json.loads(secret['SecretString'])
    DB_USER = creds['username']
    DB_PASSWORD = creds['password']
    
    s3 = boto3.client('s3')
    logger.info("Secrets fetched successfully")

    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        local_path = f"/tmp/{key.split('/')[-1]}"
        
        logger.info(f"Downloading {key} from bucket {bucket}")
        s3.download_file(bucket, key, local_path)

        logger.info("Reading Excel file...")
        df = pd.read_excel(local_path)
        
        # Log original columns
        logger.info(f"Original columns ({len(df.columns)}): {df.columns.tolist()}")
        
        # Clean column names
        original_columns = df.columns.tolist()
        cleaned_columns = [clean_column_name(col) for col in original_columns]
        df.columns = cleaned_columns
        
        logger.info(f"Cleaned columns ({len(df.columns)}): {df.columns.tolist()}")
        logger.info(f"DataFrame shape: {df.shape}")
        
        # Check for empty DataFrame
        if df.empty:
            logger.warning("DataFrame is empty, skipping insert")
            continue
        
        # Handle NaN values (convert to None for SQL NULL)
        df = df.where(pd.notna(df), None)
        
        # Show sample data
        logger.info(f"Sample data (first row): {df.iloc[0].to_dict()}")
        
        # Connect via RDS Proxy
        logger.info("Connecting to database...")
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
            logger.info("Database connected successfully")
            cursor = conn.cursor()
            table_name = "redcap_data"

            # Get columns from DataFrame
            columns = df.columns.tolist()
            logger.info(f"Preparing to insert {len(columns)} columns: {columns}")
            
            # Convert DataFrame to list of tuples
            records = [tuple(x) for x in df.to_numpy()]
            
            # Validate data structure
            logger.info(f"Total records: {len(records)}")
            if records:
                logger.info(f"First record has {len(records[0])} values")
                logger.info(f"Columns count: {len(columns)}")
                
                # Verify match
                if len(columns) != len(records[0]):
                    error_msg = f"MISMATCH! Columns: {len(columns)}, Values in record: {len(records[0])}"
                    logger.error(error_msg)
                    logger.error(f"Columns: {columns}")
                    logger.error(f"First record: {records[0]}")
                    raise ValueError(error_msg)
            
            # Build query with escaped column names
            placeholders = ', '.join(['%s'] * len(columns))
            column_names = ', '.join([f'"{col}"' for col in columns])
            insert_query = f'INSERT INTO {table_name} ({column_names}) VALUES ({placeholders})'
            
            logger.info(f"Insert query: {insert_query}")
            
            # Execute batch insert
            logger.info(f"Executing batch insert of {len(records)} rows...")
            execute_batch(cursor, insert_query, records, page_size=100)
            
            conn.commit()
            logger.info(f"✅ Successfully inserted {len(records)} rows into {table_name}")
            
        except psycopg2.Error as db_error:
            if conn:
                conn.rollback()
            logger.error(f"❌ Database error: {str(db_error)}")
            logger.error(f"Error details: {db_error.pgerror if hasattr(db_error, 'pgerror') else 'N/A'}")
            raise
            
        except Exception as e:
            if conn:
                conn.rollback()
            logger.error(f"❌ Error processing file: {str(e)}")
            import traceback
            logger.error(f"Traceback: {traceback.format_exc()}")
            raise
            
        finally:
            if cursor:
                cursor.close()
            if conn:
                conn.close()
            logger.info("Database connection closed")

    return {
        "statusCode": 200, 
        "body": json.dumps(f"Successfully processed {len(event['Records'])} file(s)")
    }