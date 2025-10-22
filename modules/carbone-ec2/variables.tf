variable "project_name" {
  description = "Project name"
  type        = string
}

variable "carbone_ami_id" {
  description = "Carbone AMI ID (leave empty to auto-detect)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "lambda_security_group_id" {
  description = "Lambda security group ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = null
}

variable "log_retention_days" {
  description = "CloudWatch log retention days"
  type        = number
  default     = 30
}

variable "enable_cloudwatch_alarms" {
  description = "Enable CloudWatch alarms"
  type        = bool
  default     = true
}

variable "alarm_actions" {
  description = "SNS topic ARNs for alarms"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}