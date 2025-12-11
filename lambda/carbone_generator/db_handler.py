"""
Database handler for RDS PostgreSQL operations
"""
import boto3
import psycopg2
import json
import logging
from typing import Dict, Optional, Any, List
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
    
    def discover_specialty_tables(self) -> List[str]:
        """
        Dynamically discover all specialty tables (excluding encounters and system tables)
        
        Returns:
            List of table names
        """
        logger.info("🔍 Discovering specialty tables...")
        
        try:
            query = """
                SELECT table_name 
                FROM information_schema.tables 
                WHERE table_schema = 'public' 
                  AND table_name != 'encounters'
                  AND table_name NOT LIKE 'pg_%'
                  AND table_name NOT IN ('pg_stat_statements', 'pg_buffercache')
                ORDER BY table_name;
            """
            
            self.cursor.execute(query)
            tables = [row[0] for row in self.cursor.fetchall()]
            
            logger.info(f"✅ Found {len(tables)} specialty tables")
            logger.info(f"   Tables: {tables}")
            
            return tables
            
        except Exception as e:
            logger.error(f"❌ Error discovering tables: {str(e)}")
            return []
    
    def fetch_encounter_data(self, encounter_id: str) -> Optional[Dict[str, Any]]:
        """
        Fetch encounter master record
        
        Args:
            encounter_id: Encounter ID (format: YYYYMMDD_PatientID)
            
        Returns:
            Dictionary containing encounter data
        """
        logger.info(f"🔍 Fetching encounter: {encounter_id}")
        
        try:
            # Get column names from encounters table
            self.cursor.execute("""
                SELECT column_name 
                FROM information_schema.columns 
                WHERE table_name = 'encounters'
                ORDER BY ordinal_position
            """)
            
            columns = [row[0] for row in self.cursor.fetchall()]
            
            if not columns:
                logger.error("❌ Encounters table has no columns!")
                return None
            
            # Fetch encounter data
            column_list = ', '.join([f'"{col}"' for col in columns])
            query = f'SELECT {column_list} FROM encounters WHERE encounter_id = %s'
            
            self.cursor.execute(query, (encounter_id,))
            row = self.cursor.fetchone()
            
            if not row:
                logger.warning(f"⚠️  Encounter not found: {encounter_id}")
                return None
            
            # Build encounter data dictionary
            encounter_data = {}
            for col, val in zip(columns, row):
                # Convert datetime/date objects to strings
                if hasattr(val, 'isoformat'):
                    encounter_data[col] = val.isoformat()
                else:
                    encounter_data[col] = val if val is not None else ''
            
            logger.info(f"✅ Encounter fetched: {len(columns)} fields")
            return encounter_data
            
        except Exception as e:
            logger.error(f"❌ Error fetching encounter: {str(e)}")
            return None
    
    def fetch_specialty_table_data(self, table_name: str, encounter_id: str) -> Dict[str, Any]:
        """
        Fetch data from a specialty table for a given encounter
        
        Args:
            table_name: Name of the specialty table
            encounter_id: Encounter ID to fetch
            
        Returns:
            Dictionary containing the table's data
        """
        try:
            # Get column names
            self.cursor.execute("""
                SELECT column_name 
                FROM information_schema.columns 
                WHERE table_name = %s 
                ORDER BY ordinal_position
            """, (table_name,))
            
            columns = [row[0] for row in self.cursor.fetchall()]
            
            if not columns:
                logger.warning(f"⚠️  No columns found for {table_name}")
                return {}
            
            # Fetch data using encounter_id
            column_list = ', '.join([f'"{col}"' for col in columns])
            query = f'SELECT {column_list} FROM {table_name} WHERE encounter_id = %s'
            
            self.cursor.execute(query, (encounter_id,))
            row = self.cursor.fetchone()
            
            if not row:
                logger.info(f"ℹ️  No data in {table_name} for encounter {encounter_id}")
                return {}
            
            # Build data dictionary
            table_data = {}
            for col, val in zip(columns, row):
                # Skip system columns to avoid duplication
                if col in ['id', 'encounter_id', 'created_at', 'updated_at']:
                    continue
                
                # Convert datetime/date objects to strings
                if hasattr(val, 'isoformat'):
                    table_data[col] = val.isoformat()
                else:
                    table_data[col] = val if val is not None else ''
            
            logger.info(f"✅ {table_name}: {len(table_data)} fields")
            return table_data
            
        except Exception as e:
            logger.error(f"❌ Error fetching from {table_name}: {str(e)}")
            return {}
    
    def fetch_record_data(self, encounter_id: str) -> Optional[Dict[str, Any]]:
        """
        Fetch complete record data from encounters table and all specialty tables
        
        Args:
            encounter_id: Encounter ID (format: YYYYMMDD_PatientID)
            
        Returns:
            Dictionary containing all record data merged from all tables
        """
        logger.info(f"\n{'='*70}")
        logger.info(f"🔍 FETCHING COMPLETE RECORD DATA")
        logger.info(f"   Encounter ID: {encounter_id}")
        logger.info(f"{'='*70}")
        
        # Initialize record data structure
        record_data = {
            'encounter_id': encounter_id,
            'metadata': {
                'fetched_at': '',
                'total_fields': 0,
                'tables_processed': 0,
                'tables_with_data': []
            }
        }
        
        total_fields = 0
        tables_processed = 0
        tables_with_data = []
        
        # 1. Fetch encounter master record
        logger.info("\n📋 Step 1: Fetching encounter master record...")
        encounter_data = self.fetch_encounter_data(encounter_id)
        
        if not encounter_data:
            logger.error(f"❌ Encounter not found: {encounter_id}")
            return None
        
        # Merge encounter data
        record_data.update(encounter_data)
        total_fields += len(encounter_data)
        tables_processed += 1
        tables_with_data.append('encounters')
        
        # 2. Discover and fetch from all specialty tables
        logger.info("\n📊 Step 2: Fetching from specialty tables...")
        specialty_tables = self.discover_specialty_tables()
        
        for table_name in specialty_tables:
            table_data = self.fetch_specialty_table_data(table_name, encounter_id)
            
            if table_data:
                # Merge table data into record_data
                record_data.update(table_data)
                total_fields += len(table_data)
                tables_with_data.append(table_name)
            
            tables_processed += 1
        
        # 3. Update metadata
        from datetime import datetime
        record_data['metadata']['fetched_at'] = datetime.now().isoformat()
        record_data['metadata']['total_fields'] = total_fields
        record_data['metadata']['tables_processed'] = tables_processed
        record_data['metadata']['tables_with_data'] = tables_with_data
        
        logger.info(f"\n{'='*70}")
        logger.info(f"✅ FETCH COMPLETE")
        logger.info(f"   Total Fields: {total_fields}")
        logger.info(f"   Tables Processed: {tables_processed}")
        logger.info(f"   Tables With Data: {len(tables_with_data)}")
        logger.info(f"   Tables: {tables_with_data}")
        logger.info(f"{'='*70}\n")
        
        if total_fields == 0:
            logger.warning(f"⚠️  No data found for encounter {encounter_id}")
            return None
        
        return record_data
    
    def close(self):
        """Close database connection"""
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()
        logger.info("✅ Database connection closed")