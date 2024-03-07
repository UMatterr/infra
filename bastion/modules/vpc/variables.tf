variable "az_list" {
  description = "List of availability zones for the subnets"
  type        = list(string)
}

variable "region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The CIDR block for the VPC"
  type        = string
}
