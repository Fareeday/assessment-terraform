output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.this.bucket_regional_domain_name
}

output "object_url" {
  value = "https://${aws_s3_bucket.this.bucket_regional_domain_name}/${aws_s3_object.this.key}"
}
