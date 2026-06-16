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