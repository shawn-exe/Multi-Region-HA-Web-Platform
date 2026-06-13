provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "usw2"
  region = "us-west-2"
}

module "networking_use1" {
  source = "../../modules/networking"

  providers = {
    aws = aws.use1
  }

  environment = var.environment

  vpc_cidr = var.regions["us-east-1"].vpc_cidr
  azs      = var.regions["us-east-1"].azs
}

module "networking_usw2" {
  source = "../../modules/networking"

  providers = {
    aws = aws.usw2
  }

  environment = var.environment

  vpc_cidr = var.regions["us-west-2"].vpc_cidr
  azs      = var.regions["us-west-2"].azs
}