resource "aws_iam_policy" "this" {
  name = "s3-replication-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectRetention",
          "s3:GetObjectLegalHold"
        ]
        Resource = [
          var.source_bucket_arn,
          "${var.source_bucket_arn}/*",
          var.target_bucket_arn,
          "${var.target_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:GetObjectVersionTagging"
        ]
        Resource = "${var.target_bucket_arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutBucketReplication",
          "s3:GetBucketReplication"
        ]
        Resource = var.source_bucket_arn
      }
    ]
  })
}




/*resource "aws_iam_role" "this" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "this" {
  name = "s3-replication-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectRetention",
          "s3:GetObjectLegalHold"
        ]
        Resource = [
          var.source_bucket_arn,
          "${var.source_bucket_arn}/*",
          var.target_bucket_arn,
          "${var.target_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:GetObjectVersionTagging"
        ]
        Resource = "${var.target_bucket_arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutBucketReplication",
          "s3:GetBucketReplication"
        ]
        Resource = var.source_bucket_arn
      }
    ]
  })
}*/

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

output "role_arn" {
  value = aws_iam_role.this.arn
}
