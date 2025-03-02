# modules/s3/main.tf

resource "aws_s3_bucket" "source" {
  bucket = var.source_bucket_name
  force_destroy = true

  tags = {
    Name = "source S3 Bucket"
  }
}

/*resource "aws_s3_bucket" "destination" {
  #provider = aws.destination_region
  bucket   = var.destination_bucket_name
  force_destroy = true

  tags = {
    Name = "destination S3 Bucket"
  }
}*/

# Enable versioning for replication
resource "aws_s3_bucket_versioning" "source" {
  bucket = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled"
  }
}

/*resource "aws_s3_bucket_versioning" "destination" {
  #provider = aws.destination_region
  bucket   = aws_s3_bucket.destination.id
  versioning_configuration {
    status = "Enabled"
  }
}*/

resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket  = var.source_bucket_name

  rule  {
    #object_ownership  = "BucketOwnerPreferred"
    object_ownership  = "BucketOwnerEnforced"
  }
  
    depends_on  = [aws_s3_bucket.source]

}

resource  "aws_s3_bucket_public_access_block"  "access_block"  {
  bucket  = var.source_bucket_name

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  depends_on    = [aws_s3_bucket.source]
}

/*resource  "aws_s3_bucket_acl"  "bucket_acl"  {
  bucket  = var.source_bucket_name

  depends_on  = [
    aws_s3_bucket_ownership_controls.ownership_controls,
    aws_s3_bucket_public_access_block.access_block,
  ]
  acl     = "public-read"
  #acl     = "private"
}*/

resource "aws_s3_object" "object" {
  bucket       = var.source_bucket_name
  key          = "index.html" # The file name in the bucket
  source       = "/opt/assessment-terraform/modules/s3/index.html" # Path to the local file
  content_type = "text/html"  # MIME type of the file
  #acl          = "public-read" # Make the file publicly accessible

  depends_on  = [aws_s3_bucket.source]
}

#Bucket Policy to Allow Public Read Access
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.source_bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.source.arn}/*"
      }
    ]
  })
}
