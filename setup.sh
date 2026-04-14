#!/bin/bash
#===============================================
# envsetup - 重装系统后一键配置开发环境
# 使用方式: bash setup.sh
#===============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "envsetup - 开始配置开发环境"
echo "=========================================="
echo ""
echo "各阶段说明:"
echo "  [1] preinstall   - 系统基础工具"
echo "  [2] shells        - Oh My Zsh + Starship + tmux"
echo "  [3] runtimes      - Go / Rust / Node.js / Bun / Ollama / Python"
echo "  [4] android       - Android SDK"
echo "  [5] gpu           - NVIDIA GPU 驱动检查"
echo "  [6] docker        - Docker + Docker Compose"
echo "  [7] inputmethod   - fcitx5 中文输入法"
echo "  [8] projects      - 创建项目目录结构"
echo ""
read -p "是否按顺序执行所有步骤? [Y/n]: " confirm
confirm="${confirm:-Y}"

if [[ "$confirm" =~ ^[Nn]$ ]]; then
    echo "已取消，请单独运行: bash scripts/<阶段>.sh"
    exit 0
fi

echo ""

# 按顺序执行所有脚本
for i in 1 2 3 4 5 6 7 8; do
    script_name=$(printf "%02d" $i)
    script="scripts/${script_name}-*.sh"
    script_path=$(ls $script 2>/dev/null | head -1)

    if [ -f "$script_path" ]; then
        echo ""
        echo ">>> 执行: $script_path"
        echo ""
        bash "$script_path"
    fi
done
