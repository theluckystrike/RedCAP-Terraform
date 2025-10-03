resource "aws_security_group" "carbone_sg" {
  name        = "${var.name}-sg"
  description = "Allow Carbone port 4000"

  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "carbone_role" {
  name = "${var.name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = "sts:AssumeRole",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "marketplace_access" {
  role       = aws_iam_role.carbone_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSMarketplaceMeteringFullAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_access" {
  role       = aws_iam_role.carbone_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_access" {
  role       = aws_iam_role.carbone_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_instance_profile" "carbone_profile" {
  name = "${var.name}-instance-profile"
  role = aws_iam_role.carbone_role.name
}

resource "aws_instance" "carbone" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.carbone_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.carbone_profile.name

  tags = merge(
    var.tags,
    { "CARBONE_CONFIG_PREFIX" = var.config_prefix }
  )

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              # Carbone is preinstalled on AMI
              EOF
}