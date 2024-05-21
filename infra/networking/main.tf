variable vpc_cidr {}
variable vpc_name {}
variable cidr_public_subnet {}
variable availability_zone {}




######## Setup VPC - creating one vpc
resource "aws_vpc" "ta_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
    Project = "TerraformAnsible"
  }
}

## creating one public subnet
resource "aws_subnet" "ta_public_subnets" {
  vpc_id            = aws_vpc.ta_vpc.id
  cidr_block        = var.cidr_public_subnet
  availability_zone = var.availability_zone
  tags = {
    Name = "ta_public-subnet-1"
    Project = "TerraformAnsible"
  }
}

# Setup Internet Gateway
resource "aws_internet_gateway" "ta_public_internet_gateway" {
  vpc_id = aws_vpc.ta_vpc.id
  tags = {
    Name = "ta-igw"
    Project = "TerraformAnsible"
  }
}


##creating a public route table for public subnet
resource "aws_route_table" "ta_public_route_table" {
  vpc_id = aws_vpc.ta_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ta_public_internet_gateway.id
  }
  tags = {
    Name = "ta-public-rt"
    Project = "TerraformAnsible"
  }
}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "ta_public_rt_subnet_association" {
  subnet_id      = aws_subnet.ta_public_subnets.id
  route_table_id = aws_route_table.ta_public_route_table.id
}
