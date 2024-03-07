resource "aws_db_instance" "master" {
  db_name               = var.db_name
  identifier            = "${var.db_name}-master"
  instance_class        = var.db_instance_class
  engine                = var.db_engine
  engine_version        = var.db_engine_version
  username              = var.db_username
  password              = var.db_password
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.db_pg.name

  apply_immediately       = true
  backup_retention_period = 1
  deletion_protection     = false
  multi_az                = true
  publicly_accessible     = false
  skip_final_snapshot     = true
  storage_encrypted       = false
}

resource "aws_db_instance" "replica" {
  identifier            = "${var.db_name}-replica"
  instance_class        = var.db_instance_class
  port                  = var.db_port
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage

  parameter_group_name   = aws_db_parameter_group.db_pg.name
  replicate_source_db    = aws_db_instance.master.identifier
  vpc_security_group_ids = [aws_security_group.rds.id]

  apply_immediately       = true
  backup_retention_period = 0
  deletion_protection     = false
  multi_az                = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  storage_encrypted       = false
}

resource "aws_db_parameter_group" "db_pg" {
  name   = "${var.db_name}-pg"
  family = var.db_family

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "timezone"
    value = "Asia/Seoul"
  }

  parameter {
    name  = "default_transaction_isolation"
    value = "repeatable read"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.db_name}-subnets"
  subnet_ids = var.db_subnets

  tags = {
    Name = var.db_name
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.db_name}-rds"
  vpc_id      = var.db_vpc_id
  description = "PostgreSQL security group with multi-AZ replica"

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_name}-rds"
  }
}