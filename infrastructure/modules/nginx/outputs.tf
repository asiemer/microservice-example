output "elb_url" {
  value = "http://${aws_elb.elb.dns_name}:${var.container_port}"
}