provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "ap-northeast-1"
}

variable "images" {
    default = {
        us-east-1      = "ami-1ecae776"
        us-west-2      = "ami-e7527ed7"
        us-west-1      = "ami-d114f295"
        eu-west-1      = "ami-a10897d6"
        eu-central-1   = "ami-a8221fb5"
        ap-southeast-1 = "ami-68d8e93a"
        ap-southeast-2 = "ami-fd9cecc7"
        ap-northeast-1 = "ami-cbf90ecb"
        sa-east-1      = "ami-b52890a8"
    }
}

/*
 * vpc周り
 */
resource "aws_vpc" "main-vpc" {
    cidr_block           = "10.100.0.0/16"
    instance_tenancy     = "default"
    enable_dns_support   = "true"
    enable_dns_hostnames = "false"
    tags {
      Name = "${var.app_name}-vpc"
    }
}
resource "aws_internet_gateway" "main-gw" {
    vpc_id = "${aws_vpc.main-vpc.id}"
}
resource "aws_subnet" "main-publicsubnet-a" {
    vpc_id            = "${aws_vpc.main-vpc.id}"
    cidr_block        = "10.100.10.0/24"
    availability_zone = "ap-northeast-1a"
}
resource "aws_subnet" "main-publicsubnet-c" {
    vpc_id            = "${aws_vpc.main-vpc.id}"
    cidr_block        = "10.100.20.0/24"
    availability_zone = "ap-northeast-1c"
}

/*
 * RDS周り
 */
resource "aws_db_subnet_group" "db-sg" {
    name        = "${var.app_name}-main-sg"
    description = "Our main group of subnets"
    subnet_ids  = [
        "${aws_subnet.main-publicsubnet-a.id}",
        "${aws_subnet.main-publicsubnet-c.id}"
    ]
    tags {
        Name = "${var.app_name}-db-sg"
    }
}
resource "aws_db_parameter_group" "db-pg-mysql56" {
    name        = "${var.app_name}-mysql56-pg"
    family      = "mysql5.6"
    description = "${var.app_name}-db-pg-mysql56"

    parameter {
      name  = "character_set_server"
      value = "utf8"
    }

    parameter {
      name  = "character_set_client"
      value = "utf8"
    }
}
resource "aws_db_instance" "db-instance" {
    allocated_storage    = 10
    engine               = "mysql"
    engine_version       = "5.6.29"
    instance_class       = "db.t1.micro"
    name                 = "${var.app_name}"
    username             = "foo"
    password             = "barbarbar"
    multi_az             = false
    port                 = 3306
    db_subnet_group_name = "${aws_db_subnet_group.db-sg.name}"
    parameter_group_name = "${aws_db_parameter_group.db-pg-mysql56.name}"
}

