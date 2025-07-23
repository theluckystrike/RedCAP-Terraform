resource "aws_instance" "redcap" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.redcap_sg.id]

  tags = {
    Name = "redcap-server"
  }

  provisioner "local-exec" {
    command = "mkdir -p ${path.root}/ansible && echo '[redcap]\n${self.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${var.private_key_path}' > ${path.root}/ansible/inventory.ini"
  }
}

resource "aws_security_group" "redcap_sg" {
  name        = "redcap-sg"
  description = "Allow web + SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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