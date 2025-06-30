# modules/rds/outputs.tf - Outputs for RDS module

# Database Instance Outputs
output "db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.main.id
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.main.arn
}

output "rds_sg_id" {
  value = aws_security_group.rds.id
}

output "db_instance_resource_id" {
  description = "The RDS resource ID"
  value       = aws_db_instance.main.resource_id
}


# Connection Information
output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "db_instance_address" {
  description = "The hostname of the RDS instance"
  value       = aws_db_instance.main.address
  sensitive   = true
}

output "db_instance_port" {
  description = "The database port"
  value       = aws_db_instance.main.port
}

output "db_name" {
  description = "The database name"
  value       = aws_db_instance.main.db_name
}

output "db_username" {
  description = "The master username"
  value       = aws_db_instance.main.username
  sensitive   = true
}

# Password (only if auto-generated)
output "db_password" {
  description = "The database password (only available if auto-generated)"
  value       = var.db_password == "" ? random_password.db_password[0].result : null
  sensitive   = true
}

# Network Outputs
output "db_subnet_group_id" {
  description = "The db subnet group ID"
  value       = aws_db_subnet_group.main.id
}

output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = aws_db_subnet_group.main.arn
}

output "security_group_id" {
  description = "The security group ID for the RDS instance"
  value       = aws_security_group.rds.id
}

# Configuration Outputs
output "db_instance_class" {
  description = "The RDS instance class"
  value       = aws_db_instance.main.instance_class
}

output "db_instance_engine" {
  description = "The database engine"
  value       = aws_db_instance.main.engine
}

output "db_instance_engine_version" {
  description = "The engine version"
  value       = aws_db_instance.main.engine_version_actual
}

output "db_instance_storage_type" {
  description = "The storage type"
  value       = aws_db_instance.main.storage_type
}

output "db_instance_allocated_storage" {
  description = "The allocated storage in GB"
  value       = aws_db_instance.main.allocated_storage
}

output "db_instance_max_allocated_storage" {
  description = "The maximum allocated storage in GB"
  value       = aws_db_instance.main.max_allocated_storage
}

# High Availability
output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = aws_db_instance.main.availability_zone
}

output "db_instance_multi_az" {
  description = "If the RDS instance is multi-AZ"
  value       = aws_db_instance.main.multi_az
}

# Backup Information
output "db_instance_backup_retention_period" {
  description = "The backup retention period"
  value       = aws_db_instance.main.backup_retention_period
}

output "db_instance_backup_window" {
  description = "The backup window"
  value       = aws_db_instance.main.backup_window
}

output "db_instance_maintenance_window" {
  description = "The maintenance window"
  value       = aws_db_instance.main.maintenance_window
}

# Monitoring
output "db_instance_monitoring_role_arn" {
  description = "The ARN of the enhanced monitoring IAM role"
  value       = var.enhanced_monitoring_interval > 0 ? aws_iam_role.rds_monitoring[0].arn : null
}

output "db_instance_monitoring_interval" {
  description = "The interval for collecting enhanced monitoring metrics"
  value       = aws_db_instance.main.monitoring_interval
}

# Parameter and Option Groups
output "db_parameter_group_id" {
  description = "The db parameter group ID"
  value       = aws_db_parameter_group.main.id
}

output "db_option_group_id" {
  description = "The db option group ID"
  value       = aws_db_option_group.main.id
}

# KMS
output "kms_key_id" {
  description = "The KMS key ID used for encryption"
  value       = var.create_kms_key ? aws_kms_key.rds[0].id : null
}

output "kms_key_arn" {
  description = "The KMS key ARN used for encryption"
  value       = var.create_kms_key ? aws_kms_key.rds[0].arn : null
}

# CloudWatch Alarms
output "cloudwatch_alarm_cpu_name" {
  description = "The name of the CPU utilization alarm"
  value       = var.create_cloudwatch_alarms ? aws_cloudwatch_metric_alarm.database_cpu[0].alarm_name : null
}

output "cloudwatch_alarm_disk_space_name" {
  description = "The name of the disk space alarm"
  value       = var.create_cloudwatch_alarms ? aws_cloudwatch_metric_alarm.database_disk_space[0].alarm_name : null
}

output "cloudwatch_alarm_connections_name" {
  description = "The name of the connections alarm"
  value       = var.create_cloudwatch_alarms ? aws_cloudwatch_metric_alarm.database_connection_count[0].alarm_name : null
}

# Connection String (for convenience)
output "postgresql_connection_string" {
  description = "PostgreSQL connection string (without password)"
  value       = "postgresql://${aws_db_instance.main.username}@${aws_db_instance.main.address}:${aws_db_instance.main.port}/${aws_db_instance.main.db_name}"
  sensitive   = true
}