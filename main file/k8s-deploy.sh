#!/bin/bash

# Kubernetes Deployment Script for Daily Activity Tracker

set -e

echo "🚀 Starting Kubernetes Deployment..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}Error: kubectl is not installed${NC}"
    exit 1
fi

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    echo -e "${RED}Error: Kubernetes cluster is not accessible${NC}"
    exit 1
fi

echo -e "${GREEN}✓ kubectl is installed and cluster is accessible${NC}"
echo ""

# Step 1: Create namespace
echo "📦 Creating namespace..."
kubectl apply -f .k8s/namespace.yaml
echo -e "${GREEN}✓ Namespace created${NC}"
echo ""

# Step 2: Create ConfigMap
echo "📝 Creating ConfigMap..."
kubectl apply -f .k8s/configmap.yaml
echo -e "${GREEN}✓ ConfigMap created${NC}"
echo ""

# Step 3: Create Secrets
echo "🔐 Creating Secrets..."
echo -e "${YELLOW}⚠️  Note: Update .k8s/secrets.yaml with your actual Supabase anon key${NC}"
kubectl apply -f .k8s/secrets.yaml
echo -e "${GREEN}✓ Secrets created${NC}"
echo ""

# Step 4: Deploy application
echo "🚀 Deploying application..."
kubectl apply -f .k8s/deployment.yaml
echo -e "${GREEN}✓ Deployment created${NC}"
echo ""

# Step 5: Create service
echo "🌐 Creating service..."
kubectl apply -f .k8s/service.yaml
echo -e "${GREEN}✓ Service created${NC}"
echo ""

# Wait for pods to be ready
echo "⏳ Waiting for pods to be ready..."
sleep 5
kubectl wait --for=condition=ready pod -l app=activity-tracker -n activity-tracker --timeout=120s || true
echo ""

# Step 6: Display status
echo "📊 Deployment Status:"
echo ""
kubectl get pods -n activity-tracker
echo ""
kubectl get svc -n activity-tracker
echo ""

# Get service details
echo "🔍 Access Information:"
echo ""
LOAD_BALANCER_IP=$(kubectl get svc -n activity-tracker activity-tracker-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "N/A")
if [ "$LOAD_BALANCER_IP" != "N/A" ]; then
    echo -e "${GREEN}External IP: http://$LOAD_BALANCER_IP${NC}"
else
    echo -e "${YELLOW}Use port-forward to access:${NC}"
    echo "kubectl port-forward -n activity-tracker service/activity-tracker-service 8080:80"
    echo -e "${GREEN}Then open: http://localhost:8080${NC}"
fi
echo ""

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo ""
echo "Useful commands:"
echo "  kubectl get pods -n activity-tracker       # Check pod status"
echo "  kubectl logs -n activity-tracker -l app=activity-tracker  # View logs"
echo "  kubectl delete -f .k8s/                   # Delete all resources"

