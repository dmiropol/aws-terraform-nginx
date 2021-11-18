# create new VPC
resource "aws_vpc" "aws_demo_vpc" {
    cidr_block = var.aws_vpc.cidr_block
    tags = {
        Name = var.aws_vpc.name
    }
}

// define private subnet
resource "aws_subnet" "aws_demo_private_sn" {
    vpc_id = aws_vpc.aws_demo_vpc.id 
    cidr_block = var.aws_private_subnet.cidr_block
    availability_zone = var.aws_private_subnet.availability_zone
    map_public_ip_on_launch = false
    tags = {
        Name = var.aws_private_subnet.name
    }
}

// create the IGW
resource "aws_internet_gateway" "aws_demo_igw" { 
    vpc_id = aws_vpc.aws_demo_vpc.id
    tags = {
        Name = var.aws_igw
    }
}

// configure default route
resource "aws_route" "aws_demo_public_rt" {
    route_table_id = aws_vpc.aws_demo_vpc.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_demo_igw.id
}

// create AWS SG rules
resource "aws_security_group" "aws_demo_private_sg" {
    vpc_id = aws_vpc.aws_demo_vpc.id
    tags = {
        Name = var.aws_demo_private_sg.name
    }
    // ALL
    ingress {
        from_port = var.aws_demo_private_sg.port_1
        to_port = var.aws_demo_private_sg.port_1
        protocol = var.aws_demo_private_sg.protocol
        cidr_blocks = [var.aws_demo_private_sg.ingress_cidr_block]
    }
    ingress {
        from_port = var.aws_demo_private_sg.port_2
        to_port = var.aws_demo_private_sg.port_2
        protocol = var.aws_demo_private_sg.protocol
        cidr_blocks = [var.aws_demo_private_sg.ingress_cidr_block]
    }
    ingress {
        from_port = var.aws_demo_private_sg.port_3
        to_port = var.aws_demo_private_sg.port_3
        protocol = var.aws_demo_private_sg.protocol
        cidr_blocks = [var.aws_demo_private_sg.ingress_cidr_block]
    }
    // ALL
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.aws_demo_private_sg.egress_cidr_block]
    }
}

# Create a nginx server instance
// key pair creation
resource "tls_private_key" "aws_vm_key" {
  algorithm = "RSA"
}

module "key_pair_vm" {
  source = "terraform-aws-modules/key-pair/aws"
  public_key = tls_private_key.aws_vm_key.public_key_openssh
  key_name = var.aws_vm_instance.private_key_name
}

resource "aws_network_interface" "aws_vm_private_intf" { 
    subnet_id = aws_subnet.aws_demo_private_sn.id
    source_dest_check = false
    security_groups = [aws_security_group.aws_demo_private_sg.id]
    tags = {
        Name = var.aws_vm_instance.private_interface
    }
}

resource "aws_instance" "aws_vm_instance" { 
    instance_type = var.aws_vm_instance.instance_type
    key_name = var.aws_vm_instance.private_key_name
    ami = lookup(var.aws_ami_bitnami_nginx, var.aws_provider.aws_region)
    network_interface {
        network_interface_id = aws_network_interface.aws_vm_private_intf.id
        device_index  = 0
    }
    user_data = file("./cloud-init-aws-nginx")
    tags = {
        Name = var.aws_vm_instance.instance_name
    }
}

// associate elastic IP
resource "aws_eip" "aws_demo-eip" {
  instance = aws_instance.aws_vm_instance.id
  vpc      = true
  depends_on = [aws_internet_gateway.aws_demo_igw]
}
