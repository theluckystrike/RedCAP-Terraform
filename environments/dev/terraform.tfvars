# Existing configurations...
environment                     = "dev"
project                         = "clinical-docs-dev"
vpc_cidr                        = "10.0.0.0/16"
public_subnet_cidrs             = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs            = ["10.0.101.0/24", "10.0.102.0/24"]
db_subnet_cidrs                 = ["10.0.201.0/24", "10.0.202.0/24"]
create_ha_nat                   = false
project_name                    = "clinical-docs-dev"
az_count                        = 2                   
enable_nat_gateway              = true
single_nat_gateway              = true                 
enable_flow_logs                = false  
low_logs_retention_days         = 7
enable_vpc_endpoints            = true
enable_secrets_manager_endpoint = false

# RDS Configuration
db_instance_class               = "db.t3.micro"
allocated_storage               = 20
max_allocated_storage           = 0
multi_az                        = false
backup_retention_period         = 1
skip_final_snapshot             = true
deletion_protection             = false

# RDS Monitoring
enhanced_monitoring_interval    = 0
performance_insights_enabled    = false
create_cloudwatch_alarms        = false
allowed_database_cidr_blocks    = ["10.0.0.0/16"]

# S3 Configuration
s3_encryption_type              = "AES256"
s3_enable_versioning            = true
s3_enable_lifecycle_rules       = true
s3_processed_transition_days    = 30
s3_processed_glacier_days       = 60
s3_processed_expiration_days    = 90
s3_failed_expiration_days       = 7
s3_incoming_expiration_days     = 3
s3_enable_event_notifications   = true
s3_enable_eventbridge           = false
s3_enable_cors                  = false
s3_enable_logging               = false
s3_create_cloudwatch_alarms     = false

# EC2
key_name                        = "my-ec2-key"
private_key_path                = "~/.ssh/id_rsa"

# ===== NEW: Carbone Lambda Configuration =====

# Enable/Disable Carbone Lambda
enable_carbone_lambda           = true

# Carbone API Configuration (choose one)
# Option 1: Use Carbone Cloud (recommended for dev)
carbone_api_key                 = ""  # Set via environment variable: export TF_VAR_carbone_api_key="your-key"

# Option 2: Use self-hosted Carbone (uncomment if using)
# carbone_endpoint                = "http://carbone-service.internal:3000"

carbone_version                 = "4"

# Lambda Configuration
carbone_lambda_memory_size      = 1024
carbone_lambda_timeout          = 300

# S3 Buckets for Carbone (auto-generated if empty)
template_bucket_name            = ""  # Will create: clinical-docs-dev-dev-carbone-templates
output_bucket_name              = ""  # Will create: clinical-docs-dev-dev-generated-documents

# Scheduling (disabled for dev)
enable_scheduled_generation     = false
schedule_expression             = "cron(0 8 * * ? *)"
default_record_ids              = []
default_template_name           = "patient_report.odt"

# Notifications
notification_emails             = [
  "ankitgarg9601@gmail.com"
]

carbone_ami_id = "ami-0b7d8b37ef766b435"

# Monitoring (enabled for dev testing)
enable_carbone_cloudwatch_alarms = true
enable_carbone_dashboard         = true

# Tags
tags = {
  Environment  = "development"
  Project      = "REDCap Automation"
  Owner        = "DevTeam"
  CostCenter   = "Development"
  HIPAA        = "false"
  AutoShutdown = "true"
  Component    = "Carbone Pipeline"
}