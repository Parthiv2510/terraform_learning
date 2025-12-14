terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}

# AWS Provider
provider "aws" {
  region = "us-east-1"
}

# -----------------------
# VPC
# -----------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tf-vpc"
  }
}

# -----------------------
# Public Subnet
# -----------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-public-subnet"
  }
}

# -----------------------
# Internet Gateway
# -----------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-igw"
  }
}

# -----------------------
# Route Table
# -----------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "tf-public-rt"
  }
}

# -----------------------
# Route Table Association
# -----------------------
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# -----------------------
# EC2 Instance
# -----------------------
resource "aws_instance" "myserver" {
  ami           = "ami-0ecb62995f68bb549" # Amazon Linux 2 (us-east-1)
  instance_type = "t3.nano"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "terraform-ec2"
  }
}
