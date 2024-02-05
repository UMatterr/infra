resource "aws_db_instance" "master" {
  identifier            = "${var.db_name}-master"
  instance_class        = var.db_instance_class
  engine                = var.db_engine
  engine_version        = var.db_engine_version
  username              = var.db_username
  password              = var.db_password
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage

  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  parameter_group_name    = aws_db_parameter_group.db_pg.name
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az = true
  backup_retention_period = 1
}

resource "aws_db_instance" "replica" {
  identifier     = "${var.db_name}-replica"
  instance_class = var.db_instance_class

  replicate_source_db    = aws_db_instance.master.identifier
  multi_az = true
  apply_immediately      = true
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.db_pg.name
}

resource "aws_db_parameter_group" "db_pg" {
  name   = "${var.db_name}-pg"
  family = var.db_family

  parameter {
    name  = "log_connections"
    value = "1"
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
  name   = "${var.db_name}-rds"
  vpc_id = var.db_vpc_id

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