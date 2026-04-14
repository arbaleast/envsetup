#!/bin/bash
#===============================================
# 2-shells.sh - 安装 Oh My Zsh + Starship + tmux
#===============================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_DIR

echo "[2/8] 安装 Shell 配置..."

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "  安装 Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Oh My Zsh 插件
echo "  安装 Oh My Zsh 插件..."
local plugins_dir="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$plugins_dir"
[ -d "$plugins_dir/zsh-autosuggestions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
[ -d "$plugins_dir/zsh-syntax-highlighting" ] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$plugins_dir/zsh-syntax-highlighting"
[ -d "$plugins_dir/zsh-completions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-completions "$plugins_dir/zsh-completions"

# Starship
if ! command -v starship &> /dev/null; then
    echo "  安装 Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# tmux 插件管理器
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "  安装 Tmux Plugin Manager..."
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# 部署 dotfiles（创建符号链接）
echo "  部署 dotfiles..."
[ -f "$DOTFILES_DIR/configs/zshrc" ] && ln -sf "$DOTFILES_DIR/configs/zshrc" "$HOME/.zshrc"
[ -f "$DOTFILES_DIR/configs/gitconfig" ] && ln -sf "$DOTFILES_DIR/configs/gitconfig" "$HOME/.gitconfig"
[ -f "$DOTFILES_DIR/configs/starship.toml" ] && ln -sf "$DOTFILES_DIR/configs/starship.toml" "$HOME/.config/starship.toml"
[ -f "$DOTFILES_DIR/configs/tmux.conf" ] && ln -sf "$DOTFILES_DIR/configs/tmux.conf" "$HOME/.tmux.conf"

# 设为默认 shell
if command -v zsh &> /dev/null; then
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        echo "  设置 zsh 为默认 shell..."
        chsh -s "$(command -v zsh)"
    fi
fi

echo "✅ Shell 配置完成"
echo ""
echo "下一步: bash scripts/3-runtimes.sh"
