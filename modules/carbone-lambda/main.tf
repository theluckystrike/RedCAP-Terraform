/**
 * Carbone Document Generator Lambda Module
 * Standalone module that integrates with existing infrastructure
 */


locals {
  function_name = "${var.project_name}-${var.environment}-carbone-generator"
  
  aws_data_wrangler_layer_arn = "arn:aws:lambda:ap-southeast-2:336392948345:layer:AWSSDKPandas-Python311:23"

  # Combine AWS layer with any additional layers passed in
  all_layers = concat(
    [local.aws_data_wrangler_layer_arn],
    var.lambda_layers
  )

  # Lambda environment variables
  lambda_environment = {
    DB_NAME            = var.db_name
    DB_PROXY_ENDPOINT  = var.db_proxy_endpoint
    SECRET_ARN         = var.db_secret_arn
    TEMPLATE_BUCKET    = var.template_bucket_name
    OUTPUT_BUCKET      = var.output_bucket_name
    SNS_TOPIC_ARN      = var.sns_topic_arn != null ? var.sns_topic_arn : ""
    REGION             = var.aws_region
    CARBONE_API_KEY    = var.carbone_api_key != null ? var.carbone_api_key : ""
    CARBONE_ENDPOINT   = var.carbone_endpoint != null ? var.carbone_endpoint : ""
    CARBONE_VERSION    = var.carbone_version
  }
}

# ===== Data Sources =====
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ===== Lambda Layer for Dependencies =====
data "archive_file" "lambda_layer" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambda/layers/carbone_dependencies"
  output_path = "${path.module}/files/lambda_layer.zip"
}

resource "aws_lambda_layer_version" "carbone_dependencies" {
  filename            = data.archive_file.lambda_layer.output_path
  layer_name          = "${var.project_name}-${var.environment}-carbone-deps"
  compatible_runtimes = [var.lambda_runtime]
  source_code_hash    = data.archive_file.lambda_layer.output_base64sha256

  description = "Carbone Lambda dependencies (requests, psycopg2-binary)"

  lifecycle {
    create_before_destroy = true
  }
}

# ===== Lambda Function Package =====
data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambda/carbone_generator"
  output_path = "${path.module}/files/carbone_lambda.zip"

  excludes = [
    "__pycache__",
    "*.pyc",
    ".pytest_cache",
    "tests",
    "venv",
    ".git"
  ]
}

# ===== Lambda Function =====
resource "aws_lambda_function" "carbone_generator" {
  filename         = data.archive_file.lambda_function.output_path
  function_name    = local.function_name
  role            = aws_iam_role.lambda_role.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = var.lambda_runtime
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory_size
  source_code_hash = data.archive_file.lambda_function.output_base64sha256

  environment {
    variables = local.lambda_environment
  }

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [var.lambda_security_group_id]
  }

  layers = local.all_layers
  
  tracing_config {
    mode = var.enable_xray_tracing ? "Active" : "PassThrough"
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.dlq.arn
  }

  reserved_concurrent_executions = var.reserved_concurrent_executions

  tags = merge(
    var.tags,
    {
      Name        = local.function_name
      Component   = "Carbone Generator"
      Environment = var.environment
    }
  )

  depends_on = [
    aws_cloudwatch_log_group.lambda_logs,
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_iam_role_policy_attachment.lambda_vpc_execution
  ]
}

# ===== CloudWatch Log Group =====
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = var.log_retention_days

  kms_key_id = var.cloudwatch_kms_key_arn

  tags = merge(
    var.tags,
    {
      Name = "${local.function_name}-logs"
    }
  )
}

# ===== Dead Letter Queue =====
resource "aws_sqs_queue" "dlq" {
  name                      = "${local.function_name}-dlq"
  message_retention_seconds = 1209600  # 14 days
  kms_master_key_id         = var.sqs_kms_key_id

  tags = merge(
    var.tags,
    {
      Name        = "${local.function_name}-dlq"
      Environment = var.environment
    }
  )
}

resource "aws_sqs_queue_policy" "dlq_policy" {
  queue_url = aws_sqs_queue.dlq.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.dlq.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_lambda_function.carbone_generator.arn
          }
        }
      }
    ]
  })
}

# ===== Lambda Event Invoke Configuration =====
resource "aws_lambda_function_event_invoke_config" "carbone_config" {
  function_name = aws_lambda_function.carbone_generator.function_name

  maximum_event_age_in_seconds = var.max_event_age_seconds
  maximum_retry_attempts       = var.max_retry_attempts

  destination_config {
    on_failure {
      destination = aws_sqs_queue.dlq.arn
    }

    dynamic "on_success" {
      for_each = var.success_destination_arn != null ? [1] : []
      content {
        destination = var.success_destination_arn
      }
    }
  }
}

# ===== Lambda Alias (for versioning) =====
resource "aws_lambda_alias" "carbone_live" {
  name             = var.lambda_alias_name
  description      = "Live alias for Carbone Lambda"
  function_name    = aws_lambda_function.carbone_generator.arn
  function_version = "$LATEST"

  lifecycle {
    ignore_changes = [function_version]
  }
}