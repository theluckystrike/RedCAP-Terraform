variable "name" { type = string }
variable "ami" { type = string }
variable "instance_type" { type = string, default = "t3.medium" }
variable "key_name" { type = string }
variable "subnet_id" { type = string }
variable "tags" { type = map(string), default = {} }
variable "config_prefix" { type = string, default = "/PROD/" }