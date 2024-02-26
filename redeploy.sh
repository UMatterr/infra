#!/bin/bash
set -e

kubectl delete deployment django -n final

kubectl apply -f manifests/
