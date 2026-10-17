resource "aws_vpc" "ecommerce_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "ecommerce-vpc" }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.ecommerce_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags                    = { Name = "ecommerce-public-1" }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.ecommerce_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "${var.aws_region}a"
  tags              = { Name = "ecommerce-private-1" }
}

# (Repeat subnets for availability zone 'b' to ensure High Availability)

