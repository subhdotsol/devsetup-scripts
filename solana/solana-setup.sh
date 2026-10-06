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
        echo
        echo "ERROR: Unsupported operating system: $OS"
        exit 1
        ;;
esac

echo "==> Detected platform: $PLATFORM"


# --------------------------------------
# Install system dependencies
# --------------------------------------

echo
echo "==> Installing system dependencies..."

if [[ "$PLATFORM" == "macos" ]]; then

    # ----------------------------------
    # macOS
    # ----------------------------------

    if ! command -v brew >/dev/null 2>&1; then
        echo
        echo "ERROR: Homebrew is not installed."
        echo
        echo "Install Homebrew from:"
        echo "https://brew.sh/"
        exit 1
    fi

    echo "==> Updating Homebrew..."
    brew update

    echo "==> Installing dependencies..."

    brew install \
        curl \
        git \
        pkg-config \
        openssl

elif [[ "$PLATFORM" == "linux" ]]; then

    # ----------------------------------
    # Linux
    # ----------------------------------

    if ! command -v apt-get >/dev/null 2>&1; then
        echo
        echo "ERROR: This Linux distribution does not use apt."
        echo "Only Debian/Ubuntu-based systems are currently supported."
        exit 1
    fi

    echo "==> Updating apt..."

    sudo apt-get update

    echo "==> Installing dependencies..."

    sudo apt-get install -y \
        curl \
        git \
        pkg-config \
        build-essential \
        libssl-dev \
        libudev-dev
fi


# --------------------------------------
# Install Rust
# --------------------------------------

echo
echo "======================================"
echo " Installing Rust"
echo "======================================"

if command -v rustup >/dev/null 2>&1; then

    echo "==> Rustup already installed."

else

    echo "==> Installing Rustup..."

    curl --proto '=https' \
         --tlsv1.2 \
         -sSf https://sh.rustup.rs \
         | sh -s -- -y
fi

# Load Rust into current shell
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

echo "==> Updating Rust..."

rustup self update || true
rustup toolchain install stable
rustup default stable

echo
echo "Rust:"
rustc --version

echo
echo "Cargo:"
cargo --version


# --------------------------------------
# Install Solana CLI
# --------------------------------------

echo
echo "======================================"
echo " Installing Solana CLI"
echo "======================================"

if command -v solana >/dev/null 2>&1; then

    echo "==> Solana CLI already installed."
    solana --version

else

    echo "==> Installing Solana CLI..."

    sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"

fi


# --------------------------------------
# Configure Solana PATH
# --------------------------------------

SOLANA_BIN="$HOME/.local/share/solana/install/active_release/bin"

if [[ -d "$SOLANA_BIN" ]]; then

    export PATH="$SOLANA_BIN:$PATH"

fi


# --------------------------------------
# Persist Solana PATH
# --------------------------------------

if [[ "$PLATFORM" == "macos" ]]; then

    SHELL_CONFIG="$HOME/.zshrc"

else

    SHELL_CONFIG="$HOME/.bashrc"

fi

if [[ -d "$SOLANA_BIN" ]]; then

    if ! grep -Fq "$SOLANA_BIN" "$SHELL_CONFIG" 2>/dev/null; then

        echo
        echo "==> Adding Solana to PATH..."

        cat >> "$SHELL_CONFIG" <<EOF

# Solana CLI
export PATH="\$HOME/.local/share/solana/install/active_release/bin:\$PATH"
EOF

    fi

fi


# --------------------------------------
# Verify Solana
# --------------------------------------

echo
echo "==> Checking Solana..."

if command -v solana >/dev/null 2>&1; then

    solana --version

else

    echo
    echo "WARNING: Solana is installed but is not available"
    echo "in the current PATH."
    echo
    echo "Run:"
    echo
    echo "    source $SHELL_CONFIG"
    echo
    echo "Then:"
    echo
    echo "    solana --version"
fi


# --------------------------------------
# Install AVM
# --------------------------------------

echo
echo "======================================"
echo " Installing Anchor Version Manager"
echo "======================================"

if command -v avm >/dev/null 2>&1; then

    echo "==> AVM already installed."
    avm --version

else

    echo "==> Installing AVM..."

    cargo install \
        --git https://github.com/solana-foundation/anchor \
        avm \
        --force
fi


# --------------------------------------
# Configure Cargo PATH
# --------------------------------------

export PATH="$HOME/.cargo/bin:$PATH"

if ! grep -Fq '$HOME/.cargo/bin' "$SHELL_CONFIG" 2>/dev/null; then

    echo
    echo "==> Adding Cargo to PATH..."

    cat >> "$SHELL_CONFIG" <<'EOF'

# Rust / Cargo
export PATH="$HOME/.cargo/bin:$PATH"
EOF

fi


# --------------------------------------
# Verify AVM
# --------------------------------------

echo
echo "==> Checking AVM..."

if ! command -v avm >/dev/null 2>&1; then

    echo
    echo "ERROR: AVM installation failed."
    exit 1

fi

avm --version


# --------------------------------------
# Install latest Anchor
# --------------------------------------

echo
echo "======================================"
echo " Installing latest Anchor"
echo "======================================"

echo "==> Installing latest Anchor..."

avm install latest
avm use latest


# --------------------------------------
# Final PATH refresh
# --------------------------------------

export PATH="$HOME/.cargo/bin:$SOLANA_BIN:$PATH"


# --------------------------------------
# Final verification
# --------------------------------------

echo
echo "======================================"
echo " Verification"
echo "======================================"

echo
echo "Operating System:"
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
    echo "Not available"
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

echo
echo "Restart your terminal or run:"
echo
echo "    source $SHELL_CONFIG"
echo
