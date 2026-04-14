# envsetup - 重装系统后一键配置开发环境

适用于 Debian/Ubuntu (Linux) 全新系统重装后的一键环境配置脚本。

## 目录结构

```
envsetup/
├── setup.sh              # 主入口（一键执行全部）
├── configs/
│   ├── zshrc             # Zsh 配置
│   ├── gitconfig         # Git 配置
│   ├── starship.toml     # Starship 配置
│   └── tmux.conf         # tmux 配置
└── scripts/
    ├── 1-preinstall.sh   # 系统基础工具
    ├── 2-shells.sh       # Oh My Zsh + Starship + tmux
    ├── 3-runtimes.sh     # Go / Rust / Node.js / Bun / Ollama / Python
    ├── 4-android.sh      # Android SDK
    ├── 5-gpu.sh          # NVIDIA GPU 驱动检查
    ├── 6-docker.sh       # Docker + Docker Compose
    ├── 7-inputmethod.sh   # fcitx5 中文输入法
    └── 8-projects.sh     # 创建项目目录结构
```

## 一键执行（推荐）

```bash
bash setup.sh
```

或分步执行：

```bash
bash scripts/1-preinstall.sh
bash scripts/2-shells.sh
bash scripts/3-runtimes.sh
bash scripts/4-android.sh
bash scripts/5-gpu.sh
bash scripts/6-docker.sh
bash scripts/7-inputmethod.sh
bash scripts/8-projects.sh
```

## 各阶段覆盖内容

| 阶段 | 内容 |
|------|------|
| 1-preinstall | curl/wget/git/vim/unzip/build-essential/cmake/clang/fzf/ripgrep/tree/jq/bat/exa/字体 |
| 2-shells | Oh My Zsh / Starship / tmux + TPM / 插件 (autosuggestions/syntax-highlighting/completions) |
| 3-runtimes | Go 1.22 / Rust / Node.js 24 (nvm) / Bun / Ollama / Python + pyenv |
| 4-android | cmdline-tools / platform-tools / build-tools 34 / platforms android-34 / NDK 26 / CMake 3.22 |
| 5-gpu | NVIDIA 驱动检查 / CUDA 安装提示 |
| 6-docker | Docker CE / Docker Compose v2 |
| 7-inputmethod | fcitx5 + rime 拼音 + 自动启动配置 |
| 8-projects | ~/projects / ~/go/src / ~/Android/Sdk 等目录创建 |

## 已集成的 dotfiles 配置

- **Shell**: Oh My Zsh + Starship + tmux
- **PATH**: Go > Neovim > Cargo > Node 生态 > pnpm > CUDA > Android SDK
- **代理**: localhost:7893（pon/poff/pst）
- **Git**: GitHub SSH + HTTPS 代理
- **输入法**: fcitx5 + rime 简体拼音

## 使用前提

- Debian/Ubuntu 系统
- sudo 权限
- 网络连接（用于下载工具）

## 重启后操作

1. `source ~/.zshrc` 加载新配置
2. 重新登录（使 docker 组 / NVM / fcitx5 等生效）
3. 配置 Git 用户信息
4. 生成 SSH Key 并添加到 GitHub

## 自定义 dotfiles

替换 `configs/` 目录下的文件后，重新执行对应脚本即可覆盖。

```bash
cp ~/.zshrc configs/zshrc
cp ~/.gitconfig configs/gitconfig
bash scripts/2-shells.sh  # 重新部署
```
