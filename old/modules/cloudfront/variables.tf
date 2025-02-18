variable "primary_bucket_regional_domain_name" {
  type        = string
  description = "The regional domain name of the primary S3 bucket"
}

variable "failover_bucket_regional_domain_name" {
  type        = string
  description = "The regional domain name of the failover S3 bucket"
}
