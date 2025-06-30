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

# Network Configuration
variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "database_subnet_ids" {
  description = "List of database subnet IDs from VPC module"
  type        = list(string)
  default     = null
}

variable "private_route_table_id" {
  description = "Private route table ID from the VPC module"
  type        = string
  default     = null  # optional, if you want to make it optional
}

variable "lambda_security_group_id" {
  description = "Security group ID of Lambda functions that need RDS access"
  type        = string
  default     = ""
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access RDS (for development/debugging)"
  type        = list(string)
  default     = []
}

# Database Configuration
variable "db_name" {
  description = "Name of the database to create"
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
  description = "Master password for the database (auto-generated if not provided)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "db_port" {
  description = "Port for PostgreSQL"
  type        = number
  default     = 5432
}

# Instance Configuration
variable "db_instance_class" {
  description = "Instance class for RDS"
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
  default     = 100
}

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1)"
  type        = string
  default     = "gp3"
  validation {
    condition     = contains(["gp2", "gp3", "io1"], var.storage_type)
    error_message = "Storage type must be gp2, gp3, or io1."
  }
}

# Engine Configuration
variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15"
}

variable "parameter_group_family" {
  description = "DB parameter group family"
  type        = string
  default     = "postgres15"
}

# High Availability
variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "Availability zone for single-AZ deployment"
  type        = string
  default     = null
}

# Backup Configuration
variable "backup_retention_period" {
  description = "Days to retain backups (0-35)"
  type        = number
  default     = 7
  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "Backup retention period must be between 0 and 35 days."
  }
}

variable "backup_window" {
  description = "Preferred backup window (UTC)"
  type        = string
  default     = "03:00-04:00"
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying"
  type        = bool
  default     = false
}

# Maintenance
variable "maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Apply changes immediately (not recommended for production)"
  type        = bool
  default     = false
}

# Performance Configuration
variable "max_connections" {
  description = "Maximum number of database connections"
  type        = string
  default     = "100"
}

variable "slow_query_log_threshold" {
  description = "Log queries slower than this (milliseconds)"
  type        = string
  default     = "1000"
}

variable "enable_query_logging" {
  description = "Enable logging of all queries (impacts performance)"
  type        = bool
  default     = false
}

# Monitoring
variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default     = ["postgresql"]
}

variable "enhanced_monitoring_interval" {
  description = "Enhanced monitoring interval in seconds (0 to disable)"
  type        = number
  default     = 0
  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.enhanced_monitoring_interval)
    error_message = "Enhanced monitoring interval must be 0, 1, 5, 10, 15, 30, or 60."
  }
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
  validation {
    condition     = contains([7, 731], var.performance_insights_retention_period)
    error_message = "Performance Insights retention must be 7 or 731 days."
  }
}

# CloudWatch Alarms
variable "create_cloudwatch_alarms" {
  description = "Create CloudWatch alarms for RDS"
  type        = bool
  default     = true
}

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

variable "alarm_sns_topic_arns" {
  description = "SNS topic ARNs for alarm notifications"
  type        = list(string)
  default     = []
}

# Encryption
variable "create_kms_key" {
  description = "Create a dedicated KMS key for RDS encryption"
  type        = bool
  default     = false
}

variable "kms_key_deletion_window" {
  description = "KMS key deletion window in days"
  type        = number
  default     = 30
}

# Protection
variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}