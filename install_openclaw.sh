#!/bin/bash
# OpenClaw 一键安装脚本 (已修复WSL2 IP问题)
set -euo pipefail

# ============================================
# 配置区
# ============================================
SCRIPT_URL="https://raw.githubusercontent.com/Hutton-h/wsl.ubuntu.openclaw-/refs/heads/main/merged_openclaw_readable.sh"

# ✅ 修复：WSL2 正确获取 Windows 主机IP
WIN_IP=$(ip route show | grep default | awk '{print $3}')

# 输入代理端口
read -p "请输入代理端口 (默认: 10808): " INPUT_PORT
PROXY_PORT=${INPUT_PORT:-10808}

# 端口校验
if ! [[ "$PROXY_PORT" =~ ^[0-9]+$ ]] || [ "$PROXY_PORT" -lt 1 ] || [ "$PROXY_PORT" -gt 65535 ]; then
    echo -e "\033[31m错误：端口必须是 1-65535 之间的数字\033[0m"
    exit 1
fi

LOCAL_PROXY="socks5://${WIN_IP}:${PROXY_PORT}"

GITHUB_PROXY_LIST=(
    "https://mirror.ghproxy.com/"
    "https://gh-proxy.com/"
    "https://ghproxy.net/"
)

WORK_DIR="/root/.skpl"
SCRIPT_NAME="merged_openclaw_readable.sh"
SCRIPT_PATH="${WORK_DIR}/${SCRIPT_NAME}"

# ============================================
# 功能函数
# ============================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_url() {
    local url="$1"
    local timeout="${2:-5}"
    curl -fsSL --max-time "$timeout" -x "${LOCAL_PROXY}" -o /dev/null "$url" 2>/dev/null
    return $?
}

select_proxy() {
    log_info "检测网络中...(使用代理: ${LOCAL_PROXY})"

    if check_url "$SCRIPT_URL" 5; then
        log_info "本机代理可用，直接下载"
        echo "$SCRIPT_URL"
        return 0
    fi

    for proxy in "${GITHUB_PROXY_LIST[@]}"; do
        local test_url="${proxy}${SCRIPT_URL}"
        if check_url "$test_url" 8; then
            log_info "使用备用代理: ${proxy}"
            echo "${proxy}${SCRIPT_URL}"
            return 0
        fi
    done

    return 1
}

download_script() {
    local download_url="$1"

    log_info "正在下载脚本..."
    log_info "来源: ${download_url}"
    log_info "当前代理: ${LOCAL_PROXY}"

    mkdir -p "$WORK_DIR"

    if curl -fsSL --max-time 30 -x "${LOCAL_PROXY}" "$download_url" -o "$SCRIPT_PATH" 2>/dev/null; then
        log_info "下载成功: ${SCRIPT_PATH}"
    elif wget -q --timeout=30 -e use_proxy=yes -e socks5_proxy="${LOCAL_PROXY}" -O "$SCRIPT_PATH" "$download_url" 2>/dev/null; then
        log_info "下载成功 (wget): ${SCRIPT_PATH}"
    else
        log_error "下载失败"
        return 1
    fi

    chmod +x "$SCRIPT_PATH"
    log_info "已添加执行权限"

    local file_size
    file_size=$(stat -c%s "$SCRIPT_PATH" 2>/dev/null || stat -f%z "$SCRIPT_PATH" 2>/dev/null || echo "0")
    if [ "$file_size" -lt 100 ]; then
        log_error "文件下载异常 (${file_size} bytes)"
        return 1
    fi

    log_info "文件大小: ${file_size} bytes"
    return 0
}

# ============================================
# 主流程
# ============================================
main() {
    echo -e "${BLUE}=======================================${NC}"
    echo -e "${BLUE}  OpenClaw 一键安装程序${NC}"
    echo -e "${BLUE}  自动检测IP + 手动输入代理端口${NC}"
    echo -e "${BLUE}=======================================${NC}"
    echo ""

    log_info "检测到 Windows 主机IP: $WIN_IP"
    log_info "使用代理端口: $PROXY_PORT"
    echo ""

    local final_url
    final_url=$(select_proxy) || {
        log_error "所有下载方式均不可用"
        exit 1
    }

    download_script "$final_url" || exit 1

    echo ""
    log_info "下载完成！即将启动安装程序..."
    echo ""
    bash "$SCRIPT_PATH"
}

main
