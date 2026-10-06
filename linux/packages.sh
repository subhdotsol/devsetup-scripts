#!/usr/bin/env bash

set -euo pipefail

echo "==> Updating package lists..."
sudo apt update

echo "==> Installing Linux development packages..."

sudo apt install -y \
    fastfetch \
    curl \
    git \
    gcc \
    pkg-config

echo "==> Linux packages installed successfully."
