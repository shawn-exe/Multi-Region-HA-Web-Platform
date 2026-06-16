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

# Compute resource provinsioning startes below:
module "compute_use1" {
  source = "../../modules/compute"

  providers = {
    aws = aws.use1
  }

  name_prefix = "use1"
  aws_region = "us-east-1"
  vpc_id             = module.networking_use1.vpc_id
  public_subnet_ids  = module.networking_use1.public_subnet_ids
  private_subnet_ids = module.networking_use1.private_subnet_ids

  alb_security_group_id = module.networking_use1.alb_security_group_id
  ec2_security_group_id = module.networking_use1.app_security_group_id

  ami_id                = data.aws_ami.ubuntu_use1.id
  instance_type         = "t3.micro"
  #instance_profile_name = aws_iam_instance_profile.ec2.name - removed this as I don't need IAM profile for this EC2 instance for now.
}


#DB module is provisioned below:

module "database_use1" {
  source = "../../modules/database"

  providers = {
    aws = aws.use1
  }

  name_prefix = "use1"

  private_subnet_ids = module.networking_use1.private_subnet_ids

  db_security_group_id = module.networking_use1.rds_security_group_id

  db_username = var.db_username
  db_password = var.db_password

  db_instance_class = "db.t3.micro"

  replica_instance_class = "db.t3.micro"
}