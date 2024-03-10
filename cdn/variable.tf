variable "s3_name" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "domain" {
  type = string
  description = "The domain of AWS CloudFront"
  default = "web.umatter-goorm.net"
}
