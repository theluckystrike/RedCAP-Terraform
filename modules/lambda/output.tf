
output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.redcap_excel_processor.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.redcap_excel_processor.arn
}

output "lambda_function_invoke_arn" {
  description = "Invoke ARN of the Lambda function (for S3 triggers, API Gateway, etc.)"
  value       = aws_lambda_function.redcap_excel_processor.invoke_arn
}

output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_exec_role.arn
}

output "lambda_role_name" {
  description = "Name of the Lambda execution role"
  value       = aws_iam_role.lambda_exec_role.name
}

output "log_group_name" {
  description = "CloudWatch log group name for Lambda"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}

output "log_group_arn" {
  description = "CloudWatch log group ARN for Lambda"
  value       = aws_cloudwatch_log_group.lambda_logs.arn
}

output "lambda_security_group_id" {
  description = "Security group ID attached to Lambda"
  value       = var.lambda_security_group_id
}

output "environment_variables" {
  description = "Lambda environment variables (for verification)"
  value = {
    DB_NAME                      = var.db_name
    DB_PROXY_ENDPOINT            = var.db_proxy_endpoint
    MAPPING_BUCKET               = var.mapping_bucket
    MAPPING_KEY                  = var.mapping_key
    CARBONE_LAMBDA_FUNCTION_NAME = var.carbone_lambda_function_name
  }
  sensitive = false
}
