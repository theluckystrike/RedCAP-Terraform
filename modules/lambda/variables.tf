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

variable "tags" {
  type    = map(string)
  default = {}
}