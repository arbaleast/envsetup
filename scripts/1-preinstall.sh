#!/bin/bash
#===============================================
# 1-preinstall.sh - 系统基础工具安装
# 适用于：Debian/Ubuntu
#===============================================

set -e

echo "[1/8] 安装系统基础工具..."

sudo apt update

# 基础网络工具
sudo apt install -y \
    curl wget git vim vim-common \
    unzip zip xz-utils bzip2 gzip \
    tar p7zip-full jq

# sudo 配置（如未安装）
command -v sudo >/dev/null || {
    echo "sudo 未安装，请先手动配置 root"
    exit 1
}

# 终端
sudo apt install -y \
    zsh bash-completion tmux

# 编译工具链
sudo apt install -y \
    build-essential cmake clang \
    gcc g++ make autoconf automake libtool \
    pkg-config

# 系统工具
sudo apt install -y \
    htop bmon nethogs iotop \
    strace ltrace dstat \
    net-tools iputils-ping dnsutils \
    lsof strace perf

# 文件管理
sudo apt install -y \
    tree fd-find fzf ripgrep \
    bat exa ncdu rsync

# 字体
sudo apt install -y \
    fonts-firacode fonts-jetbrains-mono \
    fonts-noto-cjk fonts-wqy-zenhei fonts-wqy-microhei

# 基础开发库
sudo apt install -y \
    libssl-dev libffi-dev python3-dev \
    libbz2-dev libreadline-dev libsqlite3-dev \
    libncurses5-dev libncursesw5-dev

echo "✅ 基础工具安装完成"
echo ""
echo "下一步: 重启终端或运行: bash scripts/2-shells.sh"
