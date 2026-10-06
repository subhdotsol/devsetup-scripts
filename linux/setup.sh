#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "======================================"
echo " Linux Development Environment Setup"
echo "======================================"

echo
echo "==> Installing system packages..."
"$SCRIPT_DIR/packages.sh"

echo
echo "==> Installing Rust..."

if ! command -v rustup >/dev/null 2>&1; then
    echo "Rustup not found. Installing Rust..."

    curl --proto '=https' \
         --tlsv1.2 \
         -sSf https://sh.rustup.rs \
         | sh -s -- -y
fi

# Make Rust available in the current shell.
source "$HOME/.cargo/env"

echo
echo "==> Updating Rust..."
rustup self update
rustup update stable
rustup default stable

echo
echo "==> Installing AArch64 Linux target..."
rustup target add aarch64-unknown-linux-gnu

echo
echo "======================================"
echo " Installation complete!"
echo "======================================"

echo
echo "==> System information"
fastfetch

echo
echo "==> Rust"
rustc --version

echo
echo "==> Cargo"
cargo --version

echo
echo "==> Rustup"
rustup --version

echo
echo "==> Architecture"
uname -m

echo
echo "======================================"
echo " Your Linux development environment"
echo " is ready! 🚀"
echo "======================================"
