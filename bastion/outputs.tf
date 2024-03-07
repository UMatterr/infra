# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
output "azs" {
  description = "AZ list"
  value       = local.azs
}

output "ami" {
  description = "Filtered ami ids"
  value       = data.aws_ami.ubuntu
}
