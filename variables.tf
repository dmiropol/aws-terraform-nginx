# AWS Provider variables
variable "aws_provider" {
  type = map
  default = {
    aws_credentials = "$HOME/.aws/credentials"
    aws_region = "us-east-1"
    aws_profile = "default"
  }
}
  
variable "aws_vpc" {
  type = map
  default = {
    name = "demo-vpc"
    cidr_block = "172.16.0.0/16"
    private_sn_cidr_block = "172.16.1.0/24"
    availability_zone = "us-east-1a"
  }
}

variable "aws_private_subnet" {
  type = map
  default = {
    name = "private_sn"
    cidr_block = "172.16.1.0/24"
    availability_zone = "us-east-1a"
  }
}

variable "aws_igw" {
  default = "demo_igw"
}

variable "aws_demo_private_sg" {
  type = map
  default = {
    name = "demo_private_sg"
    port_1 = 22
    port_2 = 80
    port_3 = 443
    protocol = "tcp"
    ingress_cidr_block = "0.0.0.0/0"
    egress_cidr_block = "0.0.0.0/0"
  }  
}

variable "aws_vm_instance" {
  type = map
  default = {
    private_key_name = "nginx"
    private_interface = "private_network_interface"
    instance_type = "t2.micro"
    instance_name = "nginx"
  }
}

variable "aws_ami_bitnami_nginx" {
    default = {
        us-east-1 = "ami-0ed34781dc2ec3964"
    }
}
