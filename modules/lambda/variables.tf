# -------------------------
# General Configuration
# -------------------------

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# -------------------------
# Lambda Configuration
# -------------------------

variable "lambda_package_path" {
  description = "Path to the ZIP file of the Lambda function code"
  type        = string
}

variable "lambda_layers" {
  description = "List of Lambda layer ARNs to attach"
  type        = list(string)
  default     = []
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 300
}

variable "lambda_memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 1024
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

# -------------------------
# Database Configuration
# -------------------------

variable "db_proxy_endpoint" {
  description = "RDS Proxy endpoint for database connection"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "secret_arn" {
  description = "Secrets Manager ARN for database credentials"
  type        = string
}

# DEPRECATED: These are now in Secrets Manager
# Kept for backward compatibility but not used
variable "db_host" {
  description = "[DEPRECATED] Database host - use db_proxy_endpoint instead"
  type        = string
  default     = ""
}

variable "db_user" {
  description = "[DEPRECATED] Database user - credentials now in Secrets Manager"
  type        = string
  default     = ""
  sensitive   = true
}

variable "db_password" {
  description = "[DEPRECATED] Database password - credentials now in Secrets Manager"
  type        = string
  default     = ""
  sensitive   = true
}

# -------------------------
# Networking Configuration
# -------------------------

variable "vpc_id" {
  description = "VPC ID for Lambda function"
  type        = string
}

variable "lambda_subnet_ids" {
  description = "Subnet IDs for Lambda VPC configuration (use private subnets)"
  type        = list(string)
}

variable "lambda_security_group_id" {
  description = "Security Group ID for Lambda function"
  type        = string
}

variable "rds_security_group_id" {
  description = "RDS security group ID to allow Lambda access"
  type        = string
}

# Alias for consistency
variable "rds_sg_id" {
  description = "[ALIAS] RDS security group ID - same as rds_security_group_id"
  type        = string
  default     = ""
}

# -------------------------
# S3 Configuration
# -------------------------

variable "s3_bucket_id" {
  description = "S3 bucket ID for Lambda trigger"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN for Lambda trigger"
  type        = string
}

variable "s3_trigger_prefix" {
  description = "S3 prefix for Lambda trigger (e.g., 'incoming/')"
  type        = string
  default     = "incoming/"
}

variable "s3_trigger_suffix" {
  description = "S3 suffix for Lambda trigger (e.g., '.xlsx')"
  type        = string
  default     = ".xlsx"
}