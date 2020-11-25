output "eip" {
  value = aws_eip.vault_eip.*.public_ip
}

output "password" {
  value = var.ubuntu_password
}