terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.12"
    }
  }
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "redcap-eu-west-1"
    key            = "redcap/dev/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "redcap-eu-west-1"
    encrypt        = true
  }
}

module "vpc" {
  source               = "../../modules/vpc"
  environment          = var.environment
  project              = var.project
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs      = var.db_subnet_cidrs
  create_ha_nat        = var.create_ha_nat
}

module "ec2_redcap" {
  source           = "../../modules/ec2"
  ami              = "ami-010876b9ddd38475e"
  instance_type    = "t2.micro"
  key_name         = var.key_name
  private_key_path = var.private_key_path
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.public_subnet_ids[0]
}

# Security Group for Lambda
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

# Security Group for RDS Proxy
resource "aws_security_group" "rds_proxy" {
  name        = "${var.project_name}-${var.environment}-rds-proxy-sg"
  description = "Security group for RDS Proxy"
  vpc_id      = module.vpc.vpc_id
  
  ingress {
    description     = "PostgreSQL from Lambda"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda.id]
  }

  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-proxy-sg"
    Environment = var.environment
  }
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS database"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "PostgreSQL from RDS Proxy"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.rds_proxy.id]
  }

  ingress {
    description     = "PostgreSQL from Lambda (direct access if needed)"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-sg"
    Environment = var.environment
  }
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
  private_route_table_id   = module.vpc.private_route_table_id
  
  # Pass the RDS security group we created above
  rds_security_group_id = aws_security_group.rds.id
  
  tags = var.tags

  depends_on = [module.vpc]
}

# Store RDS credentials in Secrets Manager for RDS Proxy
resource "aws_secretsmanager_secret" "rds_credentials" {
  name        = "/redcap/${var.environment}/db_credentials"
  description = "RDS credentials for ${var.project_name} in ${var.environment}"

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "rds_credentials_version" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = module.rds.db_username
    password = module.rds.db_password
  })
}

# IAM Role for RDS Proxy
resource "aws_iam_role" "rds_proxy_role" {
  name = "${var.project_name}-${var.environment}-rds-proxy-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "rds.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-proxy-role"
    Environment = var.environment
  }
}

# IAM Policy for RDS Proxy to access Secrets Manager
resource "aws_iam_role_policy" "rds_proxy_secrets_policy" {
  name = "${var.project_name}-${var.environment}-rds-proxy-secrets-policy"
  role = aws_iam_role.rds_proxy_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.rds_credentials.arn
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:ViaService" = "secretsmanager.${var.aws_region}.amazonaws.com"
          }
        }
      }
    ]
  })
}

# RDS Proxy
resource "aws_db_proxy" "redcap_proxy" {
  name                = "${var.project_name}-${var.environment}-rds-proxy"
  engine_family       = "POSTGRESQL"
  idle_client_timeout = 1800
  require_tls         = true
  debug_logging       = false
  role_arn            = aws_iam_role.rds_proxy_role.arn

  # Fixed: Use module.vpc.db_subnet_ids instead of var.database_subnet_ids
  vpc_subnet_ids = module.vpc.db_subnet_ids
  
  # Fixed: Use rds_proxy security group instead of rds
  vpc_security_group_ids = [aws_security_group.rds_proxy.id]

  auth {
    auth_scheme = "SECRETS"
    secret_arn  = aws_secretsmanager_secret.rds_credentials.arn
    iam_auth    = "DISABLED"
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-${var.environment}-rds-proxy"
      Environment = var.environment
    }
  )

  depends_on = [
    aws_iam_role_policy.rds_proxy_secrets_policy,
    aws_secretsmanager_secret_version.rds_credentials_version
  ]
}

# Fixed: Use correct resource type
resource "aws_db_proxy_default_target_group" "default" {
  db_proxy_name = aws_db_proxy.redcap_proxy.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent = 50
    session_pinning_filters      = ["EXCLUDE_VARIABLE_SETS"]
  }
}

# RDS Proxy Target
resource "aws_db_proxy_target" "redcap_target" {
  db_proxy_name = aws_db_proxy.redcap_proxy.name
  target_group_name = aws_db_proxy_default_target_group.default.name
  
  # Fixed: Use output from RDS module
  db_instance_identifier = module.rds.db_instance_identifier
}

resource "aws_lambda_layer_version" "data_processing_deps" {
  filename   = "lambda_layer.zip"
  layer_name = "${var.project_name}-${var.environment}-data-processing-deps"
  compatible_runtimes = ["python3.11"]
  description = "Lambda layer for pandas, numpy, psycopg2, openpyxl"
  license_info = "MIT"
}


module "lambda" {
  source = "../../modules/lambda"

  project_name        = var.project_name
  rds_sg_id           = aws_security_group.rds.id
  environment         = var.environment
  lambda_package_path = "lambda_function.zip"
  db_host             = var.db_host
  db_name             = module.rds.db_name
  db_user             = module.rds.db_username
  db_password         = module.rds.db_password
  lambda_subnet_ids   = module.vpc.private_subnet_ids
  lambda_security_group_id = aws_security_group.lambda.id
  rds_security_group_id    = aws_security_group.rds.id
  db_proxy_endpoint        = aws_db_proxy.redcap_proxy.endpoint
  secret_arn               = aws_secretsmanager_secret.rds_credentials.arn
  vpc_id                   = module.vpc.vpc_id

  lambda_layers = [aws_lambda_layer_version.data_processing_deps.arn]

  tags                     = var.tags

  depends_on = [aws_db_proxy.redcap_proxy]
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

  processed_transition_days          = var.s3_processed_transition_days
  processed_glacier_days             = var.s3_processed_glacier_days
  processed_expiration_days          = var.s3_processed_expiration_days
  failed_expiration_days             = var.s3_failed_expiration_days
  incoming_expiration_days           = var.s3_incoming_expiration_days
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

  depends_on = [module.lambda]
}

# SSM Parameters for RedCap
resource "aws_ssm_parameter" "rds_instance_id" {
  name  = "/redcap/${var.environment}/rds_instance_id"
  type  = "String"
  value = module.rds.db_instance_identifier
}

resource "aws_ssm_parameter" "region" {
  name  = "/redcap/${var.environment}/region"
  type  = "String"
  value = var.aws_region
}

resource "aws_ssm_parameter" "db_uri" {
  name  = "/redcap/${var.environment}/db_uri"
  type  = "SecureString"
  value = module.rds.postgresql_connection_string
}

resource "aws_ssm_parameter" "num_parts" {
  name  = "/redcap/${var.environment}/num_parts"
  type  = "String"
  value = "3"
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
      endpoint       = module.rds.db_instance_endpoint
      port           = module.rds.db_instance_port
      database_name  = module.rds.db_name
      instance_class = module.rds.db_instance_class
      multi_az       = module.rds.db_instance_multi_az
      storage_gb     = module.rds.db_instance_allocated_storage
    }

    rds_proxy = {
      endpoint = aws_db_proxy.redcap_proxy.endpoint
      port     = 5432
    }

    s3 = {
      bucket_name      = module.s3.bucket_id
      incoming_folder  = module.s3.incoming_folder_uri
      processed_folder = module.s3.processed_folder_uri
      encryption       = module.s3.encryption_type
      versioning       = module.s3.versioning_enabled
    }
  }
  sensitive = true
}

output "db_instance_endpoint_clean" {
  description = "RDS endpoint without port"
  value       = regex("^([^:]+)", module.rds.db_instance_endpoint)[0]
  sensitive   = true
}

output "db_name" {
  value = module.rds.db_name
}

output "db_username" {
  value     = module.rds.db_username
  sensitive = true
}

output "db_password" {
  value     = module.rds.db_password
  sensitive = true
}

output "database_connection" {
  description = "Database connection information"
  value = {
    endpoint          = module.rds.db_instance_endpoint
    port              = module.rds.db_instance_port
    database_name     = module.rds.db_name
    username          = module.rds.db_username
    connection_string = module.rds.postgresql_connection_string
    proxy_endpoint    = aws_db_proxy.redcap_proxy.endpoint
  }
  sensitive = true
}

# Fixed: Output now references the correct resource
output "rds_sg_id" {
  description = "RDS Security Group ID"
  value       = aws_security_group.rds.id
}

output "rds_proxy_sg_id" {
  description = "RDS Proxy Security Group ID"
  value       = aws_security_group.rds_proxy.id
}

output "rds_proxy_endpoint" {
  description = "RDS Proxy endpoint for Lambda connections"
  value       = aws_db_proxy.redcap_proxy.endpoint
  sensitive   = true
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
  sensitive = true
}