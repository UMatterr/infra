provider "aws" {}

module "s3" {
  source = "./modules/s3"

  s3_name = var.s3_name
  cf_arn = module.cloudfront.cf_arn
}

module "cloudfront" {
  source = "./modules/cloudfront"
  domain = var.domain
  certificate_arn = var.certificate_arn
}

resource "aws_route53_record" "root_domain" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = module.cloudfront.domain_name
    zone_id                = module.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}