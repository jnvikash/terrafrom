output "webnode_sec_group" {
  value = "${aws_security_group.web-node-secgroup.id}"
}

output "vpc_id" {
  value = "${aws_vpc.VPC_DEV.id}"
}


output "vcp_subnets" {
  value = "${aws_subnet.vpc_dev_subnet.*.id}"
}
