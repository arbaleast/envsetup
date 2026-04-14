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

# 查找最新快照作为配置源
LATEST_SNAPSHOT=$(ls -td "$DOTFILES_DIR/snapshot"/[0-9]* 2>/dev/null | head -1)
CONFIG_SRC="$DOTFILES_DIR/configs"
[ -n "$LATEST_SNAPSHOT" ] && CONFIG_SRC="$LATEST_SNAPSHOT"

echo "  配置来源: $CONFIG_SRC"

# 部署 dotfiles（创建符号链接）
deploy_dotfile() {
    local src="$CONFIG_SRC/$1"
    local dest="$HOME/$2"
    if [ -e "$src" ]; then
        mkdir -p "$(dirname "$dest")"
        ln -sf "$src" "$dest"
        echo "  ✓ $2"
    fi
}

echo "  部署 dotfiles..."
deploy_dotfile "home/.zshrc" ".zshrc"
deploy_dotfile "home/.bashrc" ".bashrc"
deploy_dotfile "home/.profile" ".profile"
deploy_dotfile "home/.gitconfig" ".gitconfig"
deploy_dotfile "home/.npmrc" ".npmrc"
deploy_dotfile "home/.cargo" ".cargo"
deploy_dotfile "home/.ssh/config" ".ssh/config"
deploy_dotfile "home/.ssh/known_hosts" ".ssh/known_hosts"
deploy_dotfile "config/starship.toml" ".config/starship.toml"
deploy_dotfile "config/tmux.conf" ".tmux.conf"

# Neovim 配置
if [ -d "$CONFIG_SRC/config/nvim" ]; then
    mkdir -p "$HOME/.config"
    ln -sf "$CONFIG_SRC/config/nvim" "$HOME/.config/nvim"
    echo "  ✓ nvim"
fi

# Oh My Zsh 自定义配置
if [ -d "$CONFIG_SRC/config/oh-my-zsh-custom" ]; then
    local omz_custom="$HOME/.oh-my-zsh/custom"
    mkdir -p "$omz_custom"
    rsync -r "$CONFIG_SRC/config/oh-my-zsh-custom/" "$omz_custom/" 2>/dev/null || true
    echo "  ✓ oh-my-zsh/custom/"
fi

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
