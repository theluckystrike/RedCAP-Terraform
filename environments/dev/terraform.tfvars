environment         = "dev"
project             = "clinical-docs-dev"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
db_subnet_cidrs     = ["10.0.201.0/24", "10.0.202.0/24"]
create_ha_nat       = false