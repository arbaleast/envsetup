#!/bin/bash
#===============================================
# 6-docker.sh - Docker + Docker Compose 安装
#===============================================

set -e

echo "[6/8] 安装 Docker..."

# 检查是否已安装
if command -v docker &> /dev/null; then
    echo "  Docker 已安装: $(docker --version)"
    if command -v docker-compose &> /dev/null; then
        echo "  Docker Compose 已安装: $(docker-compose --version)"
    fi
    return 0 2>/dev/null || exit 0
fi

# Docker
echo "  安装 Docker..."
curl -fsSL https://get.docker.com | sh

# 当前用户加入 docker 组
sudo usermod -aG docker "$USER"

# Docker Compose (独立版本)
if ! command -v docker-compose &> /dev/null; then
    echo "  安装 Docker Compose..."
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -o '"tag_name": "v[^"]*"' | cut -d'"' -f4)
    sudo curl -fsSL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# 启动 Docker 守护进程
sudo systemctl enable docker 2>/dev/null || true
sudo systemctl start docker 2>/dev/null || true

echo "✅ Docker 安装完成"
echo "  注意: 需要重新登录或运行 'newgrp docker' 使组成员生效"
echo ""
echo "下一步: bash scripts/7-inputmethod.sh"
