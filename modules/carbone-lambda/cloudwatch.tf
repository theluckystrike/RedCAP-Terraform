/**
 * CloudWatch Alarms and Dashboard
 */

# ===== Lambda Error Alarm =====
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${local.function_name}-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alert when Carbone Lambda has errors"
  alarm_actions       = var.alarm_actions
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.carbone_generator.function_name
  }

  tags = merge(
    var.tags,
    {
      Name     = "${local.function_name}-error-alarm"
      Severity = "High"
    }
  )
}

# ===== Lambda Duration Alarm =====
resource "aws_cloudwatch_metric_alarm" "lambda_duration" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${local.function_name}-duration"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Average"
  threshold           = var.lambda_timeout * 1000 * 0.8  # 80% of timeout
  alarm_description   = "Alert when Lambda duration is high"
  alarm_actions       = var.alarm_actions
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.carbone_generator.function_name
  }

  tags = merge(
    var.tags,
    {
      Name     = "${local.function_name}-duration-alarm"
      Severity = "Medium"
    }
  )
}

# ===== Lambda Throttle Alarm =====
resource "aws_cloudwatch_metric_alarm" "lambda_throttles" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${local.function_name}-throttles"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = "300"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "Alert when Lambda is throttled"
  alarm_actions       = var.alarm_actions
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.carbone_generator.function_name
  }

  tags = merge(
    var.tags,
    {
      Name     = "${local.function_name}-throttle-alarm"
      Severity = "High"
    }
  )
}

# ===== Lambda Concurrent Executions Alarm =====
resource "aws_cloudwatch_metric_alarm" "lambda_concurrent_executions" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${local.function_name}-concurrent-executions"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "ConcurrentExecutions"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.reserved_concurrent_executions > 0 ? var.reserved_concurrent_executions * 0.8 : 100
  alarm_description   = "Alert when Lambda concurrent executions are high"
  alarm_actions       = var.alarm_actions
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.carbone_generator.function_name
  }

  tags = merge(
    var.tags,
    {
      Name     = "${local.function_name}-concurrency-alarm"
      Severity = "Medium"
    }
  )
}

# ===== DLQ Message Alarm =====
resource "aws_cloudwatch_metric_alarm" "dlq_messages" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${local.function_name}-dlq-messages"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "300"
  statistic           = "Average"
  threshold           = "0"
  alarm_description   = "Alert when messages appear in DLQ"
  alarm_actions       = var.alarm_actions
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = aws_sqs_queue.dlq.name
  }

  tags = merge(
    var.tags,
    {
      Name     = "${local.function_name}-dlq-alarm"
      Severity = "Critical"
    }
  )
}

# ===== CloudWatch Dashboard =====
resource "aws_cloudwatch_dashboard" "carbone_pipeline" {
  count = var.enable_dashboard ? 1 : 0

  dashboard_name = "${var.project_name}-${var.environment}-carbone-pipeline"

  dashboard_body = jsonencode({
    widgets = [
      # Lambda Invocations
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/Lambda", "Invocations", { stat = "Sum", label = "Invocations" }],
            [".", "Errors", { stat = "Sum", label = "Errors", color = "#d62728" }],
            [".", "Throttles", { stat = "Sum", label = "Throttles", color = "#ff7f0e" }]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "Lambda Invocations & Errors"
          yAxis = {
            left = {
              min = 0
            }
          }
          dimensions = {
            FunctionName = [aws_lambda_function.carbone_generator.function_name]
          }
        }
        width  = 12
        height = 6
        x      = 0
        y      = 0
      },
      # Lambda Duration
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/Lambda", "Duration", { stat = "Average", label = "Avg Duration" }],
            ["...", { stat = "Maximum", label = "Max Duration", color = "#d62728" }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Lambda Duration (ms)"
          yAxis = {
            left = {
              min = 0
            }
          }
          dimensions = {
            FunctionName = [aws_lambda_function.carbone_generator.function_name]
          }
        }
        width  = 12
        height = 6
        x      = 12
        y      = 0
      },
      # Concurrent Executions
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/Lambda", "ConcurrentExecutions", { stat = "Maximum", label = "Concurrent Executions" }]
          ]
          period = 60
          stat   = "Maximum"
          region = var.aws_region
          title  = "Concurrent Executions"
          yAxis = {
            left = {
              min = 0
            }
          }
          dimensions = {
            FunctionName = [aws_lambda_function.carbone_generator.function_name]
          }
        }
        width  = 8
        height = 6
        x      = 0
        y      = 6
      },
      # DLQ Messages
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/SQS", "ApproximateNumberOfMessagesVisible", { stat = "Average", label = "DLQ Messages" }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Dead Letter Queue"
          yAxis = {
            left = {
              min = 0
            }
          }
          dimensions = {
            QueueName = [aws_sqs_queue.dlq.name]
          }
        }
        width  = 8
        height = 6
        x      = 8
        y      = 6
      },
      # Recent Log Events
      {
        type = "log"
        properties = {
          query = <<-EOT
            SOURCE '${aws_cloudwatch_log_group.lambda_logs.name}'
            | fields @timestamp, @message
            | filter @message like /✅|❌|⚠️/
            | sort @timestamp desc
            | limit 20
          EOT
          region = var.aws_region
          title  = "Recent Lambda Logs"
        }
        width  = 24
        height = 6
        x      = 0
        y      = 12
      }
    ]
  })
}

# ===== Log Metric Filters =====
resource "aws_cloudwatch_log_metric_filter" "generation_success" {
  name           = "${local.function_name}-generation-success"
  log_group_name = aws_cloudwatch_log_group.lambda_logs.name
  pattern        = "[time, request_id, level = INFO*, msg = \"✅ Document generated*\"]"

  metric_transformation {
    name      = "DocumentGenerationSuccess"
    namespace = "CarbonePipeline"
    value     = "1"
    unit      = "Count"
  }
}

resource "aws_cloudwatch_log_metric_filter" "generation_failure" {
  name           = "${local.function_name}-generation-failure"
  log_group_name = aws_cloudwatch_log_group.lambda_logs.name
  pattern        = "[time, request_id, level = ERROR*, msg = \"❌*\"]"

  metric_transformation {
    name      = "DocumentGenerationFailure"
    namespace = "CarbonePipeline"
    value     = "1"
    unit      = "Count"
  }
}

resource "aws_cloudwatch_log_metric_filter" "row_too_big_error" {
  name           = "${local.function_name}-row-too-big"
  log_group_name = aws_cloudwatch_log_group.lambda_logs.name
  pattern        = "row is too big"

  metric_transformation {
    name      = "RowTooBigError"
    namespace = "CarbonePipeline"
    value     = "1"
    unit      = "Count"
  }
}