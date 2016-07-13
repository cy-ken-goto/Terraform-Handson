variable "access_key" {}
variable "secret_key" {}

provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "ap-northeast-1"
}

variable "images" {
    default = {
        us-east-1 = "ami-1ecae776"
        us-west-2 = "ami-e7527ed7"
        us-west-1 = "ami-d114f295"
        eu-west-1 = "ami-a10897d6"
        eu-central-1 = "ami-a8221fb5"
        ap-southeast-1 = "ami-68d8e93a"
        ap-southeast-2 = "ami-fd9cecc7"
        ap-northeast-1 = "ami-cbf90ecb"
        sa-east-1 = "ami-b52890a8"
    }
}

resource "aws_vpc" "YourNameVPC" {
    cidr_block = "10.1.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "false"
    tags {
      Name = "YourNameVPC"
    }
}

resource "aws_internet_gateway" "YourNameGW" {
    vpc_id = "${aws_vpc.YourNameVPC.id}"
}

resource "aws_subnet" "YourNamePublicSubnetA" {
    vpc_id = "${aws_vpc.YourNameVPC.id}"
    cidr_block = "10.1.1.0/24"
    availability_zone = "ap-northeast-1a"
}

resource "aws_route_table" "public-route" {
    vpc_id = "${aws_vpc.YourNameVPC.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.YourNameGW.id}"
    }
}

resource "aws_route_table_association" "puclic-a" {
    subnet_id = "${aws_subnet.YourNamePublicSubnetA.id}"
    route_table_id = "${aws_route_table.public-route.id}"
}

resource "aws_security_group" "ssh" {
    name = "SSH-sec"
    description = "Allow SSH From Cybird IP"
    vpc_id = "${aws_vpc.YourNameVPC.id}"
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
    name = "HTTP-sec"
    description = "Allow HTTP"
    vpc_id = "${aws_vpc.YourNameVPC.id}"
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

resource "aws_instance" "YourNameTerraformTest" {
    ami = "${var.images.ap-northeast-1}"
    instance_type = "t2.micro"
    key_name = "goto_key"
    vpc_security_group_ids = [
      "${aws_security_group.ssh.id}",
      "${aws_security_group.http.id}"
    ]
    subnet_id = "${aws_subnet.YourNamePublicSubnetA.id}"
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
        Name = "YourNameTerraformTest"
    }
}

output "public ip of YourNameTerraformTest" {
  value = "${aws_instance.YourNameTerraformTest.public_ip}"
}