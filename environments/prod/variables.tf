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
