variable "hosted_zone_id" {
  type        = string
  description = "The ID of the Route 53 hosted zone"
}

variable "domain_name" {
  type        = string
  description = "The domain name to configure failover routing for"
}

variable "primary_alb_dns" {
  type        = string
  description = "DNS name of the primary ALB"
}

variable "primary_alb_zone_id" {
  type        = string
  description = "Zone ID of the primary ALB"
}

variable "secondary_alb_dns" {
  type        = string
  description = "DNS name of the secondary ALB"
}

variable "secondary_alb_zone_id" {
  type        = string
  description = "Zone ID of the secondary ALB"
}

