output "vpc_id" {
  value = "${aws_vpc.main.id}"
}
output "public_subnets" {
  value = "${aws_subnet.public_subnet.*.id}"
}
output "private_subnet1" {
  value = "${element(aws_subnet.private_subnet.*.id, 1)}"
}
output "private_subnet2" {
  value = "${element(aws_subnet.private_subnet.*.id, 2)}"
}


