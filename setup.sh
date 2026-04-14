#!/bin/bash
#===============================================
# envsetup - 一键配置重装系统后的开发环境
#===============================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR

echo "=========================================="
echo "envsetup - 开始配置开发环境"
echo "=========================================="

# 检测系统
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [[ -f /etc/debian_version ]]; then
            echo "debian"
        elif [[ -f /etc/redhat-release ]]; then
            echo "rhel"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

OS_TYPE=$(detect_os)
echo "检测系统: $OS_TYPE"

#===============================================
# 1. 安装基础工具
#===============================================
install_base() {
    echo ""
    echo "[1/5] 安装基础工具..."

    if [[ "$OS_TYPE" == "debian" ]]; then
        sudo apt update
        sudo apt install -y \
            curl wget git vim unzip xz-utils zip \
            build-essential cmake clang \
            fonts-firacode zsh autojump \
            fzf ripgrep fd-find \
            tree jq bat exa
    elif [[ "$OS_TYPE" == "macos" ]]; then
        if ! command -v brew &> /dev/null; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install \
            curl wget git vim unzip \
            cmake clang \
            zsh autojump \
            fzf ripgrep fd tree jq bat exa
    fi
}

#===============================================
# 2. 安装开发语言运行时
#===============================================
install_runtimes() {
    echo ""
    echo "[2/5] 安装开发语言运行时..."

    # Go
    if ! command -v go &> /dev/null; then
        echo "  安装 Go..."
        cd /tmp
        wget -q https://go.dev/dl/go1.22.3.linux-amd64.tar.gz
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf go1.22.3.linux-amd64.tar.gz
        rm go1.22.3.linux-amd64.tar.gz
    fi

    # Rust
    if ! command -v rustc &> /dev/null; then
        echo "  安装 Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi

    # Node.js (via nvm)
    if ! command -v nvm &> /dev/null && [ ! -d "$HOME/.nvm" ]; then
        echo "  安装 NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    fi

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
}

#===============================================
# 3. 安装 Oh My Zsh + Starship
#===============================================
install_shell() {
    echo ""
    echo "[3/5] 安装 Oh My Zsh + Starship..."

    # Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "  安装 Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Oh My Zsh 插件
    echo "  安装 Oh My Zsh 插件..."
    local plugins_dir="$HOME/.oh-my-zsh/custom/plugins"
    [ -d "$plugins_dir/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
    [ -d "$plugins_dir/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting "$plugins_dir/zsh-syntax-highlighting"

    # Starship
    if ! command -v starship &> /dev/null; then
        echo "  安装 Starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi
}

#===============================================
# 4. 部署配置文件（创建符号链接）
#===============================================
deploy_configs() {
    echo ""
    echo "[4/5] 部署配置文件..."

    # zshrc
    if [ -f "$DOTFILES_DIR/configs/zshrc" ]; then
        echo "  部署 .zshrc..."
        ln -sf "$DOTFILES_DIR/configs/zshrc" "$HOME/.zshrc"
    fi

    # gitconfig
    if [ -f "$DOTFILES_DIR/configs/gitconfig" ]; then
        echo "  部署 .gitconfig..."
        ln -sf "$DOTFILES_DIR/configs/gitconfig" "$HOME/.gitconfig"
    fi

    # Starship
    if [ -f "$DOTFILES_DIR/configs/starship.toml" ]; then
        echo "  部署 starship.toml..."
        mkdir -p "$HOME/.config"
        ln -sf "$DOTFILES_DIR/configs/starship.toml" "$HOME/.config/starship.toml"
    fi

    # Neovim config
    if [ -d "$DOTFILES_DIR/configs/nvim" ]; then
        echo "  部署 Neovim 配置..."
        ln -sf "$DOTFILES_DIR/configs/nvim" "$HOME/.config/nvim"
    fi
}

#===============================================
# 5. 创建项目目录
#===============================================
setup_dirs() {
    echo ""
    echo "[5/5] 创建项目目录..."

    local dirs=(
        "$HOME/projects"
        "$HOME/go/src"
        "$HOME/go/pkg"
        "$HOME/go/bin"
        "$HOME/Android/Sdk"
        "$HOME/.ollama/models"
        "$HOME/.local/share/Trash"
    )

    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            echo "  创建 $dir"
            mkdir -p "$dir"
        fi
    done
}

#===============================================
# 主流程
#===============================================
main() {
    install_base
    install_runtimes
    install_shell
    deploy_configs
    setup_dirs

    echo ""
    echo "=========================================="
    echo "✅ 环境配置完成!"
    echo "=========================================="
    echo ""
    echo "下一步:"
    echo "  1. 重启终端或执行: source ~/.zshrc"
    echo "  2. 运行: nvm install 24 && nvm use 24"
    echo "  3. 配置 Git: git config --global user.name 'Your Name'"
    echo ""
}

main "$@"
