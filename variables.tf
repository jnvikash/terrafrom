variable "aws_access_key" {
}
variable "aws_secret_key" {
}

variable "web_server_private_ips" {
    default = ["172.31.0.1","172.31.0.2", "172.31.0.3"]
}

###################### Compute Nodes ######################
variable "web_server_count" { }
variable "web_server_instance_type" { }
variable "web_server_name_prefix" {}
variable "web_server_name_suffix" {}
variable "web_server_public_ip" {}




