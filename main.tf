terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }    
  }
}

provider "aws" {
   access_key = var.AWS_ACCESS_KEY
   secret_key = var.AWS_SECRET_KEY
   region = var.AWS_REGION
}

#creacion de vpc
resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "app-vpc"
  }
}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "vpc_igw"
  }
}

#subnet publica 1 
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"

  tags = {
    Name = "public-subnet"
  }
}

#subnet publica 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"

  tags = {
    Name = "public-subnet_2"
  }
}

#subnet privada 1 
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.private_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone = "us-east-2a"
  

  tags = {
    Name = "private-subnet"
  }
}

#subnet privada 2 
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = var.private_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone = "us-east-2a"
 

  tags = {
    Name = "private-subnet_2"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

}

}

#nat 1 
resource "aws_nat_gateway" "NAT_1" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private_subnet

}

#nat 2
resource "aws_nat_gateway" "NAT_2" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private_subnet_2
}

#load balancer
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in aws_subnet.public_subnet.id : aws_subnet.public_subnet_2.id]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

#APACHE -
resource "aws_instance" "apache" {
  ami             = "ami-04505e74c0741db8d" 
  instance_type   = var.instance_type
  key_name        = var.instance_key
  subnet_id       = aws_nat_gateway.NAT_1.id
  security_groups = [aws_security_group.sg.id]

 user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  EOF

}

# NGINX

resource "aws_instance" "nginx" {
  ami = "ami-03a0c45ebc70f98ea"
  instance_type = var.instance_type
  key_name = var.instance_key
  subnet_id = aws_nat_gateway.NAT_2.id
  security_groups = [aws_security_group.sg.id]

    provisioner "remote-exec" {
      inline = [
        "sudo amazon-linux-extras enable nginx1.12",
        "sudo yum -y install nginx",
        "sudo systemctl start nginx",
      ]
    }
}
  


