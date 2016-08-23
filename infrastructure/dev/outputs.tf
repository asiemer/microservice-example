// The bastion host IP.
output "bastion_ip" {
  value = "${module.stack.bastion_ip}"
}