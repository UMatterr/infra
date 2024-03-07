#!/bin/bash
set -e

if ls -d .tfplan/ > /dev/null 2>&1; then
    echo .tfplan folder exists
else
    mkdir .tfplan
fi

if ls -d tmp/ > /dev/null 2>&1; then
    echo tmp folder exists
else
    mkdir tmp
fi

# Initialize terraform
terraform init

# Format the tf files
terraform fmt -recursive

# Prepare a tfplan file
terraform plan -out=bastion.tfplan

count=$(ls .tfplan/ | wc -w)
count=`expr $count + 1`
cp -v bastion.tfplan .tfplan/bastion_v${count}.tfplan

# # Apply the new tfplan file
terraform apply "bastion.tfplan"
