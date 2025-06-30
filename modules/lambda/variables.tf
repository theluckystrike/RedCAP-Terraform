variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "lambda_package_path" {
  type = string
  description = "Path to the ZIP file of the Lambda function code"
}

variable "db_host" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "lambda_subnet_ids" {
  type = list(string)
}

variable "lambda_security_group_id" {
  description = "Security Group ID for Lambda function"
  type        = string
}

variable "rds_security_group_id" {
  description = "RDS security group ID to allow Lambda access"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}