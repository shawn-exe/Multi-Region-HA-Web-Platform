provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

# Provisioing Infra only in us-east-1 for staging.

module "networking_use1" {
  source = "../../modules/networking"

  providers = {
    aws = aws.use1
  }

  environment = var.environment

  vpc_cidr = var.regions["us-east-1"].vpc_cidr
  azs      = var.regions["us-east-1"].azs
}