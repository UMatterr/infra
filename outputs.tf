# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = local.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_arn" {
  description = "Kubernetes Cluster ARN"
  value       = module.eks.cluster_arn
}

output "oidc_id" {
  value = module.eks.oidc_provider_arn
}

output "oidc_provider" {
  value = module.eks.oidc_provider
}

output "oidc_issuer" {
  value = module.eks.cluster_oidc_issuer_url
}

output "eks_cluster_cert" {
  value = module.eks.cluster_certificate_authority_data
}

output "rds_host" {
  value     = module.db.rds_hostname
  sensitive = true
}