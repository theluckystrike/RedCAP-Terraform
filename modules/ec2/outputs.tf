output "public_ip" {
  value = aws_instance.redcap.public_ip
}

output "instance_id" {
  value = aws_instance.redcap.id
}

output "security_group_id" {
  description = "Security group ID for the REDCap EC2 instance"
  value       = aws_security_group.redcap_sg.id
}