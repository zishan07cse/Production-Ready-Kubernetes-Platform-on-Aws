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
