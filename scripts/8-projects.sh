#!/bin/bash
#===============================================
# 8-projects.sh - 创建项目目录结构
#===============================================

set -e

echo "[8/8] 创建项目目录结构..."

# 项目根目录
PROJECTS_DIR="$HOME/projects"
mkdir -p "$PROJECTS_DIR"

# Go 目录
mkdir -p "$HOME/go/src"
mkdir -p "$HOME/go/pkg"
mkdir -p "$HOME/go/bin"

# Android
mkdir -p "$HOME/Android/Sdk"

# Ollama
mkdir -p "$HOME/.ollama/models"

# Docker
mkdir -p "$HOME/.docker"

# 下载目录
mkdir -p "$HOME/Downloads"

# 工作目录
mkdir -p "$HOME/workspace"

# 清理
mkdir -p "$HOME/.local/share/Trash"

# 创建常用软链接
[ ! -L "$HOME/projects/projects" ] && ln -sf /vol1/1000/projects "$HOME/projects/projects" 2>/dev/null || true

echo "✅ 项目目录创建完成"
echo ""
echo "=========================================="
echo "✅ 环境配置全部完成!"
echo "=========================================="
echo ""
echo "请执行以下步骤完成配置:"
echo ""
echo "  1. 重启终端 或 执行: source ~/.zshrc"
echo "  2. 重新登录以生效:"
echo "     - 用户组变更 (docker)"
echo "     - NVM 环境变量"
echo "     - fcitx5 输入法"
echo "     - pyenv"
echo ""
echo "  3. 启动 Docker: sudo systemctl start docker"
echo ""
echo "  4. 配置 Git 用户信息:"
echo "     git config --global user.name 'Your Name'"
echo "     git config --global user.email 'your@email.com'"
echo ""
echo "  5. 生成 SSH Key 并添加到 GitHub:"
echo "     ssh-keygen -t ed25519 -C 'your@email.com'"
echo "     cat ~/.ssh/id_ed25519.pub"
echo ""
echo "其他可选操作:"
echo "  - 安装 VS Code / JetBrains IDE"
echo "  - 配置 Chrome/Firefox 浏览器"
echo "  - 安装 Spotify / Discord 等娱乐软件"
echo ""
