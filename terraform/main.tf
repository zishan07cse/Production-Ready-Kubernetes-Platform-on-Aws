locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "./modules/vpc"

  name                  = local.name_prefix
  vpc_cidr              = var.vpc_cidr
  azs                   = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
}

module "ecr" {
  source = "./modules/ecr"

  repositories = var.ecr_repositories
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  cluster_name          = var.cluster_name
  log_retention_in_days = var.log_retention_in_days
}

module "eks" {
  source = "./modules/eks"

  cluster_name                    = var.cluster_name
  kubernetes_version              = var.kubernetes_version
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnet_ids
  node_instance_types             = [var.node_instance_type]
  node_desired_size               = var.node_desired_size
  node_min_size                   = var.node_min_size
  node_max_size                   = var.node_max_size
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  enabled_cluster_log_types       = var.enabled_cluster_log_types

  depends_on = [module.cloudwatch]
}

module "rds" {
  source = "./modules/rds"

  name                     = "${local.name_prefix}-db"
  vpc_id                   = module.vpc.vpc_id
  database_subnet_ids       = module.vpc.database_subnet_ids
  allowed_security_group_id = module.eks.cluster_security_group_id
  db_engine                = var.db_engine
  db_engine_version        = var.db_engine_version
  db_name                  = var.db_name
  db_username              = var.db_username
  db_password              = var.db_password
  db_instance_class        = var.db_instance_class
  allocated_storage        = var.db_allocated_storage
  backup_retention_period  = var.db_backup_retention_period
  multi_az                 = var.db_multi_az
  deletion_protection      = var.db_deletion_protection
}
