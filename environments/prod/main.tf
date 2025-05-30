
module "vpc" {
  source              = "../modules/vpc"
  environment         = var.environment
  project             = var.project
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs
  create_ha_nat       = var.create_ha_nat
}
