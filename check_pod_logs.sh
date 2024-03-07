#!/bin/bash
set -e

idx=$1
if [ -z "${idx}" ]; then
    echo Any index is not given. use a default value 1;
    idx=1
fi

pods=$(kubectl get pod -n final | \
        grep Running | \
        grep django | \
        wc -l)
if [ $pods -lt $idx ]; then
    echo Invalid index ${idx};
    exit 1
fi

kubectl logs \
    -n final \
    $(kubectl get pod -n final | \
        grep Running | \
        grep django | \
        sed -n ${idx}p | \
        awk -F' ' '{printf $1}')
