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
export TF_DB_HOST=$(terraform output -raw rds_proxy_endpoint)
export TF_DB_NAME=$(terraform output -raw db_name)
export TF_DB_USER=$(terraform output -raw db_username)
export TF_DB_PASS=$(terraform output -raw db_password)

echo "Running Ansible playbook..."
cd ../../ansible/
# ansible-playbook -i inventory.ini redcap_install.yml

ansible-playbook -i inventory.ini rds_schema_upload.yml

cd ../environments/dev

TEMPLATE_BUCKET=$(terraform output -raw carbone_template_bucket_name)
aws s3 cp ../../patient_report.odt s3://$TEMPLATE_BUCKET/