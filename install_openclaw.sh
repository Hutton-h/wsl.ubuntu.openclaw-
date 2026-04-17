#!/bin/bash
# OpenClaw 一键安装脚本 (带 GitHub 代理)
# 用法: curl -fsSL <RAW_SCRIPT_URL> | bash
# 或: wget -qO- <RAW_SCRIPT_URL> | bash

set -euo pipefail

# ============================================
# 配置区 - 可修改以下变量
# ============================================

# GitHub 原始文件地址 (请替换为你的实际仓库地址)
# 格式: https://raw.githubusercontent.com/用户名/仓库名/分支名/文件路径
SCRIPT_URL="https://raw.githubusercontent.com/Hutton-h/wsl.ubuntu.openclaw-/refs/heads/main/merged_openclaw_readable.sh"

# 代理地址列表 - 按需选择或添加
# 留空则直接访问 (不走代理)
GITHUB_PROXY_LIST=(
    "https://mirror.ghproxy.com/"
    "https://gh-proxy.com/"
    "https://ghproxy.net/"
    "https://gh.ddlc.top/"
)

# 脚本存放目录
WORK_DIR="/root/.skpl"
SCRIPT_NAME="merged_openclaw_readable.sh"
SCRIPT_PATH="${WORK_DIR}/${SCRIPT_NAME}"

# ============================================
# 功能函数
# ============================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检查网络连接 (带超时)
check_url() {
    local url="$1"
    local timeout="${2:-5}"
    curl -fsSL --max-time "$timeout" -o /dev/null "$url" 2>/dev/null
    return $?
}

# 选择可用的代理
select_proxy() {
    log_info "检测可用代理..."

    # 先测试直连
    if check_url "$SCRIPT_URL" 5; then
        log_info "直连可用，不使用代理"
        echo "$SCRIPT_URL"
        return 0
    fi

    # 遍历代理列表
    for proxy in "${GITHUB_PROXY_LIST[@]}"; do
        local test_url="${proxy}${SCRIPT_URL}"
        if check_url "$test_url" 8; then
            log_info "找到可用代理: ${proxy}"
            echo "${proxy}${SCRIPT_URL}"
            return 0
        fi
    done

    return 1
}

# 下载脚本
download_script() {
    local download_url="$1"

    log_info "正在下载脚本..."
    log_info "来源: ${download_url}"

    mkdir -p "$WORK_DIR"

    # 下载并保存到本地
    if curl -fsSL --max-time 30 "$download_url" -o "$SCRIPT_PATH" 2>/dev/null; then
        log_info "下载成功: ${SCRIPT_PATH}"
    elif wget -q --timeout=30 -O "$SCRIPT_PATH" "$download_url" 2>/dev/null; then
        log_info "下载成功 (wget): ${SCRIPT_PATH}"
    else
        log_error "下载失败，请检查网络或手动下载"
        return 1
    fi

    # 添加执行权限
    chmod +x "$SCRIPT_PATH"
    log_info "已添加执行权限"

    # 验证文件大小
    local file_size
    file_size=$(stat -c%s "$SCRIPT_PATH" 2>/dev/null || stat -f%z "$SCRIPT_PATH" 2>/dev/null || echo "0")
    if [ "$file_size" -lt 100 ]; then
        log_error "下载的文件过小 (${file_size} bytes)，可能下载失败"
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
    echo -e "${BLUE}  脚本将保存至: ${WORK_DIR}${NC}"
    echo -e "${BLUE}=======================================${NC}"
    echo ""

    # 选择下载源
    local final_url
    final_url=$(select_proxy) || {
        log_error "所有代理均不可用"
        echo ""
        log_warn "你可以尝试以下操作:"
        echo "  1. 手动下载脚本到 ${SCRIPT_PATH}"
        echo "  2. 设置 http_proxy 环境变量后重试"
        echo "  3. 检查脚本 URL 是否正确: ${SCRIPT_URL}"
        exit 1
    }

    # 下载脚本
    download_script "$final_url" || exit 1

    echo ""
    log_info "下载完成!"

    # 询问是否立即执行
    echo ""
    echo "======================================="
    echo " 脚本已保存至: ${SCRIPT_PATH}"
    echo "======================================="
    echo ""
    echo "你可以使用以下命令执行:"
    echo "  ${GREEN}bash ${SCRIPT_PATH}${NC}"
    echo ""

    # 自动执行
    log_info "正在启动安装程序..."
    echo ""
    bash "$SCRIPT_PATH"
}

# 执行
main
