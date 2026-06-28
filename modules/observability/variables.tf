variable "name_prefix" {
  type = string
}

variable "dashboard_name" {
  type    = string
  default = ""
}

variable "dashboard_body" {
  type = string
  default = "{\"widgets\":[] }"
}

variable "log_group_name" {
  type    = string
  default = ""
}

variable "retention_in_days" {
  type    = number
  default = 14
}

variable "tags" {
  type    = map(string)
  default = {}
}
