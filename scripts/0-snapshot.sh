#!/bin/bash
#===============================================
# 0-snapshot.sh - 快照当前系统配置到 envsetup
# 在重装系统前，在现有机器上运行此脚本
#===============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_DIR="$SCRIPT_DIR"
EXPORT_DIR="$SCRIPT_DIR/snapshot/$(date +%Y%m%d)"
SKIP_DIRS="node_modules/.cache/go-build/target"

echo "=========================================="
echo "快照当前系统配置"
echo "=========================================="
echo "导出目录: $EXPORT_DIR"
echo ""

# 创建导出目录
mkdir -p "$EXPORT_DIR"/{home,config,packages,scripts}

#===============================================
# 1. 导出 apt 已安装包列表
#===============================================
echo "[1/6] 导出已安装的 apt 包..."
if command -v dpkg &> /dev/null; then
    dpkg --get-selections | grep -v deinstall | awk '{print $1}' > "$EXPORT_DIR/packages/apt.txt"
    echo "  → $(wc -l < "$EXPORT_DIR/packages/apt.txt") 个包"
fi

#===============================================
# 2. 导出 Homebrew 包列表（macOS）
#===============================================
echo "[2/6] 导出 Homebrew 包..."
if command -v brew &> /dev/null; then
    brew bundle dump --file="$EXPORT_DIR/packages/Brewfile" --force 2>/dev/null || true
fi

#===============================================
# 3. 同步 dotfiles 到 snapshot/home/
#===============================================
echo "[3/6] 同步 home 目录 dotfiles..."

home_dotfiles=(
    .zshrc
    .bashrc
    .bash_profile
    .profile
    .gitconfig
    .gitignore_global
    .vimrc
    .npmrc
    .cargo/config.toml
    .cargo/config
    .ssh/config
    .ssh/known_hosts
    .tmux.conf
    .starship.toml
    .wgetrc
    .curlrc
)

for item in "${home_dotfiles[@]}"; do
    src="$HOME/$item"
    if [ -e "$src" ]; then
        # 跳过符号链接（避免循环）
        if [ ! -L "$src" ]; then
            dest="$EXPORT_DIR/home/$item"
            mkdir -p "$(dirname "$dest")"
            cp -r "$src" "$dest"
            echo "  ✓ $item"
        fi
    fi
done

#===============================================
# 4. 同步 ~/.config/ 到 snapshot/config/
#===============================================
echo "[4/6] 同步 .config/ 目录..."

config_items=(
    starship.toml
    nvim
    alacritty
    foot
    kitty
    tmux
    fish
    zsh
    i3
    sway
    waybar
    fuzzel
    rofi
    dunst
    picom
    mako
    swaync
    cliphist
    Code/User/settings.json
    Code/User/keybindings.json
)

for item in "${config_items[@]}"; do
    src="$HOME/.config/$item"
    if [ -e "$src" ]; then
        dest="$EXPORT_DIR/config/$item"
        mkdir -p "$(dirname "$dest")"
        cp -r "$src" "$dest"
        echo "  ✓ $item"
    fi
done

#===============================================
# 5. 同步 Oh My Zsh 自定义配置
#===============================================
echo "[5/6] 同步 Oh My Zsh 自定义配置..."
# Oh My Zsh 自定义配置（排除 git 历史/test 文件/图片）
omz_custom="$HOME/.oh-my-zsh/custom"
if [ -d "$omz_custom" ]; then
    mkdir -p "$EXPORT_DIR/config/oh-my-zsh-custom"
    rsync -r --exclude='.git' --exclude='test-data' --exclude='tests' \
          --exclude='images' --exclude='*.md' --exclude='.github' \
          "$omz_custom/" "$EXPORT_DIR/config/oh-my-zsh-custom/" 2>/dev/null || true
    echo "  ✓ oh-my-zsh/custom/"
fi

#===============================================
# 6. 导出 Go mod 列表
#===============================================
echo "[6/6] 导出 Go 模块..."
if command -v go &> /dev/null; then
    go list -m all > "$EXPORT_DIR/packages/go-mod.txt" 2>/dev/null || true
fi

#===============================================
# 生成快照信息
#===============================================
cat > "$EXPORT_DIR/info.txt" << EOF
快照时间: $(date)
主机名: $(hostname)
系统: $(uname -a)
EOF

echo ""
echo "=========================================="
echo "✅ 快照完成!"
echo "=========================================="
echo ""
echo "已导出的内容:"
du -sh "$EXPORT_DIR" 2>/dev/null || true
echo ""
echo "下一步:"
echo "  1. 将 envsetup/ 目录上传到 GitHub 或备份到U盘"
echo "  2. 重装系统后运行: bash setup.sh"
echo "  3. 或恢复特定配置: bash scripts/restore.sh"
echo ""
