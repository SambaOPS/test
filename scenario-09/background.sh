#!/bin/bash
set -e

echo "🔹 Downloading cri-dockerd package..."
wget -q https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.20/cri-dockerd_0.3.20.3-0.debian-bullseye_amd64.deb -O /root/cri-dockerd.deb

echo "🔹 Installing Docker (prerequisite)..."
apt-get update -qq
apt-get install -y -qq docker.io

echo "🔹 Loading kernel modules..."
modprobe br_netfilter || true
modprobe nf_conntrack || true

echo "✅ Lab ready!"
echo "   - Package: /root/cri-dockerd.deb"
echo "   - Docker: installed"
echo "   - Task: Install cri-dockerd and configure sysctl"
