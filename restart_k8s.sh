#!/bin/bash
kubectl delete ns final && \

current_context=$(kubectl config current-context) && \
terraform_cluster_arn=$(terraform output -raw cluster_arn)

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

if ! kubectl get namespace final > /dev/null 2>&1; then
    echo "Creating namespace final"
    kubectl create ns final
fi

# Apply k8s service and ingress yaml files
kubectl apply -f ./manifests/service.yaml && \
kubectl apply -f ./manifests/ingress.yaml && \

# Update alb url
url=$(kubectl get ing django-alb -n final | tail -n 1 | awk -F' ' '{printf $4}')
while [ -z "${url}" ] || [ "${url}" == "80" ]; do
    echo Not found alb url
    kubectl describe ing django-alb -n final
    sleep 5
    url=$(kubectl get ing django-alb -n final | tail -n 1 | awk -F' ' '{printf $4}')
done
echo Update the alb ulr: $url

sed -E -i.bak1 "s|DJANGO_BASE_URL: http://[0-9a-zA-Z\.-]+|DJANGO_BASE_URL: http://${url}|g" ./manifests/configmap.yaml && \
# sed -E -i.bak2 "s|DJANGO_ALLOWED_HOSTS: https://d11k7zd8ekz887.cloudfront.net http://[0-9a-zA-Z\.-]+|DJANGO_ALLOWED_HOSTS: https://d11k7zd8ekz887.cloudfront.net http://${url}|g" ./manifests/configmap.yaml && \

mv -v manifests/*.yaml.bak* tmp/ && \

# Apply configmap and deployment yaml files
kubectl apply -f ./manifests/configmap.yaml && \
kubectl apply -f ./manifests/deployment.yaml

