#!/bin/bash
#===============================================
# 4-android.sh - Android SDK 安装
#===============================================

set -e

echo "[4/8] 安装 Android SDK..."

export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

# 如已安装，跳过
if [ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ]; then
    echo "  Android SDK 已安装，跳过"
    echo "  SDK 路径: $ANDROID_HOME"
    return 0 2>/dev/null || exit 0
fi

mkdir -p "$ANDROID_HOME"

# 下载 command-line tools
CMDLINE_TOOLS_VERSION="11076708"
echo "  下载 Android command-line tools..."
cd /tmp
wget -q "https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip" -O cmdline-tools.zip

unzip -q cmdline-tools.zip
mkdir -p "$ANDROID_HOME/cmdline-tools"
mv cmdline-tools "$ANDROID_HOME/cmdline-tools/latest"
rm -f cmdline-tools.zip

# 接受 license
yes | "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --licenses >/dev/null 2>&1 || true

# 安装基础组件
echo "  安装 Android SDK 组件（platform-tools, build-tools, platforms）..."
"$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0" \
    "ndk;26b" \
    "cmake;3.22.1"

echo "✅ Android SDK 安装完成"
echo "  ANDROID_HOME=$ANDROID_HOME"
echo ""
echo "下一步: bash scripts/5-gpu.sh"
