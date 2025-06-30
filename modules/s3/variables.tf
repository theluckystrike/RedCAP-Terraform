# modules/s3/variables.tf - Variables for S3 module

# General Configuration
variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "Environment must be dev, stg, or prod."
  }
}

variable "lambda_function_name" {
  description = "Name of the Lambda function for S3 trigger"
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "Name of the S3 bucket (leave empty for auto-generated name)"
  type        = string
  default     = ""
}

# Encryption Configuration
variable "encryption_type" {
  description = "Server-side encryption type (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "aws:kms"], var.encryption_type)
    error_message = "Encryption type must be AES256 or aws:kms."
  }
}

variable "kms_key_id" {
  description = "KMS key ID for encryption (required if encryption_type is aws:kms)"
  type        = string
  default     = ""
}

# Versioning
variable "enable_versioning" {
  description = "Enable bucket versioning"
  type        = bool
  default     = true
}

# Lifecycle Configuration
variable "enable_lifecycle_rules" {
  description = "Enable lifecycle rules for cost optimization"
  type        = bool
  default     = true
}

variable "processed_transition_days" {
  description = "Days before transitioning processed files to IA storage"
  type        = number
  default     = 30
}

variable "processed_glacier_days" {
  description = "Days before transitioning processed files to Glacier"
  type        = number
  default     = 90
}

variable "processed_expiration_days" {
  description = "Days before deleting processed files"
  type        = number
  default     = 365
}

variable "failed_expiration_days" {
  description = "Days before deleting failed files"
  type        = number
  default     = 30
}

variable "incoming_expiration_days" {
  description = "Days before deleting unprocessed incoming files"
  type        = number
  default     = 7
}

variable "noncurrent_version_expiration_days" {
  description = "Days before deleting noncurrent versions"
  type        = number
  default     = 30
}

# Event Notifications
variable "enable_event_notifications" {
  description = "Enable S3 event notifications"
  type        = bool
  default     = true
}

variable "lambda_function_arn" {
  description = "ARN of Lambda function to trigger on file upload"
  type        = string
  default     = ""
}

variable "enable_eventbridge" {
  description = "Enable EventBridge integration"
  type        = bool
  default     = false
}

# CORS Configuration
variable "enable_cors" {
  description = "Enable CORS configuration"
  type        = bool
  default     = false
}

variable "cors_allowed_origins" {
  description = "Allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

# Logging
variable "enable_logging" {
  description = "Enable S3 access logging"
  type        = bool
  default     = true
}

variable "logging_bucket" {
  description = "Target bucket for access logs (creates new bucket if empty)"
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "Days to retain access logs"
  type        = number
  default     = 30
}

# CloudWatch Alarms
variable "create_cloudwatch_alarms" {
  description = "Create CloudWatch alarms for S3 metrics"
  type        = bool
  default     = true
}

variable "create_lambda_permission" {
  description = "Whether to create the lambda permission"
  type        = bool
  default     = false
}

variable "lambda_security_group_id" {
  description = "Optional SG ID of Lambda to allow PostgreSQL access"
  type        = string
  default     = null
}

variable "bucket_size_alarm_threshold" {
  description = "Bucket size threshold for alarm in bytes"
  type        = number
  default     = 107374182400  # 100 GB
}

variable "object_count_alarm_threshold" {
  description = "Object count threshold for alarm"
  type        = number
  default     = 10000
}

variable "alarm_sns_topic_arns" {
  description = "SNS topic ARNs for alarm notifications"
  type        = list(string)
  default     = []
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "s3_enable_lifecycle_rules" {
  description = "Enable lifecycle rules and folder creation"
  type        = bool
  default     = true
}