#!/bin/bash
set -e

# Find the cluster arn
cluster_arn=$(terraform output -raw cluster_arn)
if [ -z "${cluster_arn}" ]; then
	echo "cluster arn is empty"
	exit 1
fi

# Remove the namespace and all the resources
kubectl delete ns final

# Remove the AWS EKS cluster info from the kubeconfig file
kubectl config unset current-context

# Remove the AWS EKS cluster info from the kubeconfig file
kubectl config delete-cluster ${cluster_arn}
kubectl config delete-context ${cluster_arn}
kubectl config delete-user ${cluster_arn}

# Destroy the Terraform resources from AWS
terraform destroy -auto-approve
