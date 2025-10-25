/**
 * Carbone EC2 Instance Module
 * Deploys Carbone from AWS Marketplace AMI
 */

# Use provided AMI ID or search for it
locals {
  use_ami_lookup = var.carbone_ami_id == ""
}

data "aws_ami" "carbone" {
  count       = local.use_ami_lookup ? 1 : 0
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "product-code"
    values = ["f9b9fb4e-6454-41c9-81a4-eba0bd4ab8a6"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ami_id = local.use_ami_lookup ? data.aws_ami.carbone[0].id : var.carbone_ami_id
}

# ===== Security Group for Carbone EC2 =====
resource "aws_security_group" "carbone_ec2" {
  name_prefix = "${var.project_name}-${var.environment}-carbone-ec2"
  description = "Security group for Carbone EC2 instance"
  vpc_id      = var.vpc_id

  # Allow HTTP from Lambda
  ingress {
    description     = "HTTP from Lambda"
    from_port       = 4000
    to_port         = 4000
    protocol        = "tcp"
    security_groups = [var.lambda_security_group_id]
  }

  # Allow HTTPS from Lambda (if needed)
  ingress {
    description     = "HTTPS from Lambda"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [var.lambda_security_group_id]
  }

  # Allow SSH for management (optional)
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow all outbound
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-carbone-ec2-sg"
    }
  )
}

# ===== IAM Role for EC2 =====
resource "aws_iam_role" "carbone_ec2" {
  name = "${var.project_name}-${var.environment}-carbone-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# ===== SSM Managed Instance Core (for remote access) =====
resource "aws_iam_role_policy_attachment" "carbone_ec2_ssm" {
  role       = aws_iam_role.carbone_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ===== AWS Marketplace Policy =====
resource "aws_iam_role_policy" "carbone_marketplace" {
  name = "${var.project_name}-${var.environment}-carbone-marketplace"
  role = aws_iam_role.carbone_ec2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "aws-marketplace:MeterUsage",
          "aws-marketplace:RegisterUsage",
          "aws-marketplace:ResolveCustomer"
        ]
        Resource = "*"
      }
    ]
  })
}

# ===== S3 Access Policy =====
resource "aws_iam_role_policy" "carbone_s3_access" {
  name = "${var.project_name}-${var.environment}-carbone-s3"
  role = aws_iam_role.carbone_ec2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.template_bucket_name}",
          "arn:aws:s3:::${var.template_bucket_name}/*",
          "arn:aws:s3:::${var.output_bucket_name}",
          "arn:aws:s3:::${var.output_bucket_name}/*"
        ]
      }
    ]
  })
}

# ===== IAM Instance Profile =====
resource "aws_iam_instance_profile" "carbone_ec2" {
  name = "${var.project_name}-${var.environment}-carbone-ec2-profile"
  role = aws_iam_role.carbone_ec2.name
}

# ===== EC2 Instance =====
resource "aws_instance" "carbone" {
  ami           = local.ami_id
  instance_type = var.instance_type
  
  subnet_id                   = var.private_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.carbone_ec2.id]
  iam_instance_profile        = aws_iam_instance_profile.carbone_ec2.name
  associate_public_ip_address = false

  key_name = var.key_name

  user_data_base64 = base64encode(templatefile("${path.module}/user_data.sh", {
    template_bucket = var.template_bucket_name
    output_bucket   = var.output_bucket_name
    aws_region      = var.aws_region
  }))

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-carbone"
    }
  )
}

# ===== CloudWatch Log Group =====
resource "aws_cloudwatch_log_group" "carbone_ec2" {
  name              = "/aws/ec2/${var.project_name}-${var.environment}-carbone"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# ===== CloudWatch Alarms =====
resource "aws_cloudwatch_metric_alarm" "carbone_cpu" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${var.project_name}-${var.environment}-carbone-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alert when Carbone EC2 CPU is high"
  alarm_actions       = var.alarm_actions

  dimensions = {
    InstanceId = aws_instance.carbone.id
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "carbone_status" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${var.project_name}-${var.environment}-carbone-status"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "Alert when Carbone EC2 status check fails"
  alarm_actions       = var.alarm_actions

  dimensions = {
    InstanceId = aws_instance.carbone.id
  }

  tags = var.tags
}

# ===== Outputs =====
output "carbone_instance_id" {
  description = "Carbone EC2 instance ID"
  value       = aws_instance.carbone.id
}

output "carbone_private_ip" {
  description = "Carbone EC2 private IP"
  value       = aws_instance.carbone.private_ip
}

output "carbone_endpoint" {
  description = "Carbone service endpoint"
  value       = "http://${aws_instance.carbone.private_ip}:4000"
}

output "carbone_security_group_id" {
  description = "Carbone security group ID"
  value       = aws_security_group.carbone_ec2.id
}