output "carbone_public_ip" {
  value = aws_instance.carbone.public_ip
}

output "carbone_instance_id" {
  value = aws_instance.carbone.id
}