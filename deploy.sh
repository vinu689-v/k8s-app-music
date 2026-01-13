#!/usr/bin/env bash
set -e

NAMESPACE="music-app"
IMAGE_NAME="music-server:latest"

echo " Starting deployment"

# 1. Ensure Minikube is running
if ! minikube status >/dev/null 2>&1; then
  echo " Starting Minikube"
  minikube start
fi

# 2. Enable ingress
echo " Enabling ingress addon"
minikube addons enable ingress

# 3. Docker env
echo " Configuring Docker to use Minikube"
eval "$(minikube docker-env)"

# 4. Build image
echo " Building server Docker image"
docker build -t ${IMAGE_NAME} .

# 5. Create namespace FIRST
echo " Creating namespace"
kubectl apply -f k8s/namespace.yaml

# 6. Apply remaining manifests
echo " Applying Kubernetes manifests"
kubectl apply -f k8s/ --namespace ${NAMESPACE}

# 7. Wait for deployments
echo " Waiting for deployments"
kubectl wait --for=condition=available deployment --all \
  -n ${NAMESPACE} --timeout=120s

MINIKUBE_IP=$(minikube ip)

echo "▶ Deployment complete"
echo "Add to /etc/hosts:"
echo "${MINIKUBE_IP} music.local"
