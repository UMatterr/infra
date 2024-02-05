# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "k8s_version" {
  description = "k8s version"
  type        = string
  default     = "1.28"
}

variable "db_password" {
  type        = string
  description = "a password for RDS"
  default     = "test1234"
}