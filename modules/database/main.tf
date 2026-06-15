resource "aws_db_subnet_group" "this" {
  name = "${var.name_prefix}-db-subnet-group"

  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.name_prefix}-db-subnet-group"
  }
}

resource "aws_db_instance" "primary" {
  identifier = "${var.name_prefix}-db"

  engine         = "postgres"
  engine_version = "16"

  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_encrypted = true

  username = var.db_username
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.this.name

  vpc_security_group_ids = [
    var.db_security_group_id
  ]

  multi_az = true

  skip_final_snapshot = false

  tags = {
    Name = "${var.name_prefix}-db"
  }
}