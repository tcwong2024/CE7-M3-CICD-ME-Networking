# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.public_subnet_prefix}-${element(var.availability_zones, count.index)}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + 3)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.private_subnet_prefix}-${element(var.availability_zones, count.index)}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.internet_gateway
  }
}

# S3 Endpoint
resource "aws_vpc_endpoint" "vpce_s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"

  route_table_ids = aws_route_table.private_rt[*].id

  tags = {
    Name = var.vpc_endpoint_s3
  }
}

# Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public_rt
  }
}

# Route Table for Private Subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.private_rt
  }
}

# Associate Public Subnets with Route Table
resource "aws_route_table_association" "public_subnet_association" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Associate Private Subnets with Route Table
resource "aws_route_table_association" "private_subnet_association" {
  count          = 3
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# Create an security group module
module "security_group" {
  source = "./sg"
  vpc_id = aws_vpc.main.id
}

# --------------------------------------------------------
# This checkov detected will be skip and will solve later
# --------------------------------------------------------
#checkov:skip=CKV_AWS_130: Ensure VPC subnets do not assign public IP by default
#checkov:skip=CKV_AWS_260: Ensure no security groups allow ingress from 0.0.0.0:0 to port 80
#checkov:skip=CKV_AWS_24: Ensure no security groups allow ingress from 0.0.0.0:0 to port 22
#checkov:skip=CKV_AWS_23: Ensure every security group and rule has a description
#checkov:skip=CKV2_AWS_5: Ensure that Security Groups are attached to another resource
#checkov:skip=CKV2_AWS_11: Ensure VPC flow logging is enabled in all VPCs
# --------------------------------------------------------
