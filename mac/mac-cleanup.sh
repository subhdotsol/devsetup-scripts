#!/usr/bin/env bash

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

msg() {
    echo -e "${GREEN}==>${NC} $1"
}

before=$(df -k ~ | awk 'NR==2 {print $4}')

# Bun

if command -v bun >/dev/null 2>&1; then
    msg "Cleaning Bun cache..."
    rm -rf ~/.bun/install/cache 2>/dev/null || true
fi

# npm

if command -v npm >/dev/null 2>&1; then
    msg "Cleaning npm cache..."
    npm cache clean --force >/dev/null 2>&1 || true
fi

# pnpm

if command -v pnpm >/dev/null 2>&1; then
    msg "Cleaning pnpm..."
    pnpm store prune >/dev/null 2>&1 || true
fi

rm -rf ~/Library/pnpm 2>/dev/null || true
rm -rf ~/Library/Caches/pnpm 2>/dev/null || true

# Yarn

if command -v yarn >/dev/null 2>&1; then
    msg "Cleaning Yarn cache..."
    yarn cache clean >/dev/null 2>&1 || true
fi

# Go

if command -v go >/dev/null 2>&1; then
    msg "Cleaning Go cache..."
    go clean -cache >/dev/null 2>&1 || true
    go clean -modcache >/dev/null 2>&1 || true
fi
# General caches

msg "Cleaning macOS caches..."

rm -rf ~/Library/Caches/* 2>/dev/null || true
rm -rf ~/.cache/* 2>/dev/null || true

# VS Code

msg "Cleaning VS Code cache..."

rm -rf ~/Library/Application\ Support/Code/Cache 2>/dev/null || true
rm -rf ~/Library/Application\ Support/Code/CachedData 2>/dev/null || true
rm -rf ~/Library/Application\ Support/Code/Service\ Worker/CacheStorage 2>/dev/null || true


# Playwright


if [ -d ~/Library/Caches ]; then
    msg "Cleaning Playwright cache..."
    rm -rf ~/Library/Caches/ms-playwright* 2>/dev/null || true
fi


# Cypress


msg "Cleaning Cypress cache..."

rm -rf ~/Library/Caches/Cypress 2>/dev/null || true


# Docker

if command -v docker >/dev/null 2>&1; then
    echo
    read -rp "Prune Docker images/containers/volumes? (y/N): " ans

    if [[ "$ans" =~ ^[Yy]$ ]]; then
        msg "Cleaning Docker..."
        docker system prune -a --volumes -f || true
    fi
fi

# Done

after=$(df -k ~ | awk 'NR==2 {print $4}')
freed=$(( (after - before) / 1024 ))

echo
echo -e "${BLUE}=======================================${NC}"
echo -e "${GREEN}Cleanup complete.${NC}"

if (( freed > 0 )); then
    echo -e "${GREEN}Approximate space recovered:${NC} ${freed} MB"
else
    echo -e "${YELLOW}No significant disk space recovered.${NC}"
fi

echo -e "${BLUE}=======================================${NC}"%
