variable "project_name" {}
variable "environment" {}

variable "db_host" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}

variable "processed_bucket_name" {}
variable "processed_bucket_arn" {}


variable "carbone_api_token" {
  description = "Your Carbone.io API token"
  type        = string
  sensitive   = true
}

variable "carbone_template_id" {
  description = "Your Carbone.io template ID"
  type        = string
}

variable "project_name" { type = string }
variable "environment"  { type = string }
variable "vpc_id"       { type = string }
variable "subnet_id"    { type = string }
variable "allowed_cidr_blocks" { type = list(string) }

variable "db_host"      { type = string }
variable "db_name"      { type = string }
variable "db_user"      { type = string }
variable "db_password"  { type = string, sensitive = true }

variable "processed_bucket_name" { type = string }
variable "processed_bucket_arn"  { type = string }

variable "carbone_api_token"    { type = string, sensitive = true }
variable "carbone_template_id"  { type = string }

variable "carbone_ami"           { type = string }
variable "carbone_instance_type" { type = string, default = "t3.medium" }