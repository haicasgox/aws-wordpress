output "wordpress_sg" {
  value = "${aws_security_group.wordpress_security_group.id}"
}
output "instance1_id" {
  value = "${element(aws_instance.wordpress_instance.*.id, 1)}"
}
output "instance2_id" {
  value = "${element(aws_instance.wordpress_instance.*.id, 2)}"
}


