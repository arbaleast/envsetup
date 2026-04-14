#!/bin/bash
#===============================================
# 3-runtimes.sh - 安装开发语言运行时
#===============================================

set -e

echo "[3/8] 安装开发语言运行时..."

# Go
if ! command -v go &> /dev/null; then
    echo "  安装 Go..."
    GO_VERSION="1.22.3"
    cd /tmp
    wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
    rm -f "go${GO_VERSION}.linux-amd64.tar.gz"
fi
export PATH="/usr/local/go/bin:$PATH"
go version

# Rust
if ! command -v rustc &> /dev/null; then
    echo "  安装 Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
    . "$HOME/.cargo/env"
fi

# NVM (Node.js)
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    echo "  安装 NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install 24 2>/dev/null || true
nvm use 24 2>/dev/null || true

# Bun
if ! command -v bun &> /dev/null; then
    echo "  安装 Bun..."
    curl -fsSL https://bun.sh/install | bash
fi

# Ollama
if ! command -v ollama &> /dev/null; then
    echo "  安装 Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
fi

# Python (系统自带 python3，如需特定版本用 pyenv)
if ! command -v python3 &> /dev/null; then
    echo "  安装 Python..."
    sudo apt install -y python3 python3-pip python3-venv python3-dev
fi

# Pyenv (可选)
export PYENV_ROOT="$HOME/.pyenv"
if [ ! -d "$PYENV_ROOT" ]; then
    echo "  安装 Pyenv..."
    curl -fsSL https://github.com/pyenv/pyenv-installer/raw/master/install.sh | bash
fi

echo "✅ 运行时安装完成"
echo ""
echo "下一步: bash scripts/4-android.sh"
