# modules/s3_replication/main.tf

# IAM Role for S3 Replication
resource "aws_iam_role" "s3_replication_role" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "s3.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy for Replication Permissions
resource "aws_iam_policy" "s3_replication_policy" {
  name        = "s3-replication-policy"
  description = "Policy for S3 replication"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:ReplicateObject", "s3:ReplicateDelete", "s3:ReplicateTags"]
      Resource = [
        "${var.destination_bucket_arn}/*"
      ]
    }]
  })
}

# Attach the IAM Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "s3_replication_attachment" {
  role       = aws_iam_role.s3_replication_role.name
  policy_arn = aws_iam_policy.s3_replication_policy.arn
}

# S3 Replication Configuration
resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [aws_s3_bucket_versioning.source_versioning]

  role   = aws_iam_role.s3_replication_role.arn  
  bucket = var.source_bucket_id

  rule {
    status = "Enabled"

    destination {
      bucket = var.destination_bucket_arn
    }
  }
}

