#!/bin/bash
# scripts/test-s3.sh - Test S3 deployment

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get environment from argument
ENVIRONMENT=${1:-dev}

echo -e "${BLUE}Testing S3 deployment for $ENVIRONMENT environment...${NC}"

# Get bucket name from Terraform output
BUCKET_NAME=$(terraform output -json | jq -r '.s3_bucket_info.value.bucket_name' 2>/dev/null || echo "")

if [ -z "$BUCKET_NAME" ] || [ "$BUCKET_NAME" == "null" ]; then
    echo -e "${RED}Error: Could not get S3 bucket name. Is the infrastructure deployed?${NC}"
    exit 1
fi

echo -e "${GREEN}✓ S3 Bucket: $BUCKET_NAME${NC}"

# Check if bucket exists
echo -e "${BLUE}Checking bucket existence...${NC}"
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo -e "${GREEN}✓ Bucket exists and is accessible${NC}"
else
    echo -e "${RED}✗ Bucket does not exist or is not accessible${NC}"
    exit 1
fi

# Get bucket location
LOCATION=$(aws s3api get-bucket-location --bucket "$BUCKET_NAME" --query 'LocationConstraint' --output text)
echo -e "${GREEN}✓ Bucket location: $LOCATION${NC}"

# Check versioning
echo -e "${BLUE}Checking versioning configuration...${NC}"
VERSIONING=$(aws s3api get-bucket-versioning --bucket "$BUCKET_NAME" --query 'Status' --output text)
if [ "$VERSIONING" == "Enabled" ]; then
    echo -e "${GREEN}✓ Versioning: Enabled${NC}"
else
    echo -e "${YELLOW}! Versioning: Not enabled${NC}"
fi

# Check encryption
echo -e "${BLUE}Checking encryption configuration...${NC}"
ENCRYPTION=$(aws s3api get-bucket-encryption --bucket "$BUCKET_NAME" 2>/dev/null)
if [ $? -eq 0 ]; then
    ALGORITHM=$(echo "$ENCRYPTION" | jq -r '.ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm')
    echo -e "${GREEN}✓ Encryption: $ALGORITHM${NC}"
else
    echo -e "${RED}✗ Encryption not configured${NC}"
fi

# Check public access block
echo -e "${BLUE}Checking public access block...${NC}"
PUBLIC_BLOCK=$(aws s3api get-public-access-block --bucket "$BUCKET_NAME" 2>/dev/null)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Public access blocked${NC}"
else
    echo -e "${RED}✗ Public access block not configured${NC}"
fi

# List folders
echo -e "${BLUE}Checking folder structure...${NC}"
FOLDERS=$(aws s3 ls "s3://$BUCKET_NAME/" 2>/dev/null | grep PRE || true)
if [ ! -z "$FOLDERS" ]; then
    echo -e "${GREEN}✓ Folder structure:${NC}"
    echo "$FOLDERS" | while read -r line; do
        folder=$(echo "$line" | awk '{print $2}')
        echo -e "  ${GREEN}• $folder${NC}"
    done
else
    echo -e "${YELLOW}! No folders found${NC}"
fi

# Check lifecycle rules
echo -e "${BLUE}Checking lifecycle rules...${NC}"
LIFECYCLE=$(aws s3api get-bucket-lifecycle-configuration --bucket "$BUCKET_NAME" 2>/dev/null)
if [ $? -eq 0 ]; then
    RULE_COUNT=$(echo "$LIFECYCLE" | jq '.Rules | length')
    echo -e "${GREEN}✓ Lifecycle rules configured: $RULE_COUNT rules${NC}"
    echo "$LIFECYCLE" | jq -r '.Rules[] | "  • \(.Id): \(.Status)"'
else
    echo -e "${YELLOW}! No lifecycle rules configured${NC}"
fi

# Check event notifications
echo -e "${BLUE}Checking event notifications...${NC}"
NOTIFICATIONS=$(aws s3api get-bucket-notification-configuration --bucket "$BUCKET_NAME" 2>/dev/null)
if [ $? -eq 0 ]; then
    LAMBDA_COUNT=$(echo "$NOTIFICATIONS" | jq '.LambdaFunctionConfigurations | length' 2>/dev/null || echo "0")
    if [ "$LAMBDA_COUNT" -gt 0 ]; then
        echo -e "${GREEN}✓ Lambda triggers configured: $LAMBDA_COUNT${NC}"
    else
        echo -e "${YELLOW}! No Lambda triggers configured yet${NC}"
    fi
    
    EVENTBRIDGE=$(echo "$NOTIFICATIONS" | jq -r '.EventBridgeConfiguration' 2>/dev/null || echo "null")
    if [ "$EVENTBRIDGE" != "null" ]; then
        echo -e "${GREEN}✓ EventBridge integration enabled${NC}"
    else
        echo -e "${YELLOW}! EventBridge not enabled${NC}"
    fi
else
    echo -e "${YELLOW}! No event notifications configured${NC}"
fi

# Check bucket policy
echo -e "${BLUE}Checking bucket policy...${NC}"
POLICY=$(aws s3api get-bucket-policy --bucket "$BUCKET_NAME" 2>/dev/null)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Bucket policy configured${NC}"
    # Check for secure transport requirement
    if echo "$POLICY" | grep -q "aws:SecureTransport"; then
        echo -e "${GREEN}  ✓ HTTPS-only access enforced${NC}"
    fi
else
    echo -e "${YELLOW}! No bucket policy configured${NC}"
fi

# Test write access
echo -e "${BLUE}Testing write access...${NC}"
TEST_FILE="/tmp/test-s3-${RANDOM}.txt"
echo "Test file created at $(date)" > "$TEST_FILE"

if aws s3 cp "$TEST_FILE" "s3://$BUCKET_NAME/incoming/test-file.txt" 2>/dev/null; then
    echo -e "${GREEN}✓ Successfully uploaded test file${NC}"
    
    # Test read access
    if aws s3 cp "s3://$BUCKET_NAME/incoming/test-file.txt" "/tmp/test-download.txt" 2>/dev/null; then
        echo -e "${GREEN}✓ Successfully downloaded test file${NC}"
    else
        echo -e "${RED}✗ Failed to download test file${NC}"
    fi
    
    # Clean up test file
    aws s3 rm "s3://$BUCKET_NAME/incoming/test-file.txt" 2>/dev/null
    echo -e "${GREEN}✓ Cleaned up test file${NC}"
else
    echo -e "${RED}✗ Failed to upload test file${NC}"
fi

rm -f "$TEST_FILE" "/tmp/test-download.txt"

# Show bucket size
echo -e "${BLUE}Bucket statistics:${NC}"
SIZE=$(aws s3 ls "s3://$BUCKET_NAME/" --recursive --summarize 2>/dev/null | grep "Total Size" | awk '{print $3}')
COUNT=$(aws s3 ls "s3://$BUCKET_NAME/" --recursive --summarize 2>/dev/null | grep "Total Objects" | awk '{print $3}')
echo -e "  Total Size: ${GREEN}${SIZE:-0} bytes${NC}"
echo -e "  Total Objects: ${GREEN}${COUNT:-0}${NC}"

# Show URIs from Terraform output
echo -e "${BLUE}S3 URIs:${NC}"
echo -e "  Incoming: ${GREEN}$(terraform output -json | jq -r '.s3_bucket_info.value.incoming_folder')${NC}"
echo -e "  Processed: ${GREEN}$(terraform output -json | jq -r '.s3_bucket_info.value.processed_folder')${NC}"
echo -e "  Failed: ${GREEN}$(terraform output -json | jq -r '.s3_bucket_info.value.failed_folder')${NC}"

echo ""
echo -e "${GREEN}S3 deployment test completed successfully!${NC}"
echo ""
echo -e "${BLUE}To upload files to the bucket:${NC}"
echo -e "${YELLOW}aws s3 cp your-file.xlsx s3://$BUCKET_NAME/incoming/${NC}"
echo ""
echo -e "${BLUE}To list files in a folder:${NC}"
echo -e "${YELLOW}aws s3 ls s3://$BUCKET_NAME/incoming/${NC}"