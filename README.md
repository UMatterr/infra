# Buile a bastion host and EKS cluster

## Prerequisites
* a EC2 instance
    - make an AWS EC2 instance as you need
    - The instance created in this repository is using:
        * t2.small
        * ubuntu 20.04
        * gp2 20 GiB
        * security group for port 22
        * user-data: setup-linux.sh

