#!/bin/bash
# scripts/test-rds.sh - Test RDS deployment

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get environment from argument
ENVIRONMENT=${1:-dev}

echo -e "${BLUE}Testing RDS deployment for $ENVIRONMENT environment...${NC}"

# Get RDS instance identifier from Terraform output
INSTANCE_ID=$(terraform output -json | jq -r '.infrastructure_summary.value.rds.endpoint' | cut -d'.' -f1 2>/dev/null || echo "")

if [ -z "$INSTANCE_ID" ] || [ "$INSTANCE_ID" == "null" ]; then
    echo -e "${RED}Error: Could not get RDS instance ID. Is the infrastructure deployed?${NC}"
    exit 1
fi

echo -e "${GREEN}✓ RDS Instance ID: $INSTANCE_ID${NC}"

# Check RDS instance status
echo -e "${BLUE}Checking RDS instance status...${NC}"
STATUS=$(aws rds describe-db-instances --db-instance-identifier $INSTANCE_ID --query 'DBInstances[0].DBInstanceStatus' --output text 2>/dev/null || echo "not-found")

if [ "$STATUS" == "available" ]; then
    echo -e "${GREEN}✓ RDS instance is available${NC}"
elif [ "$STATUS" == "not-found" ]; then
    echo -e "${RED}✗ RDS instance not found${NC}"
    exit 1
else
    echo -e "${YELLOW}! RDS instance status: $STATUS (not yet available)${NC}"
fi

# Get instance details
echo -e "${BLUE}RDS Instance Details:${NC}"
aws rds describe-db-instances --db-instance-identifier $INSTANCE_ID --query 'DBInstances[0].[
    DBInstanceClass,
    Engine,
    EngineVersion,
    AllocatedStorage,
    MultiAZ,
    BackupRetentionPeriod,
    StorageEncrypted
]' --output table

# Check endpoint connectivity
ENDPOINT=$(terraform output -json | jq -r '.database_connection.value.endpoint' | cut -d':' -f1)
PORT=$(terraform output -json | jq -r '.database_connection.value.port')
DB_NAME=$(terraform output -json | jq -r '.database_connection.value.database_name')

echo ""
echo -e "${BLUE}Connection Information:${NC}"
echo -e "Endpoint: ${GREEN}$ENDPOINT${NC}"
echo -e "Port: ${GREEN}$PORT${NC}"
echo -e "Database: ${GREEN}$DB_NAME${NC}"

# Check security group
echo ""
echo -e "${BLUE}Security Group Rules:${NC}"
SG_ID=$(aws rds describe-db-instances --db-instance-identifier $INSTANCE_ID --query 'DBInstances[0].VpcSecurityGroups[0].VpcSecurityGroupId' --output text)
echo -e "Security Group: ${GREEN}$SG_ID${NC}"

# Show ingress rules
aws ec2 describe-security-groups --group-ids $SG_ID --query 'SecurityGroups[0].IpPermissions[*].[
    FromPort,
    ToPort,
    IpProtocol,
    IpRanges[0].CidrIp,
    UserIdGroupPairs[0].GroupId
]' --output table

# Check subnet group
echo ""
echo -e "${BLUE}DB Subnet Group:${NC}"
SUBNET_GROUP=$(aws rds describe-db-instances --db-instance-identifier $INSTANCE_ID --query 'DBInstances[0].DBSubnetGroup.DBSubnetGroupName' --output text)
echo -e "Subnet Group: ${GREEN}$SUBNET_GROUP${NC}"

# List subnets
aws rds describe-db-subnet-groups --db-subnet-group-name $SUBNET_GROUP --query 'DBSubnetGroups[0].Subnets[*].[
    SubnetIdentifier,
    SubnetAvailabilityZone.Name,
    SubnetStatus
]' --output table

# Check automated backups
echo ""
echo -e "${BLUE}Backup Configuration:${NC}"
aws rds describe-db-instances --db-instance-identifier $INSTANCE_ID --query 'DBInstances[0].[
    BackupRetentionPeriod,
    PreferredBackupWindow,
    PreferredMaintenanceWindow,
    LatestRestorableTime
]' --output table

# Check if enhanced monitoring is enabled
MONITORING_INTERVAL=$(aws rds describe-db-instances --db-instance-identifier $INSTANCE_ID --query 'DBInstances[0].MonitoringInterval' --output text)
if [ "$MONITORING_INTERVAL" -gt 0 ]; then
    echo -e "${GREEN}✓ Enhanced Monitoring: Enabled (${MONITORING_INTERVAL}s interval)${NC}"
else
    echo -e "${YELLOW}! Enhanced Monitoring: Disabled${NC}"
fi

# Check if Performance Insights is enabled
PI_ENABLED=$(aws rds describe-db-instances --db-instance-identifier $INSTANCE_ID --query 'DBInstances[0].PerformanceInsightsEnabled' --output text)
if [ "$PI_ENABLED" == "true" ]; then
    echo -e "${GREEN}✓ Performance Insights: Enabled${NC}"
else
    echo -e "${YELLOW}! Performance Insights: Disabled${NC}"
fi

# Test password (if auto-generated)
AUTO_PASSWORD=$(terraform output -json database_password 2>/dev/null | jq -r '.value' || echo "")
if [ ! -z "$AUTO_PASSWORD" ] && [ "$AUTO_PASSWORD" != "null" ]; then
    echo ""
    echo -e "${YELLOW}Note: Auto-generated password is available in Terraform output${NC}"
    echo -e "${YELLOW}Run: terraform output -json database_password | jq -r '.value'${NC}"
fi

echo ""
echo -e "${GREEN}RDS deployment test completed successfully!${NC}"
echo ""
echo -e "${BLUE}To connect to the database from within the VPC:${NC}"
echo -e "${YELLOW}psql -h $ENDPOINT -p $PORT -U $(terraform output -json | jq -r '.database_connection.value.username') -d $DB_NAME${NC}"