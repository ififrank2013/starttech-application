# To-Do Backend Deployment

This project contains a Golang API and MongoDB setup optimized for Docker and Kubernetes (Kind).

## Prerequisites
- Docker & Docker Compose
- Kind (Kubernetes in Docker)
- kubectl

## Local Development (Docker Compose)
1. Run `sh scripts/docker-run.sh`
2. Access the API at `http://localhost:8080`
3. Check health at `http://localhost:8080/health`

## Kubernetes Deployment (Kind)
1. Run sh script/docker-build.sh` to build the docker images locally.
2. Run `kind create cluster --name muchtodo` to create the kind cluster named "muchtodo"
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
4. Run `sh scripts/k8s-deploy.sh` to deploy everything.
5. The script will:
   - Create a Kind cluster
   - Build and side-load the Docker image
   - Deploy MongoDB (with PVC) and the Backend (2 replicas)
6. Get the running pods by running `kubectl get pods -n muchtodo` to confirm that the deployment was successful.
7. Access via the Service/Ingress mapping at on your browser via `http://localhost:8080`

## Cleanup
7. Run `sh scripts/k8s-cleanup.sh` to remove the cluster.
