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

# ===== VPC Module =====
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

# ===== EC2 Module =====
module "ec2_redcap" {
  source           = "../../modules/ec2"
  ami              = "ami-010876b9ddd38475e"
  instance_type    = "t2.micro"
  key_name         = var.key_name
  private_key_path = var.private_key_path
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.public_subnet_ids[0]
}

# ===== Security Groups =====

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
    description     = "PostgreSQL from Lambda"
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

# Allow EC2 to access RDS
resource "aws_security_group_rule" "rds_from_ec2" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = module.ec2_redcap.security_group_id
  description              = "PostgreSQL from EC2 RedCAP instance"
}

# ===== VPC Endpoints =====

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.vpc.private_route_table_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-s3-endpoint"
    Environment = var.environment
  }
}

# ===== RDS Module =====

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
  rds_security_group_id    = aws_security_group.rds.id
  
  tags = var.tags

  depends_on = [module.vpc]
}

# ===== Secrets Manager =====

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

# ===== RDS Proxy =====

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

# IAM Policy for RDS Proxy
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

  vpc_subnet_ids         = module.vpc.db_subnet_ids
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

resource "aws_db_proxy_default_target_group" "default" {
  db_proxy_name = aws_db_proxy.redcap_proxy.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent = 50
    session_pinning_filters      = ["EXCLUDE_VARIABLE_SETS"]
  }
}

resource "aws_db_proxy_target" "redcap_target" {
  db_proxy_name          = aws_db_proxy.redcap_proxy.name
  target_group_name      = aws_db_proxy_default_target_group.default.name
  db_instance_identifier = module.rds.db_instance_identifier
}

# ===== Lambda Layer =====

resource "aws_lambda_layer_version" "data_processing_deps" {
  filename            = "lambda_layer.zip"
  layer_name          = "${var.project_name}-${var.environment}-data-processing-deps"
  compatible_runtimes = ["python3.11"]
  description         = "Lambda layer for pandas, numpy, psycopg2, openpyxl"
  license_info        = "MIT"
}



# ===== S3 Module =====
module "s3" {
  source = "../../modules/s3"

  project_name = var.project_name
  environment  = var.environment
  bucket_name  = var.s3_bucket_name

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

  enable_event_notifications = false
  lambda_function_arn        = ""
  lambda_function_name       = ""
  enable_eventbridge         = false

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


}

# ===== Data Ingestion Lambda =====

module "lambda" {
  source = "../../modules/lambda"

  # Required
  project_name          = var.project_name
  environment           = var.environment
  aws_region            = var.aws_region
  lambda_package_path   = "lambda_function.zip"
  db_proxy_endpoint     = aws_db_proxy.redcap_proxy.endpoint
  db_name               = module.rds.db_name
  secret_arn            = aws_secretsmanager_secret.rds_credentials.arn
  vpc_id                = module.vpc.vpc_id
  lambda_subnet_ids     = module.vpc.private_subnet_ids
  lambda_security_group_id = aws_security_group.lambda.id
  rds_security_group_id    = module.rds.security_group_id
  lambda_layers = [aws_lambda_layer_version.data_processing_deps.arn]

  s3_bucket_id          = module.s3.bucket_id
  s3_bucket_arn         = module.s3.bucket_arn

  # Optional with defaults
  tags = var.tags

  # Deprecated - empty values
  db_host     = ""
  db_user     = ""
  db_password = ""
  rds_sg_id   = module.rds.security_group_id

  depends_on = [
    module.rds,
    module.s3,  
    aws_db_proxy.redcap_proxy,
    aws_secretsmanager_secret.rds_credentials
  ]
}

# ===== CARBONE DOCUMENT GENERATION PIPELINE =====

# S3 Bucket for Carbone Templates
resource "aws_s3_bucket" "carbone_templates" {
  count = var.enable_carbone_lambda ? 1 : 0

  bucket = var.template_bucket_name != "" ? var.template_bucket_name : "${var.project_name}-${var.environment}-carbone-templates"

  tags = merge(
    var.tags,
    {
      Name        = "Carbone Templates"
      Purpose     = "Document Templates Storage"
      Environment = var.environment
    }
  )
}

resource "aws_s3_bucket_versioning" "templates_versioning" {
  count = var.enable_carbone_lambda ? 1 : 0

  bucket = aws_s3_bucket.carbone_templates[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "templates_encryption" {
  count = var.enable_carbone_lambda ? 1 : 0

  bucket = aws_s3_bucket.carbone_templates[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "templates_block" {
  count = var.enable_carbone_lambda ? 1 : 0

  bucket = aws_s3_bucket.carbone_templates[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket for Generated Documents (Output)
resource "aws_s3_bucket" "carbone_output" {
  count = var.enable_carbone_lambda ? 1 : 0

  bucket = var.output_bucket_name != "" ? var.output_bucket_name : "${var.project_name}-${var.environment}-generated-documents"

  tags = merge(
    var.tags,
    {
      Name        = "Generated Documents"
      Purpose     = "Generated PDF Storage"
      Environment = var.environment
    }
  )
}

resource "aws_s3_bucket_versioning" "output_versioning" {
  count = var.enable_carbone_lambda ? 1 : 0

  bucket = aws_s3_bucket.carbone_output[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "output_encryption" {
  count = var.enable_carbone_lambda ? 1 : 0

  bucket = aws_s3_bucket.carbone_output[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "output_block" {
  count = var.enable_carbone_lambda ? 1 : 0

  bucket = aws_s3_bucket.carbone_output[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "output_lifecycle" {
  count = var.enable_carbone_lambda ? 1 : 0

  bucket = aws_s3_bucket.carbone_output[0].id

  rule {
    id     = "delete-old-documents"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = var.s3_processed_expiration_days
    }

    noncurrent_version_expiration {
      noncurrent_days = var.s3_noncurrent_version_expiration_days
    }
  }

  rule {
    id     = "transition-to-ia"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = var.s3_processed_transition_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.s3_processed_glacier_days
      storage_class = "GLACIER"
    }
  }
}

# SNS Topic for Carbone Notifications
resource "aws_sns_topic" "carbone_notifications" {
  count = var.enable_carbone_lambda && length(var.notification_emails) > 0 ? 1 : 0

  name         = "${var.project_name}-${var.environment}-carbone-notifications"
  display_name = "Carbone Document Generation Notifications"

  tags = merge(
    var.tags,
    {
      Name        = "Carbone Notifications"
      Environment = var.environment
    }
  )
}

resource "aws_sns_topic_subscription" "email_subscriptions" {
  for_each = var.enable_carbone_lambda && length(var.notification_emails) > 0 ? toset(var.notification_emails) : []

  topic_arn = aws_sns_topic.carbone_notifications[0].arn
  protocol  = "email"
  endpoint  = each.value
}

# ===== Carbone EC2 Instance (from AWS Marketplace AMI) =====
module "carbone_ec2" {
  count = var.enable_carbone_lambda ? 1 : 0

  source = "../../modules/carbone-ec2"

  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  vpc_cidr                  = module.vpc.vpc_cidr
  private_subnet_ids        = module.vpc.private_subnet_ids
  lambda_security_group_id  = aws_security_group.lambda.id
  instance_type             = var.carbone_instance_type
  key_name                  = var.key_name
  log_retention_days        = var.low_logs_retention_days
  enable_cloudwatch_alarms  = var.enable_carbone_cloudwatch_alarms
  carbone_ami_id            = var.carbone_ami_id  # Add this line
  
  alarm_actions = length(var.notification_emails) > 0 ? [aws_sns_topic.carbone_notifications[0].arn] : []

  tags = var.tags

  depends_on = [module.vpc]
}

# ===== Carbone Lambda Module =====
module "carbone_lambda" {
  count = var.enable_carbone_lambda ? 1 : 0

  source = "../../modules/carbone-lambda"

  # General Configuration
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  # Database Configuration
  db_name           = module.rds.db_name
  db_proxy_endpoint = aws_db_proxy.redcap_proxy.endpoint
  db_secret_arn     = aws_secretsmanager_secret.rds_credentials.arn

  # S3 Configuration
  template_bucket_name = aws_s3_bucket.carbone_templates[0].id
  output_bucket_name   = aws_s3_bucket.carbone_output[0].id

  # Networking
  vpc_id                   = module.vpc.vpc_id
  private_subnet_ids       = module.vpc.private_subnet_ids
  lambda_security_group_id = aws_security_group.lambda.id

  # Lambda Configuration
  lambda_runtime     = "python3.11"
  lambda_memory_size = var.carbone_lambda_memory_size
  lambda_timeout     = var.carbone_lambda_timeout

  # Carbone Configuration - Use EC2 endpoint (no API key needed)
  carbone_api_key  = null
  carbone_endpoint = module.carbone_ec2[0].carbone_endpoint
  carbone_version  = var.carbone_version

  # SNS Configuration
  sns_topic_arn = length(var.notification_emails) > 0 ? aws_sns_topic.carbone_notifications[0].arn : null

  # Monitoring
  enable_cloudwatch_alarms = var.enable_carbone_cloudwatch_alarms
  enable_dashboard         = var.enable_carbone_dashboard
  enable_xray_tracing      = true
  log_retention_days       = var.low_logs_retention_days
  
  alarm_actions = length(var.notification_emails) > 0 ? [aws_sns_topic.carbone_notifications[0].arn] : []

  # Scheduling
  enable_scheduled_generation = var.enable_scheduled_generation
  schedule_expression         = var.schedule_expression
  default_record_ids          = var.default_record_ids
  default_template_name       = var.default_template_name

  # Additional Lambda Layers
  additional_lambda_layers = []

  # Tags
  tags = merge(
    var.tags,
    {
      Component   = "Carbone Document Generator"
      Purpose     = "PDF Generation from RDS"
      Environment = var.environment
    }
  )

  depends_on = [
    aws_s3_bucket.carbone_templates,
    aws_s3_bucket.carbone_output,
    aws_db_proxy.redcap_proxy,
    aws_secretsmanager_secret.rds_credentials,
    module.carbone_ec2
  ]
}

# ===== SSM Parameters =====

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
  value = "10"
}

# ===== OUTPUTS =====

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

    carbone = var.enable_carbone_lambda ? {
      lambda_function = module.carbone_lambda[0].lambda_function_name
      template_bucket = aws_s3_bucket.carbone_templates[0].id
      output_bucket   = aws_s3_bucket.carbone_output[0].id
      ec2_instance    = module.carbone_ec2[0].carbone_instance_id
      dashboard_url   = module.carbone_lambda[0].dashboard_url
    } : null
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

# ===== Carbone Outputs =====

output "carbone_instance_id" {
  description = "Carbone EC2 instance ID"
  value       = var.enable_carbone_lambda ? module.carbone_ec2[0].carbone_instance_id : null
}

output "carbone_private_ip" {
  description = "Carbone EC2 private IP address"
  value       = var.enable_carbone_lambda ? module.carbone_ec2[0].carbone_private_ip : null
  sensitive   = true
}

output "carbone_endpoint" {
  description = "Carbone service endpoint"
  value       = var.enable_carbone_lambda ? module.carbone_ec2[0].carbone_endpoint : null
  sensitive   = true
}

output "carbone_security_group_id" {
  description = "Carbone EC2 security group ID"
  value       = var.enable_carbone_lambda ? module.carbone_ec2[0].carbone_security_group_id : null
}

output "carbone_ssm_connect_command" {
  description = "Command to connect to Carbone EC2 via SSM"
  value       = var.enable_carbone_lambda ? "aws ssm start-session --target ${module.carbone_ec2[0].carbone_instance_id}" : null
}

output "carbone_lambda_function_name" {
  description = "Carbone Lambda function name"
  value       = var.enable_carbone_lambda ? module.carbone_lambda[0].lambda_function_name : null
}

output "carbone_lambda_function_arn" {
  description = "Carbone Lambda function ARN"
  value       = var.enable_carbone_lambda ? module.carbone_lambda[0].lambda_function_arn : null
}

output "carbone_template_bucket_name" {
  description = "Carbone template S3 bucket name"
  value       = var.enable_carbone_lambda ? aws_s3_bucket.carbone_templates[0].id : null
}

output "carbone_output_bucket_name" {
  description = "Carbone output S3 bucket name"
  value       = var.enable_carbone_lambda ? aws_s3_bucket.carbone_output[0].id : null
}

output "carbone_dashboard_url" {
  description = "Carbone CloudWatch dashboard URL"
  value       = var.enable_carbone_lambda && var.enable_carbone_dashboard ? module.carbone_lambda[0].dashboard_url : null
}

output "carbone_log_group_name" {
  description = "Carbone Lambda CloudWatch log group name"
  value       = var.enable_carbone_lambda ? module.carbone_lambda[0].log_group_name : null
}

output "carbone_setup_commands" {
  description = "Quick setup commands for Carbone"
  value = var.enable_carbone_lambda ? {
    upload_template = "aws s3 cp template.odt s3://${aws_s3_bucket.carbone_templates[0].id}/templates/"
    invoke_lambda   = "aws lambda invoke --function-name ${module.carbone_lambda[0].lambda_function_name} --payload '{\"record_ids\":[1],\"template_name\":\"template.odt\"}' --cli-binary-format raw-in-base64-out response.json"
    tail_logs       = "aws logs tail ${module.carbone_lambda[0].log_group_name} --follow"
    connect_ec2     = "aws ssm start-session --target ${module.carbone_ec2[0].carbone_instance_id}"
    check_documents = "aws s3 ls s3://${aws_s3_bucket.carbone_output[0].id}/generated/ --recursive"
  } : null
}