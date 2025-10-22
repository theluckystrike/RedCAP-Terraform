output "lambda_function_arn" {
  value = aws_lambda_function.redcap_excel_processor.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.redcap_excel_processor.function_name
}


output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_exec_role.arn
}

output "lambda_role_name" {
  description = "Name of the Lambda execution role"
  value       = aws_iam_role.lambda_exec_role.name
}