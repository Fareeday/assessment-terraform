resource "aws_cloudfront_origin_access_control" "primary" {
  name                              = "primary-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_origin_access_control" "failover" {
  name                              = "failover-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled = true

  origin {
    domain_name              = var.primary_bucket_regional_domain_name
    origin_id                = "primary-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.primary.id
  }

  origin {
    domain_name              = var.failover_bucket_regional_domain_name
    origin_id                = "failover-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.failover.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "primary-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "failover-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_root_object = "index.html"
}

#output "cloudfront_domain_name" {
#  value = aws_cloudfront_distribution.this.domain_name
#}
