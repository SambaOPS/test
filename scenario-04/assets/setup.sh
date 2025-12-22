#!/bin/bash
kubectl apply -f - <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
spec:
  replicas: 3
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      initContainers:
      - name: init-setup
        image: busybox
        command: ["sh", "-c", "echo 'Preparing...' && sleep 5"]
      containers:
      - name: wordpress
        image: wordpress:6.2-apache
        ports:
        - containerPort: 80
YAML
echo "✅ Lab ready!"
