#!/bin/bash
set -e

kubectl get all -n final -o wide

kubectl get ing -n final -o wide
