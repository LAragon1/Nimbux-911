variable "vpc_cidr" {
default = "172.31.0.0/16"
}

variable "public_subnet_cidr" {
default = "172.31.0.0/24"
}

variable "private_subnet_cidr" {
default = "172.31.1.0/24"
}

variable "AWS_REGION" {
default = "us-east-2"
}

variable "AWS_SECRET_KEY" {
default = "K4omR5n7UScd1VyTeVNYh4IlSu2zLL8goMwTVXM0"
}

variable "AWS_ACCESS_KEY" {
default = "AKIAVKYSRJWXWMY7IUHT"
}

variable "instance_key" {
default = "doS0Yz5rKxjlza6aV0vbfiwuPFtXSguyWYzd83a6ekw"
}

variable "instance_type" {
default = "t2.micro"
}
