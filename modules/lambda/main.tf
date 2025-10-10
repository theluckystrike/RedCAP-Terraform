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

# ✅ Allow Lambda to read the DB credentials secret
resource "aws_iam_role_policy" "lambda_secret_access" {
  name = "${var.project_name}-${var.environment}-lambda-secret-access"
  role = aws_iam_role.lambda_exec_role.id

  # Tip: using var.secret_arn keeps this flexible across environments
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
          "ec2:DeleteNetworkInterface"
        ],
        Resource = "*"
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
  timeout     = 300      # 5 minutes (default is 3 seconds!)
  memory_size = 1024
  environment {
    variables = {
      DB_PROXY_ENDPOINT = var.db_proxy_endpoint
      DB_NAME           = var.db_name
      SECRET_ARN        = var.secret_arn
    }
  }

  vpc_config {
    subnet_ids         = var.lambda_subnet_ids
    security_group_ids = [var.lambda_security_group_id]
  }

  tags = var.tags
}