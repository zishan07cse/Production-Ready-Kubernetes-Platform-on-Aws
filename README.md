# DevOps Assessment - Task 1, Task 2, Task 3, Task 4, Task 5 Task 6 and Task 7

This repository contains the completed setup for **Task 1**, **Task 2**, **Task 3**, **Task 4**,**Task 5**,**Task 6** and **Task 7** of the DevOps Engineer Assessment.

It includes:

- A separate backend API application
- A separate frontend application
- Dockerfiles for both applications
- Docker Compose to run both containers locally
- Backend endpoints required by the assessment
- GitHub Actions CI/CD pipeline
- Docker image build and tagging
- Mock Amazon ECR image push
- Mock Amazon EKS/Kubernetes deployment
- GitHub release tag creation
- Safe secrets management explanation
- Kubernetes manifests for frontend and backend
- Separate Kubernetes deployments and services
- AWS EKS-style Ingress for external frontend access
- Backend ConfigMap and Secret example
- Kubernetes readiness and liveness probes
- Kubernetes resource requests and limits
- Private database connectivity design
- Private subnet and private DNS explanation
- Security group/firewall rules for backend-only database access
- Secure database credential storage using Kubernetes Secret and production secret manager guidance
- Database public access verification steps
- Module-based Terraform for AWS EKS provisioning
- Custom Terraform modules only, without third-party ready-made modules
- VPC, public subnet, private subnet, and database subnet design
- EKS cluster and managed node group provisioning design
- Amazon ECR repository provisioning design
- CloudWatch logging and monitoring design
- Private RDS connectivity through Terraform
- Terraform remote backend and state locking explanation
- Terraform maintenance, EKS upgrade, node resizing, and downtime prevention guidance

---

# Project Structure

```text
devops-assessment/
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   ├── src/
│   │   ├── app.js
│   │   └── server.js
│   └── tests/
│       └── app.test.js
├── frontend/
│   ├── Dockerfile
│   ├── package.json
│   ├── index.html
│   ├── app.js
│   └── nginx.conf
├── .github/
│   └── workflows/
│       └── deploy.yml
├── k8s/
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── ingress.yaml
│   ├── backend-configmap.yaml
│   └── backend-secret-example.yaml
├── docs/
│   ├── task-2-ci-cd.md
│   ├── task-3-kubernetes.md
│   └── task-5-terraform.md
│   ├── troubleshooting.md
│   └── future-improvements.md
│   
├── terraform/
│   ├── provider.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── README.md
│   └── modules/
│       ├── vpc/
│       ├── ecr/
│       ├── cloudwatch/
│       ├── eks/
│       └── rds/
├── docker-compose.yml
├── .dockerignore
├── .gitignore
└── README.md
```

---

# Task 1: Frontend, Backend, Docker, and Docker Compose

## Task 1 Overview

Task 1 contains two separate applications:

1. **Backend API application**
2. **Frontend web application**

The backend and frontend run in separate Docker containers using Docker Compose.

---

## Backend Requirements

The backend API runs on port **8080** and provides the following required endpoints:

| Endpoint  | Response                 |
| --------- | ------------------------ |
| `/`       | `Application is running` |
| `/health` | `{ "status": "ok" }`     |

---

## Frontend Requirements

The frontend:

- Runs as a separate Docker container
- Serves a simple web page through Nginx
- Calls the backend API through an internal Docker Compose network
- Uses Nginx proxy path `/api/health` to reach the backend container

---

## Requirements

Install Docker and Docker Compose.

Check Docker:

```bash
docker --version
docker compose version
```

---

## Run the Project Locally

From the root folder:

```bash
docker compose up -d --build
```

Check running containers:

```bash
docker compose ps
```

Expected containers:

```text
backend-api
frontend-app
```

---

## Test Backend

Test the root endpoint:

```bash
curl http://localhost:8080
```

Expected output:

```text
Application is running
```

Test the health endpoint:

```bash
curl http://localhost:8080/health
```

Expected output:

```json
{ "status": "ok" }
```

On Windows PowerShell, use:

```powershell
curl.exe http://localhost:8080
curl.exe http://localhost:8080/health
```

---

## Test Frontend

Open in browser:

```text
http://localhost:3000
```

Click the **Check Backend Health** button.

Expected response:

```json
{ "status": "ok" }
```

You can also test the frontend-to-backend proxy:

```bash
curl http://localhost:3000/api/health
```

Expected output:

```json
{ "status": "ok" }
```

---

## Stop the Project

```bash
docker compose down
```

---

## Run Backend Tests Locally

If Node.js is installed locally:

```bash
cd backend
npm install
npm test
```

The backend tests validate:

- `/` returns `Application is running`
- `/health` returns `{ "status": "ok" }`

---

## Task 1 Requirement Checklist

| Requirement                                                       | Status    |
| ----------------------------------------------------------------- | --------- |
| Frontend application created                                      | Completed |
| Backend API application created                                   | Completed |
| Backend `/` endpoint returns `Application is running`             | Completed |
| Backend `/health` endpoint returns `{ "status": "ok" }`           | Completed |
| Backend runs on port `8080`                                       | Completed |
| Frontend runs as a separate container                             | Completed |
| Frontend calls backend API                                        | Completed |
| `frontend/` folder exists                                         | Completed |
| `backend/` folder exists                                          | Completed |
| `docker-compose.yml` exists                                       | Completed |
| `.dockerignore` exists                                            | Completed |
| Project runs using `docker compose up -d`                         | Completed |
| Backend testable using `curl http://localhost:8080`               | Completed |
| Backend health testable using `curl http://localhost:8080/health` | Completed |

---

# Task 2: CI/CD Pipeline

## Task 2 Overview

Task 2 is implemented using **GitHub Actions**.

The CI/CD workflow file is located at:

```text
.github/workflows/deploy.yml
```

The pipeline follows an AWS DevOps style workflow using:

- GitHub Actions for CI/CD
- Docker for image build
- Amazon ECR image naming format
- Mock Amazon ECR image push
- Mock Amazon EKS/Kubernetes deployment
- GitHub release tag creation

The ECR push and EKS deployment are mocked to avoid unnecessary AWS cost during assessment review.

---

## Pipeline Name

```text
CI/CD Pipeline - Docker, ECR Mock, EKS Mock
```

---

## Pipeline Triggers

The pipeline runs on:

- Push to `main`
- Pull request to `main`
- Manual workflow dispatch

Workflow trigger configuration:

```yaml
on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  workflow_dispatch:
```

---

## Pipeline Permissions

The workflow uses:

```yaml
permissions:
  contents: write
```

This is required because the workflow creates a GitHub release tag.

---

## Pipeline Environment Variables

The workflow uses the following environment variables:

```yaml
env:
  AWS_REGION: us-east-1
  ECR_BACKEND_REPOSITORY: devops-assessment-backend
  ECR_FRONTEND_REPOSITORY: devops-assessment-frontend
```

These values are used to prepare mock Amazon ECR image names.

---

## Pipeline Steps

### 1. Checkout Code

The pipeline checks out the repository code using:

```yaml
- name: Checkout code
  uses: actions/checkout@v4
```

### 2. Setup Node.js

The pipeline sets up Node.js version 20:

```yaml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: 20
```

This ensures that backend and frontend dependency installation and test commands run in a consistent Node.js environment.

### 3. Set Docker Image Tag

The pipeline creates a Docker image tag using the Git commit SHA:

```bash
IMAGE_TAG="sha-${GITHUB_SHA::7}"
```

Example image tag:

```text
sha-a1b2c3d
```

This avoids using the `latest` tag and makes every build traceable to a Git commit.

### 4. Install Backend Dependencies

The pipeline installs backend dependencies:

```yaml
- name: Install backend dependencies
  working-directory: backend
  run: npm install
```

### 5. Run Backend Tests

The pipeline runs backend tests:

```yaml
- name: Run backend tests
  working-directory: backend
  run: npm test
```

The tests confirm that:

- `/` returns `Application is running`
- `/health` returns `{ "status": "ok" }`

### 6. Install Frontend Dependencies

The pipeline installs frontend dependencies:

```yaml
- name: Install frontend dependencies
  working-directory: frontend
  run: npm install
```

The frontend is static, so the `frontend/package.json` contains simple smoke test and build scripts.

### 7. Run Frontend Tests

The pipeline runs the frontend test script:

```yaml
- name: Run frontend tests
  working-directory: frontend
  run: npm test
```

For this static frontend, the test is a smoke test that confirms the frontend CI step exists and passes.

### 8. Build Frontend Static Assets

The pipeline runs the frontend build script:

```yaml
- name: Build frontend static assets
  working-directory: frontend
  run: npm run build
```

For the static frontend, this confirms that the build stage is included in the CI/CD flow.

### 9. Build Backend Docker Image

The backend Docker image is built using:

```bash
docker build -t backend:${IMAGE_TAG} ./backend
```

### 10. Build Frontend Docker Image

The frontend Docker image is built using:

```bash
docker build -t frontend:${IMAGE_TAG} ./frontend
```

### 11. Tag Docker Images for Amazon ECR

The workflow tags both Docker images using Amazon ECR style image names.

Backend image format:

```text
<aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/devops-assessment-backend:<image-tag>
```

Frontend image format:

```text
<aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/devops-assessment-frontend:<image-tag>
```

If the GitHub secret `AWS_ACCOUNT_ID` is not configured, the workflow uses a mock account ID:

```text
000000000000
```

This allows the workflow to run without real AWS credentials.

### 12. Mock Push Images to Amazon ECR

The pipeline does not push images to a real ECR registry.

Instead, it prints the commands that would be used in a real AWS deployment:

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
docker push <backend-ecr-image>
docker push <frontend-ecr-image>
```

This satisfies the mock push option and avoids AWS cost.

### 13. Create GitHub Release Tag

On push to `main`, the workflow creates a GitHub tag.

Example tag:

```text
task2-a1b2c3d
```

This satisfies the release tag requirement.

### 14. Mock Deploy Both Apps to Kubernetes/EKS

The workflow prints the commands that would be used to deploy to Amazon EKS:

```bash
aws eks update-kubeconfig --name <eks-cluster-name> --region us-east-1
kubectl set image deployment/backend backend=<backend-ecr-image> -n default
kubectl set image deployment/frontend frontend=<frontend-ecr-image> -n default
kubectl rollout status deployment/backend -n default
kubectl rollout status deployment/frontend -n default
```

This satisfies the Kubernetes mock deployment requirement without creating AWS resources.

---

## Why ECR Push and EKS Deploy Are Mocked

The pipeline uses mock AWS steps because creating and running real AWS resources can create cost.

A real AWS deployment would require:

- Amazon ECR repositories
- Amazon EKS cluster
- EKS worker nodes
- IAM permissions
- Kubernetes manifests
- AWS Load Balancer Controller or another ingress solution

To avoid unnecessary cloud cost during assessment review, this repository includes the correct CI/CD logic but keeps AWS push and deployment steps mocked.

---

## Secrets Management

No real secrets are committed to this repository.

For a real production deployment, secrets should be stored securely using:

- GitHub Actions Secrets
- AWS Secrets Manager
- AWS IAM roles
- GitHub OIDC for AWS authentication

---

## GitHub Secrets for CI/CD

The following values should be stored in GitHub Secrets for a real AWS pipeline:

```text
AWS_ACCOUNT_ID
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
EKS_CLUSTER_NAME
ECR_BACKEND_REPOSITORY
ECR_FRONTEND_REPOSITORY
```

A better production approach is to use **GitHub OIDC with an AWS IAM role** instead of long-lived AWS access keys.

---

## AWS Secrets Manager for Application Secrets

Application-level secrets should be stored in AWS Secrets Manager, such as:

```text
DB_USERNAME
DB_PASSWORD
DB_HOST
DB_NAME
API_KEYS
```

Kubernetes can consume secrets securely through tools such as:

- External Secrets Operator
- AWS Secrets and Configuration Provider
- Sealed Secrets
- Kubernetes Secrets for non-production examples only

---

## Do Not Commit Secrets

The following must never be committed to GitHub:

```text
AWS access keys
Database passwords
API tokens
Private keys
Webhook URLs
.env files
Terraform state files
```

---

## Real AWS Deployment Plan

To convert this mock pipeline into a real AWS deployment:

1. Create Amazon ECR repositories.
2. Create an Amazon EKS cluster.
3. Configure IAM role or GitHub Secrets for AWS authentication.
4. Login to Amazon ECR from GitHub Actions.
5. Push backend and frontend Docker images to ECR.
6. Update kubeconfig for EKS.
7. Apply Kubernetes manifests.
8. Update Kubernetes deployments with new image tags.
9. Verify rollout status.
10. Monitor logs and application health.

---

## Task 2 Requirement Checklist

| Requirement                                   | Status                         |
| --------------------------------------------- | ------------------------------ |
| Checkout code                                 | Completed                      |
| Setup Node.js                                 | Completed                      |
| Install backend dependencies                  | Completed                      |
| Run backend tests                             | Completed                      |
| Install frontend dependencies                 | Completed                      |
| Run frontend tests                            | Completed                      |
| Build frontend static assets                  | Completed                      |
| Build backend Docker image                    | Completed                      |
| Build frontend Docker image                   | Completed                      |
| Tag backend Docker image                      | Completed                      |
| Tag frontend Docker image                     | Completed                      |
| Push images to ECR or mock push               | Completed with mock ECR push   |
| Create GitHub release or release tag          | Completed                      |
| Deploy both apps to Kubernetes or mock deploy | Completed with mock EKS deploy |
| Explain safe secrets storage                  | Completed                      |

---

# Task 3: Kubernetes Manifests

## Task 3 Overview

Task 3 adds Kubernetes manifests under the `k8s/` folder.

The manifests are designed for an AWS EKS-style Kubernetes deployment and include:

- Separate frontend and backend Deployments
- Separate frontend and backend Services
- AWS ALB Ingress to expose the frontend externally
- Internal-only backend Service
- Backend ConfigMap
- Backend Secret example for database credentials
- Readiness probes
- Liveness probes
- Resource requests and limits
- Non-`latest` image tags

The Kubernetes files are written so they can be reviewed without creating real AWS resources.

---

## Kubernetes Files

The required Kubernetes files are located in:

```text
k8s/
├── frontend-deployment.yaml
├── frontend-service.yaml
├── backend-deployment.yaml
├── backend-service.yaml
├── ingress.yaml
├── backend-configmap.yaml
└── backend-secret-example.yaml
```

---

## Frontend Deployment

The frontend is deployed as a separate Kubernetes Deployment:

```text
k8s/frontend-deployment.yaml
```

Important configuration:

- Deployment name: `frontend`
- Container port: `80`
- Replicas: `2`
- Readiness probe: enabled
- Liveness probe: enabled
- Resource requests and limits: configured
- Image tag: uses a fixed example tag such as `sha-demo`, not `latest`

Example image format:

```text
000000000000.dkr.ecr.us-east-1.amazonaws.com/devops-assessment-frontend:sha-demo
```

In a real CI/CD deployment, the image tag would be updated with the Git commit SHA from the pipeline.

---

## Frontend Service

The frontend service is defined in:

```text
k8s/frontend-service.yaml
```

The frontend Service uses:

```text
type: ClusterIP
```

The frontend is not directly exposed using a LoadBalancer Service. Instead, it is exposed externally through the Ingress.

---

## Backend Deployment

The backend is deployed as a separate Kubernetes Deployment:

```text
k8s/backend-deployment.yaml
```

Important configuration:

- Deployment name: `backend`
- Container port: `8080`
- Replicas: `2`
- Readiness probe: `/health`
- Liveness probe: `/health`
- Resource requests and limits: configured
- ConfigMap usage: enabled
- Secret usage: enabled
- Image tag: uses a fixed example tag such as `sha-demo`, not `latest`

Example image format:

```text
000000000000.dkr.ecr.us-east-1.amazonaws.com/devops-assessment-backend:sha-demo
```

---

## Backend Service

The backend service is defined in:

```text
k8s/backend-service.yaml
```

The backend Service uses:

```text
type: ClusterIP
```

This means the backend is internal-only inside the Kubernetes cluster.

The backend is not exposed through the Ingress and is not exposed through a public LoadBalancer.

---

## Backend ConfigMap

The backend ConfigMap is defined in:

```text
k8s/backend-configmap.yaml
```

It stores non-sensitive backend configuration values:

```text
APP_ENV
PORT
DB_HOST
DB_PORT
DB_NAME
```

Example:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backend-config
data:
  APP_ENV: "production"
  PORT: "8080"
  DB_HOST: "postgres.internal.example.com"
  DB_PORT: "5432"
  DB_NAME: "appdb"
```

These values are non-sensitive and safe to keep in a ConfigMap.

---

## Backend Secret Example

The backend Secret example is defined in:

```text
k8s/backend-secret-example.yaml
```

It contains example database credential keys:

```text
DB_USERNAME
DB_PASSWORD
```

Example:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: backend-secret-example
type: Opaque
stringData:
  DB_USERNAME: "example-user"
  DB_PASSWORD: "example-password"
```

These are example values only.

For production, real database credentials should be stored in:

- AWS Secrets Manager
- External Secrets Operator
- GitHub Secrets for CI/CD-level values
- Kubernetes Secrets generated securely during deployment

Real passwords must not be committed to GitHub.

---

## Ingress

The Ingress file is:

```text
k8s/ingress.yaml
```

The Ingress exposes the frontend externally using AWS ALB Ingress annotations.

Example annotations:

```yaml
alb.ingress.kubernetes.io/scheme: internet-facing
alb.ingress.kubernetes.io/target-type: ip
alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}]'
```

The Ingress routes public traffic to the frontend Service only.

The backend remains internal and is not exposed externally.

---

## Kubernetes Probes

Both frontend and backend deployments include readiness and liveness probes.

### Backend probes

The backend probes use:

```text
/health
```

on port:

```text
8080
```

This confirms that the backend API is healthy before Kubernetes sends traffic to it.

### Frontend probes

The frontend probes use:

```text
/
```

on port:

```text
80
```

This confirms that the Nginx frontend container is serving content properly.

---

## Resource Requests and Limits

Both frontend and backend containers include resource requests and limits.

Example:

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

This helps Kubernetes schedule pods properly and prevents containers from using unlimited CPU or memory.

---

## Image Tagging Policy

The Kubernetes manifests do not use the `latest` tag.

Example tag:

```text
sha-demo
```

In a real deployment, the CI/CD pipeline would replace this with a commit-based image tag such as:

```text
sha-a1b2c3d
```

This makes deployments traceable and safer for rollback.

---

## Validate Kubernetes YAML

If `kubectl` is installed, the manifests can be validated locally using:

```bash
kubectl apply --dry-run=client -f k8s/
```

This checks the YAML structure without applying resources to a real cluster.

---

## Apply to Kubernetes

If a real Kubernetes or EKS cluster is available, the manifests can be applied with:

```bash
kubectl apply -f k8s/
```

Check resources:

```bash
kubectl get deployments
kubectl get pods
kubectl get svc
kubectl get ingress
```

Important: applying these files to real AWS EKS may create AWS resources and cost if the AWS Load Balancer Controller provisions an ALB.

---

## Task 3 Requirement Checklist

| Requirement                                      | Status    |
| ------------------------------------------------ | --------- |
| `k8s/frontend-deployment.yaml` exists            | Completed |
| `k8s/frontend-service.yaml` exists               | Completed |
| `k8s/backend-deployment.yaml` exists             | Completed |
| `k8s/backend-service.yaml` exists                | Completed |
| `k8s/ingress.yaml` exists                        | Completed |
| `k8s/backend-configmap.yaml` exists              | Completed |
| `k8s/backend-secret-example.yaml` exists         | Completed |
| Frontend and backend are separate deployments    | Completed |
| Backend runs on port `8080`                      | Completed |
| Minimum 2 replicas configured                    | Completed |
| Readiness probes configured                      | Completed |
| Liveness probes configured                       | Completed |
| Resource requests and limits configured          | Completed |
| ConfigMap usage configured                       | Completed |
| Secret example for database credentials included | Completed |
| Image tag is not hardcoded as `latest`           | Completed |
| Ingress exposes frontend externally              | Completed |
| Backend is internal only using `ClusterIP`       | Completed |

---

# Task 4: Private Database Connectivity

## Task 4 Overview

Task 4 explains how the backend application connects privately to a database.

For this project, the recommended cloud design is:

```text
AWS EKS backend application → Private AWS RDS PostgreSQL/MySQL database
```

The same design can also be applied to Azure AKS with Azure SQL, Azure PostgreSQL, or Azure MySQL using private endpoints.

The database must not be publicly exposed. Only the backend application should be able to connect to the database.

---

## Database Choice

For the AWS-based design, the backend connects to one of the following private database options:

```text
AWS RDS PostgreSQL
AWS RDS MySQL
EC2-based PostgreSQL or MySQL inside a private subnet
```

Recommended option:

```text
AWS RDS PostgreSQL or AWS RDS MySQL with Publicly Accessible = No
```

This ensures that the database does not receive a public IP address.

---

## Private Connectivity Design

The application follows this private connectivity flow:

```text
Internet User
    ↓
Public Ingress / AWS ALB
    ↓
Frontend Service
    ↓
Backend Service
    ↓
Private Database
```

The frontend is the only component exposed externally through the Ingress.

The backend runs inside the Kubernetes cluster and connects to the database using the private database endpoint.

The database is not exposed through:

```text
Public LoadBalancer
Public IP address
Ingress
Internet Gateway
0.0.0.0/0 inbound rule
```

---

## Private Subnet Design

The VPC contains both public and private subnets.

Public subnets are used for:

```text
AWS Application Load Balancer
Ingress traffic from internet users
```

Private subnets are used for:

```text
EKS worker nodes
Backend pods
Internal services
Private RDS database
```

The database subnet group must include private subnets only.

The private database subnet should not have a direct route to an Internet Gateway.

---

## Private DNS Requirement

The backend connects to the database using the database DNS endpoint.

Example:

```text
mydb.xxxxxx.us-east-1.rds.amazonaws.com
```

Inside the VPC, this DNS name resolves to the private IP address of the RDS database.

The VPC must have DNS resolution enabled so that backend pods can resolve the private database endpoint correctly.

Required VPC DNS settings:

```text
enableDnsHostnames = true
enableDnsSupport = true
```

If Azure is used, the same concept applies through Azure Private DNS Zone linked with the AKS virtual network.

---

## Security Group and Firewall Rules

The database security group must allow inbound traffic only from the backend/EKS private network.

Example for PostgreSQL:

| Resource       | Port | Source                                                | Access  |
| -------------- | ---- | ----------------------------------------------------- | ------- |
| RDS PostgreSQL | 5432 | EKS node security group or backend pod security group | Allowed |
| RDS PostgreSQL | 5432 | 0.0.0.0/0                                             | Denied  |

Example for MySQL:

| Resource  | Port | Source                                                | Access  |
| --------- | ---- | ----------------------------------------------------- | ------- |
| RDS MySQL | 3306 | EKS node security group or backend pod security group | Allowed |
| RDS MySQL | 3306 | 0.0.0.0/0                                             | Denied  |

The database must not allow access from public IP addresses.

The frontend security group or public load balancer should not have direct database access.

---

## How Only Backend Can Access the Database

Only the backend deployment receives database connection details.

The frontend does not contain database credentials and does not connect to the database directly.

The backend receives the database configuration through Kubernetes ConfigMap and Secret.

Non-sensitive values are stored in ConfigMap:

```text
DB_HOST
DB_PORT
DB_NAME
APP_ENV
```

Sensitive values are stored in Secret:

```text
DB_USERNAME
DB_PASSWORD
```

The backend service is internal-only using `ClusterIP`.

The database accepts traffic only from the backend/EKS private network.

This ensures that:

```text
Internet users cannot access the database
Frontend cannot access the database directly
Only backend pods can connect to the database
```

---

## Database Credentials Storage

Database credentials are stored using Kubernetes Secret for this assessment.

Example file:

```text
k8s/backend-secret-example.yaml
```

Example Secret structure:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: backend-secret-example
type: Opaque
stringData:
  DB_USERNAME: "example-user"
  DB_PASSWORD: "example-password"
```

The backend deployment reads these values as environment variables.

Example:

```yaml
env:
  - name: DB_USERNAME
    valueFrom:
      secretKeyRef:
        name: backend-secret-example
        key: DB_USERNAME
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: backend-secret-example
        key: DB_PASSWORD
```

For production, real database credentials should not be committed to GitHub.

Production-grade secret options:

```text
AWS Secrets Manager
External Secrets Operator
Sealed Secrets
GitHub Actions Secrets for CI/CD values
```

---

## How to Confirm the Database Is Not Publicly Accessible

The database private access can be confirmed by the following checks.

### 1. Check database public access setting

For AWS RDS:

```text
Publicly Accessible = No
```

### 2. Check subnet placement

The database must be placed in private subnets only.

The private subnet route table should not have a direct route to an Internet Gateway.

### 3. Check security group rules

The database security group must not allow inbound traffic from:

```text
0.0.0.0/0
Public IP addresses
Unknown external sources
Frontend Load Balancer
```

Only the backend/EKS private network should be allowed.

### 4. Test from a public machine

A database connection attempt from a public machine should fail.

Example for PostgreSQL:

```bash
nc -vz mydb.xxxxxx.us-east-1.rds.amazonaws.com 5432
```

Example for MySQL:

```bash
nc -vz mydb.xxxxxx.us-east-1.rds.amazonaws.com 3306
```

Expected result:

```text
Connection failed or timed out
```

### 5. Test from backend pod

A database connection attempt from the backend pod should succeed.

Example:

```bash
kubectl exec -it <backend-pod-name> -- sh
```

Then test the database connection:

```bash
nc -vz $DB_HOST $DB_PORT
```

Expected result:

```text
Connection successful
```

If the public machine cannot connect but the backend pod can connect, then the database is privately accessible only from the backend environment.

---

## Task 4 Requirement Checklist

| Requirement                                          | Status    |
| ---------------------------------------------------- | --------- |
| Backend connects to database privately               | Completed |
| Database is not publicly exposed                     | Completed |
| Private subnet design explained                      | Completed |
| Private endpoint/private database endpoint explained | Completed |
| Private DNS requirement explained                    | Completed |
| Security group/firewall rules explained              | Completed |
| Backend-only database access explained               | Completed |
| Database credentials stored securely                 | Completed |
| Public access verification steps explained           | Completed |

---

# Task 5: Terraform Cluster Provisioning

## Task 5 Overview

Task 5 adds a module-based Terraform structure under the `terraform/` folder.

This project uses the **AWS EKS** option. The Terraform configuration shows how to provision and maintain a production-style Kubernetes platform on AWS.

The Terraform code uses **custom local modules only**. It does not use third-party or ready-made Terraform modules.

---

## Terraform Folder Structure

The required Terraform files are located in:

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

---

## Required Top-Level Files

### `terraform/provider.tf`

This file defines:

- Terraform required version
- AWS provider
- AWS region
- Default AWS tags
- Example S3 remote backend block for Terraform state

The S3 backend block is kept as an example/commented block because the S3 backend bucket must already exist before enabling it.

---

### `terraform/main.tf`

This file connects all custom modules together:

```text
module.vpc
module.ecr
module.cloudwatch
module.eks
module.rds
```

The root module passes VPC, subnet, EKS, ECR, RDS, and environment variables into the child modules.

---

### `terraform/variables.tf`

This file defines configurable values such as:

```text
aws_region
environment
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

The `db_password` variable is marked as sensitive and should be passed securely. It must not be committed to GitHub.

---

### `terraform/outputs.tf`

This file exports important values after provisioning:

```text
cluster_name
cluster_endpoint
cluster_security_group_id
vpc_id
private_subnet_ids
database_subnet_ids
ecr_repository_urls
cloudwatch_log_group_name
database_endpoint
database_security_group_id
```

These outputs help CI/CD and operators connect to the infrastructure after provisioning.

---

### `terraform/README.md`

This file explains:

- How to initialize Terraform
- How to validate Terraform
- How to run `terraform plan`
- How to run `terraform apply`
- Remote backend and state locking
- EKS upgrade process
- Node group resizing
- Downtime prevention
- Environment separation
- Secret handling
- What to check if Terraform wants to recreate the cluster

---

## Custom Terraform Modules

The `terraform/modules/` folder contains custom local modules only.

| Module               | Purpose                                                                                                         |
| -------------------- | --------------------------------------------------------------------------------------------------------------- |
| `modules/vpc`        | Creates VPC, public subnets, private subnets, database subnets, Internet Gateway, NAT Gateway, and route tables |
| `modules/ecr`        | Creates Amazon ECR repositories for backend and frontend images                                                 |
| `modules/cloudwatch` | Creates CloudWatch log group for EKS logs                                                                       |
| `modules/eks`        | Creates EKS cluster, IAM roles, managed node group, and EKS add-ons                                             |
| `modules/rds`        | Creates private RDS database, database subnet group, and database security group                                |

No third-party Terraform modules are used.

---

## What Terraform Provisions

The Terraform design includes:

- AWS VPC
- Public subnets for internet-facing load balancer
- Private subnets for EKS worker nodes
- Private database subnets for RDS
- Internet Gateway
- NAT Gateway
- Route tables
- Amazon ECR repositories
- Amazon EKS cluster
- EKS managed node group
- EKS IAM roles and policies
- EKS add-ons
- CloudWatch log group
- Private Amazon RDS database
- Security group rule allowing database access only from the EKS/backend security group

---

## Private Database Connectivity Through Terraform

The RDS module creates the database in private database subnets.

The database is configured with:

```text
publicly_accessible = false
```

The database security group allows inbound database traffic only from the EKS/backend security group.

This supports the private database design from Task 4 and ensures the database is not exposed publicly.

---

## Remote Backend and Terraform State Locking

Terraform state should not be committed to GitHub.

Recommended production setup:

```text
S3 bucket for Terraform state
State locking enabled
Bucket versioning enabled
Server-side encryption enabled
Separate state key per environment
```

The repository must not commit:

```text
terraform.tfstate
terraform.tfstate.backup
.terraform/
secret tfvars files
```

An example remote backend block is included in `terraform/provider.tf`.

---

## How to Run Terraform

Go to the Terraform folder:

```bash
cd terraform
```

Set the database password securely.

Linux/macOS:

```bash
export TF_VAR_db_password="REPLACE_WITH_SECURE_PASSWORD"
```

Windows PowerShell:

```powershell
$env:TF_VAR_db_password="REPLACE_WITH_SECURE_PASSWORD"
```

Initialize Terraform:

```bash
terraform init
```

Validate Terraform:

```bash
terraform validate
```

Run a plan:

```bash
terraform plan
```

Apply only if AWS resources and cost are acceptable:

```bash
terraform apply
```

Destroy resources when finished:

```bash
terraform destroy
```

---

## EKS Upgrade Strategy

To upgrade EKS safely:

1. Upgrade the development environment first.
2. Review the Terraform plan.
3. Upgrade the EKS control plane.
4. Upgrade managed node groups after the control plane.
5. Use rolling updates.
6. Verify nodes, pods, services, ingress, and logs.
7. Promote the same process to staging and production.

---

## Add or Resize Node Pools

The default EKS managed node group can be resized using:

```text
node_desired_size
node_min_size
node_max_size
node_instance_type
```

For multiple workload types, additional custom node group blocks can be added to the EKS module.

Example node group categories:

```text
general workloads
system workloads
high-memory workloads
spot workloads
```

---

## Avoid Downtime During Cluster Changes

Recommended practices:

- Run at least 2 replicas of each app
- Use readiness probes
- Use rolling deployments
- Use managed node group rolling updates
- Spread nodes across multiple Availability Zones
- Use PodDisruptionBudget in production
- Review `terraform plan` before applying
- Avoid destructive cluster replacement unless planned

---

## Dev, Staging, and Production Separation

Recommended environment separation:

```text
dev
staging
production
```

Each environment should have:

- Separate Terraform state
- Separate VPC
- Separate EKS cluster
- Separate RDS database
- Separate variable values
- Separate CI/CD approval gates

This avoids accidental production changes while testing in dev or staging.

---

## Handling Secrets Outside Terraform Code

Do not hardcode secrets in Terraform files.

Recommended options:

- GitHub Actions Secrets
- AWS Secrets Manager
- AWS Systems Manager Parameter Store
- Environment variable `TF_VAR_db_password`
- External Secrets Operator for Kubernetes

The repository must not contain real database passwords, AWS keys, private keys, tokens, or Terraform state files.

---

## What to Check If Terraform Wants to Recreate the Cluster

If `terraform plan` wants to recreate the EKS cluster, check:

1. Did the cluster name change?
2. Did the VPC ID change?
3. Did private subnet IDs change?
4. Did an immutable EKS field change?
5. Is Terraform using the correct backend and state file?
6. Is the correct environment selected?
7. Did someone manually change resources in AWS?
8. Did provider version changes affect the plan?
9. Did module resource names change?
10. Can the change be done through node group replacement instead of cluster replacement?

Do not approve destructive changes until the reason is understood.

---

## Cost Warning

This Terraform design can create paid AWS resources, including:

```text
EKS cluster
EC2 worker nodes
NAT Gateway
RDS database
CloudWatch logs
Load balancer if Kubernetes Ingress is applied later
```

For assessment review, the Terraform code can be submitted as Infrastructure as Code without applying it to AWS unless a live deployment is specifically required.

---

## Task 5 Requirement Checklist

| Requirement                                                                                             | Status    |
| ------------------------------------------------------------------------------------------------------- | --------- |
| `terraform/` folder exists                                                                              | Completed |
| `terraform/provider.tf` exists                                                                          | Completed |
| `terraform/main.tf` exists                                                                              | Completed |
| `terraform/variables.tf` exists                                                                         | Completed |
| `terraform/outputs.tf` exists                                                                           | Completed |
| `terraform/README.md` exists                                                                            | Completed |
| `terraform/modules/` folder exists                                                                      | Completed |
| Terraform is module-based                                                                               | Completed |
| Custom modules only                                                                                     | Completed |
| Third-party ready-made modules are not used                                                             | Completed |
| VPC/network design included                                                                             | Completed |
| Public, private, and database subnet design included                                                    | Completed |
| EKS cluster included                                                                                    | Completed |
| EKS managed node group included                                                                         | Completed |
| ECR repositories included                                                                               | Completed |
| CloudWatch monitoring/logging included                                                                  | Completed |
| Private database connectivity included                                                                  | Completed |
| Remote backend and state locking explained                                                              | Completed |
| Variables for environment, region, cluster name, node size, node count, and Kubernetes version included | Completed |
| Outputs for cluster name, endpoint, registry URLs, and network ID included                              | Completed |
| EKS upgrade process explained                                                                           | Completed |
| Node pool resize process explained                                                                      | Completed |
| Terraform state maintenance explained                                                                   | Completed |
| Downtime prevention explained                                                                           | Completed |
| Dev, staging, and production separation explained                                                       | Completed |
| Secrets outside Terraform code explained                                                                | Completed |
| Cluster recreation troubleshooting explained                                                            | Completed |

---

# Task 6: Troubleshooting Questions

This document answers the required troubleshooting questions for the DevOps Engineer Assessment.

---

## 1. Pod is in CrashLoopBackOff. What do you check?

Check the pod logs first:

```bash
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
```

Then check:

- Pod events using `kubectl describe pod <pod-name>`
- Application startup command
- Missing environment variables
- Missing ConfigMap or Secret
- Wrong image tag
- Application port mismatch
- Readiness/liveness probe failure
- Resource limits and `OOMKilled` events
- Dependency failures such as database or API connection issues

---

## 2. Deployment is successful, but app is not reachable. What do you check?

Check:

- Pods are running and ready:

```bash
kubectl get pods
```

- Service exists and points to the correct pod labels:

```bash
kubectl get svc
kubectl describe svc <service-name>
```

- Deployment selector and pod labels match
- Container port and service `targetPort` are correct
- Ingress is configured correctly
- DNS record points to the correct load balancer
- Security group/firewall allows traffic
- Application is listening on `0.0.0.0`, not only `localhost`
- Backend service is internal-only if it should not be public

---

## 3. Difference between readiness and liveness probe?

A readiness probe tells Kubernetes when a pod is ready to receive traffic.

If readiness fails, Kubernetes keeps the pod running but removes it from service endpoints.

A liveness probe tells Kubernetes whether the container is still healthy.

If liveness fails, Kubernetes restarts the container.

In short:

```text
Readiness = Should traffic be sent to this pod?
Liveness  = Should this container be restarted?
```

---

## 4. Docker build works locally but fails in pipeline. Why?

Possible reasons:

- Missing files because `.dockerignore` excludes required content
- Case-sensitive file path issue in Linux runner
- Different Node.js or package manager version
- Missing environment variables in pipeline
- Pipeline working directory is incorrect
- Dependency version mismatch
- Private package registry credentials are missing
- Dockerfile depends on local files that are not committed
- Build cache exists locally but not in CI

---

## 5. Pipeline fails during Docker build. What do you check?

Check:

- GitHub Actions logs for the exact build error
- Dockerfile syntax
- Build context path
- Required files are committed to GitHub
- `.dockerignore` is not excluding required files
- `package.json` and lock file are present
- Dependency installation step
- Base image availability
- Network access to package registries
- Memory or disk limits in the CI runner

Useful command locally:

```bash
docker build --no-cache -t test-image ./backend
```

---

## 6. Certificate renewal failed. What do you check?

Check:

- Certificate manager logs, such as cert-manager logs
- Certificate resource status
- Issuer or ClusterIssuer status
- DNS validation record
- HTTP validation path
- Ingress annotations
- Domain DNS points to the correct load balancer
- Security group allows HTTP/HTTPS traffic
- Certificate expiration date
- Rate limits from the certificate authority
- For AWS, check ACM certificate validation status if ACM is used

Commands:

```bash
kubectl get certificate
kubectl describe certificate <certificate-name>
kubectl describe issuer <issuer-name>
```

---

## 7. Ingress returns 502 or 504. What do you check?

Check:

- Backend pods are running and ready
- Service has active endpoints:

```bash
kubectl get endpoints
```

- Ingress backend service name and port are correct
- Application container listens on the expected port
- Readiness probe is not failing
- AWS Load Balancer Controller logs
- ALB target group health
- Security group rules between ALB and worker nodes/pods
- Timeout settings for long-running requests
- Network policies blocking traffic

For 502, usually check bad upstream or unhealthy target.

For 504, usually check timeout, slow backend, or network path issue.

---

## 8. Vendor SFTP connection to port 22 times out. What do you check?

Check:

- Vendor IP address is whitelisted
- Security group allows inbound TCP port 22
- Network ACL allows traffic
- Route table has correct route
- Server is running and listening on port 22
- SSH/SFTP daemon status
- Firewall rules inside the server
- Public IP or private VPN connectivity
- DNS hostname resolves correctly
- Vendor is connecting to the correct hostname and port
- Fail2ban or security tool has not blocked the vendor IP

Useful checks:

```bash
nc -vz <sftp-host> 22
telnet <sftp-host> 22
```

---

## 9. Terraform plan wants to recreate the cluster. What do you check?

Check:

- Cluster name changed
- VPC ID or subnet IDs changed
- Kubernetes version change requires replacement
- Immutable EKS field changed
- Terraform state is missing or incorrect
- Wrong workspace or backend is selected
- Resource was changed manually in AWS
- Provider version changed behavior
- Module resource names changed
- Variable values are different from the previous apply

Do not apply destructive changes until the reason is clear.

Use:

```bash
terraform plan
terraform state list
terraform state show <resource>
```

---

## 10. How would you upgrade AKS/EKS safely?

For EKS:

1. Check supported Kubernetes upgrade path.
2. Upgrade dev first.
3. Review `terraform plan`.
4. Take backups of critical data.
5. Upgrade the EKS control plane first.
6. Upgrade managed node groups after the control plane.
7. Use rolling node updates.
8. Keep at least 2 application replicas.
9. Confirm readiness probes are working.
10. Verify pods, services, ingress, logs, metrics, and application health.
11. Upgrade staging.
12. Upgrade production during an approved maintenance window.

Do not upgrade production first.

---

## 11. Frontend loads, but backend API calls fail. What do you check?

Check:

- Browser developer console network errors
- Frontend API URL
- Nginx proxy configuration
- Backend service name and port
- Backend pod status
- Backend service endpoints
- CORS configuration if frontend directly calls backend
- Ingress path routing
- DNS resolution inside the cluster
- Security group or network policy blocking traffic
- Backend logs

Commands:

```bash
kubectl get pods
kubectl get svc
kubectl get endpoints
kubectl logs deploy/backend
```

---

## 12. Backend pod is running, but database connection times out. What do you check?

Check:

- DB hostname and port values
- Kubernetes ConfigMap values
- Kubernetes Secret values
- RDS endpoint is private and reachable from EKS
- Database security group allows traffic from EKS/backend security group
- Database subnet route table
- Network ACL rules
- Private DNS resolution
- Database is running and accepting connections
- Correct database port: PostgreSQL `5432`, MySQL `3306`
- Credentials are correct
- SSL requirement if enabled by database

From backend pod:

```bash
kubectl exec -it <backend-pod-name> -- sh
nc -vz $DB_HOST $DB_PORT
```

---

## 13. Private DNS is not resolving database hostname. What do you check?

Check:

- VPC DNS support is enabled
- VPC DNS hostnames are enabled
- Correct private hosted zone exists
- Private hosted zone is associated with the correct VPC
- RDS endpoint is correct
- CoreDNS pods are running in Kubernetes
- Pod DNS policy is correct
- Network rules allow DNS traffic to the cluster DNS service
- `/etc/resolv.conf` inside the pod
- No custom DNS misconfiguration

Commands:

```bash
kubectl get pods -n kube-system
kubectl logs -n kube-system deploy/coredns
kubectl exec -it <pod-name> -- nslookup <db-hostname>
```

---

## 14. How would you rotate database credentials safely?

Steps:

1. Create new database credentials.
2. Store the new credentials in AWS Secrets Manager or Kubernetes Secret.
3. Update backend deployment to use the new secret.
4. Roll out backend pods gradually.
5. Verify the application connects successfully.
6. Keep old credentials temporarily during the transition.
7. Remove old credentials after verification.
8. Audit logs for failed connections.

Safe rotation should avoid downtime by allowing old and new credentials during the transition where possible.

For production, automate rotation using AWS Secrets Manager rotation or External Secrets Operator.

---

## 15. Secrets were accidentally committed to GitHub. What do you do?

Immediately:

1. Revoke or rotate the exposed secret.
2. Remove the secret from the code.
3. Remove it from Git history if required.
4. Force push only if the team agrees and understands the impact.
5. Check GitHub secret scanning alerts.
6. Check cloud logs for suspicious activity.
7. Move secrets to GitHub Secrets, AWS Secrets Manager, or another secret manager.
8. Add `.env`, state files, and secret files to `.gitignore`.
9. Notify the security/team lead if this is a real production secret.

Important: deleting the file in a later commit is not enough because the secret still exists in Git history.

Tools that can help clean history:

```text
git filter-repo
BFG Repo-Cleaner
```

---

# Task 7: Future Improvement Proposal

This document explains future improvements recommended for the production-style DevOps platform.

For each improvement, this section includes:

- What improvement is recommended
- Why it is needed
- How it helps the team or business
- How it would be implemented
- What risk it reduces

---

## 1. Secret Management

### What improvement is recommended?

Use AWS Secrets Manager with External Secrets Operator instead of storing real secrets directly in Kubernetes YAML files.

### Why is it needed?

Secrets in plain YAML files can be accidentally committed to GitHub or exposed to people who should not have access.

### How does it help the team or business?

It improves security, centralizes secret management, and makes secret rotation easier.

### How would it be implemented?

- Store database credentials in AWS Secrets Manager.
- Install External Secrets Operator in EKS.
- Configure Kubernetes ExternalSecret resources.
- Use IAM Roles for Service Accounts to allow limited access to secrets.
- Remove real credentials from Kubernetes manifests.

### What risk does it reduce?

It reduces the risk of credential leaks, unauthorized database access, and manual secret rotation mistakes.

---

## 2. Image Vulnerability Scanning

### What improvement is recommended?

Add container image vulnerability scanning.

### Why is it needed?

Docker images may contain vulnerable OS packages or application dependencies.

### How does it help the team or business?

It helps detect security issues before images are deployed to Kubernetes.

### How would it be implemented?

- Enable Amazon ECR scan on push.
- Add Trivy or Grype scanning in GitHub Actions.
- Fail the pipeline for critical vulnerabilities.
- Review and patch vulnerable packages regularly.

### What risk does it reduce?

It reduces the risk of deploying vulnerable containers to production.

---

## 3. Monitoring and Alerting

### What improvement is recommended?

Add centralized monitoring, logging, and alerting.

### Why is it needed?

Without monitoring, failures may not be noticed until users report them.

### How does it help the team or business?

It improves reliability, incident response, and operational visibility.

### How would it be implemented?

- Use Amazon CloudWatch for EKS logs.
- Use Prometheus and Grafana for Kubernetes metrics.
- Create alerts for pod restarts, high CPU, high memory, failed deployments, and unhealthy ingress targets.
- Send alerts to email, Slack, or incident management tools.

### What risk does it reduce?

It reduces the risk of long outages and unnoticed production failures.

---

## 4. Rollback Strategy

### What improvement is recommended?

Define a clear rollback strategy for failed deployments.

### Why is it needed?

A new release can introduce bugs or break production traffic.

### How does it help the team or business?

It allows the team to recover quickly from failed deployments.

### How would it be implemented?

- Use versioned Docker image tags based on Git commit SHA.
- Use Kubernetes rolling updates.
- Keep previous ReplicaSets.
- Roll back using:

```bash
kubectl rollout undo deployment/backend
kubectl rollout undo deployment/frontend
```

### What risk does it reduce?

It reduces downtime caused by failed application releases.

---

## 5. Helm Chart

### What improvement is recommended?

Package Kubernetes manifests into a Helm chart.

### Why is it needed?

Managing many YAML files manually becomes difficult as the platform grows.

### How does it help the team or business?

It standardizes deployments across dev, staging, and production.

### How would it be implemented?

- Create a Helm chart for frontend and backend.
- Move image tags, replica counts, resource limits, and ingress hostnames into `values.yaml`.
- Create separate values files for each environment.

### What risk does it reduce?

It reduces manual configuration errors and environment drift.

---

## 6. Terraform Remote Backend

### What improvement is recommended?

Use an S3 remote backend with Terraform state locking.

### Why is it needed?

Local Terraform state is unsafe for team collaboration.

### How does it help the team or business?

It lets multiple engineers work safely with shared infrastructure state.

### How would it be implemented?

- Create an S3 bucket for Terraform state.
- Enable versioning and encryption.
- Enable Terraform state locking.
- Use separate state keys for dev, staging, and production.

### What risk does it reduce?

It reduces the risk of corrupted, lost, or conflicting Terraform state.

---

## 7. Kubernetes Autoscaling

### What improvement is recommended?

Add Horizontal Pod Autoscaler and node autoscaling.

### Why is it needed?

Traffic can increase or decrease over time.

### How does it help the team or business?

It improves performance during high traffic and reduces cost during low traffic.

### How would it be implemented?

- Install Metrics Server.
- Configure Horizontal Pod Autoscaler for frontend and backend.
- Use Cluster Autoscaler or Karpenter for EKS node scaling.
- Set proper CPU and memory requests.

### What risk does it reduce?

It reduces the risk of overload and unnecessary infrastructure cost.

---

## 8. Cluster Upgrade Strategy

### What improvement is recommended?

Create a documented EKS upgrade strategy.

### Why is it needed?

Kubernetes versions eventually become unsupported.

### How does it help the team or business?

It keeps the cluster secure, stable, and supported.

### How would it be implemented?

- Upgrade dev first.
- Run tests.
- Upgrade staging.
- Upgrade production during a maintenance window.
- Upgrade the control plane before node groups.
- Verify workloads after each upgrade.

### What risk does it reduce?

It reduces the risk of unsupported Kubernetes versions and upgrade-related outages.

---

## 9. Production Approval Gates

### What improvement is recommended?

Add manual approval before production deployment.

### Why is it needed?

Production deployments should be controlled and reviewed.

### How does it help the team or business?

It prevents accidental or unauthorized production releases.

### How would it be implemented?

- Use GitHub Environments.
- Require approval for production.
- Restrict who can approve production deployments.
- Keep automatic deployment for dev and staging only.

### What risk does it reduce?

It reduces the risk of accidental production changes.

---

## 10. Private Cluster

### What improvement is recommended?

Use a private EKS cluster endpoint for production.

### Why is it needed?

A public Kubernetes API endpoint increases the attack surface.

### How does it help the team or business?

It improves cluster security.

### How would it be implemented?

- Disable public endpoint access for production EKS.
- Enable private endpoint access.
- Access the cluster through VPN, bastion host, or secure CI/CD runner inside the VPC.
- Use least-privilege IAM permissions.

### What risk does it reduce?

It reduces the risk of public Kubernetes API exposure.

---

## 11. WAF

### What improvement is recommended?

Add AWS WAF in front of the public Application Load Balancer.

### Why is it needed?

Public web applications are exposed to common web attacks.

### How does it help the team or business?

It adds protection for internet-facing traffic.

### How would it be implemented?

- Attach AWS WAF to the ALB.
- Enable AWS managed rule groups.
- Add rate limiting.
- Monitor blocked requests.

### What risk does it reduce?

It reduces the risk of SQL injection, cross-site scripting, bots, and abusive traffic.

---

## 12. GitOps with Argo CD

### What improvement is recommended?

Use Argo CD for GitOps-based Kubernetes deployment.

### Why is it needed?

Manual deployment or direct pipeline deployment can cause configuration drift.

### How does it help the team or business?

It makes Git the source of truth for Kubernetes state.

### How would it be implemented?

- Install Argo CD in EKS.
- Store Kubernetes manifests or Helm charts in GitHub.
- Configure Argo CD Applications for dev, staging, and production.
- Let Argo CD sync the desired state to the cluster.

### What risk does it reduce?

It reduces configuration drift and improves deployment auditability.

---

## 13. Blue/Green or Canary Deployment

### What improvement is recommended?

Use blue/green or canary deployment for safer releases.

### Why is it needed?

Deploying a new version to all users at once can be risky.

### How does it help the team or business?

It allows gradual rollout and quick rollback.

### How would it be implemented?

- Use Argo Rollouts or Flagger.
- Route a small percentage of traffic to the new version.
- Monitor error rate and latency.
- Promote or roll back based on metrics.

### What risk does it reduce?

It reduces the risk of full production outage from a bad release.

---

## 14. Backup and Disaster Recovery

### What improvement is recommended?

Add backup and disaster recovery planning.

### Why is it needed?

Databases, clusters, or infrastructure can fail.

### How does it help the team or business?

It protects business continuity and data availability.

### How would it be implemented?

- Enable automated RDS backups.
- Take RDS snapshots before major changes.
- Use Velero for Kubernetes backup.
- Test restore procedures regularly.
- Define Recovery Time Objective and Recovery Point Objective.

### What risk does it reduce?

It reduces data loss and recovery delay after failures.

---

## 15. Network Policies

### What improvement is recommended?

Add Kubernetes NetworkPolicies.

### Why is it needed?

By default, pods may communicate broadly inside the cluster.

### How does it help the team or business?

It limits internal traffic to only required communication paths.

### How would it be implemented?

- Use a CNI that supports NetworkPolicy.
- Allow frontend to communicate only with backend.
- Allow backend to communicate only with database and required services.
- Deny unnecessary pod-to-pod communication.

### What risk does it reduce?

It reduces lateral movement risk if a pod is compromised.

---

## 16. Cost Optimization

### What improvement is recommended?

Add cloud cost monitoring and optimization.

### Why is it needed?

Cloud resources can become expensive if not monitored.

### How does it help the team or business?

It reduces unnecessary AWS spending.

### How would it be implemented?

- Use AWS Cost Explorer and AWS Budgets.
- Right-size EKS worker nodes.
- Use autoscaling.
- Use Spot instances for non-critical workloads.
- Set CloudWatch log retention limits.
- Remove unused load balancers, EBS volumes, and snapshots.

### What risk does it reduce?

It reduces the risk of unexpected cloud bills and wasted infrastructure cost.

---

## Task 7 Requirement Checklist

| Improvement Area                | Status    |
| ------------------------------- | --------- |
| Secret management               | Completed |
| Image vulnerability scanning    | Completed |
| Monitoring and alerting         | Completed |
| Rollback strategy               | Completed |
| Helm chart                      | Completed |
| Terraform remote backend        | Completed |
| Kubernetes autoscaling          | Completed |
| Cluster upgrade strategy        | Completed |
| Production approval gates       | Completed |
| Private cluster                 | Completed |
| WAF                             | Completed |
| GitOps with Argo CD             | Completed |
| Blue/green or canary deployment | Completed |
| Backup and disaster recovery    | Completed |
| Network policies                | Completed |
| Cost optimization               | Completed |

# Final Completion Status

| Task                                              | Status    |
| ------------------------------------------------- | --------- |
| Task 1: Frontend, Backend, Docker, Docker Compose | Completed |
| Task 2: CI/CD Pipeline                            | Completed |
| Task 3: Kubernetes Manifests                      | Completed |
| Task 4: Private Database Connectivity             | Completed |
| Task 5: Terraform Cluster Provisioning            | Completed |
| Task 6: Troubleshooting Questions                 | Completed |
| Task 7: Future Improvement Proposal               | Completed |

The project documentation now covers frontend/backend containerization, CI/CD, Kubernetes manifests, private database connectivity, and Terraform-based EKS provisioning.
