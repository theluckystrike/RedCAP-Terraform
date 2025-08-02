#!/bin/bash
set -e

# Usage: ./destroy_redcap.sh your-s3-bucket-name

BUCKET=$1

if [[ -z "$BUCKET" ]]; then
  echo "❌ Usage: ./destroy_redcap.sh <bucket-name>"
  exit 1
fi

echo "🔥 Destroying REDCap Terraform infrastructure..."

# 🔧 Detach Option Group if in use
echo "🔍 Checking if Option Group is in use..."
DB_INSTANCE_ID=$(aws rds describe-db-instances \
  --query "DBInstances[?OptionGroupMemberships[?OptionGroupName=='clinical-docs-dev-dev-pg-options']].DBInstanceIdentifier" \
  --output text)

if [[ -n "$DB_INSTANCE_ID" ]]; then
  echo "🔧 Detaching Option Group from DB instance: $DB_INSTANCE_ID"
  aws rds modify-db-instance \
    --db-instance-identifier "$DB_INSTANCE_ID" \
    --option-group-name "default:postgres12" \
    --apply-immediately
  echo "⏳ Waiting for DB instance to update..."
  aws rds wait db-instance-available --db-instance-identifier "$DB_INSTANCE_ID"
fi

echo "🧹 Cleaning S3 bucket: $BUCKET"

# Delete object versions
aws s3api list-object-versions --bucket "$BUCKET" \
  --query 'Versions[].{Key:Key,VersionId:VersionId}' \
  --output json > raw_versions.json

if jq -e '. | length > 0' raw_versions.json > /dev/null; then
  echo "{\"Objects\": $(cat raw_versions.json)}" > versions.json
  aws s3api delete-objects --bucket "$BUCKET" --delete file://versions.json
fi

# Delete delete markers
aws s3api list-object-versions --bucket "$BUCKET" \
  --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' \
  --output json > raw_markers.json

if jq -e '. | length > 0' raw_markers.json > /dev/null; then
  echo "{\"Objects\": $(cat raw_markers.json)}" > markers.json
  aws s3api delete-objects --bucket "$BUCKET" --delete file://markers.json
fi

# Pause to ensure state update
echo "⏳ Waiting for state consistency..."
sleep 30

echo "💥 Running Terraform destroy..."
terraform destroy -auto-approve

# Cleanup temp files
rm -f raw_versions.json raw_markers.json versions.json markers.json

echo "✅ Terraform destroyed and S3 bucket $BUCKET cleaned"