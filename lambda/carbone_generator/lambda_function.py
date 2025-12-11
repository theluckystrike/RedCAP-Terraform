"""
Carbone Document Generator Lambda Function
Automatically generates documents when new data is added to RDS
"""

import os
import json
import logging
from datetime import datetime
from typing import List, Dict, Any

# Local imports
from db_handler import DatabaseHandler
from carbone_handler import CarboneHandler
from s3_handler import S3Handler
from utils import format_error_response, format_success_response
from config import Config

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    """
    Main Lambda handler for Carbone document generation
    
    Event Structure:
    {
        "record_ids": ["20231215_PAT001", "20231215_PAT002"],  # Now encounter_ids
        "template_name": "patient_report.odt",
        "output_format": "docx"
    }
    """
    
    execution_start = datetime.now()
    logger.info("="*70)
    logger.info("🚀 Carbone Document Generator Lambda Started")
    logger.info(f"   Execution ID: {context.aws_request_id if context else 'LOCAL'}")
    logger.info(f"   Timestamp: {execution_start.isoformat()}")
    logger.info("="*70)
    
    # Initialize handlers
    db_handler = None
    generated_files = []
    statistics = {
        'total_requested': 0,
        'successfully_generated': 0,
        'failed': 0,
        'execution_time_seconds': 0
    }
    
    try:
        # ===== 1. VALIDATE INPUT =====
        logger.info("📋 Step 1: Validating input parameters...")
        
        # Now expecting encounter_ids instead of record_ids
        encounter_ids = event.get('record_ids', [])  # Keep 'record_ids' key for backward compatibility
        template_name = event.get('template_name', Config.DEFAULT_TEMPLATE)
        output_format = event.get('output_format', 'docx')
        
        if not encounter_ids:
            logger.error("❌ No encounter IDs provided")
            return format_error_response(400, "No encounter IDs provided")
        
        if not isinstance(encounter_ids, list):
            logger.error("❌ record_ids must be a list")
            return format_error_response(400, "record_ids must be a list")
        
        statistics['total_requested'] = len(encounter_ids)
        
        logger.info(f"✅ Input validated:")
        logger.info(f"   - Encounter IDs: {encounter_ids[:5]}{'...' if len(encounter_ids) > 5 else ''}")
        logger.info(f"   - Total Encounters: {len(encounter_ids)}")
        logger.info(f"   - Template: {template_name}")
        logger.info(f"   - Output Format: {output_format}")
        
        # ===== 2. INITIALIZE HANDLERS =====
        logger.info("\n📦 Step 2: Initializing handlers...")
        
        config = Config()
        db_handler = DatabaseHandler(config)
        carbone_handler = CarboneHandler(config.CARBONE_ENDPOINT)
        s3_handler = S3Handler(config)
        
        logger.info("✅ All handlers initialized")
        
        # ===== 3. DOWNLOAD TEMPLATE =====
        logger.info(f"\n📄 Step 3: Downloading template from S3...")
        
        template_path = s3_handler.download_template(template_name)
        logger.info(f"✅ Template downloaded to: {template_path}")
        
        # Read template file into memory once (optimization)
        logger.info(f"📂 Reading template file into memory...")
        with open(template_path, 'rb') as template_file:
            template_bytes = template_file.read()
        logger.info(f"✅ Template loaded: {len(template_bytes):,} bytes")
        
        # ===== 4. PROCESS ENCOUNTERS =====
        logger.info(f"\n📊 Step 4: Processing {len(encounter_ids)} encounters...")
        
        for idx, encounter_id in enumerate(encounter_ids, 1):
            try:
                logger.info(f"\n{'─'*70}")
                logger.info(f"📋 Processing Encounter {idx}/{len(encounter_ids)}")
                logger.info(f"   Encounter ID: {encounter_id}")
                logger.info(f"{'─'*70}")
                
                # Fetch data from RDS using encounter_id
                record_data = db_handler.fetch_record_data(encounter_id)
                
                if not record_data:
                    logger.warning(f"⚠️  No data found for encounter ID: {encounter_id}")
                    statistics['failed'] += 1
                    continue
                
                logger.info(f"✅ Fetched {record_data['metadata']['total_fields']} fields from database")
                logger.info(f"   Tables with data: {record_data['metadata']['tables_with_data']}")
                
                # Add generation metadata
                record_data['generated_at'] = datetime.now().isoformat()
                record_data['generated_by'] = 'Carbone Lambda'
                record_data['document_format'] = output_format
                
                # Generate document
                logger.info(f"\n📄 Generating {output_format.upper()} document with Carbone...")
                document_bytes = carbone_handler.generate_document(
                    template_bytes,
                    record_data,
                    output_format
                )
                
                logger.info(f"✅ Document generated ({len(document_bytes):,} bytes)")
                
                # Upload to S3
                filename = f"{encounter_id}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.{output_format}"
                output_key = s3_handler.upload_document(
                    document_bytes,
                    filename,
                    output_format
                )
                
                logger.info(f"✅ Uploaded to S3: {output_key}")
                
                # Generate presigned URL
                presigned_url = s3_handler.generate_presigned_url(output_key)
                
                generated_files.append({
                    'encounter_id': encounter_id,
                    's3_key': output_key,
                    's3_url': f"s3://{config.OUTPUT_BUCKET}/{output_key}",
                    'presigned_url': presigned_url,
                    'file_size_bytes': len(document_bytes),
                    'format': output_format,
                    'generated_at': datetime.now().isoformat()
                })
                
                statistics['successfully_generated'] += 1
                logger.info(f"✅ Encounter {encounter_id} processed successfully")
                
            except Exception as e:
                logger.error(f"❌ Error processing encounter {encounter_id}: {str(e)}")
                import traceback
                logger.error(traceback.format_exc())
                statistics['failed'] += 1
                continue
        
        # ===== 5. SUMMARY =====
        execution_end = datetime.now()
        statistics['execution_time_seconds'] = (execution_end - execution_start).total_seconds()
        
        logger.info("\n" + "="*70)
        logger.info("📊 EXECUTION SUMMARY")
        logger.info("="*70)
        logger.info(f"✅ Total Requested: {statistics['total_requested']}")
        logger.info(f"✅ Successfully Generated: {statistics['successfully_generated']}")
        logger.info(f"❌ Failed: {statistics['failed']}")
        logger.info(f"⏱️  Execution Time: {statistics['execution_time_seconds']:.2f}s")
        logger.info(f"📁 Files Generated: {len(generated_files)}")
        logger.info(f"📑 Output Format: {output_format}")
        logger.info("="*70)
        
        return format_success_response({
            'message': f'Successfully generated {statistics["successfully_generated"]} {output_format.upper()} document(s)',
            'generated_files': generated_files,
            'statistics': statistics
        })
        
    except Exception as e:
        logger.error(f"\n❌ CRITICAL ERROR: {str(e)}")
        import traceback
        logger.error(traceback.format_exc())
        
        execution_end = datetime.now()
        statistics['execution_time_seconds'] = (execution_end - execution_start).total_seconds()
        
        return format_error_response(500, str(e), statistics)
        
    finally:
        # Cleanup
        if db_handler:
            db_handler.close()
            logger.info("🔌 Database connection closed")
        
        logger.info(f"🏁 Lambda execution completed at {datetime.now().isoformat()}")
