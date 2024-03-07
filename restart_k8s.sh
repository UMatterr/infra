#!/bin/bash
set -e

kubectl delete ns final

# Apply k8s
./apply_k8s.sh
