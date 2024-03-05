#!/bin/bash
set -e

if [ -z "$(echo $TF_VAR_db_password)" ]; then
    echo Please set the db password
    exit 1
fi

# Initialize terraform
terraform init

# Format the tf files
terraform fmt -recursive

# Prepare a tfplan file
terraform plan -out=umatter.tfplan

count=$(ls .tfplan/ | wc -w)
count=`expr $count + 1`
cp -v umatter.tfplan .tfplan/umatter_v${count}.tfplan

# Apply the new tfplan file
terraform apply "umatter.tfplan"
