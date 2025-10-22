# Carbone Lambda Module

This Terraform module deploys a Lambda function that retrieves data from RDS PostgreSQL and generates PDF documents using Carbone.

## Features

- ✅ Lambda function with VPC configuration
- ✅ Custom Lambda layer for dependencies
- ✅ IAM roles with least-privilege permissions
- ✅ CloudWatch Logs with configurable retention
- ✅ Dead Letter Queue for failed invocations
- ✅ CloudWatch alarms for monitoring
- ✅ Optional EventBridge scheduling
- ✅ CloudWatch dashboard
- ✅ X-Ray tracing support
- ✅ KMS encryption support

## Prerequisites

- Existing RDS PostgreSQL database
- Existing RDS Proxy
- Existing S3 buckets for templates and output
- Existing VPC with private subnets
- Existing security group for Lambda
- Database credentials in AWS Secrets Manager

## Usage
```hcl
module "carbone_lambda" {
  source = "./modules/carbone-lambda"

  # General
  project_name = "clinical-docs"
  environment  = "dev"
  aws_region   = "ap-southeast-2"

  # Database
  db_name           = "redcap_docupilot"
  db_proxy_endpoint = "clinical-docs-dev-rds-proxy.proxy-xxx.ap-southeast-2.rds.amazonaws.com"
  db_secret_arn     = "arn:aws:secretsmanager:ap-southeast-2:xxx:secret:xxx"

  # S3
  template_bucket_name = "clinical-docs-dev-carbone-templates"
  output_bucket_name   = "clinical-docs-dev-generated-documents"

  # Networking
  vpc_id                   = "vpc-xxx"
  private_subnet_ids       = ["subnet-xxx", "subnet-yyy"]
  lambda_security_group_id = "sg-xxx"

  # Lambda Configuration
  lambda_memory_size = 1024
  lambda_timeout     = 300

  # Carbone
  carbone_api_key = var.carbone_api_key  # Optional

  # SNS
  sns_topic_arn = "arn:aws:sns:ap-southeast-2:xxx:topic/notifications"

  # Monitoring
  enable_cloudwatch_alarms = true
  enable_dashboard         = true
  alarm_actions            = ["arn:aws:sns:ap-southeast-2:xxx:topic/alerts"]

  # Scheduling (Optional)
  enable_scheduled_generation = true
  schedule_expression         = "cron(0 8 * * ? *)"
  default_record_ids          = [1, 2, 3]
  default_template_name       = "patient_report.odt"

  tags = {
    Project   = "REDCap"
    ManagedBy = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_name | Project name | `string` | - | yes |
| environment | Environment (dev/staging/prod) | `string` | - | yes |
| aws_region | AWS region | `string` | - | yes |
| db_name | Database name | `string` | - | yes |
| db_proxy_endpoint | RDS Proxy endpoint | `string` | - | yes |
| db_secret_arn | Secrets Manager ARN | `string` | - | yes |
| template_bucket_name | Template S3 bucket name | `string` | - | yes |
| output_bucket_name | Output S3 bucket name | `string` | - | yes |
| vpc_id | VPC ID | `string` | - | yes |
| private_subnet_ids | Private subnet IDs | `list(string)` | - | yes |
| lambda_security_group_id | Lambda security group ID | `string` | - | yes |
| lambda_timeout | Lambda timeout in seconds | `number` | `300` | no |
| lambda_memory_size | Lambda memory in MB | `number` | `1024` | no |
| carbone_api_key | Carbone API key | `string` | `null` | no |
| enable_cloudwatch_alarms | Enable alarms | `bool` | `true` | no |
| enable_scheduled_generation | Enable scheduling | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| lambda_function_name | Lambda function name |
| lambda_function_arn | Lambda function ARN |
| lambda_role_arn | Lambda execution role ARN |
| log_group_name | CloudWatch Log Group name |
| dashboard_url | CloudWatch Dashboard URL |

## Invoking the Lambda

### Via AWS CLI
```bash
# Basic invocation
aws lambda invoke \
  --function-name clinical-docs-dev-carbone-generator \
  --payload '{"record_ids":[1],"template_name":"patient_report.odt"}' \
  response.json

# With notification
aws lambda invoke \
  --function-name clinical-docs-dev-carbone-generator \
  --payload '{"record_ids":[1,2,3],"template_name":"patient_report.odt","notification_email":"user@example.com"}' \
  response.json

# Batch mode
aws lambda invoke \
  --function-name clinical-docs-dev-carbone-generator \
  --payload '{"record_ids":[1,2,3],"batch_mode":true}' \
  response.json
```

### Via EventBridge
```bash
# Trigger manual event
aws events put-events \
  --entries '[{
    "Source": "custom.carbone",
    "DetailType": "Document Generation Request",
    "Detail": "{\"record_ids\":[1],\"template_name\":\"patient_report.odt\"}"
  }]'
```

## Monitoring

### View Logs
```bash
# Tail logs in real-time
aws logs tail /aws/lambda/clinical-docs-dev-carbone-generator --follow

# Search for errors
aws logs filter-log-events \
  --log-group-name /aws/lambda/clinical-docs-dev-carbone-generator \
  --filter-pattern "ERROR"
```

### CloudWatch Insights Queries
```sql
-- Success rate
fields @timestamp, @message
| filter @message like /INSERTION SUMMARY/
| stats count(*) as total by bin(5m)

-- Error analysis
fields @timestamp, @message
| filter @message like /❌/
| stats count() by @message

-- Performance metrics
fields @timestamp, @duration
| filter @type = "REPORT"
| stats avg(@duration), max(@duration), min(@duration)
```

## Security

- Lambda runs in private subnets (no internet access)
- All data encrypted at rest (S3, SQS, Secrets Manager)
- IAM roles follow least-privilege principle
- Database credentials stored in Secrets Manager
- VPC security groups restrict network access
- CloudWatch Logs optionally encrypted with KMS

## Troubleshooting

### Lambda not connecting to RDS

Check:
1. Lambda is in correct VPC and subnets
2. Security group allows Lambda → RDS Proxy (port 5432)
3. RDS Proxy endpoint is correct
4. Database credentials in Secrets Manager are valid

### Documents not generating

Check:
1. Template exists in S3 template bucket
2. Carbone API key is valid (if using Carbone Cloud)
3. Lambda has sufficient memory (increase if needed)
4. Check CloudWatch Logs for specific error messages

### DLQ has messages

Messages in DLQ indicate failed invocations. Check:
1. CloudWatch Logs for error details
2. DLQ message attributes for failure reason
3. Increase Lambda timeout if duration alarms triggered

## Cost Optimization

- Use appropriate Lambda memory size (1024MB recommended)
- Set S3 lifecycle policies on output bucket
- Adjust log retention period (default: 30 days)
- Use reserved concurrency if predictable workload

## License

Managed by DevOps Team