#!/usr/bin/env bash

set -euo pipefail

echo "======================================"
echo " Solana + Anchor Development Setup"
echo "======================================"

# --------------------------------------
# Detect operating system
# --------------------------------------

OS="$(uname -s)"
ARCH="$(uname -m)"

echo
echo "==> Operating system: $OS"
echo "==> Architecture:     $ARCH"

case "$OS" in
    Darwin)
        PLATFORM="macos"
        ;;

    Linux)
        PLATFORM="linux"
        ;;

    *)
        echo "ERROR: Unsupported operating system: $OS"
        exit 1
        ;;
esac

echo "==> Detected platform: $PLATFORM"


# --------------------------------------
# Install basic dependencies
# --------------------------------------

echo
echo "==> Installing basic dependencies..."

if [[ "$PLATFORM" == "macos" ]]; then

    if ! command -v brew >/dev/null 2>&1; then
        echo "ERROR: Homebrew is not installed."
        echo "Install Homebrew first:"
        echo "https://brew.sh/"
        exit 1
    fi

    brew update

    brew install \
        curl \
        git \
        pkg-config

elif [[ "$PLATFORM" == "linux" ]]; then

    sudo apt update

    sudo apt install -y \
        curl \
        git \
        pkg-config \
        build-essential \
        libssl-dev
fi


# --------------------------------------
# Install Rust
# --------------------------------------

echo
echo "==> Installing Rust..."

if ! command -v rustup >/dev/null 2>&1; then

    echo "Rustup not found."
    echo "Installing Rust..."

    curl --proto '=https' \
         --tlsv1.2 \
         -sSf https://sh.rustup.rs \
         | sh -s -- -y
fi

source "$HOME/.cargo/env"

echo "==> Updating Rust..."

rustup self update
rustup update stable
rustup default stable


# --------------------------------------
# Install Solana CLI
# --------------------------------------

echo
echo "==> Installing Solana CLI..."

if command -v solana >/dev/null 2>&1; then

    echo "Solana CLI already installed:"
    solana --version

else

    echo "Installing Solana CLI..."

    sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"

    # Solana installer normally updates PATH in shell config.
    # Make it available to this current script/session as well.

    if [[ -f "$HOME/.profile" ]]; then
        source "$HOME/.profile" || true
    fi

    if [[ -f "$HOME/.zprofile" ]]; then
        source "$HOME/.zprofile" || true
    fi

    if [[ -f "$HOME/.bashrc" ]]; then
        source "$HOME/.bashrc" || true
    fi

fi


# --------------------------------------
# Check Solana
# --------------------------------------

echo
echo "==> Checking Solana..."

if command -v solana >/dev/null 2>&1; then
    solana --version
else
    echo
    echo "WARNING: Solana was installed but is not currently in PATH."
    echo
    echo "Restart your terminal and run:"
    echo
    echo "    solana --version"
fi


# --------------------------------------
# Install AVM
# --------------------------------------

echo
echo "==> Installing AVM..."

if command -v avm >/dev/null 2>&1; then

    echo "AVM already installed:"
    avm --version

else

    echo "Installing AVM..."

    cargo install --git https://github.com/solana-foundation/anchor avm --force

fi


# --------------------------------------
# Install latest Anchor
# --------------------------------------

echo
echo "==> Installing latest Anchor..."

if command -v avm >/dev/null 2>&1; then

    avm install latest
    avm use latest

else

    echo "ERROR: AVM installation was not successful."
    exit 1

fi


# --------------------------------------
# Final verification
# --------------------------------------

echo
echo "======================================"
echo " Verification"
echo "======================================"

echo
echo "OS:"
uname -s

echo
echo "Architecture:"
uname -m

echo
echo "Rust:"
rustc --version

echo
echo "Cargo:"
cargo --version

echo
echo "Solana:"
if command -v solana >/dev/null 2>&1; then
    solana --version
else
    echo "Not available in current PATH"
fi

echo
echo "AVM:"
if command -v avm >/dev/null 2>&1; then
    avm --version
else
    echo "Not available"
fi

echo
echo "Anchor:"
if command -v anchor >/dev/null 2>&1; then
    anchor --version
else
    echo "Not available"
fi

echo
echo "======================================"
echo " Solana development environment ready!"
echo "======================================"
