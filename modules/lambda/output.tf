output "lambda_function_arn" {
  value = aws_lambda_function.redcap_excel_processor.arn
}
output "lambda_function_name" {
  value = aws_lambda_function.redcap_excel_processor.function_name
}
