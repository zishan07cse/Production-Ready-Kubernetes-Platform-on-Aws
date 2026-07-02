# DevOps Assessment - Task 1

This project contains Task 1 of the DevOps Engineer Assessment.

It includes:

- A separate backend API application
- A separate frontend application
- Dockerfiles for both applications
- Docker Compose to run both containers locally
- Backend endpoints required by the assessment

## Project Structure

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
│   ├── index.html
│   ├── app.js
│   └── nginx.conf
├── docker-compose.yml
├── .dockerignore
├── .gitignore
└── README.md
```

## Requirements

Install Docker and Docker Compose.

Check Docker:

```bash
docker --version
docker compose version
```

## Run the project

From the root folder:

```bash
docker compose up -d --build
```

Check running containers:

```bash
docker compose ps
```

## Test Backend

```bash
curl http://localhost:8080
```

Expected output:

```text
Application is running
```

Test health endpoint:

```bash
curl http://localhost:8080/health
```

Expected output:

```json
{"status":"ok"}
```

On Windows PowerShell, use:

```powershell
curl.exe http://localhost:8080
curl.exe http://localhost:8080/health
```

## Test Frontend

Open in browser:

```text
http://localhost:3000
```

Click the **Check Backend Health** button.

Expected response:

```json
{"status":"ok"}
```

You can also test the frontend-to-backend proxy:

```bash
curl http://localhost:3000/api/health
```

Expected output:

```json
{"status":"ok"}
```

## Stop the project

```bash
docker compose down
```

## Run backend tests locally

If Node.js is installed locally:

```bash
cd backend
npm install
npm test
```
