# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}
resource "aws_security_group" "web-node-secgroup" {
	name = "web-node-secgroup"
	description = "Web Security Group"
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

    
}resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}


resource "aws_instance" "web-node" {
    count = 3
	ami = "ami-06b5810be11add0e2"
	instance_type = "t2.micro"
	key_name = "${aws_key_pair.my-key.key_name}"
	security_groups = ["${aws_security_group.web-node-secgroup.name}"]
    private_ip = "${var.web_server_private_ips[count.index]}"
    associate_public_ip_address = true
    tags{ 
        name = "${format("web-node-%02d", count.index + 1)}"
    }
}

output "instance_publicip" {
  value = "${aws_instance.web-node.*.public_ip}"
}
