"""
Configuration module for Carbone Lambda
"""
import os

class Config:
    """Configuration class for Lambda environment variables"""
    
    # Database Configuration
    DB_NAME = os.environ.get('DB_NAME', 'redcap_docupilot')
    DB_PROXY_ENDPOINT = os.environ.get('DB_PROXY_ENDPOINT', '')
    SECRET_ARN = os.environ.get('SECRET_ARN', '')
    
    # S3 Configuration
    TEMPLATE_BUCKET = os.environ.get('TEMPLATE_BUCKET', '')
    OUTPUT_BUCKET = os.environ.get('OUTPUT_BUCKET', 'clinical-docs-dev-dev-generated-documents')
    
    # Carbone Configuration
    CARBONE_API_KEY = os.environ.get('CARBONE_API_KEY')
    CARBONE_ENDPOINT = os.environ.get('CARBONE_ENDPOINT')
    CARBONE_VERSION = os.environ.get('CARBONE_VERSION', '4')
    
    # SNS Configuration
    SNS_TOPIC_ARN = os.environ.get('SNS_TOPIC_ARN')
    
    # AWS Configuration
    REGION = os.environ.get('REGION', 'eu-west-1')
    
    # Document Settings
    DEFAULT_TEMPLATE = 'patient_report.docx'
    DEFAULT_OUTPUT_FORMAT = 'docx' 
    PRESIGNED_URL_EXPIRATION = 3600  # 1 hour
    
    # Database Tables - Now dynamically discovered, but can specify known tables for validation
    KNOWN_TABLE_PATTERNS = [
        'encounters',           # Master table
        'demographics',         # General info
        'shoulder_%',          # Shoulder tables (diagnosis, clinical, surgery, etc.)
        'elbow_%',             # Elbow tables (diagnosis, clinical, surgery, etc.)
        'general_%'            # Other general tables
    ]