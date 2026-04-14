#!/bin/bash
#===============================================
# 7-inputmethod.sh - Linux 中文输入法配置
# 适用于：Debian/Ubuntu (fcitx5 + rime)
#===============================================

set -e

echo "[7/8] 配置中文输入法..."

# 检查是否已有输入法
if command -v fcitx5 &> /dev/null; then
    echo "  fcitx5 已安装"
fi

# 安装 fcitx5 + rime
echo "  安装 fcitx5 + rime..."
sudo apt update
sudo apt install -y \
    fcitx5 fcitx5-rime \
    fcitx5-configtool fcitx5-frontend-gtk3 fcitx5-frontend-qt5 \
    librime-data-*

# Rime 配置
RIME_CONFIG_DIR="$HOME/.local/share/fcitx5/rime"
mkdir -p "$RIME_CONFIG_DIR"

# 东风破 / 简体
if [ ! -f "$RIME_CONFIG_DIR/luna_pinyin_simp.custom.yaml" ]; then
    echo "  配置 Rime 简体拼音..."
    cat > "$RIME_CONFIG_DIR/luna_pinyin_simp.custom.yaml" << 'EOF'
# luna_pinyin_simp.custom.yaml
patch:
  schema/list:
    - luna_pinyin_simp
  "menu/page_size": 9
  switcher/hotkeys:
    - Control+Shift+space
    - Alt+Shift+space
  "key_binder/bindings":
    - when: paging
      keys: ["bracketleft", "bracketright"]
      send: Page_Up, Page_Down
EOF
fi

# 设置环境变量（加入 .profile）
PROFILE_MARKER="# fcitx5 input method"
if ! grep -q "$PROFILE_MARKER" "$HOME/.profile" 2>/dev/null; then
    echo "  添加环境变量到 ~/.profile..."
    cat >> "$HOME/.profile" << 'EOF'

# fcitx5 input method
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export INPUT_METHOD=fcitx
EOF
fi

# 自动启动 fcitx5
AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"
if [ ! -f "$AUTOSTART_DIR/fcitx5.desktop" ]; then
    echo "  创建 fcitx5 自动启动项..."
    cat > "$AUTOSTART_DIR/fcitx5.desktop" << 'EOF'
[Desktop Entry]
Name=Fcitx5
Comment=Chinese Input Method
Exec=fcitx5 -d
Icon=fcitx
Type=Application
Terminal=false
EOF
fi

echo "✅ 输入法配置完成"
echo ""
echo "下一步: bash scripts/8-projects.sh"
