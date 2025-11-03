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
    
    # Database Tables
    REDCAP_TABLES = [
        'redcap_form_part_1', 'redcap_form_part_2', 'redcap_form_part_3',
        'redcap_form_part_4', 'redcap_form_part_5', 'redcap_form_part_6',
        'redcap_form_part_7', 'redcap_form_part_8', 'redcap_form_part_9',
        'redcap_form_part_10'
    ]