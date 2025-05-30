variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
}

variable "project" {
  description = "Prefix for naming resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private app subnets"
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "List of CIDR blocks for private database subnets"
  type        = list(string)
}

variable "create_ha_nat" {
  description = "Flag to create NAT gateway per AZ or only one"
  type        = bool
  default     = false
}