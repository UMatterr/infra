output "domain_name" {
  value = aws_cloudfront_distribution.web.domain_name
}

output "hosted_zone_id" {
  value = aws_cloudfront_distribution.web.hosted_zone_id
}

output "cf_id" {
  value = aws_cloudfront_distribution.web.id
}

output "cf_arn" {
  value = aws_cloudfront_distribution.web.arn
}
