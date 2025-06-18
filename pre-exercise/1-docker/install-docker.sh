#!/bin/bash

# Docker & Containerd Clean Install Script for Ubuntu
# Purpose: Uninstall conflicting runtimes, install Docker CE and containerd cleanly

set -euo pipefail

# ========================================
# 1. Remove Conflicting Packages (if installed)
# ========================================
echo "🧹 Removing old container runtimes (if present)..."

packages=(
  docker.io
  docker-doc
  docker-compose
  docker-compose-v2
  podman-docker
  containerd
  runc
)

for pkg in "${packages[@]}"; do
  if dpkg -s "$pkg" &>/dev/null; then
    echo "Removing $pkg..."
    sudo apt-get remove -y "$pkg"
  else
    echo "Package $pkg not installed, skipping."
  fi
done

# ========================================
# 2. Prepare Docker Repository
# ========================================
echo "🔧 Setting up Docker APT repository..."

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Detect Ubuntu codename
UBUNTU_CODENAME=$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")

# Add Docker repo
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# ========================================
# 3. Install Docker Components
# ========================================
echo "📦 Installing Docker CE and containerd..."

sudo apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  docker-compose

# ========================================
# 4. Post-install Check
# ========================================
echo "✅ Docker installation complete."
echo "🔍 Version info:"
docker --version
docker compose version
containerd --version