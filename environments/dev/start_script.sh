#!/bin/bash

set -e  # Exit immediately if any command fails

echo "Initializing Terraform..."
terraform init

echo "Validating Terraform config..."
terraform validate

echo "Planning Terraform changes..."
terraform plan -out=tfplan.out

echo "Applying Terraform changes..."
terraform apply -auto-approve tfplan.out

echo "Waiting for EC2 to become ready (optional)..."
sleep 30  # Optional: ensure the EC2 instance is up

echo "Exporting Vaiables For RDS Schema"
export TF_DB_HOST=$(terraform output -raw db_instance_endpoint_clean)
export TF_DB_NAME=$(terraform output -raw db_name)
export TF_DB_USER=$(terraform output -raw db_username)
export TF_DB_PASS=$(terraform output -raw db_password)

echo "Running Ansible playbook..."
ansible-playbook -i modules/ansible/inventory.ini modules/ansible/redcap_install.yml

ansible-playbook -i modules/ansible/inventory.ini modules/ansible/rds_schema_upload.yml
