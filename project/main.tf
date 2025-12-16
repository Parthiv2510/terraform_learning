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

# -----------------------
# S3 Bucket
# -----------------------
resource "aws_s3_bucket" "project_bucket" {
  bucket = "myfirstterraformproject2510"
}

# -----------------------
# Upload index.html
# -----------------------
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.project_bucket.bucket
  key          = "index.html"
  source       = "./index.html"
  content_type = "text/html"
  etag = filemd5("index.html")
}

# -----------------------
# Upload style.css
# -----------------------
resource "aws_s3_object" "style_css" {
  bucket       = aws_s3_bucket.project_bucket.bucket
  key          = "style.css"
  source       = "./style.css"
  content_type = "text/css"
}

# -----------------------
# Disable Public Access Block
# (required for public website)
# -----------------------
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.project_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# -----------------------
# Bucket Policy (PUBLIC READ)
# -----------------------
resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.project_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.project_bucket.bucket}/*"
      }
    ]
  })
}

# -----------------------
# Output Website URL
# -----------------------
output "website_url" {
  value = "https://${aws_s3_bucket.project_bucket.bucket}.s3.amazonaws.com/index.html"
}
