# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
provider "aws" {
  region = local.region
}

# Filter out local zones, which are not currently supported 
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_caller_identity" "current" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

locals {
  region        = "ap-northeast-2"
  name          = "bastion"
  azs           = slice(data.aws_availability_zones.available.names, 0, 4)
  vpc_cidr      = "10.1.0.0/16"
  instance_type = "t3.medium"
}

module "ecr" {
  source = "./modules/ecr"

  ecr_name       = "umatter"
  ecr_mutability = "MUTABLE"
}

module "vpc" {
  source = "./modules/vpc"

  az_list      = local.azs
  region       = local.region
  subnet_cidrs = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  vpc_cidr     = local.vpc_cidr
  vpc_name     = local.name
}

module "bastion-sg" {
  source = "./modules/sg"

  sg_name = local.name
  vpc_id  = module.vpc.vpc_id
}

resource "aws_key_pair" "bastion-key" {
  key_name   = "bastion-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "my_instance" {
  depends_on = [module.ecr]

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = local.instance_type
  subnet_id                   = module.vpc.subnet_ids[0]
  vpc_security_group_ids      = [module.bastion-sg.sg_id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion-key.key_name

  user_data = file(var.user_data_path)

  root_block_device {
    volume_size = 20
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "${local.name}"
  }
}
