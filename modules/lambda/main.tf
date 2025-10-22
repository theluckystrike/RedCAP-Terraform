# Get current AWS account ID
data "aws_caller_identity" "current" {}

locals {
  aws_data_wrangler_layer_arn = "arn:aws:lambda:ap-southeast-2:336392948345:layer:AWSSDKPandas-Python311:23"

  # Combine AWS layer with any additional layers passed in
  all_layers = concat(
    [local.aws_data_wrangler_layer_arn],
    var.lambda_layers
  )
}

# -------------------------
# IAM Role for Lambda
# -------------------------
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.project_name}-${var.environment}-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Principal = { Service = "lambda.amazonaws.com" },
      Effect    = "Allow"
    }]
  })
  
  tags = var.tags
}

# Basic Lambda execution permissions
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Allow Lambda to read from S3 exports bucket
resource "aws_iam_role_policy" "lambda_s3_read" {
  name = "${var.project_name}-${var.environment}-lambda-s3-read"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.project_name}-${var.environment}-redcap-exports",
          "arn:aws:s3:::${var.project_name}-${var.environment}-redcap-exports/*"
        ]
      }
    ]
  })
}

# Allow Lambda to read the DB credentials secret
resource "aws_iam_role_policy" "lambda_secret_access" {
  name = "${var.project_name}-${var.environment}-lambda-secret-access"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = "${var.secret_arn}*"
      }
    ]
  })
}

# Allow Lambda VPC network access
resource "aws_iam_role_policy" "lambda_vpc_access" {
  name   = "${var.project_name}-${var.environment}-lambda-vpc-access"
  role   = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:AssignPrivateIpAddresses",
          "ec2:UnassignPrivateIpAddresses"
        ],
        Resource = "*"
      }
    ]
  })
}

# ✅ FIXED: Allow Lambda to invoke Carbone Lambda
resource "aws_iam_role_policy" "lambda_invoke_carbone" {
  name = "${var.project_name}-${var.environment}-lambda-invoke-carbone"
  role = aws_iam_role.lambda_exec_role.id  # ✅ Changed from data_ingestion_lambda_role

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = "arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${var.project_name}-${var.environment}-carbone-generator"
      }
    ]
  })
}

# -------------------------
# Lambda Function
# -------------------------
resource "aws_lambda_function" "redcap_excel_processor" {
  function_name    = "${var.project_name}-${var.environment}-excel-processor"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  role             = aws_iam_role.lambda_exec_role.arn
  filename         = var.lambda_package_path
  source_code_hash = filebase64sha256(var.lambda_package_path)
  layers           = local.all_layers
  timeout          = 300      # 5 minutes
  memory_size      = 1024

  environment {
    variables = {
      CARBONE_LAMBDA_FUNCTION_NAME = "${var.project_name}-${var.environment}-carbone-generator"
      DB_PROXY_ENDPOINT            = var.db_proxy_endpoint
      DB_NAME                      = var.db_name
      SECRET_ARN                   = var.secret_arn
    }
  }

  vpc_config {
    subnet_ids         = var.lambda_subnet_ids
    security_group_ids = [var.lambda_security_group_id]
  }

  tags = var.tags
}

# -------------------------
# S3 Trigger for Lambda
# -------------------------
resource "aws_s3_bucket_notification" "excel_upload_trigger" {
  bucket = var.s3_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.redcap_excel_processor.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.s3_trigger_prefix
    filter_suffix       = ".xlsx"
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}

resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.redcap_excel_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_bucket_arn
}

# -------------------------
# CloudWatch Log Group
# -------------------------
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.redcap_excel_processor.function_name}"
  retention_in_days = var.log_retention_days

  tags = var.tags
}