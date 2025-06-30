data "aws_availability_zones" "available" {}

# ─────────────────────────────────────────────
# VPC
# ─────────────────────────────────────────────
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.project}-${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project}-${var.environment}-igw"
  }
}

# ─────────────────────────────────────────────
# Public Subnets
# ─────────────────────────────────────────────
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project}-${var.environment}-public-${count.index + 1}"
  }
}

# ─────────────────────────────────────────────
# Private App Subnets
# ─────────────────────────────────────────────
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.project}-${var.environment}-private-${count.index + 1}"
  }
}

# ─────────────────────────────────────────────
# DB Subnets
# ─────────────────────────────────────────────
resource "aws_subnet" "db" {
  count             = length(var.db_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.project}-${var.environment}-db-${count.index + 1}"
  }
}

# ─────────────────────────────────────────────
# NAT Gateways
# ─────────────────────────────────────────────
resource "aws_eip" "nat" {
  count = var.create_ha_nat ? length(var.public_subnet_cidrs) : 1
  tags = {
    Name = "${var.project}-${var.environment}-nat-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = var.create_ha_nat ? length(var.public_subnet_cidrs) : 1
  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.nat[count.index].id
  tags = {
    Name = "${var.project}-${var.environment}-nat-${count.index + 1}"
  }
}

# ─────────────────────────────────────────────
# Public Route Table
# ─────────────────────────────────────────────
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project}-${var.environment}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ─────────────────────────────────────────────
# Private Route Table - Shared (non-HA)
# ─────────────────────────────────────────────
resource "aws_route_table" "private_shared" {
  count  = var.create_ha_nat ? 0 : 1
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project}-${var.environment}-private-rt-shared"
  }
}

resource "aws_route" "private_nat_shared" {
  count                  = var.create_ha_nat ? 0 : 1
  route_table_id         = aws_route_table.private_shared[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

resource "aws_route_table_association" "private_shared" {
  count          = var.create_ha_nat ? 0 : length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_shared[0].id
}

# ─────────────────────────────────────────────
# Private Route Tables - HA (one per subnet)
# ─────────────────────────────────────────────
resource "aws_route_table" "private_ha" {
  count  = var.create_ha_nat ? length(var.private_subnet_cidrs) : 0
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project}-${var.environment}-private-rt-${count.index + 1}"
  }
}

resource "aws_route" "private_nat_ha" {
  count                  = var.create_ha_nat ? length(var.private_subnet_cidrs) : 0
  route_table_id         = aws_route_table.private_ha[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "private_ha" {
  count          = var.create_ha_nat ? length(var.private_subnet_cidrs) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_ha[count.index].id
}

# ─────────────────────────────────────────────
# Outputs
# ─────────────────────────────────────────────
output "private_route_table_ids" {
  value = var.create_ha_nat ? aws_route_table.private_ha[*].id : [aws_route_table.private_shared[0].id]
}

output "private_route_table_id" {
  value = var.create_ha_nat ? null : aws_route_table.private_shared[0].id
}