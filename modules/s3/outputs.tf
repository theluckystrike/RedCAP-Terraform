# modules/s3/outputs.tf - Outputs for S3 module

# Bucket Information
output "bucket_id" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.redcap_exports.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.redcap_exports.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.redcap_exports.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket regional domain name"
  value       = aws_s3_bucket.redcap_exports.bucket_regional_domain_name
}

output "bucket_region" {
  description = "The AWS region this bucket resides in"
  value       = aws_s3_bucket.redcap_exports.region
}

# Folder Prefixes
output "folder_prefixes" {
  description = "The folder structure created in the bucket"
  value = {
    incoming   = "incoming/"
    processing = "processing/"
    processed  = "processed/"
    failed     = "failed/"
    archive    = "archive/"
  }
}

# Event Configuration
output "lambda_trigger_enabled" {
  description = "Whether Lambda trigger is configured"
  value       = var.enable_event_notifications && var.lambda_function_arn != ""
}

output "eventbridge_enabled" {
  description = "Whether EventBridge integration is enabled"
  value       = var.enable_eventbridge
}

# Logging Bucket
output "logging_bucket_id" {
  description = "The name of the logging bucket"
  value       = var.enable_logging ? (var.logging_bucket != "" ? var.logging_bucket : aws_s3_bucket.logs[0].id) : null
}

output "logging_bucket_arn" {
  description = "The ARN of the logging bucket"
  value       = var.enable_logging && var.logging_bucket == "" ? aws_s3_bucket.logs[0].arn : null
}

# Security Configuration
output "encryption_type" {
  description = "The type of server-side encryption"
  value       = var.encryption_type
}

output "versioning_enabled" {
  description = "Whether versioning is enabled"
  value       = var.enable_versioning
}

# CloudWatch Alarms
output "cloudwatch_alarm_bucket_size_name" {
  description = "The name of the bucket size alarm"
  value       = var.create_cloudwatch_alarms ? aws_cloudwatch_metric_alarm.bucket_size[0].alarm_name : null
}

output "cloudwatch_alarm_object_count_name" {
  description = "The name of the object count alarm"
  value       = var.create_cloudwatch_alarms ? aws_cloudwatch_metric_alarm.object_count[0].alarm_name : null
}

# Useful URIs
output "incoming_folder_uri" {
  description = "S3 URI for incoming folder"
  value       = "s3://${aws_s3_bucket.redcap_exports.id}/incoming/"
}

output "processed_folder_uri" {
  description = "S3 URI for processed folder"
  value       = "s3://${aws_s3_bucket.redcap_exports.id}/processed/"
}

output "failed_folder_uri" {
  description = "S3 URI for failed folder"
  value       = "s3://${aws_s3_bucket.redcap_exports.id}/failed/"
}

# Policy Information
output "bucket_policy_json" {
  description = "The bucket policy as JSON"
  value       = aws_s3_bucket_policy.redcap_exports.policy
}


output "bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.redcap_exports.bucket
}
