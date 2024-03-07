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

## Apply k8s in EKS
All the k8s yaml files are in `manifests` folder, but you should create a `secret.yaml` in the `manifests` folder
```yaml
# Please update data or use template file, secret_tpl.yaml
apiVersion: v1
kind: Secret
metadata:
  name: django-secret
  namespace: final
type: Opaque
stringData:
  DJANGO_SECRET_KEY: "custom"
  DJANGO_SUPERUSER_EMAIL: "custom"
  DJANGO_SUPERUSER_PASSWORD: "custom"
  POSTGRES_USER: "custom"
  POSTGRES_PASSWORD: "custom"
  POSTGRES_DB: "custom"
  POSTGRES_HOST: "custom"
  POSTGRES_PORT: "custom"
  SUB_POSTGRES_USER: "custom"
  SUB_POSTGRES_PASSWORD: "custom"
  SUB_POSTGRES_DB: "custom"
  SUB_POSTGRES_HOST: "custom"
  SUB_POSTGRES_PORT: "custom"
  AUTH_KAKAO_CLIENT_ID: "custom"
  AUTH_KAKAO_CLIENT_SECRET: "custom"
  AUTH_KAKAO_SECRET: "custom"
  AUTH_KAKAO_SCOPE: "custom"
  AUTH_KAKAO_REDIRECT_URI_PATH: "custom"
```

```bash
# All the k8s yaml files are in manifests folder
# 
./apply_k8s.sh
```

## Attach to a pod running in EKS
```bash
./attach_k8s.sh

# or enter an number less than equal to the number of pods is running
./attach_k8s.sh 1
```

## Check logs from a pod running in EKS
```bash
./check_pod_logs.sh

# or enter an number less than equal to the number of pods is running
./check_pod_logs.sh 1
```

## Remove all resources from AWS
```
./rm_all.sh
```
