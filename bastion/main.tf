data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  sg_name  = "${var.bastion_name}-sg"
  key_name = "${var.bastion_name}-key"
}

resource "aws_key_pair" "key" {
  key_name   = local.key_name
  public_key = file(var.public_key_path)

  tags = {
    description = "Key pair for bastion host"
  }

}

resource "aws_security_group" "sg" {
  name        = local.sg_name
  vpc_id      = var.vpc_id
  description = "Security group for bastion host"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"

  key_name = aws_key_pair.key.key_name

  subnet_id                   = var.bastion_subnet_id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true

  user_data = file(var.user_data_path)

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  depends_on = [
    aws_security_group.sg,
    aws_key_pair.key
  ]
}
