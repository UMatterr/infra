#!/bin/bash
set -e

#################### terraform settings ###################
# for ubuntu/debian, amd64
sudo apt-get update

sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform

terraform version
#################### terraform settings ###################


#################### aws cli settings ###################
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

sudo apt install -y zip jq

unzip awscliv2.zip

sudo ./aws/install

export PATH=/usr/local/bin:$PATH

source ~/.bashrc

aws --version

rm -rf ./aws awscliv2.zip
#################### aws cli settings ###################


#################### kubectl settings ###################
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.5/2024-01-04/bin/linux/amd64/kubectl

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.5/2024-01-04/bin/linux/amd64/kubectl.sha256

sha256sum -c kubectl.sha256

openssl sha1 -sha256 kubectl

sudo mv -v ./kubectl /usr/local/bin/kubectl

sudo chmod +x /usr/local/bin/kubectl

kubectl version --client

rm kubectl.sha256
#################### kubectl settings ###################


#################### eksctl settings ###################
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH="amd64"
PLATFORM=$(uname -s)_$ARCH
echo $PLATFORM

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | \
    grep $PLATFORM | \
    sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp

rm eksctl_$PLATFORM.tar.gz

sudo mv -v /tmp/eksctl /usr/local/bin

eksctl version
#################### eksctl settings ###################


#################### docker settings ###################
# Add Docker's official GPG key:
sudo apt-get update

sudo apt-get install ca-certificates curl

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# to use docker command as root user
sudo usermod -aG docker $USER
newgrp docker
#################### docker settings ###################


#################### minikube settings ###################
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube version
rm minikube-linux-amd64
#################### minikube settings ###################


#################### Git Repository settings ###################
# git clone https://github.com/UMatterr/admin
# git clone https://github.com/UMatterr/infra
# git clone https://github.com/UMatterr/server
#################### Git Repository settings ###################


#################### AWS ECR settings ###################
# aws ecr get-login-password \
#     --region ap-northeast-2 | \
#     docker login \
#     --username AWS \
#     --password-stdin <AWS_ECR_HOST>
#################### AWS ECR settings ###################
