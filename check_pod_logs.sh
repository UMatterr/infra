#!/bin/bash
kubectl logs -n final $(kubectl get pod -n final | grep django | awk -F' ' '{printf $1}')
