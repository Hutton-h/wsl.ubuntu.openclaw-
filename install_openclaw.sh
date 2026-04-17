#!/bin/bash
# OpenClaw 一键安装脚本 (纯净版)
# 用法: curl -fsSL <RAW_SCRIPT_URL> | bash

set -euo pipefail

# ============================================
# 配置区 - 使用前必须修改
# ============================================

# GitHub 原始文件地址 (替换为你的实际地址)
# 正确格式: https://raw.githubusercontent.com/用户名/仓库名/分支名/文件路径
SCRIPT_URL="https://raw.githubusercontent.com/Hutton-h/wsl.ubuntu.openclaw-/main/merged_openclaw_readable.sh"

# GitHub 加速代理列表 - 按顺序尝试
# 注意: 代理末尾必须有斜杠
PROXY_LIST=(
    "https://gh-proxy.com/"
    "https://ghproxy.net/"
    "https://github.moeyy.xyz/"
    "https://gh-proxy.llyke.com/"
    "https://ghproxy.cc/"
)

# 脚本保存路径
SAVE_DIR="/root/.skpl"
SAVE_FILE="${SAVE_DIR}/merged_openclaw_readable.sh"

# ============================================
# 颜色定义
# ============================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ============================================
# 下载函数
# ============================================
try_download() {
    local url="$1"
    info "尝试下载: ${url}"

    # 优先使用 curl
    if command -v curl >/dev/null 2>&1; then
        if curl -fsSL --connect-timeout 10 --max-time 60 "$url" -o "$SAVE_FILE" 2>/dev/null; then
            return 0
        fi
    fi

    # 备选 wget
    if command -v wget >/dev/null 2>&1; then
        if wget -q --timeout=60 -O "$SAVE_FILE" "$url" 2>/dev/null; then
            return 0
        fi
    fi

    return 1
}

# ============================================
# 主流程
# ============================================
main() {
    echo -e "${BLUE}=======================================${NC}"
    echo -e "${BLUE}  OpenClaw 一键安装程序${NC}"
    echo -e "${BLUE}  将保存至: ${SAVE_FILE}${NC}"
    echo -e "${BLUE}=======================================${NC}"
    echo ""

    # 创建目录
    mkdir -p "$SAVE_DIR"

    # 检查 URL 设置
    if [[ "$SCRIPT_URL" == *"YOUR_USERNAME"* ]]; then
        error "请先修改脚本中的 SCRIPT_URL 变量"
        exit 1
    fi

    # 1. 尝试直连
    info "步骤 1/2: 尝试直连 GitHub..."
    if try_download "$SCRIPT_URL"; then
        info "直连下载成功!"
    else
        warn "直连失败，尝试使用代理..."

        # 2. 遍历代理列表
        local proxy_found=false
        for proxy in "${PROXY_LIST[@]}"; do
            local proxy_url="${proxy}${SCRIPT_URL}"
            if try_download "$proxy_url"; then
                info "代理下载成功: ${proxy}"
                proxy_found=true
                break
            fi
        done

        if [[ "$proxy_found" == false ]]; then
            error "所有代理均不可用!"
            echo ""
            echo "请尝试以下手动方案:"
            echo "  1. 在本地电脑浏览器打开以下地址:"
            echo "     https://gh-proxy.com/${SCRIPT_URL}"
            echo ""
            echo "  2. 下载后上传到服务器的 ${SAVE_FILE} 路径"
            echo ""
            echo "  3. 然后执行: bash ${SAVE_FILE}"
            exit 1
        fi
    fi

    # 3. 验证文件
    local size
    size=$(wc -c < "$SAVE_FILE")
    if [ "$size" -lt 1000 ]; then
        error "下载的文件太小 (${size} bytes)，可能下载失败"
        cat "$SAVE_FILE"
        exit 1
    fi
    info "文件大小: ${size} bytes"

    # 4. 设置执行权限
    chmod +x "$SAVE_FILE"
    info "已添加执行权限"

    # 5. 确认并执行
    echo ""
    echo -e "${GREEN}=======================================${NC}"
    echo -e "${GREEN}  下载完成!${NC}"
    echo -e "${GREEN}=======================================${NC}"
    echo ""
    info "即将启动安装程序..."
    echo ""

    # 执行下载好的脚本
    bash "$SAVE_FILE"
}

# 执行
main
