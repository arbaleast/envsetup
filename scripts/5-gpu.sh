#!/bin/bash
#===============================================
# 5-gpu.sh - NVIDIA GPU 驱动 + CUDA 安装
#===============================================

set -e

echo "[5/8] 配置 NVIDIA GPU..."

# 检查是否有 NVIDIA 显卡
if ! command -v nvidia-smi &> /dev/null; then
    echo "  未检测到 NVIDIA 显卡，跳过 GPU 配置"
    echo "  如需手动安装，运行: sudo apt install nvidia-driver nvidia-dkms"
    return 0 2>/dev/null || exit 0
fi

nvidia-smi --query-gpu=name,driver_version --format=csv,noheader

# 检查 CUDA 是否已安装
if command -v nvcc &> /dev/null; then
    echo "  CUDA 已安装: $(nvcc --version | grep release)"
    nvcc --version
else
    echo "  CUDA 未安装..."
    echo "  推荐安装方式:"
    echo "    1. 下载 CUDA Toolkit: https://developer.nvidia.com/cuda-downloads"
    echo "    2. 或: sudo apt install nvidia-cuda-toolkit"
fi

# cuDNN（如需要）
echo ""
echo "  如需安装 cuDNN:"
echo "    https://developer.nvidia.com/cudnn-download"

# 设置持久化模式（推荐用于桌面）
if command -v nvidia-smi &> /dev/null; then
    sudo nvidia-smi -pm 1 2>/dev/null || echo "  持久化模式设置需要 sudo"
fi

echo "✅ GPU 配置检查完成"
echo ""
echo "下一步: bash scripts/6-docker.sh"
