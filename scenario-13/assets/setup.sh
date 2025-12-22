#!/bin/bash
set -e
kubectl create namespace frontend --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace backend --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -n backend -f - <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: nginx
        ports:
        - containerPort: 80
YAML

kubectl apply -n frontend -f - <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: curlimages/curl
        command: ["sleep", "3600"]
YAML

mkdir -p /root/network-policies

cat > /root/network-policies/network-policy-1.yaml <<YAML
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: policy-x
  namespace: backend
spec:
  podSelector: {}
  ingress:
  - {}
  policyTypes:
  - Ingress
YAML

cat > /root/network-policies/network-policy-2.yaml <<YAML
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: policy-y
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: frontend
    - ipBlock:
        cidr: 172.16.0.0/16
    ports:
    - protocol: TCP
      port: 80
  policyTypes:
  - Ingress
YAML

cat > /root/network-policies/network-policy-3.yaml <<YAML
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: policy-z
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: frontend
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 80
  policyTypes:
  - Ingress
YAML

echo "Lab ready!"
