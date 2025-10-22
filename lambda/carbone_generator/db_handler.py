"""
Database handler for RDS PostgreSQL operations
"""
import boto3
import psycopg2
import json
import logging
from typing import Dict, Optional, Any
from config import Config

logger = logging.getLogger()


class DatabaseHandler:
    """Handle all database operations"""
    
    def __init__(self, config: Config):
        self.config = config
        self.conn = None
        self.cursor = None
        self._connect()
    
    def _connect(self):
        """Establish connection to RDS via Proxy"""
        logger.info("🔐 Fetching database credentials from Secrets Manager...")
        
        try:
            # Get credentials from Secrets Manager
            secrets_client = boto3.client('secretsmanager', region_name=self.config.REGION)
            secret = secrets_client.get_secret_value(SecretId=self.config.SECRET_ARN)
            credentials = json.loads(secret['SecretString'])
            
            logger.info("✅ Credentials retrieved")
            
            # Connect to database via RDS Proxy
            logger.info(f"🔌 Connecting to RDS via Proxy: {self.config.DB_PROXY_ENDPOINT}")
            
            self.conn = psycopg2.connect(
                host=self.config.DB_PROXY_ENDPOINT,
                database=self.config.DB_NAME,
                user=credentials['username'],
                password=credentials['password'],
                port=5432,
                connect_timeout=10
            )
            
            self.cursor = self.conn.cursor()
            logger.info("✅ Database connection established")
            
        except Exception as e:
            logger.error(f"❌ Database connection failed: {str(e)}")
            raise
    
    def fetch_record_data(self, record_id: int) -> Optional[Dict[str, Any]]:
        """
        Fetch data from all sharded tables for a given record
        
        Args:
            record_id: Record ID to fetch
            
        Returns:
            Dictionary containing all record data
        """
        logger.info(f"🔍 Fetching data for record ID: {record_id}")
        
        record_data = {
            'record_id': record_id,
            'metadata': {
                'fetched_at': '',
                'total_fields': 0,
                'tables_processed': 0
            }
        }
        
        total_fields = 0
        tables_processed = 0
        
        for table_name in self.config.REDCAP_TABLES:
            try:
                # Get column names
                self.cursor.execute(f"""
                    SELECT column_name 
                    FROM information_schema.columns 
                    WHERE table_name = %s 
                    ORDER BY ordinal_position
                """, (table_name,))
                
                columns = [row[0] for row in self.cursor.fetchall()]
                
                if not columns:
                    logger.warning(f"⚠️  No columns found for {table_name}")
                    continue
                
                # Fetch data - adjust WHERE clause based on your schema
                column_list = ', '.join([f'"{col}"' for col in columns])
                
                # Option 1: If you have an 'id' column
                query = f'SELECT {column_list} FROM {table_name} WHERE id = %s'
                self.cursor.execute(query, (record_id,))
                
                # Option 2: If using LIMIT/OFFSET
                # query = f'SELECT {column_list} FROM {table_name} LIMIT 1 OFFSET %s'
                # self.cursor.execute(query, (record_id - 1,))
                
                row = self.cursor.fetchone()
                
                if row:
                    for col, val in zip(columns, row):
                        record_data[col] = val if val is not None else ''
                    
                    total_fields += len(columns)
                    tables_processed += 1
                    logger.info(f"✅ {table_name}: {len(columns)} fields")
                    
            except Exception as e:
                logger.error(f"❌ Error fetching from {table_name}: {str(e)}")
                continue
        
        # Update metadata
        from datetime import datetime
        record_data['metadata']['fetched_at'] = datetime.now().isoformat()
        record_data['metadata']['total_fields'] = total_fields
        record_data['metadata']['tables_processed'] = tables_processed
        
        if total_fields == 0:
            logger.warning(f"⚠️  No data found for record {record_id}")
            return None
        
        logger.info(f"✅ Total: {total_fields} fields from {tables_processed} tables")
        return record_data
    
    def close(self):
        """Close database connection"""
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
        logger.info("✅ Database connection closed")