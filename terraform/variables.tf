# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
variable "db_password" {
  description = "A password for RDS"
  type        = string
  default     = "test1234"
  sensitive   = true
}

variable "public_key_path" {
  description = "The path of the public key"
  type        = string
  default     = "./umatter-key.pub"
  sensitive   = true
}

variable "user_data_path" {
  description = "The path of the user data for bastion host"
  type        = string
  default     = "./setup_linux.sh"
  sensitive   = true
}
