#!/bin/bash

# Apply terraform
set -e
if ! ./tf_apply.sh ; then
    echo "Terraform apply failed"
    exit 1
fi

# Check the cluster arn after making the AWS EKS cluster
set +e
cd terraform
echo Current folder: $(pwd)
current_context=$(kubectl config current-context)
terraform_cluster_arn=$(terraform output -raw cluster_arn)

# if the current context of the local ~/.kube/config is not configured
# or the current context is not identical with the Terraform cluster arn,
# then update/switch the the cluster to the kubectl for the AWS EKS cluster
set -e
if [ -z "${current_context}" ] || \
    [ "${current_context}" != "${terraform_cluster_arn}" ]; then
    echo "Switching to cluster"

    aws eks update-kubeconfig \
        --region $(terraform output -raw region) \
        --name $(terraform output -raw cluster_name)

    echo "Cluster switched"
fi
echo "The current context of the local machine: $(kubectl config current-context)"
cd ..
echo Current folder: $(pwd)

# Install metric servers
if ! ./metrics_server_install.sh ; then
    echo "Metrics server install failed"
    exit 1
fi

# Apply k8s
if ! ./apply_k8s.sh ; then
    echo "K8s apply failed"
    exit 1
fi
