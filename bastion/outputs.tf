# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
output "ec2" {
  description = "bastion public DNS"
  value       = aws_instance.my_instance
}

output "public_dns" {
  description = "bastion public DNS"
  value       = aws_instance.my_instance.public_dns
}
