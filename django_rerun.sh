#!/bin/bash
kubectl delete deployment django -n final && \
kubectl delete configmap django-config -n final && \
kubectl apply -f manifests/deployment.yaml && \
kubectl apply -f manifests/configmap.yaml
