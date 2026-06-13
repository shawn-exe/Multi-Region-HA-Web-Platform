environment = "prod"

regions = {
  "us-east-1" = {
    vpc_cidr = "10.0.0.0/16"
    azs = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c"
    ]
  }

  "us-west-2" = {
    vpc_cidr = "10.1.0.0/16"
    azs = [
      "us-west-2a",
      "us-west-2b",
      "us-west-2c"
    ]
  }
}