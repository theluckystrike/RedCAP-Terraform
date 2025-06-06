variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "project" {
  description = "Project prefix"
  type        = string
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

# Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}