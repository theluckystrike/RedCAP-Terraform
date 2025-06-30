module "vpc" {
  source              = "../../modules/vpc"
  environment         = var.environment
  project             = var.project
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs
  create_ha_nat       = var.create_ha_nat
}

resource "aws_security_group" "lambda" {
  name_prefix = "${var.project_name}-${var.environment}-lambda-sg"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-lambda-sg"
  }
}

module "lambda" {
  source              = "../../modules/lambda"
  project_name        = var.project_name
  environment         = var.environment
  lambda_package_path = "lambda_function.zip"
  db_host             = var.db_host
  db_name             = module.rds.db_name
  db_user             = module.rds.db_username
  db_password         = module.rds.db_password
  lambda_subnet_ids   = module.vpc.private_subnet_ids
  lambda_security_group_id = aws_security_group.lambda.id
  rds_security_group_id = module.rds.rds_sg_id 
  vpc_id              = module.vpc.vpc_id
  tags                = var.tags
}

module "rds" {
  source = "../../modules/rds"

  project_name = var.project_name
  environment  = var.environment

  vpc_id              = module.vpc.vpc_id
  database_subnet_ids = module.vpc.db_subnet_ids

  allowed_cidr_blocks = var.allowed_database_cidr_blocks

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  db_instance_class     = var.db_instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  multi_az = var.multi_az

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot

  enhanced_monitoring_interval          = var.enhanced_monitoring_interval
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  create_cloudwatch_alarms              = var.create_cloudwatch_alarms

  alarm_cpu_threshold         = var.alarm_cpu_threshold
  alarm_disk_space_threshold  = var.alarm_disk_space_threshold
  alarm_connections_threshold = var.alarm_connections_threshold

  deletion_protection = var.deletion_protection
  create_kms_key      = var.create_kms_key

  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately
  
  lambda_security_group_id = aws_security_group.lambda.id
  private_route_table_id = module.vpc.private_route_table_id

  tags = var.tags
  
  depends_on = [module.vpc]
}

module "s3" {
  source = "../../modules/s3"

  project_name = var.project_name
  environment  = var.environment

  bucket_name = var.s3_bucket_name

  encryption_type = var.s3_encryption_type
  kms_key_id      = var.s3_kms_key_id

  enable_versioning      = var.s3_enable_versioning
  enable_lifecycle_rules = var.s3_enable_lifecycle_rules

  processed_transition_days           = var.s3_processed_transition_days
  processed_glacier_days              = var.s3_processed_glacier_days
  processed_expiration_days           = var.s3_processed_expiration_days
  failed_expiration_days              = var.s3_failed_expiration_days
  incoming_expiration_days            = var.s3_incoming_expiration_days
  noncurrent_version_expiration_days = var.s3_noncurrent_version_expiration_days

  enable_event_notifications = var.s3_enable_event_notifications
  lambda_function_arn        = module.lambda.lambda_function_arn
  lambda_function_name       = module.lambda.lambda_function_name
  enable_eventbridge         = var.s3_enable_eventbridge

  enable_cors          = var.s3_enable_cors
  cors_allowed_origins = var.s3_cors_allowed_origins

  enable_logging     = var.s3_enable_logging
  logging_bucket     = var.s3_logging_bucket
  log_retention_days = var.s3_log_retention_days

  create_cloudwatch_alarms     = var.s3_create_cloudwatch_alarms
  bucket_size_alarm_threshold  = var.s3_bucket_size_alarm_threshold
  object_count_alarm_threshold = var.s3_object_count_alarm_threshold
  alarm_sns_topic_arns         = var.s3_alarm_sns_topic_arns

  tags = var.tags

  # ✅ Fix: Ensure Lambda is created before S3 attempts to configure notification
  depends_on = [module.lambda]
}

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
      endpoint       = module.rds.db_instance_endpoint
      port           = module.rds.db_instance_port
      database_name  = module.rds.db_name
      instance_class = module.rds.db_instance_class
      multi_az       = module.rds.db_instance_multi_az
      storage_gb     = module.rds.db_instance_allocated_storage
    }

    s3 = {
      bucket_name      = module.s3.bucket_id
      incoming_folder  = module.s3.incoming_folder_uri
      processed_folder = module.s3.processed_folder_uri
      encryption       = module.s3.encryption_type
      versioning       = module.s3.versioning_enabled
    }
  }
}

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

output "database_password" {
  description = "Database password (only if auto-generated)"
  value       = module.rds.db_password
  sensitive   = true
}

output "s3_bucket_info" {
  description = "S3 bucket information for REDCap exports"
  value = {
    bucket_name      = module.s3.bucket_id
    bucket_arn       = module.s3.bucket_arn
    incoming_folder  = module.s3.incoming_folder_uri
    processed_folder = module.s3.processed_folder_uri
    failed_folder    = module.s3.failed_folder_uri
  }
}