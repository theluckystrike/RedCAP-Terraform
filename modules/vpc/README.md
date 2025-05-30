# VPC Module for Clinical Docs Infrastructure

This Terraform module provisions a highly configurable VPC with support for public, private, and database subnets across multiple Availability Zones in AWS Sydney region (`ap-southeast-2`). It is used as the foundational network layer for deploying REDCap, RDS, Lambdas, and related infrastructure.

---

## Features

* Customizable VPC CIDR block
* Multi-AZ public, private (app), and DB subnets
* Internet Gateway for public subnets
* NAT Gateway(s) with optional HA support
* Separate route tables per subnet group
* Outputs for VPC and subnet IDs for downstream modules

---

## Usage

### Example

```hcl
module "vpc" {
  source              = "../modules/vpc"
  environment         = var.environment
  project             = var.project
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs
  create_ha_nat       = var.create_ha_nat
}
```

---

## Input Variables

| Name                   | Type           | Description                                                    |
| ---------------------- | -------------- | -------------------------------------------------------------- |
| `environment`          | `string`       | Environment name (e.g. `dev`, `prod`)                          |
| `project`              | `string`       | Resource name prefix                                           |
| `vpc_cidr`             | `string`       | CIDR block for the VPC                                         |
| `public_subnet_cidrs`  | `list(string)` | List of CIDRs for public subnets                               |
| `private_subnet_cidrs` | `list(string)` | List of CIDRs for app-tier private subnets                     |
| `db_subnet_cidrs`      | `list(string)` | List of CIDRs for database-tier subnets                        |
| `create_ha_nat`        | `bool`         | Whether to deploy one NAT Gateway per AZ (defaults to `false`) |

---

## Outputs

| Name                 | Description                    |
| -------------------- | ------------------------------ |
| `vpc_id`             | ID of the created VPC          |
| `public_subnet_ids`  | List of public subnet IDs      |
| `private_subnet_ids` | List of private app subnet IDs |
| `db_subnet_ids`      | List of private DB subnet IDs  |
| `availability_zones` | List of AZs used               |

---

## Environment Usage

Use `terraform.tfvars` in each environment (e.g., `dev/`, `prod/`) to pass specific CIDRs and NAT preferences.

---

## Notes

* Only one NAT Gateway is created in `dev` for cost efficiency.
* Multiple NATs are created in `prod` for high availability.
* Tags are applied consistently for easier filtering and tracking.

---

## Region

All resources are deployed to:

* `ap-southeast-2` (AWS Sydney)

---