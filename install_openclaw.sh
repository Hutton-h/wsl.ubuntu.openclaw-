#!/bin/bash
# OpenClaw 一键安装脚本 (纯净版)
# 用法: curl -fsSL <RAW_SCRIPT_URL> | bash

set -euo pipefail

# ============================================
# 配置区
# ============================================
SCRIPT_URL="https://raw.githubusercontent.com/Hutton-h/wsl.ubuntu.openclaw-/main/merged_openclaw_readable.sh"
PROXY_LIST=(
    "https://gh-proxy.com/"
    "https://ghproxy.net/"
    "https://github.moeyy.xyz/"
    "https://gh-proxy.llyke.com/"
    "https://ghproxy.cc/"
)
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

    if command -v curl >/dev/null 2>&1; then
        if curl -fsSL --connect-timeout 10 --max-time 60 "$url" -o "$SAVE_FILE" 2>/dev/null; then
            return 0
        fi
    fi

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

    mkdir -p "$SAVE_DIR"

    info "步骤 1/2: 尝试直连 GitHub..."
    if try_download "$SCRIPT_URL"; then
        info "直连下载成功!"
    else
        warn "直连失败，尝试使用代理..."
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
            exit 1
        fi
    fi

    local size
    size=$(wc -c < "$SAVE_FILE")
    if [ "$size" -lt 1000 ]; then
        error "下载失败，文件异常"
        exit 1
    fi
    info "文件大小: ${size} bytes"

    chmod +x "$SAVE_FILE"
    info "已添加执行权限"

    echo ""
    echo -e "${GREEN}=======================================${NC}"
    echo -e "${GREEN}  下载完成! 即将启动安装程序${NC}"
    echo -e "${GREEN}=======================================${NC}"
    echo ""

    # ✅ 核心修复：支持所有交互命令
    bash "$SAVE_FILE" </dev/tty
}

main
