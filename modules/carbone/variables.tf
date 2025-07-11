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