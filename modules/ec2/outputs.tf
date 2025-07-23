output "public_ip" {
  value = aws_instance.redcap.public_ip
}

output "instance_id" {
  value = aws_instance.redcap.id
}