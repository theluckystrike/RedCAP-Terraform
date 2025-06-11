# modules/s3/main.tf - S3 bucket configuration for REDCap Excel exports

locals {
  bucket_name = var.bucket_name != "" ? var.bucket_name : "${var.project_name}-${var.environment}-redcap-exports"
  
  common_tags = merge(
    var.tags,
    {
      Module      = "s3"
      Environment = var.environment
      Project     = var.project_name
      Purpose     = "REDCap Excel Storage"
    }
  )
  
  # Folder prefixes for organization
  folder_prefixes = [
    "incoming/",     # REDCap uploads files here
    "processing/",   # Files being processed
    "processed/",    # Successfully processed files
    "failed/",       # Failed processing
    "archive/"       # Old files before deletion
  ]
}

# S3 Bucket for REDCap exports
resource "aws_s3_bucket" "redcap_exports" {
  bucket = local.bucket_name

  tags = merge(local.common_tags, {
    Name = local.bucket_name
  })
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "redcap_exports" {
  bucket = aws_s3_bucket.redcap_exports.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for data protection
resource "aws_s3_bucket_versioning" "redcap_exports" {
  bucket = aws_s3_bucket.redcap_exports.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

# Server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "redcap_exports" {
  bucket = aws_s3_bucket.redcap_exports.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.encryption_type
      kms_master_key_id = var.encryption_type == "aws:kms" ? var.kms_key_id : null
    }
    bucket_key_enabled = var.encryption_type == "aws:kms" ? true : false
  }
}

# Lifecycle rules for cost optimization
resource "aws_s3_bucket_lifecycle_configuration" "redcap_exports" {
  bucket = aws_s3_bucket.redcap_exports.id

  # Rule for processed files
  rule {
    id     = "archive-processed-files"
    status = var.enable_lifecycle_rules ? "Enabled" : "Disabled"

    filter {
      prefix = "processed/"
    }

    transition {
      days          = var.processed_transition_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.processed_glacier_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.processed_expiration_days
    }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }
  }

  # Rule for failed files
  rule {
    id     = "cleanup-failed-files"
    status = var.enable_lifecycle_rules ? "Enabled" : "Disabled"

    filter {
      prefix = "failed/"
    }

    expiration {
      days = var.failed_expiration_days
    }
  }

  # Rule for old incoming files (safety cleanup)
  rule {
    id     = "cleanup-old-incoming"
    status = var.enable_lifecycle_rules ? "Enabled" : "Disabled"

    filter {
      prefix = "incoming/"
    }

    expiration {
      days = var.incoming_expiration_days
    }
  }

  # Abort incomplete multipart uploads
  rule {
    id     = "abort-incomplete-uploads"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# Bucket policy
resource "aws_s3_bucket_policy" "redcap_exports" {
  bucket = aws_s3_bucket.redcap_exports.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyInsecureConnections"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.redcap_exports.arn,
          "${aws_s3_bucket.redcap_exports.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Sid    = "DenyUnencryptedObjectUploads"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.redcap_exports.arn}/*"
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = var.encryption_type == "aws:kms" ? "aws:kms" : "AES256"
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.redcap_exports]
}

# Event notification configuration (for Lambda triggers)
resource "aws_s3_bucket_notification" "lambda_trigger" {
  count  = var.enable_event_notifications ? 1 : 0
  bucket = aws_s3_bucket.redcap_exports.id

  # Lambda function trigger for new Excel files
  dynamic "lambda_function" {
    for_each = var.lambda_function_arn != "" ? [1] : []
    content {
      lambda_function_arn = var.lambda_function_arn
      events              = ["s3:ObjectCreated:*"]
      filter_prefix       = "incoming/"
      filter_suffix       = ".xlsx"
    }
  }

  # EventBridge integration for more complex routing
  eventbridge = var.enable_eventbridge

  depends_on = [aws_lambda_permission.allow_s3]
}

# Lambda permission for S3 to invoke function
resource "aws_lambda_permission" "allow_s3" {
  count         = var.lambda_function_arn != "" ? 1 : 0
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.redcap_exports.arn
}

# CORS configuration for future web app
resource "aws_s3_bucket_cors_configuration" "redcap_exports" {
  count  = var.enable_cors ? 1 : 0
  bucket = aws_s3_bucket.redcap_exports.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = var.cors_allowed_origins
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# Bucket logging
resource "aws_s3_bucket_logging" "redcap_exports" {
  count  = var.enable_logging ? 1 : 0
  bucket = aws_s3_bucket.redcap_exports.id

  target_bucket = var.logging_bucket != "" ? var.logging_bucket : aws_s3_bucket.logs[0].id
  target_prefix = "s3-access-logs/${local.bucket_name}/"
}

# Separate bucket for logs (if needed)
resource "aws_s3_bucket" "logs" {
  count  = var.enable_logging && var.logging_bucket == "" ? 1 : 0
  bucket = "${local.bucket_name}-logs"

  tags = merge(local.common_tags, {
    Name    = "${local.bucket_name}-logs"
    Purpose = "Access Logs"
  })
}

# Block public access for logs bucket
resource "aws_s3_bucket_public_access_block" "logs" {
  count  = var.enable_logging && var.logging_bucket == "" ? 1 : 0
  bucket = aws_s3_bucket.logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle for logs bucket
resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  count  = var.enable_logging && var.logging_bucket == "" ? 1 : 0
  bucket = aws_s3_bucket.logs[0].id

  rule {
    id     = "cleanup-old-logs"
    status = "Enabled"

    expiration {
      days = var.log_retention_days
    }
  }
}

# Create folder structure
resource "aws_s3_object" "folders" {
  for_each = toset(local.folder_prefixes)
  
  bucket  = aws_s3_bucket.redcap_exports.id
  key     = each.value
  content = ""
  
  depends_on = [
    aws_s3_bucket_server_side_encryption_configuration.redcap_exports
  ]
}

# CloudWatch metric alarm for bucket size
resource "aws_cloudwatch_metric_alarm" "bucket_size" {
  count               = var.create_cloudwatch_alarms ? 1 : 0
  alarm_name          = "${local.bucket_name}-large-size"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period              = "86400" # Daily
  statistic           = "Average"
  threshold           = var.bucket_size_alarm_threshold
  alarm_description   = "This metric monitors S3 bucket size"
  alarm_actions       = var.alarm_sns_topic_arns

  dimensions = {
    BucketName = aws_s3_bucket.redcap_exports.id
    StorageType = "StandardStorage"
  }

  tags = local.common_tags
}

# CloudWatch metric alarm for number of objects
resource "aws_cloudwatch_metric_alarm" "object_count" {
  count               = var.create_cloudwatch_alarms ? 1 : 0
  alarm_name          = "${local.bucket_name}-high-object-count"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "NumberOfObjects"
  namespace           = "AWS/S3"
  period              = "86400" # Daily
  statistic           = "Average"
  threshold           = var.object_count_alarm_threshold
  alarm_description   = "This metric monitors S3 object count"
  alarm_actions       = var.alarm_sns_topic_arns

  dimensions = {
    BucketName = aws_s3_bucket.redcap_exports.id
    StorageType = "AllStorageTypes"
  }

  tags = local.common_tags
}