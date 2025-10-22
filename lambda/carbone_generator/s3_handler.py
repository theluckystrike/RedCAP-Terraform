"""
S3 operations handler
"""
import boto3
import logging
from datetime import datetime
from config import Config

logger = logging.getLogger()


class S3Handler:
    """Handle S3 operations"""
    
    def __init__(self, config: Config):
        self.config = config
        self.s3_client = boto3.client('s3', region_name=config.REGION)
    
    def download_template(self, template_name: str) -> str:
        """Download template from S3 to /tmp"""
        logger.info(f"⬇️  Downloading template: {template_name}")
        
        try:
            template_key = f"templates/{template_name}"
            local_path = f"/tmp/{template_name}"
            
            self.s3_client.download_file(
                self.config.TEMPLATE_BUCKET,
                template_key,
                local_path
            )
            
            logger.info(f"✅ Template downloaded to: {local_path}")
            return local_path
            
        except self.s3_client.exceptions.NoSuchKey:
            logger.error(f"❌ Template not found: {template_key}")
            raise FileNotFoundError(f"Template not found: {template_name}")
        except Exception as e:
            logger.error(f"❌ Template download failed: {str(e)}")
            raise
    
    def upload_document(self, document_bytes: bytes, filename: str) -> str:
        """Upload generated document to S3"""
        logger.info(f"⬆️  Uploading document: {filename}")
        
        try:
            timestamp = datetime.now().strftime('%Y%m%d')
            s3_key = f"generated/{timestamp}/{filename}"
            
            self.s3_client.put_object(
                Bucket=self.config.OUTPUT_BUCKET,
                Key=s3_key,
                Body=document_bytes,
                ContentType='application/pdf',
                ServerSideEncryption='AES256',
                Metadata={
                    'generated-by': 'carbone-lambda',
                    'generated-at': datetime.now().isoformat()
                }
            )
            
            logger.info(f"✅ Document uploaded: {s3_key}")
            return s3_key
            
        except Exception as e:
            logger.error(f"❌ Document upload failed: {str(e)}")
            raise
    
    def generate_presigned_url(self, s3_key: str, expiration: int = None) -> str:
        """Generate presigned URL for document access"""
        if expiration is None:
            expiration = self.config.PRESIGNED_URL_EXPIRATION
        
        try:
            url = self.s3_client.generate_presigned_url(
                'get_object',
                Params={
                    'Bucket': self.config.OUTPUT_BUCKET,
                    'Key': s3_key
                },
                ExpiresIn=expiration
            )
            
            logger.info(f"✅ Presigned URL generated (expires in {expiration}s)")
            return url
            
        except Exception as e:
            logger.error(f"❌ Presigned URL generation failed: {str(e)}")
            return f"s3://{self.config.OUTPUT_BUCKET}/{s3_key}"