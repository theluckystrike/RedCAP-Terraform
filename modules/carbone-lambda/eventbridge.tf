/**
 * EventBridge Rules for Scheduled Generation (Optional)
 */

variable "enable_scheduled_generation" {
  description = "Enable scheduled document generation"
  type        = bool
  default     = false
}

variable "schedule_expression" {
  description = "EventBridge schedule expression"
  type        = string
  default     = "cron(0 8 * * ? *)"
}

variable "default_record_ids" {
  description = "Default record IDs for scheduled generation"
  type        = list(number)
  default     = []
}

variable "default_template_name" {
  description = "Default template name for scheduled generation"
  type        = string
  default     = "patient_report.odt"
}

# ===== Scheduled Generation Rule =====
resource "aws_cloudwatch_event_rule" "scheduled_generation" {
  count = var.enable_scheduled_generation ? 1 : 0

  name                = "${local.function_name}-scheduled"
  description         = "Trigger Carbone Lambda on schedule"
  schedule_expression = var.schedule_expression
  state               = "ENABLED"

  tags = merge(
    var.tags,
    {
      Name = "Scheduled Document Generation"
    }
  )
}

resource "aws_cloudwatch_event_target" "lambda_scheduled" {
  count = var.enable_scheduled_generation ? 1 : 0

  rule      = aws_cloudwatch_event_rule.scheduled_generation[0].name
  target_id = "CarboneLambdaScheduled"
  arn       = aws_lambda_alias.carbone_live.arn

  input = jsonencode({
    record_ids    = var.default_record_ids
    template_name = var.default_template_name
    output_format = "pdf"
    batch_mode    = true
  })

  retry_policy {
    maximum_event_age_in_seconds = 3600
    maximum_retry_attempts       = 2
  }
}

resource "aws_lambda_permission" "allow_eventbridge_scheduled" {
  count = var.enable_scheduled_generation ? 1 : 0

  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.carbone_generator.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_generation[0].arn
  qualifier     = aws_lambda_alias.carbone_live.name
}

# ===== Manual Trigger Rule =====
resource "aws_cloudwatch_event_rule" "manual_trigger" {
  name        = "${local.function_name}-manual"
  description = "Manual trigger for document generation"
  
  event_pattern = jsonencode({
    source      = ["custom.carbone"]
    detail-type = ["Document Generation Request"]
  })

  tags = merge(
    var.tags,
    {
      Name = "Manual Document Generation"
    }
  )
}

resource "aws_cloudwatch_event_target" "lambda_manual" {
  rule      = aws_cloudwatch_event_rule.manual_trigger.name
  target_id = "CarboneLambdaManual"
  arn       = aws_lambda_alias.carbone_live.arn
}

resource "aws_lambda_permission" "allow_eventbridge_manual" {
  statement_id  = "AllowManualExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.carbone_generator.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.manual_trigger.arn
  qualifier     = aws_lambda_alias.carbone_live.name
}