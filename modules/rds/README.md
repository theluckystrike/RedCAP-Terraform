# RDS PostgreSQL Module

This module creates a secure, scalable PostgreSQL RDS instance for the REDCap to Docupilot pipeline.

## Features

- **PostgreSQL 15.x** optimized for large REDCap datasets (1000-2000 fields)
- **Multi-AZ deployment** option for high availability
- **Encryption at rest** using AWS KMS
- **Automated backups** with configurable retention
- **Enhanced monitoring** and Performance Insights
- **Auto-scaling storage** to handle growth
- **Secure networking** with isolated database subnets
- **CloudWatch alarms** for proactive monitoring

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     RDS PostgreSQL                          │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐    │
│  │              Database Configuration                 │    │
│  │  • Engine: PostgreSQL 15.4                          │    │
│  │  • Storage: GP3 SSD (auto-scaling)                  │    │
│  │  • Encryption: AES-256                              │    │
│  │  • Backups: Daily (7-30 day retention)              │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              Network Configuration                  │    │
│  │  • Deployed in isolated database subnets            │    │
│  │  • No direct internet access                        │    │
│  │  • Access only from Lambda security group           │    │
│  │  • Port 5432 (PostgreSQL default)                   │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              High Availability (Production)         │    │
│  │  • Multi-AZ deployment                              │    │
│  │  • Automatic failover                               │    │
│  │  • Read replicas (optional)                         │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## Usage

### Basic Usage

```hcl
module "rds" {
  source = "./modules/rds"
  
  project_name = "redcap-docupilot"
  environment  = "dev"
  
  # Network configuration from VPC module
  vpc_id              = module.vpc.vpc_id
  database_subnet_ids = module.vpc.database_subnet_ids
  
  # Basic database configuration
  db_name     = "redcap"
  db_username = "dbadmin"
  db_password = var.db_password  # Or leave empty for auto-generation
}
```

### Development Environment

```hcl
module "rds" {
  source = "./modules/rds"
  
  project_name = "redcap-docupilot"
  environment  = "dev"
  
  # Network
  vpc_id              = module.vpc.vpc_id
  database_subnet_ids = module.vpc.database_subnet_ids
  
  # Small instance for dev
  db_instance_class     = "db.t3.micro"  # 2 vCPU, 1 GB RAM
  allocated_storage     = 20
  max_allocated_storage = 0  # Disable auto-scaling
  
  # No HA for dev
  multi_az = false
  
  # Minimal backups
  backup_retention_period = 1
  
  # Allow access from VPC for debugging
  allowed_cidr_blocks = [module.vpc.vpc_cidr]
  
  # Skip final snapshot for easy cleanup
  skip_final_snapshot = true
  
  # No deletion protection
  deletion_protection = false
}
```

### Production Environment

```hcl
module "rds" {
  source = "./modules/rds"
  
  project_name = "redcap-docupilot"
  environment  = "prod"
  
  # Network
  vpc_id                   = module.vpc.vpc_id
  database_subnet_ids      = module.vpc.database_subnet_ids
  lambda_security_group_id = module.lambda.security_group_id
  
  # Production-sized instance
  db_instance_class     = "db.m5.large"  # 2 vCPU, 8 GB RAM
  allocated_storage     = 100
  max_allocated_storage = 1000  # Auto-scale up to 1TB
  storage_type          = "gp3"
  
  # High Availability
  multi_az = true
  
  # Production backups
  backup_retention_period = 30
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  # Enhanced monitoring
  enhanced_monitoring_interval          = 60
  performance_insights_enabled          = true
  performance_insights_retention_period = 731  # 2 years
  
  # CloudWatch alarms
  create_cloudwatch_alarms = true
  alarm_sns_topic_arns     = [aws_sns_topic.alerts.arn]
  
  # Security
  deletion_protection = true
  create_kms_key     = true
  
  # Don't skip final snapshot
  skip_final_snapshot = false
}
```

## Database Sizing Guide

### Development
- **db.t3.micro**: 2 vCPU, 1 GB RAM (~$13/month)
- 20 GB storage
- Single AZ

### Staging
- **db.t3.small**: 2 vCPU, 2 GB RAM (~$25/month)
- 50 GB storage
- Single AZ

### Production
- **db.m5.large**: 2 vCPU, 8 GB RAM (~$125/month)
- 100-1000 GB storage (auto-scaling)
- Multi-AZ (~$250/month total)

### Heavy Workload
- **db.m5.xlarge**: 4 vCPU, 16 GB RAM (~$250/month)
- 500-2000 GB storage
- Multi-AZ (~$500/month total)

## Cost Optimization

1. **Development/Staging**:
   - Use single AZ deployment
   - Smaller instance classes (t3.micro/small)
   - Shorter backup retention
   - Disable Performance Insights

2. **Storage**:
   - GP3 is more cost-effective than GP2
   - Enable storage auto-scaling to avoid over-provisioning
   - Regular cleanup of old data

3. **Monitoring**:
   - Basic monitoring is free
   - Enhanced monitoring costs ~$2-4/month
   - Performance Insights costs ~$7/month

## Security Best Practices

1. **Network Security**:
   - Database in isolated subnets
   - No public accessibility
   - Security group limits access to Lambda only

2. **Encryption**:
   - Encryption at rest enabled by default
   - SSL/TLS for connections (enforced by parameter group)
   - Optional customer-managed KMS key

3. **Access Control**:
   - Strong password policy
   - Consider AWS Secrets Manager for rotation
   - Use IAM authentication for applications

4. **Backup & Recovery**:
   - Automated daily backups
   - Point-in-time recovery available
   - Test restore procedures regularly

## Monitoring

### CloudWatch Metrics
- CPU Utilization
- Database Connections
- Free Storage Space
- Read/Write IOPS
- Read/Write Latency

### Enhanced Monitoring
- OS-level metrics
- Process list
- Memory usage details

### Performance Insights
- Query performance
- Wait events
- Top SQL statements

## Maintenance

### Regular Tasks
1. **Monitor storage usage** - ensure auto-scaling is working
2. **Review slow query logs** - optimize problematic queries
3. **Update minor versions** - apply security patches
4. **Test backups** - verify restore procedures

### PostgreSQL Optimization for REDCap

The module includes optimized parameters for REDCap workloads:
- Increased `shared_buffers` for better caching
- Optimized `checkpoint_completion_target` for write performance
- SSD-optimized `random_page_cost`
- Connection pooling configuration

## Troubleshooting

### Connection Issues
```bash
# Test connectivity from Lambda subnet
aws ec2 describe-security-groups --group-ids <sg-id>

# Check RDS endpoint
aws rds describe-db-instances --db-instance-identifier <name>
```

### Performance Issues
```sql
-- Check running queries
SELECT pid, now() - pg_stat_activity.query_start AS duration, query 
FROM pg_stat_activity 
WHERE (now() - pg_stat_activity.query_start) > interval '5 minutes';

-- Check table sizes
SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC
LIMIT 10;
```

### Storage Issues
```bash
# Check free storage
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name FreeStorageSpace \
  --dimensions Name=DBInstanceIdentifier,Value=<instance-id> \
  --start-time <time> \
  --end-time <time> \
  --period 300 \
  --statistics Average
```

## Migration Notes

For migrating existing data:
1. Use AWS DMS for large datasets
2. pg_dump/pg_restore for smaller databases
3. Consider AWS SCT for schema conversion
4. Test thoroughly in staging first

## Outputs

The module provides all necessary connection information:
- Endpoint and port
- Database name and username
- Security group ID
- Connection string (without password)