resource "aws_vpc" "cloud-design-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "cloud-design-vpc"
  }
}

resource "aws_service_discovery_private_dns_namespace" "local" {
  name        = "local"
  description = "Service Connect namespace"
  vpc         = aws_vpc.cloud-design-vpc.id
  tags = {
    Name = "myapp-namespace"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  for_each = {
    public_1 = { cidr = 0, az = 0 }
    public_2 = { cidr = 2, az = 1 }
  }

  vpc_id                  = aws_vpc.cloud-design-vpc.id
  cidr_block              = cidrsubnet(aws_vpc.cloud-design-vpc.cidr_block, 8, each.value.cidr)
  availability_zone       = data.aws_availability_zones.available.names[each.value.az]
  map_public_ip_on_launch = true

  tags = { "Name" = each.key }
}

resource "aws_subnet" "private" {
  for_each = {
    private_1 = { cidr = 1, az = 0 }
    private_2 = { cidr = 3, az = 1 }
  }

  vpc_id            = aws_vpc.cloud-design-vpc.id
  cidr_block        = cidrsubnet(aws_vpc.cloud-design-vpc.cidr_block, 8, each.value.cidr)
  availability_zone = data.aws_availability_zones.available.names[each.value.az]

  tags = { "Name" = each.key }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.cloud-design-vpc.id
  tags   = { "Name" = "cloud-design-igw" }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.cloud-design-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = { "Name" = "cloud-design-public-rt" }
}

resource "aws_route_table_association" "rt_association" {
  for_each = aws_subnet.public

  route_table_id = aws_route_table.rt.id
  subnet_id      = each.value.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.cloud-design-vpc.id

  tags = { "Name" = "cloud-design-private-rt" }
}

resource "aws_route_table_association" "private_rt_association" {
  for_each = aws_subnet.private

  route_table_id = aws_route_table.private_rt.id
  subnet_id      = each.value.id
}


resource "aws_eip" "nat" {
  domain = "vpc"

  tags = { "Name" = "cloud-design-nat-eip" }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public["public_1"].id

  tags = { "Name" = "cloud-design-nat-gateway" }

  depends_on = [ aws_internet_gateway.gw ]
}

resource "aws_route" "private_nat" {
  route_table_id = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.this.id
}