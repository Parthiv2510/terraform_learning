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
resource "aws_s3_bucket" "testing-bucket" {
  bucket = "hellomynameisparthiv"
}

resource "aws_s3_object" "data-object" {
    source = "./myfile.txt"
    bucket = aws_s3_bucket.testing-bucket.bucket
    key = "mydata.txt"
}

resource "random_id" "rand_id" {
    byte_length = 8
  
}