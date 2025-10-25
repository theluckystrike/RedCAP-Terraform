#!/bin/bash
set -e

# Log everything
exec > >(tee /var/log/carbone-user-data.log)
exec 2>&1

echo "=========================================="
echo "Starting Carbone Configuration"
echo "=========================================="
echo "Timestamp: $(date)"
echo "Template Bucket: ${template_bucket}"
echo "Output Bucket: ${output_bucket}"
echo "Region: ${aws_region}"

# Wait for Carbone to be installed
echo "Waiting for Carbone installation..."
sleep 10

# Create Carbone config directory if it doesn't exist
mkdir -p /var/www/carbone-ee/config

# Create the config.json file
echo "Creating Carbone configuration file..."
cat > /var/www/carbone-ee/config/config.json <<EOF
{
  "templateS3Bucket": "${template_bucket}",
  "templateS3BucketRegion": "${aws_region}",
  "templateS3Folder": "",
  "renderS3Bucket": "${output_bucket}",
  "renderS3BucketRegion": "${aws_region}",
  "renderS3Folder": ""
}
EOF

# Set proper ownership and permissions
chown carbone:carbone /var/www/carbone-ee/config/config.json
chmod 644 /var/www/carbone-ee/config/config.json

echo "Config file created:"
cat /var/www/carbone-ee/config/config.json

# Enable and restart Carbone service
echo "Enabling and restarting Carbone service..."
systemctl enable carbone-ee 2>/dev/null || true
systemctl restart carbone-ee 2>/dev/null || true

# Wait for service to start
sleep 5

# Check service status
echo "Checking Carbone service status..."
systemctl status carbone-ee --no-pager || true

echo "=========================================="
echo "Carbone Configuration Complete!"
echo "=========================================="