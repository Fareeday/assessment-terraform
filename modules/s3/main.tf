# This Is Modules/S3/Main.tf
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Principal = "*",
        Action   = "s3:GetObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.this.id}/*"
      },
      {
        Effect   = "Allow",
        Principal = {
          AWS = var.iam_role_arn
        },
        Action   = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete"
        ],
        Resource = "arn:aws:s3:::${aws_s3_bucket.this.id}/*"
      }
    ]
  })

  depends_on  = [aws_s3_bucket.this]
}


resource  "aws_s3_object"  "object"  {
  bucket  = aws_s3_bucket.this.id
  key     = "index.html"
  source  = "index.html"
  content_type  = "text/html"
}

