#!/bin/bash

set -e

PROJECT="clinical-docs-dev"
ENV="dev"
REGION="ap-southeast-2"
BUCKET="${PROJECT}-${ENV}-redcap-exports"
LAMBDA_NAME="${PROJECT}-${ENV}-excel-processor"
DB_IDENTIFIER="${PROJECT}-${ENV}-postgres"
DB_NAME="redcap_docupilot"
DB_USER="dbadmin"
DB_PASSWORD=$(terraform output -raw database_password)
VPC_NAME="${PROJECT}-${ENV}-vpc"

echo "🔍 Starting full infrastructure test for: $PROJECT-$ENV"

# 1️⃣ VPC Test
echo "➡️  Checking VPC..."
VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=tag:Name,Values=${VPC_NAME}" \
  --region $REGION \
  --query 'Vpcs[0].VpcId' --output text)

if [[ "$VPC_ID" == "None" || -z "$VPC_ID" ]]; then
  echo "❌ VPC not found."
  exit 1
else
  echo "✅ VPC found: $VPC_ID"
fi

# 2️⃣ Subnets Test
echo "➡️  Checking private subnets..."
SUBNET_IDS=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --region $REGION \
  --query 'Subnets[?MapPublicIpOnLaunch==`false`].SubnetId' --output text)

if [[ -z "$SUBNET_IDS" ]]; then
  echo "❌ Private subnets not found"
  exit 1
else
  echo "✅ Private subnets found: $SUBNET_IDS"
fi

# 3️⃣ NAT Gateway
echo "➡️  Checking NAT Gateway..."
NAT_STATE=$(aws ec2 describe-nat-gateways --filter Name=vpc-id,Values=$VPC_ID --region $REGION --query "NatGateways[0].State" --output text)
if [[ "$NAT_STATE" == "available" ]]; then
  echo "✅ NAT Gateway is available"
else
  echo "❌ NAT Gateway not available"
  exit 1
fi

# 4️⃣ Lambda Function Test
echo "➡️  Checking Lambda function..."
LAMBDA_ARN=$(aws lambda get-function --function-name $LAMBDA_NAME --region $REGION --query 'Configuration.FunctionArn' --output text 2>/dev/null || echo "")

if [[ -z "$LAMBDA_ARN" ]]; then
  echo "❌ Lambda function not found"
  exit 1
else
  echo "✅ Lambda function exists: $LAMBDA_ARN"
fi

# 5️⃣ Invoke Lambda (dry-run style)
echo "➡️  Invoking Lambda with test event..."
aws lambda invoke \
  --function-name "$LAMBDA_NAME" \
  --region "$REGION" \
  --payload '{}' \
  /tmp/lambda_output.json > /dev/null

echo "✅ Lambda invoked. Output:"
cat /tmp/lambda_output.json
echo ""

# 6️⃣ IAM Role Permissions
echo "➡️  Checking IAM permissions for Lambda..."
ROLE_NAME=$(aws lambda get-function-configuration --function-name $LAMBDA_NAME --region $REGION --query "Role" --output text | awk -F/ '{print $NF}')
aws iam list-attached-role-policies --role-name "$ROLE_NAME" --region $REGION

# 7️⃣ S3 Bucket Tests
echo "➡️  Checking S3 bucket..."
aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null && echo "✅ S3 bucket exists" || { echo "❌ S3 bucket missing"; exit 1; }

echo "➡️  Uploading test file to S3..."
echo "Terraform test upload $(date)" > /tmp/test_upload.txt
aws s3 cp /tmp/test_upload.txt "s3://${BUCKET}/incoming/test_upload.txt" --sse AES256

echo "➡️  Downloading file from S3..."
aws s3 cp "s3://${BUCKET}/incoming/test_upload.txt" /tmp/test_download.txt
echo "✅ S3 readback: $(cat /tmp/test_download.txt)"

# 8️⃣ RDS Connection Test
echo "➡️  Checking RDS instance..."
RDS_ENDPOINT=$(aws rds describe-db-instances \
  --db-instance-identifier "$DB_IDENTIFIER" \
  --region $REGION \
  --query "DBInstances[0].Endpoint.Address" \
  --output text)

if [[ -z "$RDS_ENDPOINT" ]]; then
  echo "❌ RDS instance not found"
  exit 1
else
  echo "✅ RDS Endpoint: $RDS_ENDPOINT"
fi

echo "➡️  Testing DB connectivity with pg_isready..."
pg_isready -h "$RDS_ENDPOINT" -p 5432 -U "$DB_USER" || { echo "❌ RDS not accepting connections"; exit 1; }
echo "✅ RDS is reachable"

# 9️⃣ CloudWatch Logs (recent)
echo "➡️  Checking recent CloudWatch logs..."
LOG_GROUP="/aws/lambda/${LAMBDA_NAME}"
LOG_STREAM=$(aws logs describe-log-streams --log-group-name "$LOG_GROUP" --order-by LastEventTime --descending --limit 1 --region $REGION --query 'logStreams[0].logStreamName' --output text)
aws logs get-log-events --log-group-name "$LOG_GROUP" --log-stream-name "$LOG_STREAM" --limit 5 --region $REGION --query 'events[*].message' --output text

echo "🎉 All tests passed successfully!"