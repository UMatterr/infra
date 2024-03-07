resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${aws_vpc.my_vpc.tags["Name"]}-igw-1"
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_vpc.my_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_subnet" "my_subnets" {
  count = length(var.subnet_cidrs)

  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = var.az_list[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${aws_vpc.my_vpc.tags["Name"]}-subnet-${count.index}"
  }
}
