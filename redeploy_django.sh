#!/bin/bash

kubectl delete deployment django -n final

kubectl delete secret django-secret -n final

kubectl delete configmap django-config -n final

kubectl apply -f manifests/
