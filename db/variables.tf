variable "db_family" {
  description = "The name of db"
  type        = string
}

variable "db_port" {
  description = "The port number of db"
  type        = number
}

variable "db_vpc_id" {
  description = "The vpc id of db"
  type        = string
}

variable "db_name" {
  description = "The name of db"
  type        = string
}

variable "db_instance_class" {
  description = "The name of db instance class"
  type        = string
}

variable "db_engine" {
  description = "The name of db engine"
  type        = string
}

variable "db_engine_version" {
  description = "The value of db engine version"
  type        = string
}

variable "db_major_engine_version" {
  description = "The value of db engine major version"
  type        = string
}

variable "db_username" {
  description = "The name of db user"
  type        = string
}

variable "db_password" {
  description = "The name of db user"
  type        = string
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "The desired size of db"
  type        = number
}

variable "db_max_allocated_storage" {
  description = "The maximum size of db"
  type        = number
}

variable "db_subnets" {
  description = "The list of db subnet"
  type        = list(string)
}
