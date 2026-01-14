#!/bin/bash
# 1. Create Kind Cluster
kind create cluster --name todo-cluster --config - <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30080
    hostPort: 8080
    listenAddress: "0.0.0.0"
EOF

# 2. Build and Load Image
docker build -t backend-api:local .
kind load docker-image backend-api:local --name todo-cluster

# 3. Apply manifests
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/mongodb/
kubectl apply -f kubernetes/backend/
kubectl apply -f kubernetes/ingress.yaml

echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=backend -n todo-app --timeout=90s