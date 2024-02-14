#!/bin/bash
# Prepare a tfplan file
terraform plan -out=umatter.tfplan && \
count=$(ls .tfplan/ | wc -w) && \
count=`expr $count + 1` && \
cp umatter.tfplan .tfplan/umatter_v${count}.tfplan && \

# Apply the new tfplan file
terraform apply "umatter.tfplan" && \

# Check the cluster arn after making the AWS EKS cluster
terraform_cluster_arn=$(terraform output -raw cluster_arn) && \

# if the current context of the local ~/.kube/config is not configured
# or the current context is not identical with the Terraform cluster arn,
# then update/switch the the cluster to the kubectl for the AWS EKS cluster
if [[ $(kubectl config current-context) -ne 0 ]] || \
    [[ $(kubectl config current-context) != $terraform_cluster_arn ]]; then
    echo "Switching to cluster"

    aws eks update-kubeconfig \
        --region $(terraform output -raw region) \
        --name $(terraform output -raw cluster_name)

    echo "Cluster switched"
fi
echo "The current context of the local machine: $(kubectl config current-context)"

# Create a new namespace if not exists
if ! kubectl get namespace final > /dev/null 2>&1; then
    echo "Creating namespace final"
    kubectl create ns final && \
fi

# Apply k8s yaml files
kubectl apply -f ./manifests && \

# Install metric servers
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml && \
kubectl get deployment metrics-server -n kube-system
