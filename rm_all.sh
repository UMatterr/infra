#!/bin/bash
# It works in bash < 4.0.0
declare -a check_list

data="cluster_arn|$(terraform output -raw cluster_arn)"

IFS=' ' read -ra check_list <<< "$data"

for item in "${check_list[@]}"; do
    IFS='|' read -ra item <<< "$item"
    if [ -z "${item[1]}" ]; then
      echo "${item[0]} is empty"
      exit 1
    fi
done

# Remove the namespace and all the resources
kubectl delete ns final && \

# Remove the AWS EKS cluster info from the kubeconfig file
kubectl config unset current-context && \

# Remove the AWS EKS cluster info from the kubeconfig file
kubectl config delete-cluster ${cluster_arn} && \
kubectl config delete-context ${cluster_arn} && \
kubectl config delete-user ${cluster_arn} && \

# Destroy the Terraform resources from AWS
terraform destroy -auto-approve