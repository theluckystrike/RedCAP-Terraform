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

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy" "lambda_s3_read" {
  name = "LambdaS3ReadAccess"
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

resource "aws_lambda_function" "redcap_excel_processor" {
  function_name = "${var.project_name}-${var.environment}-excel-processor"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = var.lambda_package_path
  source_code_hash = filebase64sha256(var.lambda_package_path)
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