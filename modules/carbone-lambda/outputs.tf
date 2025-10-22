/**
 * Output Values
 */

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.carbone_generator.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.carbone_generator.arn
}

output "lambda_function_qualified_arn" {
  description = "Qualified ARN of the Lambda function"
  value       = aws_lambda_function.carbone_generator.qualified_arn
}

output "lambda_function_version" {
  description = "Latest published version of Lambda function"
  value       = aws_lambda_function.carbone_generator.version
}

output "lambda_alias_arn" {
  description = "ARN of the Lambda alias"
  value       = aws_lambda_alias.carbone_live.arn
}

output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_role_name" {
  description = "Name of the Lambda execution role"
  value       = aws_iam_role.lambda_role.name
}

output "lambda_layer_arn" {
  description = "ARN of the Lambda layer"
  value       = aws_lambda_layer_version.carbone_dependencies.arn
}

output "lambda_layer_version" {
  description = "Version of the Lambda layer"
  value       = aws_lambda_layer_version.carbone_dependencies.version
}

output "log_group_name" {
  description = "CloudWatch Log Group name"
  value       = aws_cloudwatch_log_group.lambda_logs.name
}

output "log_group_arn" {
  description = "CloudWatch Log Group ARN"
  value       = aws_cloudwatch_log_group.lambda_logs.arn
}

output "dlq_arn" {
  description = "ARN of the Dead Letter Queue"
  value       = aws_sqs_queue.dlq.arn
}

output "dlq_url" {
  description = "URL of the Dead Letter Queue"
  value       = aws_sqs_queue.dlq.url
}

output "eventbridge_rule_name" {
  description = "Name of EventBridge rule (if scheduled generation enabled)"
  value       = var.enable_scheduled_generation ? aws_cloudwatch_event_rule.scheduled_generation[0].name : null
}

output "eventbridge_rule_arn" {
  description = "ARN of EventBridge rule (if scheduled generation enabled)"
  value       = var.enable_scheduled_generation ? aws_cloudwatch_event_rule.scheduled_generation[0].arn : null
}

output "dashboard_name" {
  description = "Name of CloudWatch dashboard (if enabled)"
  value       = var.enable_dashboard ? aws_cloudwatch_dashboard.carbone_pipeline[0].dashboard_name : null
}

output "dashboard_url" {
  description = "URL to CloudWatch dashboard (if enabled)"
  value       = var.enable_dashboard ? "https://console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.carbone_pipeline[0].dashboard_name}" : null
}

# ===== Alarm Outputs =====
output "error_alarm_arn" {
  description = "ARN of Lambda error alarm"
  value       = var.enable_cloudwatch_alarms ? aws_cloudwatch_metric_alarm.lambda_errors[0].arn : null
}

output "duration_alarm_arn" {
  description = "ARN of Lambda duration alarm"
  value       = var.enable_cloudwatch_alarms ? aws_cloudwatch_metric_alarm.lambda_duration[0].arn : null
}

output "throttle_alarm_arn" {
  description = "ARN of Lambda throttle alarm"
  value       = var.enable_cloudwatch_alarms ? aws_cloudwatch_metric_alarm.lambda_throttles[0].arn : null
}

# ===== Invocation Details =====
output "invoke_command" {
  description = "AWS CLI command to invoke Lambda"
  value       = "aws lambda invoke --function-name ${aws_lambda_function.carbone_generator.function_name} --payload '{\"record_ids\":[1],\"template_name\":\"patient_report.odt\"}' response.json"
}

output "log_tail_command" {
  description = "AWS CLI command to tail logs"
  value       = "aws logs tail ${aws_cloudwatch_log_group.lambda_logs.name} --follow"
}