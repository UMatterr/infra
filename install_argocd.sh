#!/bin/bash

set -e

# Check whether ArgoCD is installed
if $(kubectl get ns argocd) > /dev/null 2>&1; then
    echo ArgoCD is already installed
    kubectl get all -n argocd
    exit 0
fi

# Create namespace for ArgoCD
kubectl create ns argocd

# Apply ArgoCD stable version
kubectl apply \
    -n argocd \
    -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/ha/install.yaml

# Install ArgoCD CLI
if [ -z $(which argocd) ]; then
    curl -sSL -o ./argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    chmod +x ./argocd
    sudo mv -v ./argocd /usr/local/bin
    kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
else
    echo ArgoCD CLI is already installed
fi
