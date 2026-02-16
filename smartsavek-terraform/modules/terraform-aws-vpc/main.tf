data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Use only the first 'az_count' AZs.
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  public_keys  = sort(keys(var.public_subnets))
  private_keys = sort(keys(var.private_subnets))
  db_keys      = sort(keys(var.db_subnets))

  # Alternate across the selected AZs by sorted key order
  public_map = { for idx, k in local.public_keys  : k => { cidr = var.public_subnets[k],  az = local.azs[idx % length(local.azs)] } }
  private_map= { for idx, k in local.private_keys : k => { cidr = var.private_subnets[k], az = local.azs[idx % length(local.azs)] } }
  db_map     = { for idx, k in local.db_keys      : k => { cidr = var.db_subnets[k],      az = local.azs[idx % length(local.azs)] } }


}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name = "${var.vpc_name}-vpc"
  })
}

# interface VPC endpoints
resource "aws_vpc_endpoint" "interface" {
  for_each = toset(var.interface_endpoints)
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.${each.key}"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [for subnet in aws_subnet.private : subnet.id]
  security_group_ids= [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = true
  policy              = lookup(local.endpoint_policies, each.key, null)
  tags              = merge(var.tags, { Name = "${var.vpc_name}-${each.key}-endpoint" })
}

# Security group for interface endpoints
resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.vpc_name}-vpc-endpoints-sg"
  description = "Security group for Interface VPC Endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-vpc-endpoints-sg"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.vpc_name}-igw" })
}

# Subnets
resource "aws_subnet" "public" {
  for_each                 = local.public_map
  vpc_id                   = aws_vpc.main.id
  cidr_block               = each.value.cidr
  availability_zone        = each.value.az
  map_public_ip_on_launch  = true
  tags = merge(var.tags, { Name = each.key, "kubernetes.io/role/elb" = "1" })
}

resource "aws_subnet" "private" {
  for_each          = local.private_map
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = merge(var.tags, { Name = each.key, "kubernetes.io/role/internal-elb" = "1" })
}

resource "aws_subnet" "db" {
  for_each          = local.db_map
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = merge(var.tags, { Name = each.key })
}

# Public route table: single RT for all public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.vpc_name}-public-rt" })
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT gateway (single NAT design; can be extended to per-AZ if needed)
resource "aws_eip" "nat" {
  count      = var.enable_nat_gateway ? 1 : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = element(keys(aws_subnet.public), 0) != "" ? aws_subnet.public[element(keys(aws_subnet.public), 0)].id : null
  tags          = merge(var.tags, { Name = "${var.vpc_name}-nat" })
}

# Private route tables (one per private subnet)
resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id   = aws_vpc.main.id
  tags     = merge(var.tags, { Name = "${each.key}-rt" })
}

resource "aws_route" "private_nat" {
  for_each               = var.enable_nat_gateway ? aws_route_table.private : {}
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

# DB route tables (one per db subnet) -> default to NAT for egress if enabled
resource "aws_route_table" "db" {
  for_each = aws_subnet.db
  vpc_id   = aws_vpc.main.id
  tags     = merge(var.tags, { Name = "${each.key}-rt" })
}

resource "aws_route" "db_nat" {
  for_each               = var.enable_nat_gateway ? aws_route_table.db : {}
  route_table_id         = aws_route_table.db[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

resource "aws_route_table_association" "db" {
  for_each       = aws_subnet.db
  subnet_id      = aws_subnet.db[each.key].id
  route_table_id = aws_route_table.db[each.key].id
}

resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_s3_endpoint ? 1 : 0
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  # include private + db route tables
  route_table_ids   = [
    for rt in flatten([
      values(aws_route_table.private),
      values(aws_route_table.db)
    ]) : rt.id
  ]
  vpc_endpoint_type = "Gateway"
  tags              = merge(var.tags, { Name = "${var.vpc_name}-s3-endpoint" })
}

# vpc security group

