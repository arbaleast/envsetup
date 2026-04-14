# envsetup - 重装系统后一键配置开发环境

适用于 Debian/Ubuntu (Linux) 全新系统重装后的一键环境配置脚本。

## 核心思路

**两阶段工作流**：
1. **快照阶段**（重装前）：在现有系统上运行 `0-snapshot.sh`，将配置导出到 `snapshot/`
2. **恢复阶段**（重装后）：在新系统上运行 `setup.sh`，自动从 `snapshot/` 恢复所有配置

## 目录结构

```
envsetup/
├── setup.sh              # 主入口（在新系统上执行）
├── scripts/
│   ├── 0-snapshot.sh     # 快照脚本（在旧系统上执行）
│   ├── restore.sh        # 增量恢复脚本
│   ├── 1-preinstall.sh   # 系统基础工具
│   ├── 2-shells.sh       # Oh My Zsh + Starship + tmux + 部署 dotfiles
│   ├── 3-runtimes.sh     # Go / Rust / Node.js / Bun / Ollama / Python
│   ├── 4-android.sh      # Android SDK
│   ├── 5-gpu.sh          # NVIDIA GPU 驱动检查
│   ├── 6-docker.sh       # Docker + Docker Compose
│   └── 7-projects.sh     # 创建项目目录结构
├── configs/              # 基础配置（模板，snapshot 会覆盖）
│   ├── zshrc
│   ├── gitconfig
│   ├── starship.toml
│   └── tmux.conf
└── snapshot/            # 快照存储（由 0-snapshot.sh 生成）
    └── YYYYMMDD/
        ├── home/         # home 目录 dotfiles
        ├── config/       # .config/ 目录
        └── packages/
            ├── apt.txt   # 已安装 apt 包列表
            └── go-mod.txt
```

## 使用流程

### 阶段 1：重装前 — 创建快照

```bash
cd ~/envsetup
bash scripts/0-snapshot.sh
```

这会导出：
- `apt.txt` — 所有已安装的 apt 包（1658+）
- `home/` — .zshrc / .bashrc / .gitconfig / .npmrc / .ssh 等
- `config/` — Neovim / Starship / tmux / Oh My Zsh 自定义插件
- `go-mod.txt` — Go 模块列表

将 `envsetup/` 目录同步到 GitHub（或其他备份位置）：

```bash
cd ~/envsetup
git add -A && git commit -m "snapshot: $(date +%Y%m%d)" && git push
```

### 阶段 2：重装后 — 一键恢复

```bash
# 克隆 dotfiles
git clone https://github.com/arbaleast/envsetup.git ~/envsetup
cd ~/envsetup

# 执行全部配置
bash setup.sh
```

或分步执行：
```bash
bash scripts/1-preinstall.sh    # 安装基础工具
bash scripts/2-shells.sh        # 部署 shell 配置（自动使用 snapshot/ 中的 dotfiles）
bash scripts/3-runtimes.sh      # 安装语言运行时
bash scripts/4-android.sh       # Android SDK
bash scripts/5-gpu.sh           # GPU 驱动检查
bash scripts/6-docker.sh        # Docker
bash scripts/7-projects.sh      # 项目目录
```

## 增量恢复（不用全部重装）

```bash
bash scripts/restore.sh --all       # 恢复全部
bash scripts/restore.sh --home      # 仅恢复 home dotfiles
bash scripts/restore.sh --config   # 仅恢复 .config/
bash scripts/restore.sh --packages # 重新安装 apt 包
bash scripts/restore.sh --list     # 查看快照内容
```

## 各阶段覆盖内容

| 阶段 | 内容 |
|------|------|
| 0-snapshot | 导出当前系统配置到 snapshot/ |
| 1-preinstall | curl/wget/git/vim/unzip/build-essential/cmake/clang/fzf/ripgrep/tree/jq/bat/exa/字体 |
| 2-shells | Oh My Zsh / Starship / tmux + 部署 snapshot 中的全部 dotfiles |
| 3-runtimes | Go 1.22 / Rust / Node.js 24 (nvm) / Bun / Ollama / Python + pyenv |
| 4-android | cmdline-tools / platform-tools / build-tools 34 / platforms android-34 / NDK 26 / CMake 3.22 |
| 5-gpu | NVIDIA 驱动检查 / CUDA 安装提示 |
| 6-docker | Docker CE / Docker Compose v2 |
| 7-projects | ~/projects / ~/go/src / ~/Android/Sdk 等目录创建 |

## snapshot 包含的 dotfiles

- `~/.zshrc`, `~/.bashrc`, `~/.profile`
- `~/.gitconfig`, `~/.gitignore_global`
- `~/.npmrc`
- `~/.cargo/config.toml`
- `~/.ssh/config`, `~/.ssh/known_hosts`
- `~/.config/starship.toml`
- `~/.config/nvim/` (Neovim Lua 配置)
- `~/.tmux.conf`
- Oh My Zsh 自定义插件和主题

## 已知限制

- Android SDK 需要手动接受 license: `yes | sdkmanager --licenses`
- CUDA / NVIDIA 驱动需要单独安装
- macOS Homebrew 需手动运行 `brew bundle install`
- SSH 私钥不在快照中（不会备份），需单独备份
- Docker 镜像需要单独备份或使用 `docker save`

## 自定义

如需在 snapshot 外额外添加配置：
1. 放入 `configs/` 目录
2. 修改对应脚本的 `deploy_dotfile` 函数
3. 重新执行即可覆盖
