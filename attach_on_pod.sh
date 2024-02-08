#!/bin/bash
kubectl exec -it -n final $(kubectl get pod -n final | grep django | awk -F' ' '{printf $1}') -- bash
