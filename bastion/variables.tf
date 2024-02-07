variable "bastion_name" {
  description = "The name of the bastion host"
  type        = string
  default     = "bastion"
}

variable "bastion_subnet_id" {
  description = "The subnet id of the bastion host"
  type        = string
}

variable "vpc_id" {
  description = "The vpc id"
  type        = string
}

variable "public_key_path" {
  description = "The path of the public key"
  type        = string
  sensitive   = true
}

variable "user_data_path" {
  description = "The path of the user data"
  type        = string
  sensitive   = true
}
