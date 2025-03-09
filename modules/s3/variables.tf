# modules/s3/variables.tf

variable "bucket_name" {
  description = "Name of the source S3 bucket"
  type        = string
}

variable "iam_role_arn" {
  description = "Name of the destination S3 bucket"
  type        = string
}

