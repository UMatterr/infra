#!/bin/bash
set -e

kubectl logs -n final $(kubectl get pod -n final | grep Running | grep django | head -n 1 | awk -F' ' '{printf $1}')
