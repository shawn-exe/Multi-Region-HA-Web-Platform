variable "environment" {
  type = string
}

variable "regions" {
  type = map(object({
    vpc_cidr = string
    azs      = list(string)
  }))
}

# DB variables are mentioned below:

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

# the below variables are for dns and CDN 
variable "domain_name" {
  description = "Application domain name"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}