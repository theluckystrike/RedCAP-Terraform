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
low_logs_retention_days         = 7        # Shorter retention in dev
enable_vpc_endpoints            = true     # S3 endpoint is free
enable_secrets_manager_endpoint = false    # Skip interface endpoints in dev (has hourly cost)

# RDS Configuration - Minimal for development

db_instance_class               = "db.t3.micro"   # Smallest instance (~$13/month)
allocated_storage               = 20              # Minimum storage
max_allocated_storage           = 0               # No auto-scaling in dev
multi_az                        = false           # Single AZ for dev
backup_retention_period         = 1               # Minimal backups
skip_final_snapshot             = true            # Easy cleanup
deletion_protection             = false           # Allow easy deletion

# RDS Monitoring - Minimal

enhanced_monitoring_interval    = 0           # Disabled to save costs
performance_insights_enabled    = false       # Disabled to save costs
create_cloudwatch_alarms        = false       # No alarms in dev

allowed_database_cidr_blocks = ["10.0.0.0/16"]

# S3 Configuration - Development settings
s3_encryption_type           = "AES256"    # Basic encryption (no KMS cost)
s3_enable_versioning         = true        # Keep versioning for safety
s3_enable_lifecycle_rules    = true        # Enable lifecycle for cost savings

# S3 Lifecycle - Aggressive cleanup for dev
s3_processed_transition_days = 7           # Move to IA after 1 week
s3_processed_glacier_days    = 30          # Move to Glacier after 1 month
s3_processed_expiration_days = 90          # Delete after 3 months
s3_failed_expiration_days    = 7           # Delete failed files after 1 week
s3_incoming_expiration_days  = 3           # Delete unprocessed files after 3 days

# S3 Features
s3_enable_event_notifications = true       # Lambda Function trigger
s3_enable_eventbridge        = false       # No EventBridge in dev
s3_enable_cors               = false       # No CORS needed yet
s3_enable_logging            = false       # No access logs in dev (save costs)
s3_create_cloudwatch_alarms  = false       # No alarms in dev

# Tags
tags = {
  Environment  = "development"
  Project      = "REDCap Automation"
  Owner        = "DevTeam"
  CostCenter   = "Development"
  HIPAA        = "false"
  AutoShutdown = "true"  # Can be used for automated shutdown scripts
}