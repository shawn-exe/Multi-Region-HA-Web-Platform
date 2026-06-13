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