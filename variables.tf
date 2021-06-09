variable "pubkey" {}
variable "lic" {}
variable "nomadlic" {}
variable "region" {
    default = "ap-northeast-1"
}
variable "ami" {
	default = "ami-0e03b7b3b8a8c5e2c"
}
variable "instance_count" {
	default = 1
}
variable "instence_type" {
	default = "t2.micro"
}

variable "instance_name" {
	default = "hashibox"

}
variable "tags" {
	type        = "map"
	default     = {}
	description = "Key/value tags to assign to all AWS resources"
}
variable "vault_url" {
	default = "https://releases.hashicorp.com/vault/1.3.0/vault_1.3.0_linux_amd64.zip"
}
variable "consul_url" {
	default = "https://releases.hashicorp.com/consul/1.6.2/consul_1.6.2_linux_amd64.zip"
}
variable "terraform_url" {
	default = "https://releases.hashicorp.com/terraform/0.12.16/terraform_0.12.16_linux_amd64.zip"
}
variable "nomad_url" {
	default = "https://releases.hashicorp.com/nomad/0.10.1/nomad_0.10.1_linux_amd64.zip"
}
variable "nomad_auto_url" {
	default = "https://releases.hashicorp.com/nomad-autoscaler/0.2.0-beta3+ent/nomad-autoscaler_0.2.0-beta3+ent_linux_amd64.zip"
}
variable "ubuntu_password" {
	default = "happy-hacking"
}
