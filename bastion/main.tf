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

locals {
  region   = "ap-northeast-2"
  name     = "bastion"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  vpc_cidr = "10.1.0.0/16"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = local.name
  cidr = local.vpc_cidr
  azs  = local.azs

  private_subnets = [
    for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)
  ]
  public_subnets = [
    for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 3)
  ]

  enable_nat_gateway           = true
  single_nat_gateway           = true
  enable_dns_hostnames         = true
}
