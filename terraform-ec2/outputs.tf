output "static_ip" {
  value = aws_eip.static_ip.public_ip
}

output "instance_id" {
  value = aws_instance.ubuntu_vm.id
}

output "security_group" {
  value = aws_security_group.ssh_access.name
}
