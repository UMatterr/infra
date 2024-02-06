# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "db_password" {
  description = "a password for RDS"
  type        = string
  default     = "test1234"
  sensitive   = true
}