locals {
  db_port = var.db_engine == "mysql" ? 3306 : 5432
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.database_subnet_ids
  tags       = { Name = "${var.name}-subnet-group" }
}

resource "aws_security_group" "db" {
  name        = "${var.name}-sg"
  description = "Allow database access only from EKS/backend security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Database access from EKS/backend security group only"
    from_port       = local.db_port
    to_port         = local.db_port
    protocol        = "tcp"
    security_groups = [var.allowed_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name}-sg" }
}

resource "aws_db_instance" "this" {
  identifier              = var.name
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = local.db_port
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  publicly_accessible     = false
  storage_encrypted       = true
  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = true

  tags = { Name = var.name }
}
