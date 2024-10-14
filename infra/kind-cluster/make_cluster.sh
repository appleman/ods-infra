#!/bin/bash

# Variables
KIND_CLUSTER_NAME="demo-cluster"
CONFIG_FILE="kind-config.yaml"

# Step 1: Create kind cluster
echo "Creating kind cluster..."
kind create cluster --name $KIND_CLUSTER_NAME --config $CONFIG_FILE

# Step 2: Set kubectl context
kubectl cluster-info --context kind-$KIND_CLUSTER_NAME

# Step 3: Install Local Path Provisioner (for dynamic PVCs)
echo "Installing Local Path Provisioner for dynamic PVCs..."
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml

# Set the local-path storage class as default
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Step 4: Install NGINX Ingress Controller
echo "Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Wait for the NGINX ingress controller to be up
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Step 5: Install Metrics Server (for resource metrics like CPU/memory)
echo "Installing Metrics Server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Patch Metrics Server for kind (disable the secure TLS for local clusters)
kubectl patch deployment metrics-server -n kube-system --patch \
  '{"spec": {"template": {"spec": {"containers": [{"name": "metrics-server","args": ["--kubelet-insecure-tls"]}]}}}}'

# Step 6: Check the setup
echo "Verifying the installation..."

echo "Pods in kube-system namespace:"
kubectl get pods -n kube-system

echo "Ingress NGINX Controller:"
kubectl get pods -n ingress-nginx

echo "Metrics Server:"
kubectl get pods -n kube-system | grep metrics-server

echo "Kind cluster setup completed!"