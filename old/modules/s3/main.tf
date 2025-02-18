resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled" # Enable versioning (optional)
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket  = var.bucket_name
  
  rule  {
    object_ownership  = "BucketOwnerPreferred"
  }

  depends_on  = [aws_s3_bucket.this]
}

resource  "aws_s3_bucket_public_access_block"  "this"  {
  bucket  = var.bucket_name

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource  "aws_s3_bucket_acl"  "this"  {
  bucket  = var.bucket_name  
  
  depends_on  = [
    aws_s3_bucket_ownership_controls.this,
    aws_s3_bucket_public_access_block.this,
  ]
  acl     = "public-read"
  #acl     = "private"
}

#output "bucket_arn" {
#  value = aws_s3_bucket.this.arn
  #}

resource "aws_s3_object" "this" {
  bucket       = var.bucket_name
  key          = "index.html" # The file name in the bucket
  source       = "/opt/assessment/modules/s3/index.html" # Path to the local file
  content_type = "text/html"  # MIME type of the file
  acl          = "public-read" # Make the file publicly accessible
  
  depends_on  = [aws_s3_bucket.this]
}

#Bucket Policy to Allow Public Read Access
resource "aws_s3_bucket_policy" "this" {
  bucket = var.bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })
}

