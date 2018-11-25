# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

module "dev_vcp" {
	source = "./module"
	aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
	#variable = "value"
}


resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

#data "aws_ami_ids" "ubuntu" {
  #owners = ["099720109477"]
	
 # filter {
  #  name   = "name"
   # values = ["ubuntu/images/ubuntu-*-*-amd64-server-*"]
		#image_id = "ami-06b5810be11add0e2"
	
  #}
#}
resource "aws_instance" "web-node" {
  count 					= "${var.web_server_count}"
	ami 						= "ami-06b5810be11add0e2"
	#ami = "${data.aws_ami_ids.ubuntu.ids[0]}"
	instance_type 	= "${var.web_server_instance_type}"
	key_name 				= "${aws_key_pair.my-key.key_name}"
	#security_groups = ["${aws_security_group.web-node-secgroup.name}"]
	security_groups = ["${module.dev_vcp.webnode_sec_group}"]

	subnet_id 			= "${module.dev_vcp.vcp_subnets[count.index]}"

  #private_ip 			= "${var.web_server_private_ips[count.index]}"
  associate_public_ip_address = "${var.web_server_public_ip}"
  tags{ 
      name = "${format("${var.web_server_name_prefix}-%02d-${var.web_server_name_suffix}", count.index + 1)}"
  }

		provisioner "remote-exec" {
			inline = [
				"sudo sleep 60",
				"sudo apt-get update",
				"sudo apt-get install Nginx -y",
				"sudo service nginx start"
			]
			}
	}

output "instance_publicip" {
  value = "${aws_instance.web-node.*.public_ip}"
	value = "${aws_instance.web-node.*.tags}"
	value = "${aws_instance.web-node.*.private_ip}"
}
