# S3 Module

This module creates and configures S3 buckets for storing REDCap Excel exports with automated processing triggers.

## Features

- **Secure Storage**: Encryption at rest, versioning, and access controls
- **Organized Structure**: Predefined folder hierarchy for workflow management
- **Event-Driven**: Automatic Lambda triggers on file upload
- **Cost Optimization**: Lifecycle policies for automatic archival and deletion
- **Compliance**: Access logging, HTTPS-only, and audit trails
- **Monitoring**: CloudWatch alarms for bucket size and object count

## Architecture

```
S3 Bucket Structure:
└── redcap-docupilot-{env}-redcap-exports/
    ├── incoming/       # REDCap uploads Excel files here
    ├── processing/     # Files currently being processed
    ├── processed/      # Successfully processed files
    ├── failed/         # Files that failed processing
    └── archive/        # Long-term storage before deletion
```

## Usage

### Basic Usage

```hcl
module "s3" {
  source = "./modules/s3"
  
  project_name = "redcap-docupilot"
  environment  = "dev"
  
  # Basic configuration
  enable_versioning      = true
  enable_lifecycle_rules = true
  
  # No Lambda trigger yet (will be added later)
  enable_event_notifications = false
}
```

### With Lambda Trigger

```hcl
module "s3" {
  source = "./modules/s3"
  
  project_name = "redcap-docupilot"
  environment  = "prod"
  
  # Enable Lambda trigger
  enable_event_notifications = true
  lambda_function_arn       = module.lambda.excel_parser_function_arn
  
  # Enable EventBridge for complex routing
  enable_eventbridge = true
  
  # Production settings
  encryption_type = "aws:kms"
  kms_key_id     = aws_kms_key.s3.id
}
```

### Development Environment

```hcl
module "s3" {
  source = "./modules/s3"
  
  project_name = "redcap-docupilot"
  environment  = "dev"
  
  # Minimal lifecycle rules for dev
  enable_lifecycle_rules    = true
  processed_expiration_days = 30    # Delete after 30 days
  failed_expiration_days    = 7     # Delete failed files after 7 days
  
  # Minimal monitoring
  create_cloudwatch_alarms = false
  
  # Basic encryption
  encryption_type = "AES256"
}
```

## Workflow

1. **Upload**: REDCap exports Excel files to `incoming/` folder
2. **Trigger**: S3 event triggers Lambda function
3. **Process**: Lambda moves file to `processing/` during work
4. **Complete**: File moved to `processed/` or `failed/`
5. **Archive**: Lifecycle rules handle long-term storage

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_name | Project name | string | - | yes |
| environment | Environment (dev/stg/prod) | string | - | yes |
| bucket_name | Custom bucket name | string | "" | no |
| encryption_type | Encryption type (AES256/aws:kms) | string | "AES256" | no |
| enable_versioning | Enable versioning | bool | true | no |
| enable_lifecycle_rules | Enable lifecycle rules | bool | true | no |
| lambda_function_arn | Lambda ARN for triggers | string | "" | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | Bucket name |
| bucket_arn | Bucket ARN |
| incoming_folder_uri | S3 URI for uploads |
| processed_folder_uri | S3 URI for processed files |

## Lifecycle Policies

### Default Lifecycle Timeline

| Stage | Standard | Infrequent Access | Glacier | Deleted |
|-------|----------|-------------------|---------|---------|
| Processed | 0-30 days | 30-90 days | 90-365 days | After 365 days |
| Failed | - | - | - | After 30 days |
| Incoming | - | - | - | After 7 days |

### Cost Impact

- **Standard**: $0.023/GB/month
- **Infrequent Access**: $0.0125/GB/month (46% savings)
- **Glacier**: $0.004/GB/month (83% savings)

## Security

### Encryption
- Default: SSE-S3 (AES256)
- Production: SSE-KMS with customer managed keys

### Access Control
- No public access (enforced by bucket policy)
- HTTPS-only connections required
- Versioning enabled for data recovery

### Bucket Policies
- Deny unencrypted uploads
- Deny non-SSL connections
- Least privilege access

## Monitoring

### CloudWatch Metrics
- BucketSizeBytes - Total size monitoring
- NumberOfObjects - Object count monitoring

### Alarms (Production)
- Bucket size > 100GB
- Object count > 10,000

## Cost Optimization

1. **Lifecycle Rules**: Automatic transition to cheaper storage
2. **Intelligent Tiering**: Optional for unpredictable access
3. **Cleanup Policies**: Delete old/failed files automatically

## Examples

### Upload File (AWS CLI)
```bash
# Upload to incoming folder
aws s3 cp patient_data.xlsx s3://redcap-docupilot-dev-redcap-exports/incoming/

# List incoming files
aws s3 ls s3://redcap-docupilot-dev-redcap-exports/incoming/
```

### Check Bucket Size
```bash
# Get bucket size
aws s3 ls s3://redcap-docupilot-dev-redcap-exports/ --recursive --summarize | grep "Total Size"

# Get folder sizes
aws s3 ls s3://redcap-docupilot-dev-redcap-exports/processed/ --recursive --summarize
```

### Move Files Between Folders
```bash
# Move from incoming to processing
aws s3 mv s3://bucket/incoming/file.xlsx s3://bucket/processing/file.xlsx

# Copy to processed
aws s3 cp s3://bucket/processing/file.xlsx s3://bucket/processed/file.xlsx
```

## Troubleshooting

### Lambda Not Triggering
1. Check Lambda function ARN is correct
2. Verify Lambda has permission to be invoked by S3
3. Check file matches filter (`.xlsx` in `incoming/`)

### Access Denied
1. Check IAM permissions include s3:GetObject, s3:PutObject
2. Verify bucket policy isn't blocking access
3. Ensure using HTTPS connections

### High Costs
1. Review lifecycle policies
2. Check for large files in standard storage
3. Enable S3 Inventory for detailed analysis

## Integration with Lambda

The S3 module integrates with Lambda for automated processing:

```javascript
// Lambda receives S3 event
exports.handler = async (event) => {
    const bucket = event.Records[0].s3.bucket.name;
    const key = event.Records[0].s3.object.key;
    
    // Process file
    await processExcelFile(bucket, key);
    
    // Move to processed folder
    await moveToProcessed(bucket, key);
};
```

## Best Practices

1. **Naming Convention**: Use consistent file naming (e.g., `YYYYMMDD_patient_ID.xlsx`)
2. **File Validation**: Validate files before processing
3. **Error Handling**: Always move failed files to failed/ folder
4. **Monitoring**: Set up alerts for failed processing
5. **Testing**: Test lifecycle policies in dev first

## Future Enhancements

- S3 Batch Operations for bulk processing
- S3 Inventory for detailed reporting
- Cross-region replication for DR
- S3 Object Lock for compliance