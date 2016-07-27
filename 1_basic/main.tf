provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "ap-northeast-1"
}

resource "aws_vpc" "VPC" {
    cidr_block = "10.1.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "false"
    tags {
      Name = "${var.app_name}-VPC"
    }
}

resource "aws_internet_gateway" "GW" {
    vpc_id = "${aws_vpc.VPC.id}"
    tags {
      Name = "${var.app_name}-GW"
    }
}

resource "aws_subnet" "PublicSubnetA" {
    vpc_id = "${aws_vpc.VPC.id}"
    cidr_block = "10.1.1.0/24"
    availability_zone = "ap-northeast-1a"
    tags {
      Name = "${var.app_name}-PublicSubnetA"
    }
}

resource "aws_route_table" "PublicRoute" {
    vpc_id = "${aws_vpc.VPC.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.GW.id}"
    }
    tags {
      Name = "${var.app_name}-PublicRoute"
    }
}

resource "aws_route_table_association" "puclic-a" {
    subnet_id = "${aws_subnet.PublicSubnetA.id}"
    route_table_id = "${aws_route_table.PublicRoute.id}"
}

resource "aws_security_group" "ssh" {
    name = "${var.app_name}-SSH-sec"
    description = "Allow SSH From Cybird IP"
    vpc_id = "${aws_vpc.VPC.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["124.35.1.202/32","202.228.194.1/32","122.219.131.113/32"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "http" {
    name = "${var.app_name}-HTTP-sec"
    description = "Allow HTTP"
    vpc_id = "${aws_vpc.VPC.id}"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "TerraformTest" {
    ami = "${var.images.ap-northeast-1}"
    instance_type = "t2.micro"
    key_name = "goto_key"
    vpc_security_group_ids = [
      "${aws_security_group.ssh.id}",
      "${aws_security_group.http.id}"
    ]
    subnet_id = "${aws_subnet.PublicSubnetA.id}"
    associate_public_ip_address = "true"
    root_block_device = {
      volume_type = "gp2"
      volume_size = "20"
    }
    ebs_block_device = {
      device_name = "/dev/sdf"
      volume_type = "gp2"
      volume_size = "100"
    }
    tags {
        Name = "${var.app_name}-TerraformTest"
    }
}

output "public ip of TerraformTest" {
  value = "${aws_instance.TerraformTest.public_ip}"
}