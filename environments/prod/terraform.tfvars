environment         = "prod"
project             = "clinical-docs-prod"
vpc_cidr            = "10.10.0.0/16"
public_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
private_subnet_cidrs = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
db_subnet_cidrs     = ["10.10.201.0/24", "10.10.202.0/24", "10.10.203.0/24"]
create_ha_nat       = true