# modules/vpc/main.tf
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway for Public Subnets
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index].cidr
  availability_zone = var.public_subnets[count.index].az

  tags = {
    Name = var.public_subnets[count.index].name
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index].cidr
  availability_zone = var.private_subnets[count.index].az

  tags = {
    Name = var.private_subnets[count.index].name
  }
}

# NAT Gateway for Private Subnets (Optional)
resource "aws_eip" "nat" {
  count = length(var.private_subnets) > 0 ? 1 : 0
}

resource "aws_nat_gateway" "this" {
  count         = length(var.private_subnets) > 0 ? 1 : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.vpc_name}-nat-gw"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = length(aws_nat_gateway.this) > 0 ? aws_nat_gateway.this[0].id : null
  }

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
