# modules/s3_replication/main.tf

resource "aws_s3_bucket_replication_configuration" "this" {
  bucket = var.source_bucket
  role   = var.iam_role_arn

  depends_on = [
    var.source_bucket_depends_on,
    var.destination_bucket_depends_on
  ]


  rule {
    id     = "ReplicationRule"
    status = "Enabled"

    destination {
      bucket        = var.destination_bucket_arn
      storage_class = "STANDARD"
    }
  }
}

