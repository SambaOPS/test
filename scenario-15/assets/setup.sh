#!/bin/bash
set -e
cp /etc/kubernetes/manifests/kube-apiserver.yaml /root/kube-apiserver.yaml.bak
sed -i 's/:2379/:2380/g' /etc/kubernetes/manifests/kube-apiserver.yaml
echo "Lab ready - kube-apiserver is broken, fix it!"
