# MuchTodo Backend Deployment Guide

This project contains a Golang API and MongoDB setup optimized for Docker and Kubernetes (Kind) deployment locally.

## Prerequisites
- Docker & Docker Compose
- Kind (Kubernetes in Docker)
- kubectl

## Getting Started
- Clone this repository
```bash
git clone https://github.com/ififrank2013/much-to-do.git
```
Run
```bash
cd much-to-do/Server/MuchToDo
```

## Local Development (Docker Compose)
1. Run `sh scripts/docker-run.sh`to build and up the docker image.
2. Access the API at `http://localhost:8080`
3. Check health at `http://localhost:8080/health`

## Kubernetes Deployment (Kind)
1. Run `sh script/docker-build.sh` to build the docker images locally.
- If "kind" is not present in your system, you may need to install "kind" using the following set of commands:

```bash # Install Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Install Kubectl (The Kubernetes CLI)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```
2. Run `docker tag muchtodo_backend:latest backend-api:local` to explicitly push the docker images into the cluster's internal registry where they can be accessed by kind.
3. Run `kind load docker-image backend-api:local --name muchtodo` to side load the images into kind
4. Now, Run `sh scripts/k8s-deploy.sh` to deploy everything.
5. The script will:
   - Create a Kind cluster, if not exists
   - Build and side-load the Docker image
   - Deploy MongoDB (with PVC) and the Backend (2 replicas)
6. Get the running pods by running `kubectl get pods,deployments -n muchtodo` to confirm that the deployment was successful.
7. Run `Run kubectl get svc,ingress -n muchtodo` to check NopePort mapping and ingres resource for traffic routing.
7. Run `kubectl get pods -n muchtodo` to find the actual pod name for the running backend pod
8. Then use `kubectl exec -it backend-xxxx-xxxx -n muchtodo -- curl http://localhost:8080/health` command inside the pod to verify health status of the connection. NB: Replace the backend-xxxx-xxxx with your actual pod name from above.

## Cleanup
8. Run `sh scripts/k8s-cleanup.sh` to remove the cluster.
