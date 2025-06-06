# modules/rds/main.tf - RDS PostgreSQL configuration for REDCap data

locals {
  db_name = replace(var.db_name, "-", "_")  # PostgreSQL doesn't allow hyphens in db names
  
  common_tags = merge(
    var.tags,
    {
      Module      = "rds"
      Environment = var.environment
      Project     = var.project_name
      Engine      = "postgresql"
    }
  )
}

# Generate a random password if not provided
resource "random_password" "db_password" {
  count   = var.db_password == "" ? 1 : 0
  length  = 32
  special = true
  # Exclude problematic characters for PostgreSQL
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# DB Subnet Group - uses the isolated database subnets from VPC
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.database_subnet_ids
  
  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  })
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-${var.environment}-rds-"
  description = "Security group for RDS PostgreSQL instance"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Allow PostgreSQL access from Lambda security group
resource "aws_security_group_rule" "rds_from_lambda" {
  count                    = var.lambda_security_group_id != "" ? 1 : 0
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = var.lambda_security_group_id
  security_group_id        = aws_security_group.rds.id
  description              = "PostgreSQL access from Lambda functions"
}

# Allow PostgreSQL access from specific CIDR blocks (for development/debugging)
resource "aws_security_group_rule" "rds_from_cidr" {
  count             = length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.rds.id
  description       = "PostgreSQL access from allowed CIDR blocks"
}

# Egress rule - PostgreSQL typically doesn't need outbound access
resource "aws_security_group_rule" "rds_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["127.0.0.1/32"]  # Effectively no outbound
  security_group_id = aws_security_group.rds.id
  description       = "Deny all outbound traffic"
}

# DB Parameter Group for PostgreSQL optimization
resource "aws_db_parameter_group" "main" {
  name   = "${var.project_name}-${var.environment}-pg-params"
  family = var.parameter_group_family

  # PostgreSQL parameters optimized for REDCap workload
  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
  }

  parameter {
    name  = "log_statement"
    value = var.enable_query_logging ? "all" : "none"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = var.slow_query_log_threshold
  }

  # Connection settings for large number of fields
  parameter {
    name  = "max_connections"
    value = var.max_connections
  }

  # Memory settings (auto-tuned based on instance class)
  parameter {
    name  = "shared_buffers"
    value = "{DBInstanceClassMemory/4}"
  }

  parameter {
    name  = "effective_cache_size"
    value = "{DBInstanceClassMemory*3/4}"
  }

  # Write performance
  parameter {
    name  = "checkpoint_completion_target"
    value = "0.9"
  }

  parameter {
    name  = "wal_buffers"
    value = "-1"  # Auto-tuned
  }

  # Query performance
  parameter {
    name  = "random_page_cost"
    value = "1.1"  # SSD optimized
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-pg-params"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Option Group (for any PostgreSQL extensions if needed)
resource "aws_db_option_group" "main" {
  name                     = "${var.project_name}-${var.environment}-pg-options"
  option_group_description = "Option group for ${var.project_name} PostgreSQL"
  engine_name              = "postgres"
  major_engine_version     = split(".", var.engine_version)[0]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-pg-options"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# KMS key for encryption (optional - uses AWS managed key by default)
resource "aws_kms_key" "rds" {
  count                   = var.create_kms_key ? 1 : 0
  description             = "KMS key for ${var.project_name}-${var.environment} RDS encryption"
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-rds-kms"
  })
}

resource "aws_kms_alias" "rds" {
  count         = var.create_kms_key ? 1 : 0
  name          = "alias/${var.project_name}-${var.environment}-rds"
  target_key_id = aws_kms_key.rds[0].key_id
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-postgres"

  # Engine
  engine               = "postgres"
  engine_version       = var.engine_version
  db_name              = local.db_name
  username             = var.db_username
  password             = var.db_password != "" ? var.db_password : random_password.db_password[0].result
  port                 = var.db_port

  # Instance
  instance_class        = var.db_instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = true
  kms_key_id           = var.create_kms_key ? aws_kms_key.rds[0].arn : null

  # Network
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  # High Availability
  multi_az               = var.multi_az
  availability_zone      = var.multi_az ? null : var.availability_zone

  # Backups
  backup_retention_period   = var.backup_retention_period
  backup_window            = var.backup_window
  copy_tags_to_snapshot    = true
  skip_final_snapshot      = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.project_name}-${var.environment}-final-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  # Maintenance
  maintenance_window              = var.maintenance_window
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  allow_major_version_upgrade     = false
  apply_immediately               = var.apply_immediately

  # Performance and Monitoring
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  monitoring_interval             = var.enhanced_monitoring_interval
  monitoring_role_arn            = var.enhanced_monitoring_interval > 0 ? aws_iam_role.rds_monitoring[0].arn : null
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  # Parameter and Option Groups
  parameter_group_name = aws_db_parameter_group.main.name
  option_group_name    = aws_db_option_group.main.name

  # Deletion Protection
  deletion_protection = var.deletion_protection

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-postgres"
  })

  depends_on = [
    aws_db_subnet_group.main,
    aws_security_group.rds,
  ]
}

# IAM role for enhanced monitoring
resource "aws_iam_role" "rds_monitoring" {
  count = var.enhanced_monitoring_interval > 0 ? 1 : 0
  name  = "${var.project_name}-${var.environment}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-rds-monitoring-role"
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  count      = var.enhanced_monitoring_interval > 0 ? 1 : 0
  role       = aws_iam_role.rds_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "database_cpu" {
  count               = var.create_cloudwatch_alarms ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-rds-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_cpu_threshold
  alarm_description   = "This metric monitors RDS CPU utilization"
  alarm_actions       = var.alarm_sns_topic_arns

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "database_disk_space" {
  count               = var.create_cloudwatch_alarms ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-rds-low-disk-space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_disk_space_threshold
  alarm_description   = "This metric monitors RDS free disk space"
  alarm_actions       = var.alarm_sns_topic_arns

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "database_connection_count" {
  count               = var.create_cloudwatch_alarms ? 1 : 0
  alarm_name          = "${var.project_name}-${var.environment}-rds-high-connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.alarm_connections_threshold
  alarm_description   = "This metric monitors RDS connection count"
  alarm_actions       = var.alarm_sns_topic_arns

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.main.id
  }

  tags = local.common_tags
}