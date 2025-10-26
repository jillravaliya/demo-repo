# 🚀 Kubernetes Deployment Guide

## 3-Tier Architecture on Kubernetes

This setup deploys your Daily Activity Tracker as a proper 3-tier application on Kubernetes.

### Architecture Overview

```
┌─────────────────────────────────────┐
│   Ingress (NGINX/Load Balancer)    │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│    Frontend (Next.js App)           │
│    - Deployment (2 replicas)        │
│    - Service (LoadBalancer)         │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│    External Database (Supabase)      │
│    - PostgreSQL                     │
│    - Authentication                  │
└─────────────────────────────────────┘
```

---

## Prerequisites

1. **Kubernetes Cluster** (minikube, kind, GKE, EKS, AKS)
2. **kubectl** installed and configured
3. **Docker** for building images
4. **Supabase account** (database layer)

---

## Step 1: Build Docker Image

```bash
# Build the image
docker build -t activity-tracker:latest .

# Tag for your registry (optional)
docker tag activity-tracker:latest your-registry/activity-tracker:latest

# Push to registry (optional)
docker push your-registry/activity-tracker:latest
```

---

## Step 2: Configure Secrets

Edit `.k8s/secrets.yaml` with your actual Supabase anon key:

```yaml
stringData:
  NEXT_PUBLIC_SUPABASE_ANON_KEY: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

## Step 3: Update ConfigMap

Edit `.k8s/configmap.yaml` with your Supabase URL:

```yaml
data:
  NEXT_PUBLIC_SUPABASE_URL: "https://your-project.supabase.co"
```

---

## Step 4: Deploy to Kubernetes

### Option A: Deploy Everything at Once

```bash
kubectl apply -f .k8s/
```

### Option B: Deploy Step by Step

```bash
# 1. Create namespace
kubectl apply -f .k8s/namespace.yaml

# 2. Create ConfigMap
kubectl apply -f .k8s/configmap.yaml

# 3. Create Secrets
kubectl apply -f .k8s/secrets.yaml

# 4. Deploy application
kubectl apply -f .k8s/deployment.yaml

# 5. Create service
kubectl apply -f .k8s/service.yaml

# 6. (Optional) Create ingress
kubectl apply -f .k8s/ingress.yaml
```

---

## Step 5: Verify Deployment

```bash
# Check pods
kubectl get pods -n activity-tracker

# Check services
kubectl get svc -n activity-tracker

# Check deployment status
kubectl get deployment -n activity-tracker

# View logs
kubectl logs -n activity-tracker -l app=activity-tracker
```

---

## Step 6: Access the Application

### Option 1: Port Forward (Development)

```bash
kubectl port-forward -n activity-tracker service/activity-tracker-service 8080:80
```

Access at: http://localhost:8080

### Option 2: LoadBalancer IP

```bash
# Get the external IP
kubectl get svc -n activity-tracker activity-tracker-service

# Access using the EXTERNAL-IP
curl http://EXTERNAL-IP
```

### Option 3: Ingress (Production)

If you deployed ingress, access via domain configured in `.k8s/ingress.yaml`

---

## Scaling

### Scale Up/Down Manually

```bash
# Scale to 3 replicas
kubectl scale deployment activity-tracker-frontend -n activity-tracker --replicas=3

# Check replica status
kubectl get deployment -n activity-tracker
```

### Auto-scaling

```bash
kubectl autoscale deployment activity-tracker-frontend -n activity-tracker \
  --min=2 --max=10 --cpu-percent=80
```

---

## Monitoring & Health Checks

The deployment includes health checks:

- **Liveness Probe**: Checks if container is alive
- **Readiness Probe**: Checks if container is ready to serve traffic

```bash
# Check pod health
kubectl describe pod -n activity-tracker -l app=activity-tracker
```

---

## Update Application

### Update Image

```bash
# Build new image
docker build -t activity-tracker:v2 .

# Update deployment
kubectl set image deployment/activity-tracker-frontend -n activity-tracker \
  activity-tracker=activity-tracker:v2

# Or use rollout for canary deployment
kubectl rollout restart deployment/activity-tracker-frontend -n activity-tracker
```

---

## Clean Up

```bash
# Delete everything
kubectl delete -f .k8s/

# Or delete individual resources
kubectl delete deployment activity-tracker-frontend -n activity-tracker
kubectl delete svc activity-tracker-service -n activity-tracker
kubectl delete namespace activity-tracker
```

---

## Troubleshooting

### Pods Not Starting

```bash
# Check pod status
kubectl get pods -n activity-tracker

# Check logs
kubectl logs -n activity-tracker -l app=activity-tracker

# Describe pod for events
kubectl describe pod -n activity-tracker <pod-name>
```

### Connection Issues

```bash
# Check service endpoints
kubectl get endpoints -n activity-tracker activity-tracker-service

# Test connectivity
kubectl exec -it -n activity-tracker <pod-name> -- wget http://localhost:3000
```

### Image Pull Issues

```bash
# Check image
kubectl get deployment -n activity-tracker -o jsonpath='{.spec.template.spec.containers[*].image}'

# Pull image manually
docker pull activity-tracker:latest
```

---

## Resource Limits

The deployment includes resource limits:

```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

Adjust based on your cluster's capabilities.

---

## Security Best Practices

1. **Use Secrets** for sensitive data (anon keys)
2. **RBAC**: Create service accounts with minimal permissions
3. **Network Policies**: Restrict pod-to-pod communication
4. **SSL/TLS**: Use HTTPS with ingress
5. **Image Scanning**: Scan Docker images for vulnerabilities

---

## Environment-Specific Configs

Create different configs for dev/staging/prod:

```bash
.k8s/
├── dev/
│   ├── deployment.yaml
│   └── configmap.yaml
├── staging/
│   ├── deployment.yaml
│   └── configmap.yaml
└── prod/
    ├── deployment.yaml
    └── configmap.yaml
```

---

## Next Steps

- [ ] Set up CI/CD with GitHub Actions
- [ ] Configure monitoring with Prometheus
- [ ] Set up logging with ELK stack
- [ ] Implement canary deployments
- [ ] Add horizontal pod autoscaling

---

**Your app is now ready to run on Kubernetes! 🎉**

