# Configure the AWS Provider
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "${var.region}"
}




resource "aws_vpc" "VPC_DEV" {
    cidr_block          = "${var.vpc_cidr_block}"
    instance_tenancy    = "${var.vcp_instance_tenancy}"
    tags {
        Name = "VPC_DEV"
    }  
}

resource "aws_subnet" "vpc_dev_subnet" {
    count      = 2
    vpc_id     = "${aws_vpc.VPC_DEV.id}"
    cidr_block = "${var.vpc_dev_subnet_cidr_block[count.index]}"
    tags {
        Name = "${format("vpc_dev_subnet_%2d",count.index+1)}"
    }
}


resource "aws_security_group" "web-node-secgroup" {
	name = "web-node-secgroup"
	description = "Web Security Group Allow 80 and 22"
    vpc_id = "${aws_vpc.VPC_DEV.id}"
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
 
	ingress {
		from_port = 22
		to_port = 22
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