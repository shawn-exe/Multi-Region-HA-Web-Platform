resource "aws_cloudfront_distribution" "main" {

  enabled         = true
  is_ipv6_enabled = true
  comment         = "${var.environment}-distribution"

  depends_on = [
    aws_acm_certificate_validation.main
  ]

  # PRIMARY ORIGIN (us-east-1 ALB)
  origin {
    domain_name = var.primary_alb_dns_name
    origin_id   = "primary-alb"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"

      origin_ssl_protocols = [
        "TLSv1.2"
      ]
    }
  }

  # SECONDARY ORIGIN (us-west-2 ALB)
  origin {
    domain_name = var.secondary_alb_dns_name
    origin_id   = "secondary-alb"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"

      origin_ssl_protocols = [
        "TLSv1.2"
      ]
    }
  }

  # FAILOVER GROUP
  origin_group {
    origin_id = "alb-origin-group"

    failover_criteria {
      status_codes = [
        500,
        502,
        503,
        504
      ]
    }

    member {
      origin_id = "primary-alb"
    }

    member {
      origin_id = "secondary-alb"
    }
  }

  default_cache_behavior {

    target_origin_id = "alb-origin-group"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
      "PUT",
      "POST",
      "PATCH",
      "DELETE"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    compress = true

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  } 

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.main.certificate_arn #using the certificate from ACM check acm.tf
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }


  web_acl_id = aws_wafv2_web_acl.cloudfront.arn

  tags = {
    Name        = "${var.environment}-cloudfront"
    Environment = var.environment
  }
}