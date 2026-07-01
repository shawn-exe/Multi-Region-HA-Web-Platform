# Module: CDN

## Purpose

The CDN module provisions a CloudFront distribution in front of the application load balancers, with WAF, ACM certificate handling, and Route 53 integration to support secure edge delivery and failover.

## Resources Created

- aws_cloudfront_distribution.main
- aws_acm_certificate.main
- aws_route53_record.cert_validation
- aws_acm_certificate_validation.main
- aws_wafv2_web_acl.cloudfront

## Inputs

- environment: Environment name used in naming and tags
- primary_alb_dns_name: DNS name of the primary ALB
- secondary_alb_dns_name: DNS name of the secondary ALB
- domain_name: Domain name for the certificate and Route 53 alias
- hosted_zone_id: Hosted zone ID used for ACM validation and DNS record creation

## Outputs

- distribution_id: ID of the CloudFront distribution
- distribution_domain_name: CloudFront distribution domain name
- distribution_hosted_zone_id: Hosted zone ID used for the distribution

## Behavior

- CloudFront uses an origin group with failover between the primary and secondary ALBs.
- The default cache behavior redirects HTTP to HTTPS.
- WAF is attached to the distribution and uses AWS managed rule sets for common protections.
- ACM certificate validation uses DNS records in Route 53.

## Notes

- The module depends on a valid Route 53 hosted zone and a domain that can be validated through DNS.
- The example configuration uses placeholder values in the production tfvars file.

## Example Usage

```hcl
module "cdn" {
  source = "../../modules/cdn"

  environment = var.environment
  domain_name = var.domain_name
  hosted_zone_id = var.hosted_zone_id

  primary_alb_dns_name = module.compute_use1.alb_dns_name
  secondary_alb_dns_name = module.compute_usw2.alb_dns_name
}
```
