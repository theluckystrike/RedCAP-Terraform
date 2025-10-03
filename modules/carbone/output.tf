output "lambda_function_name" {
  value = aws_lambda_function.carbone_doc_generator.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.carbone_doc_generator.arn
}

output "lambda_function_name" { value = aws_lambda_function.carbone_doc_generator.function_name }
output "lambda_function_arn"  { value = aws_lambda_function.carbone_doc_generator.arn }
output "lambda_role_arn"      { value = aws_iam_role.lambda_exec.arn }
output "carbone_ec2_public_ip" { value = aws_instance.carbone_ec2.public_ip }
output "carbone_ec2_id" { value = aws_instance.carbone_ec2.id }