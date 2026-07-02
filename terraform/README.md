# Task 5: Terraform EKS Provisioning

## Overview

This folder shows how to provision and maintain an AWS EKS platform using Terraform.

The design is module-based and uses only custom local Terraform modules. No third-party or ready-made Terraform modules are used.

## Folder Structure

```text
terraform/
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md
└── modules/
    ├── vpc/
    ├── ecr/
    ├── cloudwatch/
    ├── eks/
    └── rds/
```

## What This Terraform Includes

- VPC
- Public subnets for internet-facing ALB/Ingress
- Private subnets for EKS worker nodes
- Private database subnets for RDS
- Internet Gateway
- NAT Gateway
- Route tables
- Amazon ECR repositories for frontend and backend images
- Amazon EKS cluster
- EKS managed node group
- CloudWatch log group for EKS control plane logs
- Private Amazon RDS database
- Security group rules for EKS/backend-to-database access only

## Important Variables

The following variables are included in `variables.tf`:

```text
environment
aws_region
cluster_name
kubernetes_version
node_instance_type
node_desired_size
node_min_size
node_max_size
vpc_cidr
public_subnet_cidrs
private_subnet_cidrs
database_subnet_cidrs
db_engine
db_name
db_username
db_password
```

The `db_password` variable is sensitive and must not be committed.

Set it with an environment variable:

```bash
export TF_VAR_db_password="REPLACE_WITH_SECURE_PASSWORD"
```

PowerShell:

```powershell
$env:TF_VAR_db_password="REPLACE_WITH_SECURE_PASSWORD"
```

## Commands

```bash
cd terraform
terraform init
terraform validate
terraform plan
```

Only apply if you are ready to create AWS resources and accept AWS cost:

```bash
terraform apply
```

Destroy resources when finished:

```bash
terraform destroy
```

## Remote Backend and State Locking

For real team use, store Terraform state remotely:

```text
S3 bucket for Terraform state
DynamoDB table for state locking
Bucket versioning enabled
Server-side encryption enabled
Separate state key per environment
```

A sample backend block is included as comments in `provider.tf`.

Do not commit:

```text
terraform.tfstate
terraform.tfstate.backup
.terraform/
secret tfvars files
```

## Dev, Staging, and Production Separation

Use separate environments:

```text
dev
staging
production
```

Each environment should have separate:

- Terraform state
- VPC
- EKS cluster
- RDS database
- Variable values
- CI/CD approval gates

## Safe EKS Upgrade Strategy

1. Upgrade dev first.
2. Review the Terraform plan.
3. Upgrade the EKS control plane.
4. Upgrade managed node groups after the control plane.
5. Use rolling updates.
6. Verify nodes, pods, services, ingress, and logs.
7. Promote the same process to staging and production.

## Add or Resize Node Pools

Resize the default node group using:

```text
node_desired_size
node_min_size
node_max_size
node_instance_type
```

For more workloads, add additional custom node group resources or extend the local `eks` module.

## Avoid Downtime During Cluster Changes

Use:

- At least 2 replicas for apps
- Readiness probes
- Rolling deployments
- Managed node group rolling updates
- Multiple Availability Zones
- PodDisruptionBudget in production
- Terraform plan review before apply

## Secrets Outside Terraform Code

Do not hardcode secrets in `.tf` files.

Use:

- GitHub Actions Secrets
- AWS Secrets Manager
- AWS Systems Manager Parameter Store
- Environment variable `TF_VAR_db_password`
- External Secrets Operator for Kubernetes

## What to Check If Terraform Wants to Recreate the Cluster

Check:

1. Cluster name change
2. VPC ID change
3. Private subnet ID change
4. Immutable EKS field change
5. Wrong Terraform backend/state
6. Wrong environment selected
7. Manual AWS changes causing drift
8. Provider version behavior change
9. Module resource name change
10. Whether node group replacement is enough instead of cluster replacement

Never approve destructive changes until the reason is understood.

## Cost Warning

This Terraform can create paid AWS resources such as EKS, EC2 nodes, NAT Gateway, RDS, and CloudWatch logs. For assessment review, it can be submitted as Infrastructure as Code without applying it to AWS unless a live deployment is specifically required.
