#!/bin/bash
#===============================================
# restore.sh - 从快照恢复指定配置
# 使用方式:
#   bash restore.sh              # 交互式选择
#   bash restore.sh --all         # 恢复全部
#   bash restore.sh --home       # 仅恢复 home dotfiles
#   bash restore.sh --config     # 仅恢复 .config
#   bash restore.sh --packages   # 仅恢复 apt 包
#===============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SNAPSHOT_DIR="$SCRIPT_DIR/snapshot"
LATEST_SNAPSHOT=$(ls -td "$SNAPSHOT_DIR"/[0-9]* 2>/dev/null | head -1)

MODE="${1:-interactive}"

echo "=========================================="
echo "从快照恢复配置"
echo "============================================"

if [ -z "$LATEST_SNAPSHOT" ]; then
    echo "错误: 未找到快照目录"
    echo "请先运行: bash scripts/0-snapshot.sh"
    exit 1
fi

echo "使用快照: $LATEST_SNAPSHOT"
echo ""

restore_home() {
    echo "[恢复] home 目录 dotfiles..."
    local count=0
    for item in "$LATEST_SNAPSHOT/home"/*; do
        [ -e "$item" ] || continue
        local name="$(basename "$item")"
        local dest="$HOME/$name"
        # 备份现有文件
        [ -e "$dest" ] && cp -r "$dest" "${dest}.bak.$(date +%s)" 2>/dev/null || true
        cp -r "$item" "$dest"
        echo "  ✓ $name"
        ((count++))
    done
    echo "  共恢复 $count 个文件"
}

restore_config() {
    echo "[恢复] .config/ 目录..."
    local count=0
    for item in "$LATEST_SNAPSHOT/config"/*; do
        [ -e "$item" ] || continue
        local name="$(basename "$item")"
        local dest="$HOME/.config/$name"
        # 备份现有目录
        [ -e "$dest" ] && cp -r "$dest" "${dest}.bak.$(date +%s)" 2>/dev/null || true
        mkdir -p "$(dirname "$dest")"
        cp -r "$item" "$dest"
        echo "  ✓ $name"
        ((count++))
    done
    echo "  共恢复 $count 个配置"
}

restore_apt() {
    echo "[恢复] apt 包..."
    if [ -f "$LATEST_SNAPSHOT/packages/apt.txt" ]; then
        echo "  安装 $(wc -l < "$LATEST_SNAPSHOT/packages/apt.txt") 个 apt 包..."
        xargs -a "$LATEST_SNAPSHOT/packages/apt.txt" sudo apt install -y
    fi
}

restore_packages() {
    echo "[恢复] 已安装包列表..."
    if [ -f "$LATEST_SNAPSHOT/packages/apt.txt" ]; then
        echo "  apt: $(wc -l < "$LATEST_SNAPSHOT/packages/apt.txt") 个包"
    fi
    if [ -f "$LATEST_SNAPSHOT/packages/Brewfile" ]; then
        echo "  Homebrew: $(grep -c "brew " "$LATEST_SNAPSHOT/packages/Brewfile" 2>/dev/null || echo 0) 个包"
    fi
}

if [ "$MODE" == "--all" ]; then
    restore_home
    restore_config
    restore_apt
elif [ "$MODE" == "--home" ]; then
    restore_home
elif [ "$MODE" == "--config" ]; then
    restore_config
elif [ "$MODE" == "--packages" ]; then
    restore_apt
elif [ "$MODE" == "--list" ]; then
    echo "可用快照:"
    ls -la "$SNAPSHOT_DIR/"
    echo ""
    echo "快照内容:"
    find "$LATEST_SNAPSHOT" -type f | sed "s|$LATEST_SNAPSHOT/||" | head -30
else
    echo "用法:"
    echo "  bash restore.sh --all        # 恢复全部"
    echo "  bash restore.sh --home       # 仅恢复 home dotfiles"
    echo "  bash restore.sh --config    # 仅恢复 .config"
    echo "  bash restore.sh --packages  # 仅恢复 apt 包"
    echo "  bash restore.sh --list      # 查看快照内容"
fi
