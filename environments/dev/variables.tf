variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "project" {
  description = "Project prefix"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "db_host" {
  description = "Database hostname"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private app subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDRs for DB subnets"
  type        = list(string)
}

variable "create_ha_nat" {
  description = "Whether to create NAT gateway in all AZs"
  type        = bool
}

variable "az_count" {
  description = "Number of availability zones to use"
  type        = number
  default     = 3
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "low_logs_retention_days" {
  description = "Retention period for logs in dev"
  type        = number
  default     = 7
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets"
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_logs_retention_days" {
  description = "Days to retain VPC Flow Logs"
  type        = number
  default     = 30
}

variable "enable_vpc_endpoints" {
  description = "Enable VPC endpoints for AWS services"
  type        = bool
  default     = true
}

variable "enable_secrets_manager_endpoint" {
  description = "Enable Secrets Manager VPC endpoint"
  type        = bool
  default     = true
}

# RDS Variables
variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "redcap_docupilot"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "dbadmin"
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the database (leave empty for auto-generation)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage in GB for autoscaling (0 to disable)"
  type        = number
  default     = 0
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Days to retain backups"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "allowed_database_cidr_blocks" {
  description = "CIDR blocks allowed to access RDS (for development)"
  type        = list(string)
  default     = []
}

# RDS Monitoring Variables
variable "enhanced_monitoring_interval" {
  description = "Enhanced monitoring interval in seconds (0 to disable)"
  type        = number
  default     = 0
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "Performance Insights retention period in days"
  type        = number
  default     = 7
}

variable "create_cloudwatch_alarms" {
  description = "Create CloudWatch alarms for RDS"
  type        = bool
  default     = true
}

# RDS Alarm Variables
variable "alarm_cpu_threshold" {
  description = "CPU utilization threshold for alarm (%)"
  type        = number
  default     = 80
}

variable "alarm_disk_space_threshold" {
  description = "Free disk space threshold for alarm (bytes)"
  type        = number
  default     = 2147483648  # 2GB
}

variable "alarm_connections_threshold" {
  description = "Connection count threshold for alarm"
  type        = number
  default     = 80
}

# RDS Security Variables
variable "create_kms_key" {
  description = "Create a dedicated KMS key for RDS encryption"
  type        = bool
  default     = false
}

# RDS Maintenance Variables
variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}

# S3 Variables
variable "s3_bucket_name" {
  description = "Name of the S3 bucket (leave empty for auto-generated)"
  type        = string
  default     = ""
}

variable "s3_encryption_type" {
  description = "S3 encryption type (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "s3_kms_key_id" {
  description = "KMS key ID for S3 encryption"
  type        = string
  default     = ""
}

variable "s3_enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "s3_enable_lifecycle_rules" {
  description = "Enable S3 lifecycle rules"
  type        = bool
  default     = true
}

# S3 Lifecycle Variables
variable "s3_processed_transition_days" {
  description = "Days before transitioning processed files to IA"
  type        = number
  default     = 30
}

variable "s3_processed_glacier_days" {
  description = "Days before transitioning processed files to Glacier"
  type        = number
  default     = 90
}

variable "database_subnet_ids" {
  description = "Subnet IDs for the RDS subnet group"
  type        = list(string)
  default     = null 
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-2"  # or whatever region you're using
}

variable "s3_processed_expiration_days" {
  description = "Days before deleting processed files"
  type        = number
  default     = 365
}

variable "s3_failed_expiration_days" {
  description = "Days before deleting failed files"
  type        = number
  default     = 30
}

variable "s3_incoming_expiration_days" {
  description = "Days before deleting unprocessed incoming files"
  type        = number
  default     = 7
}

variable "s3_noncurrent_version_expiration_days" {
  description = "Days before deleting noncurrent versions"
  type        = number
  default     = 30
}

# S3 Event Variables
variable "s3_enable_event_notifications" {
  description = "Enable S3 event notifications"
  type        = bool
  default     = true
}

variable "s3_lambda_function_arn" {
  description = "Lambda function ARN for S3 triggers"
  type        = string
  default     = ""
}

variable "s3_enable_eventbridge" {
  description = "Enable EventBridge integration"
  type        = bool
  default     = false
}

# S3 CORS Variables
variable "s3_enable_cors" {
  description = "Enable CORS configuration"
  type        = bool
  default     = false
}

variable "s3_cors_allowed_origins" {
  description = "Allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

# S3 Logging Variables
variable "s3_enable_logging" {
  description = "Enable S3 access logging"
  type        = bool
  default     = true
}

variable "s3_logging_bucket" {
  description = "Target bucket for logs"
  type        = string
  default     = ""
}

variable "s3_log_retention_days" {
  description = "Days to retain S3 access logs"
  type        = number
  default     = 30
}

# S3 Monitoring Variables
variable "s3_create_cloudwatch_alarms" {
  description = "Create CloudWatch alarms for S3"
  type        = bool
  default     = true
}

variable "s3_bucket_size_alarm_threshold" {
  description = "Bucket size threshold in bytes"
  type        = number
  default     = 107374182400  # 100 GB
}

variable "s3_object_count_alarm_threshold" {
  description = "Object count threshold"
  type        = number
  default     = 10000
}

variable "s3_alarm_sns_topic_arns" {
  description = "SNS topics for S3 alarms"
  type        = list(string)
  default     = []
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}