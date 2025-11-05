
resource "aws_vpc" "my-vpc-eks" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name                                        = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

}

resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.my-vpc-eks.id
  count             = length(var.private_subnet_cidrs)
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]


  tags = {
    Name                                        = "${var.cluster_name}-private-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.my-vpc-eks.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true


  tags = {
    Name                                        = "${var.cluster_name}-public-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc-eks.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }

}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.my-vpc-eks.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id

  }
  tags = {
    Name = "${var.cluster_name}-public-rt"
  }

}

resource "aws_route_table_association" "public-rt-assoc" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_eip" "eip-nat" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"
}

resource "aws_nat_gateway" "my-nat" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.eip-nat[count.index].id
  subnet_id     = aws_subnet.public-subnet[count.index].id

  tags = {
    Name = "${var.cluster_name}-nat-${count.index + 1}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.my-igw]
}

resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.my-vpc-eks.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-nat[0].id
  }

  tags = {
    Name = "${var.cluster_name}-private-rt"
  }
}

resource "aws_route_table_association" "private-rt-assoc" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-route.id
}