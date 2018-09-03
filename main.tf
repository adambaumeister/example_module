/*
stand up a new Virtual Private Cloud within an AWS topology
Configuration
*/
variable "vpc_config" {
    type = "map",
    default = {
        network_block = "10.10.0.0/16",
        name = "IMT_testing_vpc",
    }
}  
variable "public_network_config" {
    type = "map",
    default = {
        network = "10.10.10.0/24",
        name = "IMT_testing_public_network",
    }
}  

/*
VPC Resource
VPC's are networks that you can put stuff into. 
    cidr_block
        Provision the block within which networks are allocated
*/
resource "aws_vpc" "main_vpc" { 
    cidr_block  = "${var.vpc_config["network_block"]}"
    tags {
        Name = "${var.vpc_config["name"]}"
    }
}

/* 
Subnet
Subnets are contained within VPC's and are what instances connect to
    vpc_id
        ID of VPC to assign to, sourced from above aws_vpc resource
    cidr_block
        Network subnet, must be within the vpc block
    availability zone
        uhhhhh not sure 
*/
resource "aws_subnet" "public_subnet" {
    vpc_id = "${aws_vpc.main_vpc.id}" 
    cidr_block = "${var.public_network_config["network"]}"
    map_public_ip_on_launch = true    
    availability_zone = "${var.az}" 
    tags {
        Name = "${var.public_network_config["name"]}"
    }
}

/*
Internet Gateway
Provides inbound and outbound access to the internet 
*/
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main_vpc.id}"

  tags {
        Name = "${var.vpc_config["name"]}_igw"
  }
}

/*
Routes
Setup outbound routing
    route_table_id
        Routing table to install into
    destination_cidr_block
        Subnet address
    gateway_id
        Internet gateway (or nat gateway) as next-hop
*/
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

/*
Security group rule
Configure a rule to allow access within a security group
*/
resource "aws_security_group_rule" "allow_all_from_example" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  cidr_blocks     = "${var.example_trusted}"
  security_group_id = "${aws_vpc.main_vpc.default_security_group_id}" 
}
