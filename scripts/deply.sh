#!/bin/bash
# scripts/deploy.sh - Deploy infrastructure to different environments
# Supports VPC, RDS, and future modules

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Default values
ENVIRONMENT=""
ACTION="plan"
AUTO_APPROVE=""
DESTROY=false
MODULE=""
SKIP_INIT=false

# Function to display usage
usage() {
    echo -e "${BLUE}Usage: $0 -e <environment> [-a <action>] [-m <module>] [-y] [-d] [-s]${NC}"
    echo ""
    echo "Required:"
    echo "  -e: Environment (dev, stg, prod)"
    echo ""
    echo "Optional:"
    echo "  -a: Action (plan, apply, output, refresh) - default: plan"
    echo "  -m: Specific module (vpc, rds, all) - default: all"
    echo "  -y: Auto approve (skip confirmation)"
    echo "  -d: Destroy infrastructure"
    echo "  -s: Skip terraform init"
    echo ""
    echo "Examples:"
    echo "  $0 -e dev                    # Plan for dev environment"
    echo "  $0 -e dev -a apply          # Apply changes to dev"
    echo "  $0 -e prod -a apply -y      # Apply to prod without confirmation"
    echo "  $0 -e dev -m vpc            # Plan only VPC module"
    echo "  $0 -e dev -d                # Destroy dev infrastructure"
    echo ""
    echo "Environment Variables Required:"
    echo "  TF_VAR_db_password - RDS master password"
    echo "  TF_VAR_docupilot_api_key - Docupilot API key (for Lambda module)"
    exit 1
}

# Function to print banner
print_banner() {
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════════════════════╗"
    echo "║        REDCap to Docupilot Infrastructure             ║"
    echo "║                 Deployment Tool                       ║"
    echo "╚═══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to check prerequisites
check_prerequisites() {
    echo -e "${BLUE}Checking prerequisites...${NC}"
    
    # Check Terraform
    if ! command -v terraform &> /dev/null; then
        echo -e "${RED}Error: Terraform not found. Please install Terraform.${NC}"
        exit 1
    fi
    
    # Check AWS CLI
    if ! command -v aws &> /dev/null; then
        echo -e "${RED}Error: AWS CLI not found. Please install AWS CLI.${NC}"
        exit 1
    fi
    
    # Check AWS credentials
    if ! aws sts get-caller-identity &> /dev/null; then
        echo -e "${RED}Error: AWS credentials not configured. Run 'aws configure'.${NC}"
        exit 1
    fi
    
    # Check jq (optional but recommended)
    if ! command -v jq &> /dev/null; then
        echo -e "${YELLOW}Warning: jq not found. Some output formatting may be limited.${NC}"
    fi
    
    echo -e "${GREEN}✓ Prerequisites check passed${NC}"
}

# Function to check required environment variables
check_environment_variables() {
    local missing_vars=()
    
    # Check based on modules being deployed
    if [[ "$MODULE" == "all" ]] || [[ "$MODULE" == "rds" ]]; then
        if [ -z "$TF_VAR_db_password" ]; then
            missing_vars+=("TF_VAR_db_password")
        fi
    fi
    
    # Future: Add more checks for other modules
    # if [[ "$MODULE" == "all" ]] || [[ "$MODULE" == "lambda" ]]; then
    #     if [ -z "$TF_VAR_docupilot_api_key" ]; then
    #         missing_vars+=("TF_VAR_docupilot_api_key")
    #     fi
    # fi
    
    if [ ${#missing_vars[@]} -ne 0 ]; then
        echo -e "${YELLOW}Warning: Missing environment variables:${NC}"
        for var in "${missing_vars[@]}"; do
            echo -e "${YELLOW}  - $var${NC}"
        done
        echo ""
        echo -e "${YELLOW}You can set them with:${NC}"
        for var in "${missing_vars[@]}"; do
            if [[ "$var" == "TF_VAR_db_password" ]]; then
                echo -e "${YELLOW}  export TF_VAR_db_password='your-secure-password'${NC}"
                echo -e "${YELLOW}  # Or generate: export TF_VAR_db_password=\$(openssl rand -base64 32)${NC}"
            else
                echo -e "${YELLOW}  export $var='your-value'${NC}"
            fi
        done
        echo ""
        read -p "Continue anyway? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Parse command line arguments
while getopts "e:a:m:ydsh" opt; do
    case ${opt} in
        e )
            ENVIRONMENT=$OPTARG
            ;;
        a )
            ACTION=$OPTARG
            ;;
        m )
            MODULE=$OPTARG
            ;;
        y )
            AUTO_APPROVE="-auto-approve"
            ;;
        d )
            DESTROY=true
            ACTION="destroy"
            ;;
        s )
            SKIP_INIT=true
            ;;
        h )
            usage
            ;;
        \? )
            usage
            ;;
    esac
done

# Print banner
print_banner

# Validate environment
if [ -z "$ENVIRONMENT" ]; then
    echo -e "${RED}Error: Environment is required${NC}"
    usage
fi

if [[ ! "$ENVIRONMENT" =~ ^(dev|stg|prod)$ ]]; then
    echo -e "${RED}Error: Invalid environment. Must be dev, stg, or prod${NC}"
    usage
fi

# Validate action
if [[ ! "$ACTION" =~ ^(plan|apply|output|refresh|destroy)$ ]]; then
    echo -e "${RED}Error: Invalid action. Must be plan, apply, output, refresh, or destroy${NC}"
    usage
fi

# Set module to all if not specified
if [ -z "$MODULE" ]; then
    MODULE="all"
fi

# Validate module
if [[ ! "$MODULE" =~ ^(vpc|rds|lambda|s3|all)$ ]]; then
    echo -e "${RED}Error: Invalid module. Must be vpc, rds, lambda, s3, or all${NC}"
    usage
fi

# Set paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_DIR="$PROJECT_ROOT/environments/$ENVIRONMENT"

# Check if environment directory exists
if [ ! -d "$ENV_DIR" ]; then
    echo -e "${RED}Error: Environment directory not found: $ENV_DIR${NC}"
    exit 1
fi

# Check if terraform.tfvars exists for the environment
if [ ! -f "$ENV_DIR/terraform.tfvars" ]; then
    echo -e "${RED}Error: terraform.tfvars not found for $ENVIRONMENT environment${NC}"
    echo "Expected location: $ENV_DIR/terraform.tfvars"
    exit 1
fi

# Change to project root
cd "$PROJECT_ROOT"

# Check prerequisites
check_prerequisites

# Check environment variables
check_environment_variables

# Display deployment information
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Environment: ${ENVIRONMENT}${NC}"
echo -e "${GREEN}Action: ${ACTION}${NC}"
echo -e "${GREEN}Module: ${MODULE}${NC}"
echo -e "${GREEN}Region: $(grep aws_region $ENV_DIR/terraform.tfvars | cut -d'"' -f2 || echo 'ap-southeast-2')${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

# Initialize Terraform (unless skipped)
if [ "$SKIP_INIT" = false ]; then
    echo -e "${BLUE}Initializing Terraform...${NC}"
    terraform init -upgrade
    echo -e "${GREEN}✓ Terraform initialized${NC}"
    echo ""
fi

# Set target options based on module selection
TARGET_OPTIONS=""
if [ "$MODULE" != "all" ]; then
    case $MODULE in
        vpc)
            TARGET_OPTIONS="-target=module.vpc"
            ;;
        rds)
            TARGET_OPTIONS="-target=module.rds"
            ;;
        lambda)
            TARGET_OPTIONS="-target=module.lambda"
            ;;
        s3)
            TARGET_OPTIONS="-target=module.s3"
            ;;
    esac
    echo -e "${YELLOW}Targeting module: $MODULE${NC}"
fi

# Execute action
case $ACTION in
    plan)
        echo -e "${BLUE}Running Terraform plan for $ENVIRONMENT...${NC}"
        terraform plan \
            -var-file="$ENV_DIR/terraform.tfvars" \
            -out="$ENV_DIR/tfplan" \
            $TARGET_OPTIONS
        echo ""
        echo -e "${GREEN}✓ Plan complete. Review the changes above.${NC}"
        echo -e "${YELLOW}To apply these changes, run: $0 -e $ENVIRONMENT -a apply${NC}"
        ;;
        
    apply)
        # Check if we have a plan file
        if [ -f "$ENV_DIR/tfplan" ] && [ "$MODULE" == "all" ]; then
            echo -e "${BLUE}Applying planned changes for $ENVIRONMENT...${NC}"
            terraform apply $AUTO_APPROVE "$ENV_DIR/tfplan"
            rm -f "$ENV_DIR/tfplan"
        else
            echo -e "${BLUE}Running Terraform apply for $ENVIRONMENT...${NC}"
            terraform apply \
                -var-file="$ENV_DIR/terraform.tfvars" \
                $AUTO_APPROVE \
                $TARGET_OPTIONS
        fi
        echo ""
        echo -e "${GREEN}✓ Apply complete!${NC}"
        
        # Show outputs
        echo ""
        echo -e "${BLUE}Infrastructure Summary:${NC}"
        terraform output -json > "$ENV_DIR/outputs.json"
        if command -v jq &> /dev/null; then
            terraform output -json | jq -r '.infrastructure_summary.value' 2>/dev/null || terraform output
        else
            terraform output
        fi
        ;;
        
    output)
        echo -e "${BLUE}Terraform outputs for $ENVIRONMENT:${NC}"
        if [ ! -z "$2" ]; then
            terraform output $2
        else
            terraform output
        fi
        ;;
        
    refresh)
        echo -e "${BLUE}Refreshing Terraform state for $ENVIRONMENT...${NC}"
        terraform refresh -var-file="$ENV_DIR/terraform.tfvars"
        echo -e "${GREEN}✓ State refreshed${NC}"
        ;;
        
    destroy)
        echo -e "${RED}WARNING: About to destroy $ENVIRONMENT infrastructure!${NC}"
        if [ "$ENVIRONMENT" == "prod" ] && [ -z "$AUTO_APPROVE" ]; then
            echo -e "${RED}This is PRODUCTION! Are you absolutely sure?${NC}"
            read -p "Type 'destroy-production' to confirm: " confirm
            if [ "$confirm" != "destroy-production" ]; then
                echo -e "${YELLOW}Destroy cancelled.${NC}"
                exit 1
            fi
        elif [ -z "$AUTO_APPROVE" ]; then
            read -p "Are you sure? Type 'yes' to confirm: " confirm
            if [ "$confirm" != "yes" ]; then
                echo -e "${YELLOW}Destroy cancelled.${NC}"
                exit 1
            fi
        fi
        
        terraform destroy \
            -var-file="$ENV_DIR/terraform.tfvars" \
            $AUTO_APPROVE \
            $TARGET_OPTIONS
        echo -e "${GREEN}✓ Infrastructure destroyed${NC}"
        ;;
esac

# Post-deployment tasks
if [ "$ACTION" == "apply" ] && [ "$DESTROY" = false ]; then
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Deployment Complete!${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    
    # Show module-specific information
    if [[ "$MODULE" == "all" ]] || [[ "$MODULE" == "rds" ]]; then
        if terraform output -raw database_connection &>/dev/null; then
            echo ""
            echo -e "${YELLOW}Database Endpoint:${NC}"
            terraform output -json database_connection | jq -r '.endpoint' 2>/dev/null || echo "Run: terraform output database_connection"
            
            # Check if password was auto-generated
            if terraform output database_password &>/dev/null; then
                echo ""
                echo -e "${YELLOW}Auto-generated database password saved in output.${NC}"
                echo -e "${YELLOW}Retrieve with: terraform output -raw database_password${NC}"
            fi
        fi
    fi
    
    echo ""
    echo -e "${BLUE}Next Steps:${NC}"
    echo -e "  1. Test deployment: