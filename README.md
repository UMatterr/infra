# Buile a bastion host and EKS cluster

## Prerequisites
* a EC2 instance
    - make an AWS EC2 instance as you need
    - The instance created in this repository is using:
        * t2.medium
        * ubuntu 20.04
        * gp2 20 GiB
        * security group for port 22
        * user-data: setup-linux.sh
* Terraform cloud account
* AWS access key and AWS secret key
* an AWS region you prefer (in the repository, used ap-northeast-2)

## Set up a EKS cluster
```bash
# To double-check docker, kubectl, eksctl, aws cli, and terraform are installed well
docker version
kubectl version
eksctl version
aws --version
terraform version

# Set up terraform cloud
# After executing the following command, read and follow the instructions
terraform login

# Set up AWS
# After executing the command, enter the AWS access key and AWS secret key etc.
aws configure

# Set up env for terraform secret
export TF_VAR_db_password=custompassword

# Initialize terraform
./tf_apply.sh
```
