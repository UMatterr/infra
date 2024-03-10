#!/bin/bash
set -e

# Check the env json file
if ! ls env.json > /dev/null 2>&1; then
    echo No env json file exists
    exit 1
fi

# Export environment variables
echo export AWS_ECR_HOST=$(jq -r '.AWS_ECR_HOST' env.json) >> ~/.bashrc
echo export AWS_ECR_REPO_URL=$(jq -r '.AWS_ECR_REPO_URL' env.json) >> ~/.bashrc
echo export TF_VAR_db_username=$(jq -r '.TF_VAR_db_username' env.json) >> ~/.bashrc
echo export TF_VAR_db_password=$(jq -r '.TF_VAR_db_password' env.json) >> ~/.bashrc
echo export TF_VAR_admin_rds_password=$(jq -r '.TF_VAR_admin_rds_password' env.json) >> ~/.bashrc
echo export TF_VAR_admin_rds_username=$(jq -r '.TF_VAR_admin_rds_username' env.json) >> ~/.bashrc

# Update environment variables
source ~/.bashrc
