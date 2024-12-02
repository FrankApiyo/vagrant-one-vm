provider "aws" {
  region = var.region
}

# Security Group
resource "aws_security_group" "ssh_access" {
  name_prefix = "ssh-access-"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "ubuntu_vm" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = <<-EOL
  #!/bin/bash -xe

  sudo apt update
  sudo apt upgrade --yes
  sudo apt install -y acl htop
  EOL

  network_interface {
    network_interface_id = aws_network_interface.user_api.id
    device_index         = 0
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# Elastic IP
resource "aws_eip" "static_ip" {
  instance                  = aws_instance.ubuntu_vm.id
  associate_with_private_ip = "10.0.1.100"
  depends_on                = [aws_internet_gateway.gw]
}

resource "aws_network_interface" "user_api" {
  subnet_id   = aws_subnet.user_api_subnet.id
  private_ips = ["10.0.1.100"]
  security_groups = [
    aws_security_group.ssh_access.id
  ]
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.user_api_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

resource "aws_subnet" "user_api_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}
