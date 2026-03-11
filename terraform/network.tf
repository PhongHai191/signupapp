resource "aws_vpc" "webapp_vpc_staging" {

  cidr_block = var.vpc_cidr

  tags = {
    Name = "webapp-vpc"
  }

}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.webapp_vpc_staging.id

  tags = {
    Name = "webapp-igw"
  }

}

# -----------------------
# Subnets
# -----------------------

resource "aws_subnet" "public_subnet" {

  vpc_id                  = aws_vpc.webapp_vpc_staging.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "frontend-public-subnet"
  }

}

resource "aws_subnet" "private_subnet" {

  vpc_id     = aws_vpc.webapp_vpc_staging.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "backend-private-subnet"
  }

}

# -----------------------
# Public Route Table
# -----------------------

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.webapp_vpc_staging.id

  tags = {
    Name = "public-route-table"
  }

}

resource "aws_route" "public_internet_route" {

  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id

}

resource "aws_route_table_association" "public_assoc" {

  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id

}

# -----------------------
# NAT Gateway
# -----------------------

resource "aws_eip" "nat_eip" {

  domain = "vpc"

}

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "webapp-nat"
  }

}

# -----------------------
# Private Route Table
# -----------------------

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.webapp_vpc_staging.id

  tags = {
    Name = "private-route-table"
  }

}

resource "aws_route" "private_internet_route" {

  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id

}

resource "aws_route_table_association" "private_assoc" {

  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id

}