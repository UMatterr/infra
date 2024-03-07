#!/bin/bash

if $(kubectl get deployment django -n final); then
    kubectl delete deployment django -n final
fi

if $(kubectl get secret django-secret -n final); then
    kubectl delete secret django-secret -n final
fi

if $(kubectl get configmap django-config -n final); then
    kubectl delete configmap django-config -n final
fi

kubectl apply -f ./manifests
