#!/bin/bash

# Apply terraform
./tf_apply.sh

# Check the cluster arn after making the AWS EKS cluster
cd terraform
echo Current folder: $(pwd)
current_context=$(kubectl config current-context)
terraform_cluster_arn=$(terraform output -raw cluster_arn)

set -e

# if the current context of the local ~/.kube/config is not configured
# or the current context is not identical with the Terraform cluster arn,
# then update/switch the the cluster to the kubectl for the AWS EKS cluster
if [ -z "${current_context}" ] || \
    [ "${current_context}" != "${terraform_cluster_arn}" ]; then
    echo "Switching to cluster"

    aws eks update-kubeconfig \
        --region $(terraform output -raw region) \
        --name $(terraform output -raw cluster_name)

    echo "Cluster switched"
fi
echo "The current context of the local machine: $(kubectl config current-context)"
cd -
echo Current folder: $(pwd)

# Install metric servers
./metrics_server_install.sh

# Apply k8s
./apply_k8s.sh
