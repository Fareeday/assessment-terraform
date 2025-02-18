variable "source_bucket_name" {
  type        = string
  description = "The name of the source S3 bucket"
}

variable "target_bucket_arn" {
  type        = string
  description = "The ARN of the target S3 bucket"
}

variable "iam_role_arn" {
  type        = string
  description = "The ARN of the IAM role for replication"
}
