/**
 * IAM Roles and Policies for Carbone Lambda
 */

# ===== Lambda Execution Role =====
resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}-${var.environment}-carbone-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-${var.environment}-carbone-lambda-role"
      Environment = var.environment
    }
  )
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# ===== AWS Managed Policies =====
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_xray" {
  count = var.enable_xray_tracing ? 1 : 0

  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

# ===== Custom Lambda Policy =====
resource "aws_iam_role_policy" "lambda_custom_policy" {
  name   = "${var.project_name}-${var.environment}-carbone-lambda-policy"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_custom_policy.json
}

data "aws_iam_policy_document" "lambda_custom_policy" {
  # S3 Template Bucket - Read Access
  statement {
    sid    = "S3TemplateRead"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.template_bucket_name}",
      "arn:aws:s3:::${var.template_bucket_name}/*"
    ]
  }

  # S3 Output Bucket - Write Access
  statement {
    sid    = "S3OutputWrite"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${var.output_bucket_name}/*"
    ]
  }

  # Secrets Manager - Read Database Credentials
  statement {
    sid    = "SecretsManagerRead"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [
      var.db_secret_arn
    ]
  }

  # SNS - Publish Notifications
  dynamic "statement" {
    for_each = var.sns_topic_arn != null ? [1] : []
    content {
      sid    = "SNSPublish"
      effect = "Allow"
      actions = [
        "sns:Publish"
      ]
      resources = [
        var.sns_topic_arn
      ]
    }
  }

  # SQS - Dead Letter Queue
  statement {
    sid    = "SQSSendMessage"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [
      aws_sqs_queue.dlq.arn
    ]
  }

  # CloudWatch Logs
  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${local.function_name}:*"
    ]
  }

  # KMS - Decrypt for encrypted environment variables
  dynamic "statement" {
    for_each = var.lambda_kms_key_arn != null ? [1] : []
    content {
      sid    = "KMSDecrypt"
      effect = "Allow"
      actions = [
        "kms:Decrypt"
      ]
      resources = [
        var.lambda_kms_key_arn
      ]
    }
  }

  # EC2 - For VPC configuration
  statement {
    sid    = "VPCConfig"
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses"
    ]
    resources = ["*"]
  }
}

# ===== Additional Custom Policies (Optional) =====
resource "aws_iam_role_policy" "additional_policies" {
  for_each = var.additional_iam_policies

  name   = each.key
  role   = aws_iam_role.lambda_role.id
  policy = each.value
}