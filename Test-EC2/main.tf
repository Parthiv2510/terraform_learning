terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "test" {
    ami = "ami-0fa91bc90632c73c9"
    instance_type = "t3.micro"
    tags = {
        name = "my-server"
    }
}

