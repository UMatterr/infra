#!/bin/bash
set -e

if [ -z "$(echo $TF_VAR_db_password)" ]; then
    echo Please set the db password
    exit 1
fi

cd terraform
echo Current folder: $(pwd)

if $(ls -d .tfplan/) > /dev/null 2>&1; then
    mkdir .tfplan
else
    echo .tfplan folder exists
fi

if $(ls -d tmp/) > /dev/null 2>&1; then
    mkdir tmp
else
    echo tmp folder exists
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

# # Apply the new tfplan file
terraform apply "umatter.tfplan"

cd ~/infra
echo Current folder: $(pwd)
