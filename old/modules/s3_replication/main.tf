resource "aws_s3_bucket_replication_configuration" "this" {
  bucket = var.source_bucket_name

  role = var.iam_role_arn

  rule {
    id     = "replication-rule"
    status = "Enabled"

    destination {
      bucket        = var.target_bucket_arn
      storage_class = "STANDARD"
    }
  }
}
