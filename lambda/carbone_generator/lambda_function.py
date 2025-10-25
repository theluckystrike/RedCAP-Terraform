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
        "record_ids": [1, 2, 3],
        "template_name": "patient_report.odt",
        "output_format": "pdf"
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
        
        record_ids = event.get('record_ids', [])
        template_name = event.get('template_name', Config.DEFAULT_TEMPLATE)
        output_format = event.get('output_format', 'pdf')
        
        if not record_ids:
            logger.error("❌ No record IDs provided")
            return format_error_response(400, "No record IDs provided")
        
        if not isinstance(record_ids, list):
            logger.error("❌ record_ids must be a list")
            return format_error_response(400, "record_ids must be a list")
        
        statistics['total_requested'] = len(record_ids)
        
        logger.info(f"✅ Input validated:")
        logger.info(f"   - Record IDs: {record_ids}")
        logger.info(f"   - Template: {template_name}")
        logger.info(f"   - Output Format: {output_format}")
        
        # ===== 2. INITIALIZE HANDLERS =====
        logger.info("\n📦 Step 2: Initializing handlers...")
        
        config = Config()
        db_handler = DatabaseHandler(config)
        carbone_handler = CarboneHandler(os.getenv('CARBONE_ENDPOINT'))
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
        
        # ===== 4. PROCESS RECORDS =====
        logger.info("\n📊 Step 4: Processing records...")
        
        for idx, record_id in enumerate(record_ids, 1):
            try:
                logger.info(f"\n--- Processing Record {idx}/{len(record_ids)} (ID: {record_id}) ---")
                
                # Fetch data from RDS
                record_data = db_handler.fetch_record_data(record_id)
                
                if not record_data:
                    logger.warning(f"⚠️  No data found for record ID: {record_id}")
                    statistics['failed'] += 1
                    continue
                
                logger.info(f"✅ Fetched {record_data['metadata']['total_fields']} fields from database")
                
                # Add generation metadata
                record_data['generated_at'] = datetime.now().isoformat()
                record_data['generated_by'] = 'Carbone Lambda'
                
                # Generate document - FIXED: Pass template_bytes instead of template_path
                logger.info(f"📄 Generating document with Carbone...")
                pdf_bytes = carbone_handler.generate_document(
                    template_bytes,  # ✅ Pass bytes, not path
                    record_data,
                    output_format
                )
                
                logger.info(f"✅ Document generated ({len(pdf_bytes):,} bytes)")
                
                # Upload to S3
                filename = f"record_{record_id}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.{output_format}"
                output_key = s3_handler.upload_document(pdf_bytes, filename)
                
                logger.info(f"✅ Uploaded to S3: {output_key}")
                
                # Generate presigned URL
                presigned_url = s3_handler.generate_presigned_url(output_key)
                
                generated_files.append({
                    'record_id': record_id,
                    's3_key': output_key,
                    's3_url': f"s3://{config.OUTPUT_BUCKET}/{output_key}",
                    'presigned_url': presigned_url,
                    'file_size_bytes': len(pdf_bytes)
                })
                
                statistics['successfully_generated'] += 1
                logger.info(f"✅ Record {record_id} processed successfully")
                
            except Exception as e:
                logger.error(f"❌ Error processing record {record_id}: {str(e)}")
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
        logger.info("="*70)
        
        return format_success_response({
            'message': f'Successfully generated {statistics["successfully_generated"]} document(s)',
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