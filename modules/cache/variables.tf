variable "name_prefix" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "node_type" {
  type    = string
  default = "cache.t3.micro"
}

variable "engine_version" {
  type    = string
  default = "6.x"
}

variable "num_cache_nodes" {
  type    = number
  default = 1
}

variable "port" {
  type    = number
  default = 6379
}

variable "tags" {
  type    = map(string)
  default = {}
}
