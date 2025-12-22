#!/bin/bash
set -e

echo "🔍 Vérification du lab cri-dockerd..."

# Check 1: cri-docker service exists and is active
if ! systemctl is-active cri-docker.service &>/dev/null; then
  echo "❌ Service cri-docker n'est pas actif"
  systemctl status cri-docker.service || true
  exit 1
fi
echo "✅ Service cri-docker est actif"

# Check 2: cri-docker is enabled
if ! systemctl is-enabled cri-docker.service &>/dev/null; then
  echo "❌ Service cri-docker n'est pas enabled"
  exit 1
fi
echo "✅ Service cri-docker est enabled"

# Check 3: sysctl net.bridge.bridge-nf-call-iptables
VAL=$(sysctl -n net.bridge.bridge-nf-call-iptables 2>/dev/null || echo "0")
if [ "$VAL" != "1" ]; then
  echo "❌ net.bridge.bridge-nf-call-iptables = $VAL (attendu: 1)"
  exit 1
fi
echo "✅ net.bridge.bridge-nf-call-iptables = 1"

# Check 4: sysctl net.ipv4.ip_forward
VAL=$(sysctl -n net.ipv4.ip_forward 2>/dev/null || echo "0")
if [ "$VAL" != "1" ]; then
  echo "❌ net.ipv4.ip_forward = $VAL (attendu: 1)"
  exit 1
fi
echo "✅ net.ipv4.ip_forward = 1"

# Check 5: sysctl net.ipv6.conf.all.forwarding
VAL=$(sysctl -n net.ipv6.conf.all.forwarding 2>/dev/null || echo "0")
if [ "$VAL" != "1" ]; then
  echo "❌ net.ipv6.conf.all.forwarding = $VAL (attendu: 1)"
  exit 1
fi
echo "✅ net.ipv6.conf.all.forwarding = 1"

# Check 6: sysctl net.netfilter.nf_conntrack_max
VAL=$(sysctl -n net.netfilter.nf_conntrack_max 2>/dev/null || echo "0")
if [ "$VAL" != "131072" ]; then
  echo "⚠️  net.netfilter.nf_conntrack_max = $VAL (attendu: 131072)"
fi
echo "✅ net.netfilter.nf_conntrack_max = $VAL"

# Check 7: Persistent config
if [ -f /etc/sysctl.d/kube.conf ] || [ -f /etc/sysctl.d/99-kubernetes.conf ]; then
  echo "✅ Configuration sysctl persistante trouvée"
else
  echo "⚠️  Pas de fichier sysctl persistant trouvé dans /etc/sysctl.d/"
fi

echo ""
echo "🎉 Toutes les vérifications passées!"
exit 0
