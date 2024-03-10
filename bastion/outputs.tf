# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
output "ec2" {
  description = "bastion public DNS"
  value       = aws_instance.my_instance
  sensitive   = true
}

output "bastion_public_dns" {
  description = "bastion public DNS"
  value       = aws_instance.my_instance.public_dns
}

output "ecr" {
  description = "The Info of AWS ECR private repository"
  value       = module.ecr.ecr
  sensitive   = true
}

output "ecr_host" {
  description = "The URL of AWS ECR private repository"
  value       = module.ecr.ecr_host
}

output "ecr_name" {
  description = "The name of AWS ECR private repository"
  value       = module.ecr.ecr_name
}
