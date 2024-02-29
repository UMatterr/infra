#!/bin/bash
set -e

kubectl delete deployment django -n final

kubectl delete configmap django-config -n final

kubectl apply -f manifests/configmap.yaml
