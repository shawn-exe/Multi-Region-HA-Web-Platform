#Using only one region for staging environment

data "aws_ami" "ubuntu_use1" {
  provider    = aws.use1
  most_recent = true

  owners = ["099720109477"] # Canonical owner Id

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
