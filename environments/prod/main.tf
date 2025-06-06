
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

# RDS Module
module "rds" {
  source = "./modules/rds"
  
  # Basic configuration
  project_name = var.project_name
  environment  = var.environment
  
  # Network configuration from VPC module
  vpc_id              = module.vpc.vpc_id
  database_subnet_ids = module.vpc.database_subnet_ids
  
  # For now, we'll handle Lambda security group later
  # lambda_security_group_id = module.lambda.security_group_id
  
  # Allow access from specific CIDR blocks (for development)
  allowed_cidr_blocks = var.allowed_database_cidr_blocks
  
  # Database configuration
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  
  # Instance configuration
  db_instance_class     = var.db_instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  
  # High availability
  multi_az = var.multi_az
  
  # Backup configuration
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  
  # Monitoring
  enhanced_monitoring_interval          = var.enhanced_monitoring_interval
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  create_cloudwatch_alarms             = var.create_cloudwatch_alarms
  
  # Alarm configuration
  alarm_cpu_threshold         = var.alarm_cpu_threshold
  alarm_disk_space_threshold  = var.alarm_disk_space_threshold
  alarm_connections_threshold = var.alarm_connections_threshold
  
  # Security
  deletion_protection = var.deletion_protection
  create_kms_key     = var.create_kms_key
  
  # Maintenance
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately
  
  # Tags
  tags = var.tags
  
  # Ensure VPC is created first
  depends_on = [module.vpc]
}

# Outputs
output "infrastructure_summary" {
  description = "Summary of deployed infrastructure"
  value = {
    environment = var.environment
    region      = var.aws_region
    
    vpc = {
      id                 = module.vpc.vpc_id
      cidr               = module.vpc.vpc_cidr
      availability_zones = module.vpc.availability_zones
      nat_gateways       = length(module.vpc.nat_gateway_ids)
    }
    
    rds = {
      endpoint      = module.rds.db_instance_endpoint
      port          = module.rds.db_instance_port
      database_name = module.rds.db_name
      instance_class = module.rds.db_instance_class
      multi_az      = module.rds.db_instance_multi_az
      storage_gb    = module.rds.db_instance_allocated_storage
    }
  }
}

# Database connection information (sensitive)
output "database_connection" {
  description = "Database connection information"
  value = {
    endpoint          = module.rds.db_instance_endpoint
    port              = module.rds.db_instance_port
    database_name     = module.rds.db_name
    username          = module.rds.db_username
    connection_string = module.rds.postgresql_connection_string
  }
  sensitive = true
}

# Output the generated password if applicable
output "database_password" {
  description = "Database password (only if auto-generated)"
  value       = module.rds.db_password
  sensitive   = true
}