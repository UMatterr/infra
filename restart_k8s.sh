#!/bin/bash
kubectl delete ns final && \

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

if ! kubectl get namespace final > /dev/null 2>&1; then
    echo "Creating namespace final"
    kubectl create ns final
    echo "Created namespace final"
fi

# Apply k8s service and ingress yaml files
kubectl apply -f ./manifests/service.yaml
kubectl apply -f ./manifests/ingress.yaml

# Update alb url
url=$(kubectl get ing django-alb -n final | tail -n 1 | awk -F' ' '{printf $4}')
echo $url
while [ -z "${url}" ] || \
    [ "${url}" == "80" ]; do

    echo Not found alb url
    kubectl describe ing django-alb -n final
    sleep 5
    url=$(kubectl get ing django-alb -n final | tail -n 1 | awk -F' ' '{printf $4}')

done
echo Update the alb url: $url

# Apply configmap and deployment yaml files
# kubectl apply -f ./manifests/configmap.yaml
# kubectl apply -f ./manifests/deployment.yaml
kubectl apply -f ./manifests/

# Copy the template json file for updating the Route 53 record value for the new ALB
cp -v route_53_tpl.json route_53.json

# Find the hosted zone IDs for ALB and Route 53
hz_id=$(aws route53 list-hosted-zones | jq -r '.["HostedZones"][0]["Id"]')
alb_name_id=$(echo ${url} | cut -d'-' -f3)
alb_hz_id=$(aws elbv2 describe-load-balancers --names k8s-node1-${alb_name_id} | jq -r '.["LoadBalancers"][0]["CanonicalHostedZoneId"]')
echo "Route 53 Hosted zone id: ${hz_id}"
echo "ALB name id: ${alb_name_id}"
echo "ALB Hosted zone id: ${alb_hz_id}"
# if [ -z "${hz_id}" ] || \
#     [ -z "${alb_name_id}" ] || \
#     [ -z "${alb_hz_id}" ]; then
#     echo "Not all data is ready"
#     exit 1
# fi

# Update the json file
sed -E -i'' "s|ALB_HOSTED_ZONE_ID|${alb_hz_id}|g" ./route_53.json
sed -E -i'' "s|ALB_DOMAIN|${url}|g" ./route_53.json
echo Updated route_53.json
# cat ./route_53.json

# Update the Route 53 record
aws route53 change-resource-record-sets \
    --hosted-zone-id ${hz_id} \
    --change-batch file://./route_53.json
