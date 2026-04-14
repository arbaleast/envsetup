# envsetup - 重装系统后一键配置开发环境

## 功能

- 安装基础工具（curl, wget, git, vim, build-essential, cmake, clang 等）
- 安装开发语言运行时（Go, Rust, Node.js/nvm, Bun, Ollama）
- 安装 Oh My Zsh + Starship 终端配置
- 部署配置文件（.zshrc, .gitconfig, starship.toml, Neovim）
- 创建项目目录结构

## 目录结构

```
envsetup/
├── setup.sh              # 主入口脚本
├── configs/
│   ├── zshrc             # Zsh 配置
│   ├── gitconfig         # Git 配置
│   ├── starship.toml     # Starship 配置
│   └── nvim/             # Neovim 配置（可选）
└── scripts/
    └── install-tools.sh  # 工具安装脚本
```

## 使用方法

```bash
# 克隆或复制到本地
git clone https://github.com/yourname/envsetup.git ~/envsetup
cd ~/envsetup

# 执行主脚本（需要 sudo 权限）
bash setup.sh

# 或交互式执行
./setup.sh
```

## 部署自己的 dotfiles

项目内置的是基础配置。如需使用自己的 dotfiles：

1. 将现有配置复制到 `configs/` 目录
2. 修改 `setup.sh` 中的 `deploy_configs` 函数
3. 重新执行即可覆盖

```bash
# 覆盖现有配置
cp ~/.zshrc configs/zshrc
cp ~/.gitconfig configs/gitconfig
cp ~/.config/starship.toml configs/starship.toml
```

## 当前环境配置（已集成）

- **Shell**: Oh My Zsh + Starship
- **PATH**: Go / Neovim / Cargo / Node 生态 / CUDA / Android SDK
- **代理**: localhost:7893（setproxy/poff/pst）
- **Git**: GitHub SSH + 代理

## 前提条件

- Linux (Debian/Ubuntu) 或 macOS
- sudo 权限
- 网络连接

## 已知问题

- Android SDK 需要手动接受 license: `yes | sdkmanager --licenses`
- CUDA 如需 GPU 支持，需单独安装 NVIDIA 驱动
- Node.js 版本可通过 `nvm install 24 && nvm use 24` 安装
