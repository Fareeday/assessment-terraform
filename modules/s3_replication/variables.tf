# modules/s3_replication/variables.tf

variable "source_bucket" {
  description = "The ARN of the primary S3 bucket"
  type        = string
}

variable "destination_bucket_arn" {
  description = "The ARN of the secondary S3 bucket"
  type        = string
}

variable  "iam_role_arn"  {
  type        = string
}

variable "source_bucket_depends_on" {
  type = any
}

variable "destination_bucket_depends_on" {
  type = any
}

