/**
 * Input Variables for Carbone Lambda Module
 */

# ===== General Configuration =====
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod"
  }
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

# ===== Database Configuration =====
variable "db_name" {
  description = "RDS database name"
  type        = string
}

variable "db_proxy_endpoint" {
  description = "RDS Proxy endpoint"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of Secrets Manager secret containing DB credentials"
  type        = string
}

# ===== S3 Configuration =====
variable "template_bucket_name" {
  description = "Name of S3 bucket containing Carbone templates"
  type        = string
}

variable "output_bucket_name" {
  description = "Name of S3 bucket for generated documents"
  type        = string
}

# ===== Networking Configuration =====
variable "vpc_id" {
  description = "VPC ID where Lambda will run"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for Lambda"
  type        = list(string)
}

variable "lambda_security_group_id" {
  description = "Security group ID for Lambda function"
  type        = string
}

# ===== Lambda Configuration =====
variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.11"
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 300
  validation {
    condition     = var.lambda_timeout >= 60 && var.lambda_timeout <= 900
    error_message = "Lambda timeout must be between 60 and 900 seconds"
  }
}

variable "lambda_memory_size" {
  description = "Lambda memory size in MB"
  type        = number
  default     = 1024
  validation {
    condition     = var.lambda_memory_size >= 128 && var.lambda_memory_size <= 10240
    error_message = "Lambda memory must be between 128 and 10240 MB"
  }
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrent executions for Lambda (-1 for no limit)"
  type        = number
  default     = -1
}

variable "lambda_alias_name" {
  description = "Lambda alias name"
  type        = string
  default     = "live"
}

variable "additional_lambda_layers" {
  description = "Additional Lambda layer ARNs"
  type        = list(string)
  default     = []
}

# ===== Carbone Configuration =====
variable "carbone_api_key" {
  description = "Carbone Cloud API key (optional)"
  type        = string
  sensitive   = true
  default     = null
}

variable "carbone_endpoint" {
  description = "Self-hosted Carbone endpoint URL (optional)"
  type        = string
  default     = null
}

variable "carbone_version" {
  description = "Carbone API version"
  type        = string
  default     = "4"
}

# ===== SNS Configuration =====
variable "sns_topic_arn" {
  description = "ARN of SNS topic for notifications (optional)"
  type        = string
  default     = null
}

# ===== CloudWatch Configuration =====
variable "log_retention_days" {
  description = "CloudWatch Logs retention in days"
  type        = number
  default     = 30
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days)
    error_message = "Invalid log retention days value"
  }
}

variable "cloudwatch_kms_key_arn" {
  description = "KMS key ARN for CloudWatch Logs encryption (optional)"
  type        = string
  default     = null
}

variable "enable_cloudwatch_alarms" {
  description = "Enable CloudWatch alarms"
  type        = bool
  default     = true
}

variable "enable_dashboard" {
  description = "Enable CloudWatch dashboard"
  type        = bool
  default     = true
}

# ===== Monitoring Configuration =====
variable "enable_xray_tracing" {
  description = "Enable AWS X-Ray tracing"
  type        = bool
  default     = true
}

variable "alarm_actions" {
  description = "List of ARNs for alarm actions (SNS topics)"
  type        = list(string)
  default     = []
}

# ===== Event Configuration =====
variable "max_event_age_seconds" {
  description = "Maximum event age for async invocations"
  type        = number
  default     = 3600
}

variable "max_retry_attempts" {
  description = "Maximum retry attempts for failed invocations"
  type        = number
  default     = 2
}

variable "success_destination_arn" {
  description = "ARN for successful invocation destination (optional)"
  type        = string
  default     = null
}

# ===== Encryption Configuration =====
variable "lambda_kms_key_arn" {
  description = "KMS key ARN for Lambda environment variable encryption (optional)"
  type        = string
  default     = null
}

variable "sqs_kms_key_id" {
  description = "KMS key ID for SQS encryption (optional)"
  type        = string
  default     = null
}

# ===== Additional Configuration =====
variable "additional_iam_policies" {
  description = "Additional IAM policies to attach to Lambda role (map of policy name to policy JSON)"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}