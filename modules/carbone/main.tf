resource "aws_iam_role" "lambda_exec" {
  name = "${var.project_name}-${var.environment}-lambda-carbone-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = { Service = "lambda.amazonaws.com" },
      Effect   = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_custom" {
  role = aws_iam_role.lambda_exec.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["s3:PutObject"],
        Effect = "Allow",
        Resource = "${var.processed_bucket_arn}/*"
      }
    ]
  })
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_src"
  output_path = "${path.module}/lambda_src/lambda.zip"
}

resource "aws_lambda_function" "carbone_doc_generator" {
  function_name = "${var.project_name}-${var.environment}-carbone"
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role          = aws_iam_role.lambda_exec.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.11"
  timeout       = 30

  environment {
    variables = {
      DB_HOST             = var.db_host
      DB_NAME             = var.db_name
      DB_USER             = var.db_user
      DB_PASSWORD         = var.db_password
      PROCESSED_BUCKET    = var.processed_bucket_name
      CARBONE_API_TOKEN   = var.carbone_api_token
      CARBONE_TEMPLATE_ID = var.carbone_template_id
    }
  }
}