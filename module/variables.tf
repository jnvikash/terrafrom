variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "region" {
  default = "us-east-1"
}
variable "vpc_cidr_block" {
    default = "172.31.0.0/24"
}

variable "vpc_dev_subnet_cidr_block" {
    default = ["172.31.0.0/25", "172.31.0.128/25"]
}

variable "vcp_instance_tenancy" {
  default="default"
}