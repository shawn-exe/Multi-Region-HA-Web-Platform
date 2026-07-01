# Module: DNS

## Purpose

The DNS module creates a Route 53 alias record for the application domain and points it to the CloudFront distribution.

## Resources Created

- aws_route53_record.app

## Inputs

- hosted_zone_id: ID of the Route 53 hosted zone
- domain_name: Application domain name
- cloudfront_domain_name: CloudFront distribution domain name
- cloudfront_hosted_zone_id: CloudFront hosted zone ID

## Outputs

This module does not currently expose outputs.

## Notes

- The alias record is created as an A record.
- This allows the domain name to resolve to the CloudFront distribution, which then routes traffic to the application origins.

## Example Usage

```hcl
module "dns" {
  source = "../../modules/dns"

  hosted_zone_id = var.hosted_zone_id
  domain_name = var.domain_name

  cloudfront_domain_name = module.cdn.distribution_domain_name
  cloudfront_hosted_zone_id = module.cdn.distribution_hosted_zone_id
}
```
