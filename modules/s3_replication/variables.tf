# modules/s3_replication/variables.tf

variable "primary_bucket_id" {
  description = "The ID of the primary S3 bucket"
  type        = string
}

variable "primary_bucket_arn" {
  description = "The ARN of the primary S3 bucket"
  type        = string
}

variable "secondary_bucket_arn" {
  description = "The ARN of the secondary S3 bucket"
  type        = string
}

