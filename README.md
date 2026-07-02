# DevOps Assessment - Task 1 and Task 2

This repository contains the completed setup for **Task 1** and **Task 2** of the DevOps Engineer Assessment.

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
├── docs/
│   └── task-2-ci-cd.md
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

# Git Commands After Updating Files

After adding Task 2 files, run:

```bash
git status
git add .
git commit -m "Add task 2 GitHub Actions CI CD pipeline"
git push
```

Then open your GitHub repository and go to:

```text
Actions
```

Confirm that the workflow is running successfully.

---

# Final Completion Status

| Task                                              | Status    |
| ------------------------------------------------- | --------- |
| Task 1: Frontend, Backend, Docker, Docker Compose | Completed |
| Task 2: CI/CD Pipeline                            | Completed |

The project is ready for Task 3: Kubernetes manifests.
