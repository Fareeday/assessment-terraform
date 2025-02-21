# modules/s3/outputs.tf

output "primary_bucket_arn" {
  value = aws_s3_bucket.primary.arn
}

output "primary_bucket_id" {
  value = aws_s3_bucket.primary.id
}

output "secondary_bucket_arn" {
  value = aws_s3_bucket.secondary.arn
}

output "secondary_bucket_id" {
  value = aws_s3_bucket.secondary.id
}

