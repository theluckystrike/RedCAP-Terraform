environment         = "prod"
project             = "clinical-docs-prod"
vpc_cidr            = "10.10.0.0/16"
public_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
private_subnet_cidrs = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
db_subnet_cidrs     = ["10.10.201.0/24", "10.10.202.0/24", "10.10.203.0/24"]
create_ha_nat       = true

az_count            = 3                    # 3 AZs for maximum availability
enable_nat_gateway  = true
single_nat_gateway  = false                # NAT Gateway per AZ for HA
enable_flow_logs    = true                 # Required for compliance

# Production settings
flow_logs_retention_days        = 30       # 30 days for compliance
enable_vpc_endpoints            = true
enable_secrets_manager_endpoint = true     # All endpoints for security

# RDS Configuration - Production grade
db_instance_class        = "db.m5.large"   # Production instance (~$125/month)
allocated_storage        = 100             # Start with 100GB
max_allocated_storage    = 1000            # Auto-scale up to 1TB
multi_az                 = true            # High availability (~2x cost)
backup_retention_period  = 30              # 30 days of backups
skip_final_snapshot      = false           # Always keep final snapshot
deletion_protection      = true            # Prevent accidental deletion

# RDS Performance & Monitoring - Full
enhanced_monitoring_interval          = 60   # Full enhanced monitoring
performance_insights_enabled          = true # Enable Performance Insights
performance_insights_retention_period = 731  # 2 years retention
create_cloudwatch_alarms             = true # All alarms enabled

# Security - No external access
allowed_database_cidr_blocks = []

# Additional Production Settings
create_kms_key              = true         # Customer-managed encryption key
auto_minor_version_upgrade  = false        # Manual control of updates
apply_immediately           = false        # Changes during maintenance window

# Alarm thresholds
alarm_cpu_threshold         = 75           # Alert at 75% CPU
alarm_disk_space_threshold  = 10737418240  # Alert at 10GB free space
alarm_connections_threshold = 80           # Alert at 80 connections

# Tags
tags = {
  Environment    = "production"
  Project        = "REDCap Automation"
  Owner          = "Dr. [Name]"
  CostCenter     = "Orthopedics"
  HIPAA          = "true"
  DataSensitive  = "true"
  BackupRequired = "true"
  Compliance     = "HIPAA"
  CriticalSystem = "true"
}