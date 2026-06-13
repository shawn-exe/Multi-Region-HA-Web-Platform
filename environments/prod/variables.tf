variable "environment" {
  type = string
}

variable "regions" {
  type = map(object({
    vpc_cidr = string
    azs      = list(string)
  }))
}