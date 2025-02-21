# modules/s3_replications/main.tf

resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "s3.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "replication_policy" {
  name = "s3-replication-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
        "s3:ListBucket",
        "s3:GetBucketVersioning"
      ]
      Resource = [
        var.primary_bucket_arn,
        "${var.primary_bucket_arn}/*",
        var.secondary_bucket_arn,
        "${var.secondary_bucket_arn}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "replication_policy_attachment" {
  role       = aws_iam_role.replication_role.name
  policy_arn = aws_iam_policy.replication_policy.arn
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [aws_iam_role_policy_attachment.replication_policy_attachment]

  bucket = var.primary_bucket_id
  role   = aws_iam_role.replication_role.arn

  rule {
    id     = "replication-rule"
    status = "Enabled"

    destination {
      bucket        = var.secondary_bucket_arn
      storage_class = "STANDARD"
    }
  }
}

