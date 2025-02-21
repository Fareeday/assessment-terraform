# modules/s3/main.tf

resource "aws_s3_bucket" "primary" {
  bucket = var.primary_bucket_name
  force_destroy = true

  tags = {
    Name = "Primary S3 Bucket"
  }
}

resource "aws_s3_bucket" "secondary" {
  provider = aws.secondary_region
  bucket   = var.secondary_bucket_name
  force_destroy = true

  tags = {
    Name = "Secondary S3 Bucket"
  }
}

# Enable versioning for replication
resource "aws_s3_bucket_versioning" "primary" {
  bucket = aws_s3_bucket.primary.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "secondary" {
  provider = aws.secondary_region
  bucket   = aws_s3_bucket.secondary.id
  versioning_configuration {
    status = "Enabled"
  }
}

