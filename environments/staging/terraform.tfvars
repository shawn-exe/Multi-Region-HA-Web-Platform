environment = "prod"
# Provisioing Infra only in us-east-1 for staging.

regions = {
  "us-east-1" = {
    vpc_cidr = "10.0.0.0/16"
    azs = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c"
    ]
  }
}

#DB variables are mentioned below
db_username = "postgres"

#The below password is just for testig purpose - In production use AWS secrets Manager or HashiCorp Vault
db_password = "SuperSecurePassword123!"