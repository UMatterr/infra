output "ecr" {
  description = "ECR info"
  value       = aws_ecr_repository.ecr
  sensitive   = true
}

output "ecr_arn" {
  description = "ECR info"
  value       = aws_ecr_repository.ecr.arn
}

output "ecr_name" {
  description = "ECR name"
  value       = aws_ecr_repository.ecr.name
}

output "ecr_host" {
  description = "ECR host"
  value       = aws_ecr_repository.ecr.repository_url
}
