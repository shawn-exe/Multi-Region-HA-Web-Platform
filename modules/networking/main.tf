#########################################
# VPC
#########################################

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

#########################################
# Internet Gateway
#########################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

#########################################
# Public Subnets
#########################################

resource "aws_subnet" "public" {
  count = 3

  vpc_id                  = aws_vpc.this.id
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  cidr_block = cidrsubnet(
    var.vpc_cidr,
    4,
    count.index
  )

  tags = {
    Name = "${var.environment}-public-${count.index + 1}"
  }
}

#########################################
# Private Subnets
#########################################

resource "aws_subnet" "private" {
  count = 3

  vpc_id            = aws_vpc.this.id
  availability_zone = var.azs[count.index]

  cidr_block = cidrsubnet(
    var.vpc_cidr,
    4,
    count.index + 3
  )

  tags = {
    Name = "${var.environment}-private-${count.index + 1}"
  }
}

#########################################
# Public Route Table
#########################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = 3

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#########################################
# Elastic IPs
#########################################

resource "aws_eip" "nat" {
  count = 3

  domain = "vpc"

  tags = {
    Name = "${var.environment}-nat-eip-${count.index + 1}"
  }
}

#########################################
# NAT Gateways
#########################################

resource "aws_nat_gateway" "this" {
  count = 3

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = {
    Name = "${var.environment}-nat-${count.index + 1}"
  }
}

#########################################
# Private Route Tables
#########################################

resource "aws_route_table" "private" {
  count = 3

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.environment}-private-rt-${count.index + 1}"
  }
}

resource "aws_route" "private_nat" {
  count = 3

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "private" {
  count = 3

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

#########################################
# Security Group - ALB
#########################################

resource "aws_security_group" "alb" {
  name        = "${var.environment}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"

    from_port = 443
    to_port   = 443

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-alb-sg"
  }
}

#########################################
# Security Group - App
#########################################

resource "aws_security_group" "app" {
  name        = "${var.environment}-app-sg"
  description = "Application Security Group"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Application Traffic"

    from_port = 8080
    to_port   = 8080

    protocol = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]
  }

  egress {
    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-app-sg"
  }
}

#########################################
# Security Group - RDS
#########################################

resource "aws_security_group" "rds" {
  name        = "${var.environment}-rds-sg"
  description = "Database Security Group"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "MySQL"

    from_port = 3306
    to_port   = 3306

    protocol = "tcp"

    security_groups = [
      aws_security_group.app.id
    ]
  }

  egress {
    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-rds-sg"
  }
}