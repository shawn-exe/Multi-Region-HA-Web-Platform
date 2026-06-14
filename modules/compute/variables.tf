variable "name_prefix" {
type = string
}

variable "vpc_id" {
type = string
}

variable "public_subnet_ids" {
type = list(string)
}

variable "private_subnet_ids" {
type = list(string)
}

variable "alb_security_group_id" {
type = string
}

variable "ec2_security_group_id" {
type = string
}

variable "ami_id" {
type = string
}

variable "instance_type" {
type = string
}


variable "aws_region" {
type = string
}

variable "app_port" {
type    = number
default = 80
}

variable "min_size" {
type    = number
default = 2
}

variable "max_size" {
type    = number
default = 4
}

variable "desired_capacity" {
type    = number
default = 2
}
