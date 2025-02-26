# modules/s3_replication/variables.tf

variable "source_bucket_id" {
  description = "The ID of the primary S3 bucket"
  type        = string
}

variable "source_bucket_arn" {
  description = "The ARN of the primary S3 bucket"
  type        = string
}

variable "destination_bucket_arn" {
  description = "The ARN of the secondary S3 bucket"
  type        = string
}

