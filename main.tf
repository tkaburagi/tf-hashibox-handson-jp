terraform {
  required_version = "~> 0.12" 
}

provider "aws" {
	access_key = var.access_key
	secret_key = var.secret_key
	region = var.region
}

module "networking" {
    source  = "app.terraform.io/tkaburagi/networking/aws"
    version = "0.3.0"

    instance_count = var.instance_count
    instance_id = aws_instance.hashibox.*.id
}

module "pubkey" {
    source  = "app.terraform.io/tkaburagi/pubkey/aws"
    version = "1.0.2"

    pubkey = var.pubkey
}

module "securitygroup" {
    source  = "app.terraform.io/tkaburagi/securitygroup/aws"
    version = "0.2.5"

    vpc_id = module.networking.vpc_id
}

resource "aws_eip" "vault_eip" {
    count = var.instance_count
    instance = aws_instance.hashibox.*.id[count.index]
    vpc = true
}

resource "aws_instance" "hashibox" {
    ami = var.ami
    count = var.instance_count
    instance_type = var.instence_type
    vpc_security_group_ids = [module.securitygroup.sg_id]
    tags = merge(var.tags, map("Name", "hashibox-${count.index}"))
    subnet_id = module.networking.subnet_id
    key_name = module.pubkey.deployer_id
    associate_public_ip_address = true
    user_data = data.template_file.init.rendered
}

data "template_file" "init" {
    template = file("setup.sh")
    vars = {
        vault_url = var.vault_url
        consul_url = var.consul_url
        nomad_url = var.nomad_url
        terraform_url = var.terraform_url
        ubuntu_password = var.ubuntu_password

    }
}
