variable "name_prefix" {
  description = "Resource name prefix"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "db_security_group_id" {
  description = "Security Group ID for RDS"
  type        = string
}

variable "db_username" {
  description = "Master DB username"
  type        = string
}

variable "db_password" {
  description = "Master DB password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Primary DB instance class"
  type        = string

  default = "db.t3.micro"
}

variable "replica_instance_class" {
  description = "Read replica instance class"
  type        = string

  default = "db.t3.micro"
}

variable "replica_count" {
  description = "Number of read replicas"
  type        = number

  default = 1
}