output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID."
  value       = module.eks.cluster_security_group_id
}

output "vpc_id" {
  description = "VPC/network ID."
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs for EKS."
  value       = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  description = "Private database subnet IDs for RDS."
  value       = module.vpc.database_subnet_ids
}

output "ecr_repository_urls" {
  description = "ECR registry/repository URLs."
  value       = module.ecr.repository_urls
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group for EKS control plane logs."
  value       = module.cloudwatch.log_group_name
}

output "database_endpoint" {
  description = "Private RDS endpoint."
  value       = module.rds.db_endpoint
}

output "database_security_group_id" {
  description = "RDS security group ID."
  value       = module.rds.db_security_group_id
}
