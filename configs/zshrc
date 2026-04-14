# ========== Zsh 配置 ==========

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions command-not-found zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# ========== PATH - 按优先级排序（前置风格） ==========
# Go toolchain
export PATH="/usr/local/go/bin:$PATH"
# Neovim
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
# Rust/Cargo
export PATH="$PATH:$HOME/.cargo/bin"
# Node.js 生态
export PATH="$PATH:$HOME/.npm-global/bin"
export PATH="$PATH:$HOME/.bun/bin"
export PATH="$PATH:$HOME/.nvm/versions/node/v24.14.1/lib/node_modules/opencode-ai/bin"
export PATH="$PATH:$HOME/.opencode/bin"
export PATH="$PATH:$HOME/.opencode-i18n/bin"
# pnpm
export PATH="$PATH:$HOME/.local/share/pnpm"
# CUDA nvcc
export PATH="$PATH:/usr/bin/nvcc"
# Android SDK
export ANDROID_HOME=~/Android/Sdk
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"
# local/bin
export PATH="$PATH:$HOME/.local/bin"

# ========== Go ==========
export GOROOT=/usr/local/go
export GOPATH=$HOME/go

# ========== Ollama ==========
export OLLAMA_HOST=0.0.0.0
export OLLAMA_MODELS=/home/al/.ollama/models

# ========== 代理 ==========
export PROXY_HTTP="http://localhost:7893"
export PROXY_SOCKS="socks5://localhost:7893"

setproxy() {
    export http_proxy=$PROXY_HTTP
    export https_proxy=$PROXY_HTTP
    export all_proxy=$PROXY_SOCKS
    export HTTP_PROXY=$PROXY_HTTP
    export HTTPS_PROXY=$PROXY_HTTP
    export ALL_PROXY=$PROXY_SOCKS
    git config --global http.proxy $PROXY_HTTP
    git config --global https.proxy $PROXY_HTTP
    echo "✅ 代理已开启: $PROXY_HTTP"
}

unsetproxy() {
    unset http_proxy https_proxy all_proxy
    unset HTTP_PROXY HTTPS_PROXY ALL_PROXY
    git config --global --unset http.proxy 2>/dev/null
    git config --global --unset https.proxy 2>/dev/null
    echo "❌ 代理已关闭"
}

proxyinfo() {
    echo "http_proxy:  $http_proxy"
    echo "https_proxy: $https_proxy"
    echo "出口 IP: $(curl -s --connect-timeout 3 ip.sb 2>/dev/null || echo '获取失败')"
}

alias pon='setproxy'
alias poff='unsetproxy'
alias pst='proxyinfo'

# ========== Starship ==========
eval "$(starship init zsh)"

# ========== Aliases ==========
alias tvbuild='cd /vol1/1000/projects/tvlive/android-tv && ./gradlew assembleDebug --parallel -q'
