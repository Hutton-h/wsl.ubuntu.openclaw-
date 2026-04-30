#!/bin/bash
set -e

SKPL_NAME="SKPL"
SKPL_HOME="/root/.skpl"
SKPL_SCRIPT_NAME="merged_openclaw_readable.sh"
SKPL_SCRIPT_PATH="${SKPL_HOME}/${SKPL_SCRIPT_NAME}"
SKPL_CMD_PATH="/usr/local/bin/skpl"
SKPL_PROXY_PORT="10808"
EVOMAP_DIR="/root/.openclaw/evolver"
EVOMAP_MEMORY_DIR="/root/.openclaw/workspace/.learnings"
EVOMAP_BACKUP_DIR="/root/.openclaw/evolver_backups"
SKPL_STATE_FILE="/root/.skpl/install.state"
SKPL_LOG_FILE="/root/.skpl/install.log"
SKPL_APT_UPDATED="0"
OPENCLAW_UPDATE_CACHE_TS=""
OPENCLAW_UPDATE_CACHE_MSG=""
SKPL_NPM_COUNTRY=""
SKPL_NPM_REGISTRIES=""
SKPL_PROXY_ENV_SCRIPT="${SKPL_HOME}/proxy-env.sh"
SKPL_OPENCLAW_LAUNCHER="${SKPL_HOME}/openclaw-gateway-launch.sh"
SKPL_MEMORY_STATUS_CACHE_FILE="${SKPL_HOME}/memory-status.json"
SKPL_MEMORY_AGENTS_CACHE_FILE="${SKPL_HOME}/memory-agents.tsv"
SKPL_MULTIAGENT_AGENTS_CACHE_FILE="${SKPL_HOME}/multiagent-agents.json"
SKPL_MULTIAGENT_BINDINGS_CACHE_FILE="${SKPL_HOME}/multiagent-bindings.json"
SKPL_MULTIAGENT_SESSIONS_CACHE_FILE="${SKPL_HOME}/multiagent-sessions.json"
SKPL_WEBUI_TOKEN_CACHE_FILE="${SKPL_HOME}/webui-token.txt"
SKPL_REMOTE_SCRIPT_URL="https://raw.githubusercontent.com/Hutton-h/wsl.ubuntu.openclaw-/main/merged_openclaw_readable.sh"
SKPL_REMOTE_SCRIPT_PROXIES="https://gh-proxy.com/ https://ghproxy.net/ https://github.moeyy.xyz/ https://gh-proxy.llyke.com/ https://ghproxy.cc/"
SKPL_BASE_NO_PROXY_RULE="localhost,127.0.0.1,::1,.local,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12,.aliyun.com,.tsinghua.edu.cn,.ustc.edu.cn,.163.com,.huaweicloud.com,.tencent.com,.cn,mirrors.aliyun.com,mirrors.tuna.tsinghua.edu.cn,archive.ubuntu.com,security.ubuntu.com,deb.debian.org,packages.microsoft.com"
SKPL_DOMESTIC_MODEL_DIRECT_RULE="model-square.app.baizhi.cloud,.baizhi.cloud,.aliyuncs.com,.modelscope.cn,.deepseek.com,.moonshot.cn,.bigmodel.cn,.siliconflow.cn,.stepfun.com,.minimax.chat,.baichuan-ai.com,.ppinfra.com,.volces.com,.ark.cn-beijing.volces.com,.qianfan.baidubce.com,.xf-yun.com,.spark-api.xf-yun.com,.hunyuan.cloud.tencent.com,.tencentcloudapi.com"

gl_bai='\033[0m'
gl_lv='\033[32m'
gl_huang='\033[33m'
gl_hong='\033[31m'
gl_hui='\033[90m'
gl_kjlan='\033[36m'
gl_lan='\033[94m'
gl_zi='\033[95m'
gh_proxy=''

if ! command -v sudo >/dev/null 2>&1; then
  sudo() { "$@"; }
fi

skpl_ui_rule() {
  local color="${1:-$gl_hui}"
  local char="-"
  local width="${3:-60}"
  printf '%b' "$color"
  printf '%*s' "$width" '' | tr ' ' "$char"
  printf '%b\n' "$gl_bai"
}

skpl_ui_header() {
  local title="$1"
  local subtitle="${2:-}"
  skpl_ui_rule "$gl_hui" "-" 68
  printf '%b%s%b\n' "$gl_bai" "${title}" "$gl_bai"
  if [ -n "$subtitle" ]; then
    printf '%b%s%b\n' "$gl_hui" "$subtitle" "$gl_bai"
  fi
  skpl_ui_rule "$gl_hui" "-" 68
}

skpl_ui_section() {
  local title="$1"
  printf '%b[%s]%b\n' "$gl_hui" "$title" "$gl_bai"
}

skpl_ui_kv() {
  local key="$1"
  local value="$2"
  printf '%b%-12s%b : %b%s%b\n' "$gl_hui" "${key}" "$gl_bai" "$gl_bai" "$value" "$gl_bai"
}

skpl_ui_badge() {
  local tone="$1"
  local text="$2"
  local color="$gl_bai"
  case "$tone" in
    ok) color="$gl_lv" ;;
    warn) color="$gl_huang" ;;
    danger) color="$gl_hong" ;;
    info) color="$gl_hui" ;;
  esac
  printf '%b[%s]%b' "$color" "$text" "$gl_bai"
}

skpl_ui_status_row() {
  local title="$1"
  local tone="$2"
  local value="$3"
  printf '%b%-12s%b : ' "$gl_hui" "$title" "$gl_bai"
  skpl_ui_badge "$tone" "$value"
  printf '\n'
}

skpl_ui_alert() {
  local tone="$1"
  local title="$2"
  local detail="${3:-}"
  local color="$gl_hui"
  local tag="INFO"
  case "$tone" in
    warn) color="$gl_huang"; tag="WARN" ;;
    danger) color="$gl_hong"; tag="DANGER" ;;
    ok) color="$gl_lv"; tag="OK" ;;
  esac
  printf '%b[%s]%b %s\n' "$color" "$tag" "$gl_bai" "$title"
  if [ -n "$detail" ]; then
    printf '%b%s%b\n' "$gl_hui" "$detail" "$gl_bai"
  fi
}

skpl_ui_menu_item() {
  local key="$1"
  local label="$2"
  local desc="${3:-}"
  if [ -n "$desc" ]; then
    printf '%b%2s.%b %-24s  %b%s%b\n' "$gl_bai" "$key" "$gl_bai" "$label" "$gl_hui" "$desc" "$gl_bai"
  else
    printf '%b%2s.%b %s\n' "$gl_bai" "$key" "$gl_bai" "$label"
  fi
}

skpl_ui_menu_item_tone() {
  local key="$1"
  local label="$2"
  local desc="${3:-}"
  local tone="${4:-info}"
  local color="$gl_bai"
  case "$tone" in
    warn) color="$gl_huang" ;;
    danger) color="$gl_hong" ;;
    ok) color="$gl_lv" ;;
  esac
  if [ -n "$desc" ]; then
    printf '%b%2s.%b %-24s  %b%s%b\n' "$color" "$key" "$gl_bai" "$label" "$gl_hui" "$desc" "$gl_bai"
  else
    printf '%b%2s.%b %s\n' "$color" "$key" "$gl_bai" "$label"
  fi
}

skpl_ui_footer_prompt() {
  local prompt="${1:-请输入选项并回车: }"
  echo
  printf '%b%s%b' "$gl_hui" "$prompt" "$gl_bai"
}

skpl_merge_no_proxy_csv() {
  python3 - "$1" "$2" <<'PY'
import sys

seen = set()
items = []
for raw in sys.argv[1:]:
    for part in raw.split(','):
        part = part.strip()
        if not part or part in seen:
            continue
        seen.add(part)
        items.append(part)
print(','.join(items))
PY
}

skpl_build_no_proxy_rule() {
  local extra_hosts="${1:-}"
  skpl_merge_no_proxy_csv "$SKPL_BASE_NO_PROXY_RULE" "$SKPL_DOMESTIC_MODEL_DIRECT_RULE" "$extra_hosts"
}

skpl_extract_url_host() {
  python3 - "$1" <<'PY'
import sys
from urllib.parse import urlparse

url = (sys.argv[1] or '').strip()
if not url:
    print('')
    raise SystemExit(0)
parsed = urlparse(url)
print(parsed.hostname or '')
PY
}

skpl_is_domestic_model_host() {
  python3 - "$1" <<'PY'
import sys

host = (sys.argv[1] or '').strip().lower()
rules = [
    'model-square.app.baizhi.cloud', '.baizhi.cloud', '.aliyuncs.com', '.modelscope.cn',
    '.deepseek.com', '.moonshot.cn', '.bigmodel.cn', '.siliconflow.cn', '.stepfun.com',
    '.minimax.chat', '.baichuan-ai.com', '.ppinfra.com', '.volces.com',
    '.ark.cn-beijing.volces.com', '.qianfan.baidubce.com', '.xf-yun.com',
    '.spark-api.xf-yun.com', '.hunyuan.cloud.tencent.com', '.tencentcloudapi.com'
]
ok = False
for rule in rules:
    if rule.startswith('.'):
        if host.endswith(rule):
            ok = True
            break
    elif host == rule or host.endswith('.' + rule):
        ok = True
        break
print('1' if ok else '0')
PY
}

skpl_model_request_no_proxy_hosts() {
  local base_url="$1"
  local host=""
  host=$(skpl_extract_url_host "$base_url")
  [ -z "$host" ] && return 0
  if [ "$(skpl_is_domestic_model_host "$host")" = "1" ]; then
    printf '%s\n' "$host"
  fi
}

curl_fetch_models_json() {
  local base_url="$1"
  local api_key="$2"
  local no_proxy_hosts=""
  no_proxy_hosts=$(skpl_model_request_no_proxy_hosts "$base_url")
  if [ -n "$no_proxy_hosts" ]; then
    curl --noproxy "$no_proxy_hosts" -s -m 10 -H "Authorization: Bearer $api_key" "${base_url}/models"
    return $?
  fi
  curl -s -m 10 -H "Authorization: Bearer $api_key" "${base_url}/models"
}

skpl_collect_domestic_provider_hosts_from_config() {
  local config_file="$1"
  [ -s "$config_file" ] || return 0
  python3 - "$config_file" <<'PY'
import json
import sys
from urllib.parse import urlparse

rules = [
    'model-square.app.baizhi.cloud', '.baizhi.cloud', '.aliyuncs.com', '.modelscope.cn',
    '.deepseek.com', '.moonshot.cn', '.bigmodel.cn', '.siliconflow.cn', '.stepfun.com',
    '.minimax.chat', '.baichuan-ai.com', '.ppinfra.com', '.volces.com',
    '.ark.cn-beijing.volces.com', '.qianfan.baidubce.com', '.xf-yun.com',
    '.spark-api.xf-yun.com', '.hunyuan.cloud.tencent.com', '.tencentcloudapi.com'
]

def is_domestic(host: str) -> bool:
    host = (host or '').strip().lower()
    if not host:
        return False
    for rule in rules:
        if rule.startswith('.'):
            if host.endswith(rule):
                return True
        elif host == rule or host.endswith('.' + rule):
            return True
    return False

with open(sys.argv[1], 'r', encoding='utf-8') as f:
    data = json.load(f)

providers = (((data or {}).get('models') or {}).get('providers') or {})
hosts = []
seen = set()
for provider in providers.values():
    if not isinstance(provider, dict):
        continue
    base_url = str(provider.get('baseUrl') or '').strip()
    if not base_url:
        continue
    host = (urlparse(base_url).hostname or '').strip().lower()
    if host and is_domestic(host) and host not in seen:
        seen.add(host)
        hosts.append(host)
print(','.join(hosts))
PY
}

init_skpl_runtime() {
  mkdir -p "$SKPL_HOME"
  touch "$SKPL_LOG_FILE"
  touch "$SKPL_STATE_FILE"
  write_skpl_proxy_env_script >/dev/null 2>&1 || true
  write_openclaw_gateway_launcher >/dev/null 2>&1 || true
}

skpl_openclaw_gateway_service_path() {
  echo "/root/.config/systemd/user/openclaw-gateway.service"
}

skpl_effective_proxy_port() {
  local saved_port=""
  saved_port=$(awk -F'=' '$1=="PROXY_PORT" {print $2; exit}' "$SKPL_STATE_FILE" 2>/dev/null || true)
  if [[ "$saved_port" =~ ^[0-9]+$ ]] && [ "$saved_port" -ge 1 ] && [ "$saved_port" -le 65535 ]; then
    printf '%s\n' "$saved_port"
    return 0
  fi
  printf '%s\n' "${SKPL_PROXY_PORT:-10808}"
}

resolve_node_runtime() {
  local node_bin=""
  node_bin=$(command -v node 2>/dev/null || true)
  if [ -n "$node_bin" ] && [ -x "$node_bin" ]; then
    printf '%s\n' "$node_bin"
    return 0
  fi
  if [ -x /usr/bin/node ]; then
    printf '%s\n' /usr/bin/node
    return 0
  fi
  if [ -x /usr/local/bin/node ]; then
    printf '%s\n' /usr/local/bin/node
    return 0
  fi
  return 1
}

node_major_version_current() {
  node -p 'process.versions.node.split(".")[0]' 2>/dev/null || true
}

resolve_openclaw_js_entry() {
  local npm_global candidate openclaw_bin
  npm_global=$(npm root -g 2>/dev/null || true)
  for candidate in \
    "${npm_global}/openclaw/dist/entry.js" \
    "${npm_global}/openclaw/dist/entry.mjs" \
    "${npm_global}/openclaw/dist/index.js" \
    "/usr/lib/node_modules/openclaw/dist/entry.js" \
    "/usr/lib/node_modules/openclaw/dist/entry.mjs" \
    "/usr/lib/node_modules/openclaw/dist/index.js" \
    "/usr/local/lib/node_modules/openclaw/dist/entry.js" \
    "/usr/local/lib/node_modules/openclaw/dist/entry.mjs" \
    "/usr/local/lib/node_modules/openclaw/dist/index.js"; do
    if [ -n "$candidate" ] && [ -f "$candidate" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  openclaw_bin=$(command -v openclaw 2>/dev/null || true)
  if [ -n "$openclaw_bin" ] && [ -f "$openclaw_bin" ]; then
    printf '%s\n' "$openclaw_bin"
    return 0
  fi
  return 1
}

ensure_openclaw_cli_on_path() {
  local npm_prefix npm_bin openclaw_bin node_bin openclaw_entry wrapper_path

  if command -v openclaw >/dev/null 2>&1 && openclaw --version >/dev/null 2>&1; then
    return 0
  fi

  npm_prefix=$(npm prefix -g 2>/dev/null || true)
  if [ -n "$npm_prefix" ] && [ -d "${npm_prefix}/bin" ]; then
    PATH="${npm_prefix}/bin:${PATH}"
    export PATH
    hash -r 2>/dev/null || true
  fi

  npm_bin=$(npm bin -g 2>/dev/null || true)
  if [ -n "$npm_bin" ] && [ -d "$npm_bin" ]; then
    PATH="${npm_bin}:${PATH}"
    export PATH
    hash -r 2>/dev/null || true
  fi

  if command -v openclaw >/dev/null 2>&1 && openclaw --version >/dev/null 2>&1; then
    return 0
  fi

  node_bin=$(resolve_node_runtime 2>/dev/null || true)
  openclaw_entry=$(resolve_openclaw_js_entry 2>/dev/null || true)
  [ -n "$node_bin" ] || return 1
  [ -n "$openclaw_entry" ] || return 1

  wrapper_path="/usr/local/bin/openclaw"
  mkdir -p "$(dirname "$wrapper_path")"
  cat > "$wrapper_path" <<EOF_OPENCLAW_WRAPPER
#!/bin/bash
set -e
case "${openclaw_entry}" in
  *.js|*.mjs)
    exec "${node_bin}" "${openclaw_entry}" "\$@"
    ;;
  *)
    exec "${openclaw_entry}" "\$@"
    ;;
esac
EOF_OPENCLAW_WRAPPER
  chmod +x "$wrapper_path"
  hash -r 2>/dev/null || true
  command -v openclaw >/dev/null 2>&1 && openclaw --version >/dev/null 2>&1
}

refresh_openclaw_gateway_service() {
  local service_file openclaw_js node_bin gateway_port proxy_port active_state=1
  service_file=$(skpl_openclaw_gateway_service_path)
  openclaw_js=$(resolve_openclaw_js_entry 2>/dev/null || true)
  [ -n "$openclaw_js" ] || return 0
  node_bin=$(resolve_node_runtime 2>/dev/null || true)
  [ -n "$node_bin" ] || return 0
  gateway_port="${OPENCLAW_GATEWAY_PORT:-18789}"
  proxy_port="$(skpl_effective_proxy_port)"

  mkdir -p /root/.config/systemd/user
  write_skpl_proxy_env_script
  write_openclaw_gateway_launcher

  cat > "$service_file" <<EOF_SKPL_GATEWAY_SERVICE
[Unit]
Description=OpenClaw Gateway
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=${SKPL_OPENCLAW_LAUNCHER} ${node_bin} ${openclaw_js} ${proxy_port} gateway --port ${gateway_port}
Restart=always
RestartSec=5
TimeoutStartSec=30
TimeoutStopSec=30
SuccessExitStatus=0 143
KillMode=control-group
Environment=HOME=/root
Environment=TMPDIR=/tmp
Environment=PATH=/usr/local/bin:/usr/bin:/bin:/root/.local/bin
Environment=OPENCLAW_GATEWAY_PORT=${gateway_port}

[Install]
WantedBy=default.target
EOF_SKPL_GATEWAY_SERVICE

  systemctl --user is-active --quiet openclaw-gateway.service >/dev/null 2>&1
  active_state=$?
  systemctl --user daemon-reload >/dev/null 2>&1 || true
  systemctl --user enable openclaw-gateway.service >/dev/null 2>&1 || true
  if [ $active_state -eq 0 ]; then
    systemctl --user restart openclaw-gateway.service >/dev/null 2>&1 || true
  fi
}

openclaw_gateway_fallback_start() {
  local openclaw_entry node_bin proxy_port gateway_port fallback_log
  openclaw_entry=$(resolve_openclaw_js_entry 2>/dev/null || true)
  node_bin=$(resolve_node_runtime 2>/dev/null || true)
  proxy_port="$(skpl_effective_proxy_port)"
  gateway_port="${OPENCLAW_GATEWAY_PORT:-18789}"
  fallback_log="${SKPL_HOME}/openclaw-gateway-fallback.log"

  [ -n "$openclaw_entry" ] || return 1
  [ -n "$node_bin" ] || return 1
  write_skpl_proxy_env_script >/dev/null 2>&1 || true
  write_openclaw_gateway_launcher >/dev/null 2>&1 || true

  nohup "$SKPL_OPENCLAW_LAUNCHER" "$node_bin" "$openclaw_entry" "$proxy_port" gateway --port "$gateway_port" >"$fallback_log" 2>&1 &
  disown 2>/dev/null || true
  sleep 2
  openclaw_gateway_is_running
}

remove_openclaw_gateway_service() {
  local service_file
  service_file=$(skpl_openclaw_gateway_service_path)
  systemctl --user disable --now openclaw-gateway.service >/dev/null 2>&1 || true
  if [ -f "$service_file" ]; then
    rm -f "$service_file"
  fi
  systemctl --user daemon-reload >/dev/null 2>&1 || true
}

log_msg() {
  local msg="$1"
  printf '[%s] %s\n' "$(date '+%F %T')" "$msg" >> "$SKPL_LOG_FILE"
}

check_tcp_port() {
  local ip_port="$1"
  local ip port
  ip=$(echo "$ip_port" | cut -d: -f1)
  port=$(echo "$ip_port" | cut -d: -f2)
  timeout 0.5 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null
}

openclaw_gateway_port() {
  printf '%s\n' "${OPENCLAW_GATEWAY_PORT:-18789}"
}

openclaw_gateway_cli_status_ok() {
  command -v openclaw >/dev/null 2>&1 || return 1
  timeout 8 openclaw gateway status --json >/dev/null 2>&1 \
    || timeout 8 openclaw gateway status >/dev/null 2>&1
}

openclaw_gateway_service_active() {
  systemctl --user is-active --quiet openclaw-gateway.service >/dev/null 2>&1
}

openclaw_gateway_port_reachable() {
  check_tcp_port "127.0.0.1:$(openclaw_gateway_port)"
}

openclaw_gateway_process_running() {
  pgrep -f "openclaw-gateway|dist/index\.js.*gateway|node .*openclaw.*gateway|openclaw[[:space:]]+gateway" >/dev/null 2>&1
}

openclaw_gateway_is_running() {
  openclaw_gateway_cli_status_ok \
    || openclaw_gateway_service_active \
    || openclaw_gateway_port_reachable \
    || openclaw_gateway_process_running
}

skpl_low_priority_prefix() {
  if command -v ionice >/dev/null 2>&1; then
    printf 'nice -n 10 ionice -c3 '
  else
    printf 'nice -n 10 '
  fi
}

skpl_proxy_candidates() {
  local port="${1:-$(skpl_effective_proxy_port)}"
  local host=""

  printf '%s\n' "127.0.0.1:${port}"
  printf '%s\n' "10.255.255.254:${port}"

  host=$(getent ahostsv4 host.docker.internal 2>/dev/null | awk 'NR==1{print $1}')
  if [ -n "$host" ]; then
    printf '%s\n' "${host}:${port}"
  fi

  host=$(awk '/^nameserver /{print $2; exit}' /etc/resolv.conf 2>/dev/null)
  if [ -n "$host" ]; then
    printf '%s\n' "${host}:${port}"
  fi

  host=$(ip route 2>/dev/null | awk '/^default /{print $3; exit}')
  if [ -n "$host" ]; then
    printf '%s\n' "${host}:${port}"
  fi
}

resolve_active_proxy() {
  local port="${1:-$(skpl_effective_proxy_port)}"
  local candidate=""

  while IFS= read -r candidate; do
    [ -z "$candidate" ] && continue
    if check_tcp_port "$candidate"; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done < <(skpl_proxy_candidates "$port" | awk '!seen[$0]++')

  return 1
}

apply_detected_proxy_env() {
  local active_proxy="$1"
  local no_proxy_rule=""
  local proxy_url=""

  no_proxy_rule=$(skpl_build_no_proxy_rule)

  if [ -z "$active_proxy" ]; then
    unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY all_proxy ALL_PROXY ftp_proxy FTP_PROXY no_proxy NO_PROXY npm_config_proxy npm_config_https_proxy npm_config_noproxy
    return 0
  fi

  proxy_url="http://$active_proxy"
  export http_proxy="$proxy_url"
  export https_proxy="$proxy_url"
  export HTTP_PROXY="$proxy_url"
  export HTTPS_PROXY="$proxy_url"
  export all_proxy="$proxy_url"
  export ALL_PROXY="$proxy_url"
  export ftp_proxy="$proxy_url"
  export FTP_PROXY="$proxy_url"
  export no_proxy="$no_proxy_rule"
  export NO_PROXY="$no_proxy_rule"
  export npm_config_proxy="$proxy_url"
  export npm_config_https_proxy="$proxy_url"
  export npm_config_noproxy="$no_proxy_rule"
}

refresh_runtime_proxy_env() {
  local active_proxy=""
  if active_proxy=$(resolve_active_proxy "$(skpl_effective_proxy_port)"); then
    apply_detected_proxy_env "$active_proxy"
    log_msg "检测到活动代理: $active_proxy"
  else
    apply_detected_proxy_env ""
    log_msg "未检测到活动代理，使用直连"
  fi
}

write_skpl_proxy_env_script() {
  mkdir -p "$SKPL_HOME"
  cat > "$SKPL_PROXY_ENV_SCRIPT" <<'EOF_PROXY_ENV'
#!/bin/bash
SKPL_PROXY_PORT_VALUE="${1:-10808}"
NO_PROXY_RULE="__NO_PROXY_RULE__"
PROXY_URL=""

proxy_candidates() {
  local port="$SKPL_PROXY_PORT_VALUE"
  local host=""

  printf '%s\n' "127.0.0.1:${port}"
  printf '%s\n' "10.255.255.254:${port}"

  host=$(getent ahostsv4 host.docker.internal 2>/dev/null | awk 'NR==1{print $1}')
  if [ -n "$host" ]; then
    printf '%s\n' "${host}:${port}"
  fi

  host=$(awk '/^nameserver /{print $2; exit}' /etc/resolv.conf 2>/dev/null)
  if [ -n "$host" ]; then
    printf '%s\n' "${host}:${port}"
  fi

  host=$(ip route 2>/dev/null | awk '/^default /{print $3; exit}')
  if [ -n "$host" ]; then
    printf '%s\n' "${host}:${port}"
  fi
}

check_port() {
  local ip_port="$1"
  local ip port
  ip=$(echo "$ip_port" | cut -d: -f1)
  port=$(echo "$ip_port" | cut -d: -f2)
  timeout 0.5 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null
}

ACTIVE_PROXY=""
while IFS= read -r candidate; do
  [ -z "$candidate" ] && continue
  if check_port "$candidate"; then
    ACTIVE_PROXY="$candidate"
    break
  fi
done < <(proxy_candidates | awk '!seen[$0]++')

if [ -n "$ACTIVE_PROXY" ]; then
  PROXY_URL="http://$ACTIVE_PROXY"
  export http_proxy="$PROXY_URL"
  export https_proxy="$PROXY_URL"
  export HTTP_PROXY="$PROXY_URL"
  export HTTPS_PROXY="$PROXY_URL"
  export all_proxy="$PROXY_URL"
  export ALL_PROXY="$PROXY_URL"
  export ftp_proxy="$PROXY_URL"
  export FTP_PROXY="$PROXY_URL"
  export no_proxy="$NO_PROXY_RULE"
  export NO_PROXY="$NO_PROXY_RULE"
  export npm_config_proxy="$PROXY_URL"
  export npm_config_https_proxy="$PROXY_URL"
  export npm_config_noproxy="$NO_PROXY_RULE"
else
  unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY all_proxy ALL_PROXY ftp_proxy FTP_PROXY no_proxy NO_PROXY npm_config_proxy npm_config_https_proxy npm_config_noproxy
fi
EOF_PROXY_ENV
  local merged_no_proxy
  merged_no_proxy=$(skpl_build_no_proxy_rule)
  sed -i "s|__NO_PROXY_RULE__|${merged_no_proxy}|g" "$SKPL_PROXY_ENV_SCRIPT"
  chmod +x "$SKPL_PROXY_ENV_SCRIPT"
}

write_openclaw_gateway_launcher() {
  mkdir -p "$SKPL_HOME"
  cat > "$SKPL_OPENCLAW_LAUNCHER" <<'EOF_OPENCLAW_LAUNCHER'
#!/bin/bash
set -e
NODE_BIN="$1"
OPENCLAW_ENTRY="$2"
PROXY_PORT="$3"
shift 3

merge_no_proxy_csv() {
  python3 - "$1" "$2" <<'PY'
import sys

seen = set()
items = []
for raw in sys.argv[1:]:
    for part in raw.split(','):
        part = part.strip()
        if not part or part in seen:
            continue
        seen.add(part)
        items.append(part)
print(','.join(items))
PY
}

collect_domestic_hosts_from_config() {
  local config_file="$1"
  [ -s "$config_file" ] || return 0
  python3 - "$config_file" <<'PY'
import json
import sys
from urllib.parse import urlparse

rules = [
    'model-square.app.baizhi.cloud', '.baizhi.cloud', '.aliyuncs.com', '.modelscope.cn',
    '.deepseek.com', '.moonshot.cn', '.bigmodel.cn', '.siliconflow.cn', '.stepfun.com',
    '.minimax.chat', '.baichuan-ai.com', '.ppinfra.com', '.volces.com',
    '.ark.cn-beijing.volces.com', '.qianfan.baidubce.com', '.xf-yun.com',
    '.spark-api.xf-yun.com', '.hunyuan.cloud.tencent.com', '.tencentcloudapi.com'
]

def is_domestic(host: str) -> bool:
    host = (host or '').strip().lower()
    if not host:
        return False
    for rule in rules:
        if rule.startswith('.'):
            if host.endswith(rule):
                return True
        elif host == rule or host.endswith('.' + rule):
            return True
    return False

with open(sys.argv[1], 'r', encoding='utf-8') as f:
    data = json.load(f)

providers = (((data or {}).get('models') or {}).get('providers') or {})
hosts = []
seen = set()
for provider in providers.values():
    if not isinstance(provider, dict):
        continue
    base_url = str(provider.get('baseUrl') or '').strip()
    if not base_url:
        continue
    host = (urlparse(base_url).hostname or '').strip().lower()
    if host and is_domestic(host) and host not in seen:
        seen.add(host)
        hosts.append(host)
print(','.join(hosts))
PY
}

if [ -f /root/.skpl/proxy-env.sh ]; then
  # shellcheck disable=SC1091
  source /root/.skpl/proxy-env.sh "$PROXY_PORT"
fi

CONFIG_FILE="/root/.openclaw/openclaw.json"
DYNAMIC_NO_PROXY="$(collect_domestic_hosts_from_config "$CONFIG_FILE" 2>/dev/null || true)"
if [ -n "$DYNAMIC_NO_PROXY" ]; then
  no_proxy="$(merge_no_proxy_csv "${no_proxy:-}" "$DYNAMIC_NO_PROXY")"
  NO_PROXY="$no_proxy"
  export no_proxy NO_PROXY
  npm_config_noproxy="$(merge_no_proxy_csv "${npm_config_noproxy:-}" "$DYNAMIC_NO_PROXY")"
  export npm_config_noproxy
fi

if [ ! -x "$NODE_BIN" ]; then
  NODE_BIN="$(command -v node 2>/dev/null || true)"
fi

case "$OPENCLAW_ENTRY" in
  *.js|*.mjs)
    if [ -x "$NODE_BIN" ]; then
      exec "$NODE_BIN" "$OPENCLAW_ENTRY" "$@"
    fi
    ;;
  *)
    if [ -x "$OPENCLAW_ENTRY" ]; then
      exec "$OPENCLAW_ENTRY" "$@"
    fi
    ;;
esac

exec "$NODE_BIN" "$OPENCLAW_ENTRY" "$@"
EOF_OPENCLAW_LAUNCHER
  chmod +x "$SKPL_OPENCLAW_LAUNCHER"
}

state_get() {
  local key="$1"
  awk -F'=' -v k="$key" '$1==k {print $2; exit}' "$SKPL_STATE_FILE" 2>/dev/null
}

state_set() {
  local key="$1"
  local value="$2"
  if grep -q "^${key}=" "$SKPL_STATE_FILE" 2>/dev/null; then
    python3 - "$SKPL_STATE_FILE" "$key" "$value" <<'PY'
import sys
path, key, value = sys.argv[1:4]
rows = []
with open(path, 'r', encoding='utf-8') as f:
    rows = f.readlines()
with open(path, 'w', encoding='utf-8') as f:
    written = False
    for row in rows:
        if row.startswith(key + '='):
            f.write(f"{key}={value}\n")
            written = True
        else:
            f.write(row)
    if not written:
        f.write(f"{key}={value}\n")
PY
  else
    echo "${key}=${value}" >> "$SKPL_STATE_FILE"
  fi
}

state_reset_for_full_rerun() {
  : > "$SKPL_STATE_FILE"
  state_set STEP 1
  echo "已重置安装进度，将从第 1 步开始重新执行。"
}

run_step_guard() {
  local step="$1"
  shift
  local rc=0
  log_msg "开始: $step"
  log_msg "执行命令: $*"
  if "$@"; then
    log_msg "完成: $step"
    return 0
  fi
  rc=$?
  log_msg "失败: $step | 返回码: $rc | 命令: $*"
  return $rc
}

print_failure_hint() {
  echo "步骤执行失败，日志文件：$SKPL_LOG_FILE"
  echo "可执行 skpl，选择继续安装或查看日志。"
}

show_recent_log() {
  if [ ! -s "$SKPL_LOG_FILE" ]; then
    echo "暂无日志。"
    return 0
  fi
  python3 - "$SKPL_LOG_FILE" <<'PY'
import sys
path = sys.argv[1]
with open(path, 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()
for line in lines[-80:]:
    print(line.rstrip())
PY
}

prewarm_openclaw_dependencies() {
  export NPM_CONFIG_FUND=false
  export NPM_CONFIG_AUDIT=false
  export NPM_CONFIG_PROGRESS=false
  export npm_config_loglevel=error

  if command -v npm >/dev/null 2>&1; then
    npm config set fund false >/dev/null 2>&1 || true
    npm config set audit false >/dev/null 2>&1 || true
    npm config set progress false >/dev/null 2>&1 || true
  fi

  ensure_node_runtime
}

send_stats() { :; }

break_end() {
  if [ "${SKPL_BATCH_MODE:-0}" = "1" ]; then
    return 0
  fi

  if ensure_interactive_terminal "继续确认"; then
    tty_prompt_line "按回车继续..." _tmp
  fi
}

install() {
  if [ "$#" -eq 0 ]; then
    return 0
  fi

  local pkg missing_packages=()
  if command -v apt >/dev/null 2>&1; then
    for pkg in "$@"; do
      dpkg -s "$pkg" >/dev/null 2>&1 || missing_packages+=("$pkg")
    done
    if [ "${#missing_packages[@]}" -eq 0 ]; then
      return 0
    fi
    if [ "$SKPL_APT_UPDATED" != "1" ]; then
      DEBIAN_FRONTEND=noninteractive apt update -y >/dev/null 2>&1 || true
      SKPL_APT_UPDATED="1"
    fi
    DEBIAN_FRONTEND=noninteractive apt install -y "${missing_packages[@]}" >/dev/null 2>&1 || true
  elif command -v dnf >/dev/null 2>&1; then
    for pkg in "$@"; do
      rpm -q "$pkg" >/dev/null 2>&1 || missing_packages+=("$pkg")
    done
    [ "${#missing_packages[@]}" -eq 0 ] || dnf install -y "${missing_packages[@]}" >/dev/null 2>&1 || true
  elif command -v yum >/dev/null 2>&1; then
    for pkg in "$@"; do
      rpm -q "$pkg" >/dev/null 2>&1 || missing_packages+=("$pkg")
    done
    [ "${#missing_packages[@]}" -eq 0 ] || yum install -y "${missing_packages[@]}" >/dev/null 2>&1 || true
  fi
}

ensure_interactive_terminal() {
  local action_name="$1"
  if [ -r /dev/tty ] && [ -w /dev/tty ]; then
    return 0
  fi
  echo "${action_name}需要在界面中手动输入，当前不是交互终端，已停止。"
  return 1
}

tty_prompt_line() {
  local prompt="$1"
  local __resultvar="$2"
  local __input

  printf '%s' "$prompt" > /dev/tty
  IFS= read -r __input < /dev/tty
  printf -v "$__resultvar" '%s' "$__input"
}

prompt_proxy_port() {
  local custom_port

  ensure_interactive_terminal "代理端口确认" || return 1

  while true; do
    echo -e "默认代理端口：10808"
    echo -e "直接回车 = 使用默认端口 | 输入数字 = 使用自定义端口"
    tty_prompt_line "请输入代理端口号: " custom_port

    if [ -z "$custom_port" ]; then
      PROXY_PORT="10808"
      return 0
    fi

    if [[ "$custom_port" =~ ^[0-9]+$ ]] && [ "$custom_port" -ge 1 ] && [ "$custom_port" -le 65535 ]; then
      PROXY_PORT="$custom_port"
      return 0
    fi

    echo "端口无效，请输入 1-65535 之间的数字，或直接回车使用 10808。"
  done
}

prompt_wsl_shutdown_confirmation() {
  local reboot_confirm

  ensure_interactive_terminal "WSL 重启确认" || return 1

  while true; do
    tty_prompt_line "是否已经在 PowerShell 执行过 wsl --shutdown 重启？(y/N): " reboot_confirm
    reboot_confirm=${reboot_confirm:-N}

    if [ "$reboot_confirm" = "y" ] || [ "$reboot_confirm" = "Y" ]; then
      return 0
    fi

    echo "未确认已执行 wsl --shutdown，当前安装流程停止。请先在 PowerShell 执行重启，再重新运行脚本。"
    return 1
  done
}

prompt_evomap_node_id() {
  local node_id_input="$1"
  local last_saved_node_id="$2"
  local confirm

  ensure_interactive_terminal "EvoMap Node ID 输入" || return 1

  if [ -n "$last_saved_node_id" ]; then
    echo "已保存上次 Node ID: $last_saved_node_id"
    echo "请手动输入或粘贴本次要使用的 Node ID。"
  fi

  while true; do
    tty_prompt_line "请输入 EvoMap Node ID: " node_id_input
    if [ -z "$node_id_input" ]; then
      echo "Node ID 不能为空，必须手动输入或粘贴。"
      continue
    fi

    tty_prompt_line "确认 Node ID 为 [$node_id_input] 吗？(y/N): " confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
      printf '%s\n' "$node_id_input"
      return 0
    fi

    echo "已取消本次输入，请重新手动输入。"
  done
}

ensure_node_runtime() {
  local current_major=""

  refresh_runtime_proxy_env >/dev/null 2>&1 || true

  if command -v node >/dev/null 2>&1; then
    current_major=$(node_major_version_current)
  fi

  if command -v node >/dev/null 2>&1 && command -v npm >/dev/null 2>&1 && [[ "$current_major" =~ ^[0-9]+$ ]] && [ "$current_major" -ge 22 ]; then
    return 0
  fi

  if command -v dnf >/dev/null 2>&1; then
    install curl ca-certificates gcc gcc-c++ make python3 cmake libatomic nodejs
    return 0
  fi

  if command -v apt >/dev/null 2>&1; then
    install curl ca-certificates gnupg build-essential python3 libatomic1
    SKPL_APT_UPDATED="0"
    if curl -fsSL https://deb.nodesource.com/setup_22.x | bash -; then
      install nodejs
    else
      echo "NodeSource 安装源初始化失败，回退到系统仓库安装 nodejs/npm..."
      log_msg "NodeSource 安装源初始化失败，回退到系统仓库安装 nodejs/npm"
      install nodejs npm
    fi
  fi

  if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
    echo "Node.js 运行时安装失败，请先检查网络或软件源后重试。"
    return 1
  fi

  current_major=$(node_major_version_current)
  if ! [[ "$current_major" =~ ^[0-9]+$ ]] || [ "$current_major" -lt 22 ]; then
    echo "Node.js 版本仍低于 22，OpenClaw 无法稳定运行。当前版本: $(node -v 2>/dev/null || echo unknown)"
    echo "请检查 NodeSource 22.x 源是否可访问，或手动安装 Node.js 22+ 后重试。"
    return 1
  fi
}

detect_npm_country() {
  if [ -n "$SKPL_NPM_COUNTRY" ]; then
    echo "$SKPL_NPM_COUNTRY"
    return 0
  fi

  SKPL_NPM_COUNTRY="unknown"
  if command -v curl >/dev/null 2>&1; then
    SKPL_NPM_COUNTRY=$(curl -s --max-time 2 ipinfo.io/country | tr -d '\r\n' || echo "unknown")
  fi

  [ -n "$SKPL_NPM_COUNTRY" ] || SKPL_NPM_COUNTRY="unknown"
  echo "$SKPL_NPM_COUNTRY"
}

get_npm_registry_candidates() {
  local country

  if [ -n "$SKPL_NPM_REGISTRIES" ]; then
    printf '%s\n' "$SKPL_NPM_REGISTRIES"
    return 0
  fi

  if [ -n "$SKPL_NPM_REGISTRY" ]; then
    SKPL_NPM_REGISTRIES="$SKPL_NPM_REGISTRY
https://registry.npmjs.org"
    printf '%s\n' "$SKPL_NPM_REGISTRIES"
    return 0
  fi

  if resolve_active_proxy "$(skpl_effective_proxy_port)" >/dev/null 2>&1; then
    SKPL_NPM_REGISTRIES="https://registry.npmmirror.com
https://registry.npmjs.org"
    printf '%s\n' "$SKPL_NPM_REGISTRIES"
    return 0
  fi

  country=$(detect_npm_country)
  case "$country" in
    CN|HK)
      SKPL_NPM_REGISTRIES="https://registry.npmmirror.com
https://registry.npmjs.org"
      ;;
    *)
      SKPL_NPM_REGISTRIES="https://registry.npmjs.org
https://registry.npmmirror.com"
      ;;
  esac

  printf '%s\n' "$SKPL_NPM_REGISTRIES"
}

npm_try_with_registries() {
  local registry rc=1
  local npm_timeout_seconds="${SKPL_NPM_INSTALL_TIMEOUT:-600}"
  local -a npm_args=("$@")

  while IFS= read -r registry; do
    [ -z "$registry" ] && continue
    log_msg "npm 尝试 registry: $registry | timeout: ${npm_timeout_seconds}s | args: ${npm_args[*]}"
    echo "正在尝试 npm 源: ${registry}（超时 ${npm_timeout_seconds}s）..."
    set +e
    timeout "${npm_timeout_seconds}" npm "${npm_args[@]}" --registry "$registry"
    rc=$?
    set -e
    if [ $rc -eq 0 ]; then
      log_msg "npm 执行成功，registry: $registry"
      return 0
    fi
    log_msg "npm 执行失败，registry: $registry | 返回码: $rc"
    echo "npm 源 ${registry} 失败，正在尝试下一个..."
  done < <(get_npm_registry_candidates)

  return $rc
}

npm_query_openclaw_latest_version() {
  local registry remote_version

  while IFS= read -r registry; do
    [ -z "$registry" ] && continue
    remote_version=$(npm view openclaw version --no-update-notifier --registry "$registry" 2>/dev/null)
    if [ -n "$remote_version" ]; then
      printf '%s\n' "$remote_version"
      return 0
    fi
  done < <(get_npm_registry_candidates)

  return 1
}

configure_openclaw_git_transport() {
  git config --global url."https://github.com/".insteadOf ssh://git@github.com/ >/dev/null 2>&1 || true
  git config --global url."https://github.com/".insteadOf git@github.com: >/dev/null 2>&1 || true
}

install_openclaw_global() {
  local country="unknown"
  local preferred_registry="https://registry.npmjs.org"
  local active_proxy=""

  refresh_runtime_proxy_env

  active_proxy=$(resolve_active_proxy "$(skpl_effective_proxy_port)" 2>/dev/null || true)
  if [ -n "$active_proxy" ]; then
    preferred_registry="https://registry.npmmirror.com"
  else
    country=$(detect_npm_country)
    if [ "$country" = "CN" ] || [ "$country" = "HK" ]; then
      preferred_registry="https://registry.npmmirror.com"
    fi
  fi

  configure_openclaw_git_transport
  npm config set registry "$preferred_registry" >/dev/null 2>&1 || true
  npm config set fund false >/dev/null 2>&1 || true
  npm config set audit false >/dev/null 2>&1 || true
  npm config set progress true >/dev/null 2>&1 || true
  npm config set fetch-retries 5 >/dev/null 2>&1 || true
  npm config set fetch-timeout 600000 >/dev/null 2>&1 || true

  echo "正在安装 OpenClaw CLI..."
  echo "Node 版本: $(node -v 2>/dev/null || echo unknown)"
  echo "npm 版本: $(npm -v 2>/dev/null || echo unknown)"
  echo "当前 npm 源: ${preferred_registry}"
  if [ -n "$active_proxy" ]; then
    echo "当前检测到代理: ${active_proxy}"
  else
    echo "当前未检测到可用代理监听，按直连方式安装。"
  fi

  if npm install -g openclaw@latest --no-fund --no-audit --prefer-online --fetch-retries=5 --fetch-timeout=600000; then
    ensure_openclaw_cli_on_path >/dev/null 2>&1 || true
    return 0
  fi

  echo "首选 npm 源安装失败，开始尝试备用 npm 源..."
  npm_try_with_registries install -g openclaw@latest --no-fund --no-audit --prefer-online --fetch-retries=5 --fetch-timeout=600000
  ensure_openclaw_cli_on_path >/dev/null 2>&1 || true
}

install_evomap_dependencies() {
  local npm_args=(install --silent --no-fund --no-audit --prefer-offline)

  refresh_runtime_proxy_env

  if [ -f package-lock.json ]; then
    npm_args=(ci --silent --no-fund --no-audit --prefer-offline)
  fi

  npm_args+=(--fetch-retries=2 --fetch-timeout=300000)
  npm_try_with_registries "${npm_args[@]}"
}

openclaw_get_config_path_quick() {
  if [ -f "${HOME}/.openclaw/openclaw.json" ]; then
    echo "${HOME}/.openclaw/openclaw.json"
  else
    echo "/root/.openclaw/openclaw.json"
  fi
}

openclaw_ensure_local_gateway_config() {
  local config_file gateway_port
  config_file="$(openclaw_get_config_path_quick)"
  gateway_port="${OPENCLAW_GATEWAY_PORT:-18789}"
  mkdir -p "$(dirname "$config_file")"

  if command -v openclaw >/dev/null 2>&1; then
    openclaw config set gateway.mode local >/dev/null 2>&1 || true
    openclaw config set gateway.port "$gateway_port" --json >/dev/null 2>&1 || true
  fi

  python3 - "$config_file" "$gateway_port" <<'PY'
import json
import os
import sys

path, port_raw = sys.argv[1:3]
try:
    port = int(port_raw)
except Exception:
    port = 18789

data = {}
if os.path.exists(path) and os.path.getsize(path) > 0:
    try:
        with open(path, 'r', encoding='utf-8') as f:
            loaded = json.load(f)
            if isinstance(loaded, dict):
                data = loaded
    except Exception:
        raise SystemExit(0)

gateway = data.get('gateway')
if not isinstance(gateway, dict):
    gateway = {}
    data['gateway'] = gateway

changed = False
if gateway.get('mode') != 'local':
    gateway['mode'] = 'local'
    changed = True
if not isinstance(gateway.get('port'), int):
    gateway['port'] = port
    changed = True

for key, value in (('agents', {}), ('channels', {}), ('plugins', {}), ('memory', {})):
    if key not in data or data[key] is None:
        data[key] = value
        changed = True

if changed or not os.path.exists(path) or os.path.getsize(path) == 0:
    tmp = path + '.tmp'
    with open(tmp, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write('\n')
    os.replace(tmp, path)
PY
}

openclaw_default_memory_model_path() {
  echo "/root/.openclaw/models/embedding/embeddinggemma-300M-Q8_0.gguf"
}

install_node_and_tools() {
  ensure_node_runtime
}

start_gateway() {
  if openclaw_gateway_service_active; then
    systemctl --user restart openclaw-gateway.service >/dev/null 2>&1 || openclaw gateway restart >/dev/null 2>&1 || true
  else
    openclaw gateway restart >/dev/null 2>&1 || openclaw gateway start >/dev/null 2>&1 || true
  fi
  if [ "${SKPL_BATCH_MODE:-0}" != "1" ]; then
    sleep 3
  fi
}

openclaw_gateway_status_quick() {
  openclaw_gateway_is_running
}

openclaw_onboard_if_needed() {
  local config_file onboard_rc onboard_log
  config_file="$(openclaw_get_config_path_quick)"
  onboard_log="/root/.skpl/openclaw-onboard.log"

  if [ -s "$config_file" ]; then
    log_msg "OpenClaw 配置已存在，跳过 onboard"
    return 0
  fi

  echo "正在初始化 OpenClaw（首次执行可能需要 1-3 分钟）..."
  echo "初始化日志: ${onboard_log}"
  : > "$onboard_log"
  set +e
  timeout 180 bash -o pipefail -lc 'openclaw onboard --install-daemon 2>&1 | tee -a "$1"' _ "$onboard_log"
  onboard_rc=$?
  set -e

  if [ $onboard_rc -eq 0 ]; then
    log_msg "OpenClaw onboard 成功"
    echo "OpenClaw 初始化完成。"
    return 0
  fi

  log_msg "OpenClaw onboard 未成功，返回码: $onboard_rc"
  if [ $onboard_rc -eq 124 ]; then
    echo "OpenClaw 初始化超过 180 秒，继续执行后续兜底配置。"
  else
    echo "OpenClaw 初始化返回异常（返回码: $onboard_rc），继续执行后续兜底配置。"
  fi
  return 0
}

openclaw_ensure_gateway_ready() {
  local i

  if ! command -v openclaw >/dev/null 2>&1; then
    echo "OpenClaw CLI 未安装，无法启动网关。"
    return 1
  fi

  refresh_runtime_proxy_env
  openclaw_ensure_local_gateway_config >/dev/null 2>&1 || true
  refresh_openclaw_gateway_service >/dev/null 2>&1 || true

  if command -v systemctl >/dev/null 2>&1; then
    systemctl --user daemon-reload >/dev/null 2>&1 || true
    systemctl --user enable openclaw-gateway.service >/dev/null 2>&1 || true
    systemctl --user start openclaw-gateway.service >/dev/null 2>&1 || true
  fi

  if ! openclaw_gateway_is_running; then
    openclaw gateway install >/dev/null 2>&1 || true
    refresh_openclaw_gateway_service >/dev/null 2>&1 || true
    start_gateway
  fi

  if ! openclaw_gateway_is_running; then
    openclaw_gateway_fallback_start >/dev/null 2>&1 || true
  fi

  for i in 1 2 3 4 5 6 7 8 9 10; do
    if openclaw_gateway_is_running; then
      return 0
    fi
    sleep 1
  done

  echo "OpenClaw 网关启动后仍未就绪。"
  echo "建议检查：openclaw gateway status --deep、openclaw doctor、systemctl --user status openclaw-gateway.service --no-pager"
  echo "如果 systemd 在 WSL 中不可用，请检查 /root/.skpl/openclaw-gateway-fallback.log"
  return 1
}

openclaw_run_onboard_wizard() {
  local onboard_log="/root/.skpl/openclaw-onboard.log"
  echo "正在打开 OpenClaw 配置向导..."
  echo "配置向导日志: ${onboard_log}"
  : > "$onboard_log"
  openclaw onboard --install-daemon 2>&1 | tee -a "$onboard_log"
}

openclaw_memory_prepare() {
  local model_name model_dir model_path
  model_name="embeddinggemma-300M-Q8_0.gguf"
  model_dir="/root/.openclaw/models/embedding"
  model_path="${model_dir}/${model_name}"

  mkdir -p "${model_dir}" /root/.openclaw/workspace/memory
  openclaw config set memory.backend builtin >/dev/null 2>&1 || true
  openclaw config set agents.defaults.memorySearch.provider local >/dev/null 2>&1 || true
  openclaw config set memory.qmd.includeDefaultMemory true --json >/dev/null 2>&1 || true
  openclaw config set agents.defaults.memorySearch.local.modelPath "${model_path}" >/dev/null 2>&1 || true

  printf '%s\n' "$model_path"
}

openclaw_memory_prepare_prefetch() {
  local model_dir model_path
  model_path="$(openclaw_default_memory_model_path)"
  model_dir="$(dirname "$model_path")"
  mkdir -p "$model_dir" /root/.openclaw/workspace/memory
  printf '%s\n' "$model_path"
}

openclaw_memory_finalize() {
  openclaw memory index --force >/dev/null 2>&1 || true
  openclaw gateway restart >/dev/null 2>&1 || true
}

openclaw_memory_bootstrap() {
  local model_path="$1" low_priority_prefix
  local bootstrap_log="/root/.skpl/openclaw-memory-bootstrap.log"
  low_priority_prefix="$(skpl_low_priority_prefix)"

  nohup bash -lc '
    set -e
    model_path="$1"
    low_priority_prefix="$2"
    model_url="https://hf-mirror.com/ggml-org/embeddinggemma-300M-GGUF/resolve/main/$(basename "$model_path")"
    mkdir -p "$(dirname "$model_path")" /root/.openclaw/workspace/memory
    if [ ! -f "$model_path" ]; then
      curl -L --retry 3 --connect-timeout 10 --max-time 900 -C - -o "$model_path" "$model_url" || true
    fi
    ${low_priority_prefix}openclaw memory index --force >/dev/null 2>&1 || true
    openclaw gateway restart >/dev/null 2>&1 || true
  ' _ "$model_path" "$low_priority_prefix" >"$bootstrap_log" 2>&1 &
  disown 2>/dev/null || true
  echo "$bootstrap_log"
}

openclaw_memory_prefetch_bootstrap() {
  local model_path="$1" low_priority_prefix
  local bootstrap_log="/root/.skpl/openclaw-memory-bootstrap.log"
  low_priority_prefix="$(skpl_low_priority_prefix)"

  nohup bash -lc '
    set -e
    model_path="$1"
    low_priority_prefix="$2"
    model_name="$(basename "$model_path")"
    model_url="https://hf-mirror.com/ggml-org/embeddinggemma-300M-GGUF/resolve/main/${model_name}"
    mkdir -p "$(dirname "$model_path")"
    echo "开始后台预热记忆模型: ${model_url}"
    if [ -f "$model_path" ]; then
      echo "模型已存在，跳过下载: $model_path"
      exit 0
    fi
    ${low_priority_prefix}curl -L --retry 3 --connect-timeout 10 --max-time 1800 -C - -o "$model_path" "$model_url"
    echo "模型预热完成: $model_path"
  ' _ "$model_path" "$low_priority_prefix" >"$bootstrap_log" 2>&1 &
  disown 2>/dev/null || true
  echo "$bootstrap_log"
}

openclaw_memory_show_bootstrap_log() {
  local bootstrap_log="/root/.skpl/openclaw-memory-bootstrap.log"
  if [ ! -f "$bootstrap_log" ]; then
    echo "暂无记忆模型预热日志。"
    return 0
  fi
  python3 - "$bootstrap_log" <<'PY'
import sys
path = sys.argv[1]
with open(path, 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()
for line in lines[-80:]:
    print(line.rstrip())
PY
}

add_app_id() {
  local app_id_value="${app_id:-}"
  [ -z "$app_id_value" ] && return 0

  mkdir -p /home/docker
  touch /home/docker/appno.txt
  grep -qxF "$app_id_value" /home/docker/appno.txt || echo "$app_id_value" >> /home/docker/appno.txt
}

add_yuming() {
  read -r -p "请输入域名（example.com）: " yuming
}

ldnmp_Proxy() {
  local domain="$1"
  local target_host="$2"
  local target_port="$3"
  local conf_file="/home/web/conf.d/${domain}.conf"

  if [ ! -d /home/web/conf.d ] || ! command -v docker >/dev/null 2>&1 || ! docker ps --format '{{.Names}}' 2>/dev/null | grep -qx 'nginx'; then
    echo "未检测到可用的 Nginx 反向代理环境，无法自动为 ${domain} 配置域名访问。"
    echo "请手动将 ${domain} 反向代理到 ${target_host}:${target_port}。"
    return 1
  fi

  cat > "$conf_file" <<EOF
server {
  listen 80;
  listen [::]:80;
  server_name ${domain};

  location / {
    proxy_pass http://${target_host}:${target_port};
    proxy_http_version 1.1;
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
  }
}
EOF

  docker exec nginx nginx -s reload >/dev/null 2>&1 || {
    echo "Nginx 重载失败，请检查生成的配置：$conf_file"
    return 1
  }

  SKPL_LAST_PROXY_SCHEME="http"
  echo "已生成域名反向代理配置：${conf_file}"
  echo "访问地址：http://${domain}"
  return 0
}

web_del() {
  local remove_domain="${1:-}"

  if [ -z "$remove_domain" ]; then
    read -r -p "请输入要移除的域名: " remove_domain
  fi

  [ -z "$remove_domain" ] && return 0

  if [ ! -d /home/web/conf.d ] || ! command -v docker >/dev/null 2>&1 || ! docker ps --format '{{.Names}}' 2>/dev/null | grep -qx 'nginx'; then
    echo "未检测到可用的 Nginx 反向代理环境，请按你的环境手动删除域名配置：$remove_domain"
    return 1
  fi

  if [ -f "/home/web/conf.d/${remove_domain}.conf" ]; then
    rm -f "/home/web/conf.d/${remove_domain}.conf"
  fi
  if [ -f "/home/web/certs/${remove_domain}_key.pem" ]; then
    rm -f "/home/web/certs/${remove_domain}_key.pem"
  fi
  if [ -f "/home/web/certs/${remove_domain}_cert.pem" ]; then
    rm -f "/home/web/certs/${remove_domain}_cert.pem"
  fi

  docker exec nginx nginx -s reload >/dev/null 2>&1 || true
  echo "域名配置已删除：$remove_domain"
}

ensure_root() {
  local args=("$@")
  if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo >/dev/null 2>&1; then
      echo "检测到当前不是 root，正在尝试自动提权..."
      exec sudo bash "$0" "${args[@]}"
    fi
    echo "请使用 root 运行：su -c 'bash $0'"
    exit 1
  fi
}

save_self_to_skpl() {
  init_skpl_runtime
  mkdir -p "${SKPL_HOME}"
  if [ "$(readlink -f "$0" 2>/dev/null)" != "$(readlink -f "${SKPL_SCRIPT_PATH}" 2>/dev/null)" ]; then
    cp -f "$0" "${SKPL_SCRIPT_PATH}"
  fi
  chmod +x "${SKPL_SCRIPT_PATH}"

  cat > "${SKPL_CMD_PATH}" <<'EOF_SKPL_CMD'
#!/bin/bash
set -e
if [ ! -f /root/.skpl/merged_openclaw_readable.sh ]; then
  echo "未找到 /root/.skpl/merged_openclaw_readable.sh，请先运行安装脚本。"
  exit 1
fi
exec bash /root/.skpl/merged_openclaw_readable.sh panel "$@"
EOF_SKPL_CMD
  chmod +x "${SKPL_CMD_PATH}"
  hash -r 2>/dev/null || true
}

skpl_try_download_file() {
  local url="$1"
  local target="$2"

  if command -v curl >/dev/null 2>&1; then
    if curl -fsSL --connect-timeout 10 --max-time 90 "$url" -o "$target" 2>/dev/null; then
      return 0
    fi
  fi

  if command -v wget >/dev/null 2>&1; then
    if wget -q --timeout=90 -O "$target" "$url" 2>/dev/null; then
      return 0
    fi
  fi

  return 1
}

skpl_sync_remote_panel() {
  init_skpl_runtime
  mkdir -p "${SKPL_HOME}"

  local tmp_file downloaded_url proxy_url proxy
  tmp_file=$(mktemp)

  if skpl_try_download_file "$SKPL_REMOTE_SCRIPT_URL" "$tmp_file"; then
    downloaded_url="$SKPL_REMOTE_SCRIPT_URL"
  else
    for proxy in $SKPL_REMOTE_SCRIPT_PROXIES; do
      proxy_url="${proxy}${SKPL_REMOTE_SCRIPT_URL}"
      if skpl_try_download_file "$proxy_url" "$tmp_file"; then
        downloaded_url="$proxy_url"
        break
      fi
    done
  fi

  if [ -z "$downloaded_url" ]; then
    echo "远程更新失败：无法从 GitHub 或代理下载最新面板脚本。"
    return 1
  fi

  local size
  size=$(wc -c < "$tmp_file" 2>/dev/null || echo 0)
  if [ "$size" -lt 1000 ]; then
    echo "远程更新失败：下载文件异常。"
    return 1
  fi

  if ! bash -n "$tmp_file"; then
    echo "远程更新失败：下载到的脚本语法校验未通过。"
    return 1
  fi

  install -m 755 "$tmp_file" "${SKPL_SCRIPT_PATH}"

  cat > "${SKPL_CMD_PATH}" <<'EOF_SKPL_CMD'
#!/bin/bash
set -e
if [ ! -f /root/.skpl/merged_openclaw_readable.sh ]; then
  echo "未找到 /root/.skpl/merged_openclaw_readable.sh，请先运行安装脚本。"
  exit 1
fi
exec bash /root/.skpl/merged_openclaw_readable.sh panel "$@"
EOF_SKPL_CMD
  chmod +x "${SKPL_CMD_PATH}"
  hash -r 2>/dev/null || true

  echo "已从远程更新面板脚本。"
  echo "来源: $downloaded_url"
  return 0
}

remove_skpl_panel_only() {
  if [ -f "${SKPL_CMD_PATH}" ]; then
    rm -f "${SKPL_CMD_PATH}"
  fi
  if [ -f "${SKPL_SCRIPT_PATH}" ]; then
    rm -f "${SKPL_SCRIPT_PATH}"
  fi
  echo "SKPL 面板已卸载。OpenClaw/EvoMap 与其他脚本不受影响。"
}

run_wslwin_proxy_sync() {
  set +e
  clear
  echo -e "====================  WSL 全能一键脚本 ===================="
  local distro_codename=""
  local distro_id=""

  prompt_wsl_shutdown_confirmation || {
    set -e
    return 1
  }

  killall apt apt-get dpkg 2>/dev/null
  echo "正在清理 apt/dpkg 锁与旧代理配置..."
  sudo rm -f /var/lib/apt/lists/lock /var/cache/apt/archives/lock /var/lib/dpkg/lock*
  sudo dpkg --configure -a 2>/dev/null

  sudo rm -f /etc/apt/apt.conf.d/*proxy* /etc/apt/apt.conf.d/99*
  echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4 >/dev/null
  distro_id="$(awk -F= '/^ID=/{gsub(/"/,"",$2); print tolower($2); exit}' /etc/os-release 2>/dev/null)"
  if [ "$distro_id" = "ubuntu" ]; then
    [ ! -f /etc/apt/sources.list.bak.original ] && sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.original
    distro_codename="$(awk -F= '/^(UBUNTU_CODENAME|VERSION_CODENAME)=/{gsub(/"/,"",$2); print $2; exit}' /etc/os-release 2>/dev/null)"
    [ -n "$distro_codename" ] || distro_codename="jammy"
    sudo tee /etc/apt/sources.list >/dev/null <<'EOF'
deb http://mirrors.aliyun.com/ubuntu/ __DISTRO_CODENAME__ main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ __DISTRO_CODENAME__-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ __DISTRO_CODENAME__-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ __DISTRO_CODENAME__-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ __DISTRO_CODENAME__ main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ __DISTRO_CODENAME__-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ __DISTRO_CODENAME__-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ __DISTRO_CODENAME__-backports main restricted universe multiverse
EOF
    sudo sed -i "s/__DISTRO_CODENAME__/${distro_codename}/g" /etc/apt/sources.list
  else
    echo "检测到当前发行版不是 Ubuntu，跳过阿里 Ubuntu 源改写。"
  fi

  echo "正在刷新 apt 软件源缓存，这一步可能需要几十秒..."
  if ! DEBIAN_FRONTEND=noninteractive apt update -y >/dev/null 2>&1; then
    echo "检测到 apt update 失败，尝试回退原始 sources.list"
    if [ "$distro_id" = "ubuntu" ] && [ -f /etc/apt/sources.list.bak.original ]; then
      sudo cp /etc/apt/sources.list.bak.original /etc/apt/sources.list
    fi
  fi

  echo "软件源准备完成，开始进入代理端口配置。"

  echo -e "
==================== 配置向导：自定义代理端口 ===================="
  prompt_proxy_port || {
    set -e
    return 1
  }
  echo -e "已选择代理端口：$PROXY_PORT
"
  SKPL_PROXY_PORT="${PROXY_PORT:-10808}"
  state_set PROXY_PORT "$SKPL_PROXY_PORT"

  python3 - "$HOME/.bashrc" <<'PY'
import os
import sys

path = sys.argv[1]
start = '# >>> SKPL AUTO PROXY >>>\n'
end = '# <<< SKPL AUTO PROXY <<<\n'
try:
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()
except FileNotFoundError:
    lines = []

out = []
inside = False
for line in lines:
    if line == start:
        inside = True
        continue
    if line == end:
        inside = False
        continue
    if not inside:
        out.append(line)

with open(path, 'w', encoding='utf-8') as f:
    f.writelines(out)
PY

  cat > ~/.auto_proxy_sync.sh <<'EOF'
#!/bin/bash
SKPL_PROXY_PORT_VALUE="__PORT__"
NO_PROXY_RULE="__NO_PROXY_RULE__"

proxy_candidates() {
  local port="$SKPL_PROXY_PORT_VALUE"
  local host=""

  printf '%s\n' "127.0.0.1:${port}"
  printf '%s\n' "10.255.255.254:${port}"

  host=$(getent ahostsv4 host.docker.internal 2>/dev/null | awk 'NR==1{print $1}')
  if [ -n "$host" ]; then
    printf '%s\n' "${host}:${port}"
  fi

  host=$(awk '/^nameserver /{print $2; exit}' /etc/resolv.conf 2>/dev/null)
  if [ -n "$host" ]; then
    printf '%s\n' "${host}:${port}"
  fi

  host=$(ip route 2>/dev/null | awk '/^default /{print $3; exit}')
  if [ -n "$host" ]; then
    printf '%s\n' "${host}:${port}"
  fi
}

check_port() {
  local ip_port=$1
  local ip=$(echo "$ip_port" | cut -d: -f1)
  local port=$(echo "$ip_port" | cut -d: -f2)
  timeout 0.5 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null
}

ACTIVE_PROXY=""
while IFS= read -r candidate; do
  [ -z "$candidate" ] && continue
  if check_port "$candidate"; then
    ACTIVE_PROXY="$candidate"
    break
  fi
done < <(proxy_candidates | awk '!seen[$0]++')

if [ -n "$ACTIVE_PROXY" ]; then
  PROXY_URL="http://$ACTIVE_PROXY"
  export http_proxy="$PROXY_URL"
  export https_proxy="$PROXY_URL"
  export HTTP_PROXY="$PROXY_URL"
  export HTTPS_PROXY="$PROXY_URL"
  export all_proxy="$PROXY_URL"
  export ALL_PROXY="$PROXY_URL"
  export ftp_proxy="$PROXY_URL"
  export FTP_PROXY="$PROXY_URL"
  export no_proxy="$NO_PROXY_RULE"
  export NO_PROXY="$NO_PROXY_RULE"
  export npm_config_proxy="$PROXY_URL"
  export npm_config_https_proxy="$PROXY_URL"
  export npm_config_noproxy="$NO_PROXY_RULE"
  echo "自动同步：代理已开启 ($ACTIVE_PROXY)"
else
  unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY all_proxy ALL_PROXY ftp_proxy FTP_PROXY no_proxy NO_PROXY npm_config_proxy npm_config_https_proxy npm_config_noproxy
  echo "自动同步：未检测到代理监听，请检查 Windows 代理是否已开启"
fi
EOF

  sed -i "s/__PORT__/$PROXY_PORT/g" ~/.auto_proxy_sync.sh
  local merged_no_proxy
  merged_no_proxy=$(skpl_build_no_proxy_rule)
  sed -i "s|__NO_PROXY_RULE__|${merged_no_proxy}|g" ~/.auto_proxy_sync.sh
  chmod +x ~/.auto_proxy_sync.sh
  cat >> ~/.bashrc <<'EOF_BASHRC_SKPL'
# >>> SKPL AUTO PROXY >>>
[ -f ~/.auto_proxy_sync.sh ] && source ~/.auto_proxy_sync.sh
# <<< SKPL AUTO PROXY <<<
EOF_BASHRC_SKPL
  write_skpl_proxy_env_script
  refresh_runtime_proxy_env
  source ~/.auto_proxy_sync.sh >/dev/null 2>&1 || true

  refresh_openclaw_gateway_service >/dev/null 2>&1 || true
  set -e
}

load_openclaw_panel() {
  eval "$(cat <<'OPENCLAW_PANEL_EOF'
openclaw_panel_menu() {
  local app_id="114"

  send_stats "OpenClaw 面板管理"

  check_openclaw_update() {
    local now
    if ! command -v npm >/dev/null 2>&1; then
      return 1
    fi

    now=$(date +%s)
    if [ -n "$OPENCLAW_UPDATE_CACHE_TS" ] && [ $((now - OPENCLAW_UPDATE_CACHE_TS)) -lt 600 ]; then
      echo "$OPENCLAW_UPDATE_CACHE_MSG"
      return 0
    fi

    # 加上 --no-update-notifier，并确保错误重定向位置正确
    local_version=$(npm list -g openclaw --depth=0 --no-update-notifier 2>/dev/null | grep openclaw | awk '{print $NF}' | sed 's/^.*@//')

    if [ -z "$local_version" ]; then
      return 1
    fi

    remote_version=$(npm_query_openclaw_latest_version)

    if [ -z "$remote_version" ]; then
      return 1
    fi

    if [ "$local_version" != "$remote_version" ]; then
      OPENCLAW_UPDATE_CACHE_MSG="检测到新版本: $remote_version"
    else
      OPENCLAW_UPDATE_CACHE_MSG="当前版本已是最新: $local_version"
    fi

    OPENCLAW_UPDATE_CACHE_TS="$now"
    echo "$OPENCLAW_UPDATE_CACHE_MSG"
  }


  get_install_status() {
    if command -v openclaw >/dev/null 2>&1; then
      echo "已安装"
    else
      echo "未安装"
    fi
  }

  get_running_status() {
    if openclaw_gateway_is_running; then
      echo "运行中"
    else
      echo "未运行"
    fi
  }

  get_cached_openclaw_update_message() {
    if [ -n "$OPENCLAW_UPDATE_CACHE_MSG" ]; then
      echo "$OPENCLAW_UPDATE_CACHE_MSG"
      return 0
    fi

    if command -v openclaw >/dev/null 2>&1; then
      echo "更新检查按需执行"
    fi
  }

  get_local_openclaw_version() {
    local version_text=""
    if command -v openclaw >/dev/null 2>&1; then
      version_text=$(openclaw --version 2>/dev/null | head -n 1)
      [ -z "$version_text" ] && version_text=$(openclaw version 2>/dev/null | head -n 1)
    fi
    printf '%s\n' "${version_text:-未检测到}"
  }


  show_menu() {
    clear

    local install_status=$(get_install_status)
    local running_status=$(get_running_status)
    local local_version=$(get_local_openclaw_version)
    local install_tone="warn"
    local running_tone="warn"
    [ "$install_status" = "已安装" ] && install_tone="ok"
    [ "$running_status" = "运行中" ] && running_tone="ok"

    skpl_ui_header "OpenClaw管理面板"
    skpl_ui_section "概览"
    skpl_ui_status_row "安装状态" "$install_tone" "$install_status"
    skpl_ui_status_row "网关状态" "$running_tone" "$running_status"
    skpl_ui_kv "版本信息" "$local_version"

    echo
    skpl_ui_section "服务"
    skpl_ui_menu_item_tone 1 "安装 OpenClaw" "初始化环境与配置" "ok"
    skpl_ui_menu_item_tone 2 "启动网关" "启动当前服务" "ok"
    skpl_ui_menu_item_tone 3 "停止网关" "停止当前服务" "warn"
    skpl_ui_menu_item 4 "状态与日志" "查看运行状态和日志"
    skpl_ui_menu_item 5 "切换模型" "修改主模型与会话模型"

    echo
    skpl_ui_section "配置与接入"
    skpl_ui_menu_item 6 "API 管理" "Provider、Key、模型同步"
    skpl_ui_menu_item 7 "设备连接" "Telegram / WhatsApp / QQ"
    skpl_ui_menu_item 8 "插件管理" "扩展插件"
    skpl_ui_menu_item 9 "技能管理" "导入和管理技能"
    skpl_ui_menu_item 10 "编辑主配置" "openclaw.json"
    skpl_ui_menu_item 11 "配置向导" "重新进入 onboard"

    echo
    skpl_ui_section "运行与数据"
    skpl_ui_menu_item 12 "健康检测与修复" "自动修复常见问题"
    skpl_ui_menu_item 13 "WebUI 访问设置" "Token、域名、访问入口"
    skpl_ui_menu_item 14 "TUI 对话" "进入命令行对话界面"
    skpl_ui_menu_item 15 "记忆管理" "索引、方案、状态"
    skpl_ui_menu_item 16 "权限管理" "策略与白名单"
    skpl_ui_menu_item 17 "多智能体管理" "Agent、绑定、会话"
    skpl_ui_menu_item 18 "备份与还原" "记忆与项目快照"
    skpl_ui_menu_item 21 "EvoMap 管理" "安装、更新与记忆"

    echo
    skpl_ui_section "维护"
    skpl_ui_menu_item 19 "更新 OpenClaw" "升级 CLI 和运行环境"
    skpl_ui_menu_item_tone 20 "卸载 OpenClaw" "移除 CLI 与数据目录" "danger"
    skpl_ui_menu_item 0 "返回上一级"
    skpl_ui_footer_prompt "请输入选项并回车: "
  }


  start_gateway() {
    if openclaw_gateway_service_active; then
      systemctl --user restart openclaw-gateway.service >/dev/null 2>&1 || openclaw gateway restart >/dev/null 2>&1 || true
    else
      openclaw gateway restart >/dev/null 2>&1 || openclaw gateway start >/dev/null 2>&1 || true
    fi
    if [ "${SKPL_BATCH_MODE:-0}" != "1" ]; then
      sleep 3
    fi
  }


  install_node_and_tools() {
    ensure_node_runtime
  }

  sync_openclaw_api_models() {
    local config_file
    config_file=$(openclaw_get_config_file)

    [ ! -f "$config_file" ] && return 0

    install jq curl >/dev/null 2>&1

    python3 - "$config_file" "$ENABLE_STATS" "$sh_v" <<'PY'
import copy
import json
import os
import platform
import sys
import time
import urllib.parse
import urllib.request
from datetime import datetime, timezone

path = sys.argv[1]
stats_enabled = (sys.argv[2].lower() == "true") if len(sys.argv) > 2 else True
script_version = sys.argv[3] if len(sys.argv) > 3 else ""

def send_stat(action):
    return

with open(path, 'r', encoding='utf-8') as f:
    obj = json.load(f)

work = copy.deepcopy(obj)
models_cfg = work.setdefault('models', {})
providers = models_cfg.get('providers', {})
if not isinstance(providers, dict) or not providers:
    print('ℹ️ 未检测到 API providers，跳过模型同步')
    raise SystemExit(0)

agents = work.setdefault('agents', {})
defaults = agents.setdefault('defaults', {})
defaults_models_raw = defaults.get('models')
if isinstance(defaults_models_raw, dict):
    defaults_models = defaults_models_raw
elif isinstance(defaults_models_raw, list):
    defaults_models = {str(x): {} for x in defaults_models_raw if isinstance(x, str)}
else:
    defaults_models = {}
defaults['models'] = defaults_models

SUPPORTED_APIS = {'openai-completions', 'openai-responses'}

changed = False
fatal_errors = []
summary = []


def model_ref(provider_name, model_id):
    return f"{provider_name}/{model_id}"


def get_primary_ref(defaults_obj):
    model_obj = defaults_obj.get('model')
    if isinstance(model_obj, str):
        return model_obj
    if isinstance(model_obj, dict):
        primary = model_obj.get('primary')
        if isinstance(primary, str):
            return primary
    return None


def set_primary_ref(defaults_obj, new_ref):
    model_obj = defaults_obj.get('model')
    if isinstance(model_obj, str):
        defaults_obj['model'] = new_ref
    elif isinstance(model_obj, dict):
        model_obj['primary'] = new_ref
    else:
        defaults_obj['model'] = {'primary': new_ref}


def ref_provider(ref):
    if not isinstance(ref, str) or '/' not in ref:
        return None
    return ref.split('/', 1)[0]


def collect_available_refs(exclude_provider=None):
    refs = []
    if not isinstance(providers, dict):
        return refs
    for pname, p in providers.items():
        if exclude_provider and pname == exclude_provider:
            continue
        if not isinstance(p, dict):
            continue
        for m in p.get('models', []) or []:
            if isinstance(m, dict) and m.get('id'):
                refs.append(model_ref(pname, str(m['id'])))
    return refs


def prompt_delete_provider(name):
    prompt = f"⚠️ {name} /models 探测连续失败 3 次。是否删除该 API 供应商及其全部相关模型？[y/N]: "
    try:
        ans = input(prompt).strip().lower()
    except EOFError:
        return False
    return ans in ('y', 'yes')


def rebind_defaults_before_delete(name):
    global changed

    replacement = None

    def get_replacement():
        nonlocal replacement
        if replacement is None:
            candidates = collect_available_refs(exclude_provider=name)
            replacement = candidates[0] if candidates else None
        return replacement

    primary_ref = get_primary_ref(defaults)
    if ref_provider(primary_ref) == name:
        repl = get_replacement()
        if not repl:
            summary.append(f'❌ {name}: 默认主模型指向该 provider，但无可用替代模型，已中止删除')
            return False
        set_primary_ref(defaults, repl)
        changed = True
        summary.append(f'🔁 删除前已切换默认主模型: {primary_ref} -> {repl}')

    for fk in ('modelFallback', 'imageModelFallback'):
        val = defaults.get(fk)
        if ref_provider(val) == name:
            repl = get_replacement()
            if not repl:
                summary.append(f'❌ {name}: {fk} 指向该 provider，但无可用替代模型，已中止删除')
                return False
            defaults[fk] = repl
            changed = True
            summary.append(f'🔁 删除前已切换 {fk}: {val} -> {repl}')

    return True


def delete_provider_and_refs(name):
    global changed

    if not rebind_defaults_before_delete(name):
        return False

    removed_refs = [r for r in list(defaults_models.keys()) if r.startswith(name + '/')]
    for r in removed_refs:
        defaults_models.pop(r, None)
    if removed_refs:
        changed = True

    if name in providers:
        providers.pop(name, None)
        changed = True

    summary.append(f'🗑️ 已删除 provider {name}，并移除 defaults.models 下 {len(removed_refs)} 个模型引用')
    return True


def fetch_remote_models_with_retry(name, base_url, api_key, retries=3):
    last_error = None
    host = (urllib.parse.urlparse(base_url).hostname or '').lower()
    domestic_rules = [
        'model-square.app.baizhi.cloud', '.baizhi.cloud', '.aliyuncs.com', '.modelscope.cn',
        '.deepseek.com', '.moonshot.cn', '.bigmodel.cn', '.siliconflow.cn', '.stepfun.com',
        '.minimax.chat', '.baichuan-ai.com', '.ppinfra.com', '.volces.com',
        '.ark.cn-beijing.volces.com', '.qianfan.baidubce.com', '.xf-yun.com',
        '.spark-api.xf-yun.com', '.hunyuan.cloud.tencent.com', '.tencentcloudapi.com'
    ]

    def is_domestic(h):
        if not h:
            return False
        for rule in domestic_rules:
            if rule.startswith('.'):
                if h.endswith(rule):
                    return True
            elif h == rule or h.endswith('.' + rule):
                return True
        return False

    for attempt in range(1, retries + 1):
        req = urllib.request.Request(
            base_url.rstrip('/') + '/models',
            headers={
                'Authorization': f'Bearer {api_key}',
                'User-Agent': 'Mozilla/5.0',
            },
        )
        try:
            if is_domestic(host):
                opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
                resp = opener.open(req, timeout=12)
            else:
                resp = urllib.request.urlopen(req, timeout=12)
            with resp:
                payload = resp.read().decode('utf-8', 'ignore')
            data = json.loads(payload)
            return data, None, attempt
        except Exception as e:
            last_error = e
            if attempt < retries:
                time.sleep(1)
    return None, last_error, retries


for name, provider in list(providers.items()):
    if not isinstance(provider, dict):
        summary.append(f'ℹ️ 跳过 {name}: provider 结构非法')
        continue

    api = provider.get('api', '')
    base_url = provider.get('baseUrl')
    api_key = provider.get('apiKey')
    model_list = provider.get('models', [])

    if not base_url or not api_key or not isinstance(model_list, list) or not model_list:
        summary.append(f'ℹ️ 跳过 {name}: 无 baseUrl/apiKey/models')
        continue

    if api not in SUPPORTED_APIS:
        summary.append(f'🔁 {name}: 发现非法协议 {api or "(unset)"}，将重新探测')
        provider['api'] = ''
        api = ''
        changed = True

    data, err, attempts = fetch_remote_models_with_retry(name, base_url, api_key, retries=3)
    if err is not None:
        summary.append(f'⚠️ {name}: /models 探测失败，已重试 {attempts} 次 ({type(err).__name__}: {err})')
        send_stat('OpenClaw API确认介入')
        if prompt_delete_provider(name):
            deleted = delete_provider_and_refs(name)
            if deleted:
                send_stat('OpenClaw API删失败Provider-确认')
                summary.append(f'✅ {name}: 用户已确认删除该 provider 及全部相关模型引用')
        else:
            send_stat('OpenClaw API删失败Provider-拒绝')
            summary.append(f'ℹ️ {name}: 用户未确认删除，保留现有 provider 配置')
        continue

    if attempts > 1:
        summary.append(f'🔁 {name}: /models 第 {attempts} 次重试后成功')

    if not (isinstance(data, dict) and isinstance(data.get('data'), list)):
        summary.append(f'⚠️ 跳过 {name}: /models 返回结构不可识别')
        continue

    remote_ids = []
    for item in data['data']:
        if isinstance(item, dict) and item.get('id'):
            remote_ids.append(str(item['id']))
    remote_set = set(remote_ids)

    if not remote_set:
        fatal_errors.append(f'❌ {name} 上游 /models 为空，无法为该 provider 提供兜底模型')
        continue

    local_models = [m for m in model_list if isinstance(m, dict) and m.get('id')]
    local_ids = [str(m['id']) for m in local_models]
    local_set = set(local_ids)

    template = None
    for m in local_models:
        template = copy.deepcopy(m)
        break
    if template is None:
        summary.append(f'⚠️ 跳过 {name}: 本地 models 无有效模板模型')
        continue

    removed_ids = [mid for mid in local_ids if mid not in remote_set]
    added_ids = [mid for mid in remote_ids if mid not in local_set]

    kept_models = [copy.deepcopy(m) for m in local_models if str(m['id']) in remote_set]
    new_models = kept_models[:]

    for mid in added_ids:
        nm = copy.deepcopy(template)
        nm['id'] = mid
        if isinstance(nm.get('name'), str):
            nm['name'] = f'{name} / {mid}'
        new_models.append(nm)

    if not new_models:
        fatal_errors.append(f'❌ {name} 同步后无可用模型，无法保障默认模型/回退模型兜底')
        continue

    expected_refs = {model_ref(name, str(m['id'])) for m in new_models if isinstance(m, dict) and m.get('id')}
    local_refs = {model_ref(name, mid) for mid in local_ids}

    first_ref = model_ref(name, str(new_models[0]['id']))

    primary_ref = get_primary_ref(defaults)
    if isinstance(primary_ref, str) and primary_ref in (local_refs - expected_refs):
        set_primary_ref(defaults, first_ref)
        changed = True
        summary.append(f'🔁 默认模型已兜底替换: {primary_ref} -> {first_ref}')

    for fk in ('modelFallback', 'imageModelFallback'):
        val = defaults.get(fk)
        if isinstance(val, str) and val in (local_refs - expected_refs):
            defaults[fk] = first_ref
            changed = True
            summary.append(f'🔁 {fk} 已兜底替换: {val} -> {first_ref}')

    stale_refs = [r for r in list(defaults_models.keys()) if r.startswith(name + '/') and r not in expected_refs]
    for r in stale_refs:
        defaults_models.pop(r, None)
        changed = True

    for r in sorted(expected_refs):
        if r not in defaults_models:
            defaults_models[r] = {}
            changed = True

    if removed_ids or added_ids or len(local_models) != len(new_models):
        provider['models'] = new_models
        changed = True

    summary.append(f'✅ {name}: 新增 {len(added_ids)} 个，删除 {len(removed_ids)} 个，当前 {len(new_models)} 个')

    if added_ids:
        summary.append(f'➕ 新增模型({len(added_ids)}):')
        for mid in added_ids:
            summary.append(f'  + {mid}')
    if removed_ids:
        summary.append(f'➖ 删除模型({len(removed_ids)}):')
        for mid in removed_ids:
            summary.append(f'  - {mid}')


if fatal_errors:
    for line in summary:
        print(line)
    for err in fatal_errors:
        print(err)
    print('❌ 模型同步失败：存在 provider 同步后无可用模型，已中止写入')
    raise SystemExit(2)

if changed:
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(work, f, ensure_ascii=False, indent=2)
        f.write('\n')
    for line in summary:
        print(line)
    print('✅ OpenClaw API 模型一致性同步完成并已写入配置')
else:
    for line in summary:
        print(line)
    print('ℹ️ 无需同步：配置已与上游 /models 保持一致')
PY
  }



  install_openclaw_panel() {
    echo "开始安装 OpenClaw..."
    send_stats "开始安装 OpenClaw..."
    install git jq

    install_node_and_tools

    echo "正在安装 OpenClaw CLI..."
    install_openclaw_global
    if ! command -v openclaw >/dev/null 2>&1; then
      echo "OpenClaw CLI 安装失败：未检测到 openclaw 命令。"
      return 1
    fi

    openclaw_onboard_if_needed
    start_gateway
    openclaw gateway status >/dev/null 2>&1 || true
    add_app_id
    break_end

  }


  start_bot() {
    echo "启动 OpenClaw..."
    send_stats "启动 OpenClaw..."
    start_gateway
    break_end
  }

  stop_bot() {
    echo "停止 OpenClaw..."
    send_stats "停止 OpenClaw..."
    tmux kill-session -t gateway > /dev/null 2>&1
    openclaw gateway stop
    break_end
  }

  view_logs() {
    echo "查看 OpenClaw 状态日志"
    send_stats "查看 OpenClaw 日志"
    openclaw status
    openclaw gateway status
    openclaw logs
    break_end
  }





  # OpenClaw API 协议探测逻辑已移除：不再自动探测/判定 API 类型。
  # 说明：API 类型由用户显式配置（models.providers.<name>.api），脚本不再尝试调用 /responses 做推断。

  # 构造模型配置 JSON
  build-openclaw-provider-models-json() {
    local provider_name="$1"
    local model_ids="$2"
    local models_array="["
    local first=true

    while read -r model_id; do
      [ -z "$model_id" ] && continue
      [[ $first == false ]] && models_array+=","
      first=false

      local context_window=1048576
      local max_tokens=128000
      local input_cost=0.15
      local output_cost=0.60

      case "$model_id" in
        *opus*|*pro*|*preview*|*thinking*|*sonnet*)
          input_cost=2.00
          output_cost=12.00
          ;;
        *gpt-5*|*codex*)
          input_cost=1.25
          output_cost=10.00
          ;;
        *flash*|*lite*|*haiku*|*mini*|*nano*)
          input_cost=0.10
          output_cost=0.40
          ;;
      esac

      models_array+=$(cat <<EOF
{
  "id": "$model_id",
  "name": "$provider_name / $model_id",
  "input": ["text", "image"],
  "contextWindow": $context_window,
  "maxTokens": $max_tokens,
  "cost": {
    "input": $input_cost,
    "output": $output_cost,
    "cacheRead": 0,
    "cacheWrite": 0
  }
}
EOF
)
    done <<< "$model_ids"

    models_array+="]"
    echo "$models_array"
  }

  # 写入 provider 与模型配置
  write-openclaw-provider-models() {
    local provider_name="$1"
    local base_url="$2"
    local api_key="$3"
    local models_array="$4"
    local config_file
    config_file=$(openclaw_get_config_file)

    # 不再自动探测/纠正 API 协议；保持用户配置为准
    DETECTED_API="openai-completions"

    [[ -f "$config_file" ]] && cp "$config_file" "${config_file}.bak.$(date +%s)"

    jq --arg prov "$provider_name" \
       --arg url "$base_url" \
       --arg key "$api_key" \
       --arg api "$DETECTED_API" \
       --argjson models "$models_array" \
    '
    .models |= (
      (. // { mode: "merge", providers: {} })
      | .mode = "merge"
      | .providers[$prov] = {
        baseUrl: $url,
        apiKey: $key,
        api: $api,
        models: $models
      }
    )
    | .agents |= (. // {})
    | .agents.defaults |= (. // {})
    | .agents.defaults.models |= (
      (if type == "object" then .
       elif type == "array" then reduce .[] as $m ({}; if ($m|type) == "string" then .[$m] = {} else . end)
       else {}
       end) as $existing
      | reduce ($models[]? | .id? // empty | tostring) as $mid (
        $existing;
        if ($mid | length) > 0 then
          .["\($prov)/\($mid)"] //= {}
        else
          .
        end
      )
    )
    ' "$config_file" > "${config_file}.tmp" && mv "${config_file}.tmp" "$config_file"
  }

  # 核心函数：获取并添加所有模型
  add-all-models-from-provider() {
    local provider_name="$1"
    local base_url="$2"
    local api_key="$3"

    echo "🔍 正在获取 $provider_name 的所有可用模型..."

    local models_json
    models_json=$(curl_fetch_models_json "$base_url" "$api_key")

    if [[ -z "$models_json" ]]; then
      echo "❌ 无法获取模型列表"
      return 1
    fi

    local model_ids=$(echo "$models_json" | grep -oP '"id":\s*"\K[^"]+')

    if [[ -z "$model_ids" ]]; then
      echo "❌ 未找到任何模型"
      return 1
    fi

    local model_count=$(echo "$model_ids" | wc -l)
    echo "✅ 发现 $model_count 个模型"

    local models_array
    models_array=$(build-openclaw-provider-models-json "$provider_name" "$model_ids")

    write-openclaw-provider-models "$provider_name" "$base_url" "$api_key" "$models_array"

    if [[ $? -eq 0 ]]; then
      echo "✅ 成功添加 $model_count 个模型到 $provider_name"
      echo "📦 模型引用格式: $provider_name/<model-id>"
      return 0
    else
      echo "❌ 配置注入失败"
      return 1
    fi
  }

  # 仅添加默认模型并保留 provider
  add-default-model-only-to-provider() {
    local provider_name="$1"
    local base_url="$2"
    local api_key="$3"
    local default_model="$4"

    if [[ -z "$default_model" ]]; then
      echo "❌ 默认模型不能为空"
      return 1
    fi

    local models_array
    models_array=$(build-openclaw-provider-models-json "$provider_name" "$default_model")

    write-openclaw-provider-models "$provider_name" "$base_url" "$api_key" "$models_array"

    if [[ $? -eq 0 ]]; then
      echo "✅ 已添加 provider：$provider_name"
      echo "✅ 仅写入默认模型：$default_model"
      return 0
    else
      echo "❌ 配置注入失败"
      return 1
    fi
  }

  add-openclaw-provider-interactive() {
    send_stats "OpenClaw API添加"
    echo "=== 交互式添加 OpenClaw Provider (全量模型) ==="

    # 1. Provider 名称
    read -erp "请输入 Provider 名称 (如: deepseek): " provider_name
    while [[ -z "$provider_name" ]]; do
      echo "❌ Provider 名称不能为空"
      read -erp "请输入 Provider 名称: " provider_name
    done

    # 2. Base URL
    read -erp "请输入 Base URL (如: https://api.xxx.com/v1): " base_url
    while [[ -z "$base_url" ]]; do
      echo "❌ Base URL 不能为空"
      read -erp "请输入 Base URL: " base_url
    done
    base_url="${base_url%/}"

    # 3. API Key
    read -rsp "请输入 API Key (输入不显示): " api_key
    echo
    while [[ -z "$api_key" ]]; do
      echo "❌ API Key 不能为空"
      read -rsp "请输入 API Key: " api_key
      echo
    done

    # 4. 不再探测/判断 API 类型；协议由用户自行选择与维护

    # 5. 获取模型列表
    echo "🔍 正在获取可用模型列表..."
    models_json=$(curl_fetch_models_json "$base_url" "$api_key")

    if [[ -n "$models_json" ]]; then
      available_models=$(echo "$models_json" | grep -oP '"id":\s*"\K[^"]+' | sort)

      if [[ -n "$available_models" ]]; then
        model_count=$(echo "$available_models" | wc -l)
        echo "✅ 发现 $model_count 个可用模型："
        echo "--------------------------------"
        # 全部显示，带序号
        i=1
        model_list=()
        while read -r model; do
          echo "[$i] $model"
          model_list+=("$model")
          ((i++))
        done <<< "$available_models"
        echo "--------------------------------"
      fi
    fi

    # 5. 选择默认模型
    echo
    read -erp "请输入默认 Model ID (或序号，留空则使用第一个): " input_model

    if [[ -z "$input_model" && -n "$available_models" ]]; then
      default_model=$(echo "$available_models" | head -1)
      echo "🎯 使用第一个模型: $default_model"
    elif [[ "$input_model" =~ ^[0-9]+$ ]] && [ "${#model_list[@]}" -gt 0 ] && [ "$input_model" -ge 1 ] && [ "$input_model" -le "${#model_list[@]}" ]; then
      default_model="${model_list[$((input_model-1))]}"
      echo "🎯 已选择模型: $default_model"
    else
      default_model="$input_model"
    fi

    # 6. 确认信息
    echo
    echo "====== 确认信息 ======"
    echo "Provider    : $provider_name"
    echo "Base URL    : $base_url"
    echo "API Key     : ${api_key:0:8}****"
    echo "默认模型    : $default_model"
    echo "模型总数    : $model_count"
    echo "======================"

    read -erp "是否同时添加其他所有可用模型？(y/N): " confirm

    install jq
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      add-all-models-from-provider "$provider_name" "$base_url" "$api_key"
      add_result=$?
      finish_msg="✅ 完成！所有 $model_count 个模型已加载"
    else
      add-default-model-only-to-provider "$provider_name" "$base_url" "$api_key" "$default_model"
      add_result=$?
      finish_msg="✅ 完成！已保留 provider，并仅加载默认模型：$default_model"
    fi

    if [[ $add_result -eq 0 ]]; then
      echo
      echo "🔄 设置默认模型并重启网关..."
      openclaw models set "$provider_name/$default_model"
      openclaw_sync_sessions_model "$provider_name/$default_model"
      start_gateway
      echo "$finish_msg"
      echo "✅ 当前 API 协议类型: $DETECTED_API"
    fi

    break_end
  }



openclaw_api_manage_list() {
  local config_file="${HOME}/.openclaw/openclaw.json"
  send_stats "OpenClaw API列表"

  while IFS=$'\t' read -r rec_type idx name base_url model_count api_type latency_txt latency_level; do
    case "$rec_type" in
      MSG)
        echo "$idx"
        ;;
      ROW)
        local latency_color="$gl_bai"
        case "$latency_level" in
          low) latency_color="$gl_lv" ;;
          medium) latency_color="$gl_huang" ;;
          high|unavailable) latency_color="$gl_hong" ;;
          unchecked) latency_color="$gl_bai" ;;
        esac

        printf '%b\n' "[$idx] ${name} | API: ${base_url} | 协议: ${api_type} | 模型数量: ${gl_huang}${model_count}${gl_bai} | 延迟/状态: ${latency_color}${latency_txt}${gl_bai}"
        ;;
    esac
  done < <(python3 - "$config_file" <<-'PY'
import json
import sys
import time
import urllib.request

path = sys.argv[1]
SUPPORTED_APIS = {'openai-completions', 'openai-responses'}


def ping_models(base_url, api_key):
    req = urllib.request.Request(
        base_url.rstrip('/') + '/models',
        headers={
            'Authorization': f'Bearer {api_key}',
            'User-Agent': 'OpenClaw-API-Manage/1.0',
        },
    )
    start = time.perf_counter()
    with urllib.request.urlopen(req, timeout=4) as resp:
        resp.read(2048)
    return int((time.perf_counter() - start) * 1000)


def classify_latency(latency):
    if latency == '不可用':
        return '不可用', 'unavailable'
    if latency == '未检测':
        return '未检测', 'unchecked'
    if isinstance(latency, int):
        if latency <= 800:
            level = 'low'
        elif latency <= 2000:
            level = 'medium'
        else:
            level = 'high'
        return f'{latency}ms', level
    return str(latency), 'unchecked'


try:
    with open(path, 'r', encoding='utf-8') as f:
        obj = json.load(f)
except FileNotFoundError:
    print('MSG\tℹ️ 未找到 openclaw.json，请先完成安装/初始化。')
    raise SystemExit(0)
except Exception as e:
    print(f'MSG\t❌ 读取配置失败: {type(e).__name__}: {e}')
    raise SystemExit(0)

providers = ((obj.get('models') or {}).get('providers') or {})
if not isinstance(providers, dict) or not providers:
    print('MSG\tℹ️ 当前未配置任何 API provider。')
    raise SystemExit(0)

print('MSG\t--- 已配置 API 列表 ---')

for idx, name in enumerate(sorted(providers.keys()), start=1):
    provider = providers.get(name)
    if not isinstance(provider, dict):
        base_url = '-'
        model_count = 0
        latency_raw = '不可用'
    else:
        base_url = provider.get('baseUrl') or provider.get('url') or provider.get('endpoint') or '-'
        models = provider.get('models') if isinstance(provider.get('models'), list) else []
        model_count = sum(1 for m in models if isinstance(m, dict) and m.get('id'))
        api = provider.get('api', '')
        api_key = provider.get('apiKey')

        latency_raw = '未检测'
        if api in SUPPORTED_APIS:
            if isinstance(base_url, str) and base_url != '-' and isinstance(api_key, str) and api_key:
                try:
                    latency_raw = ping_models(base_url, api_key)
                except Exception:
                    latency_raw = '不可用'
            else:
                latency_raw = '不可用'

    latency_text, latency_level = classify_latency(latency_raw)
    api_label = api if api in SUPPORTED_APIS else '-'
    print(
        'ROW\t' + '\t'.join([
            str(idx),
            str(name),
            str(base_url),
            str(model_count),
            str(api_label),
            str(latency_text),
            str(latency_level),
        ])
    )
PY
)
}
sync-openclaw-provider-interactive() {
  local config_file="${HOME}/.openclaw/openclaw.json"
  send_stats "OpenClaw API按Provider同步"

  if [ ! -f "$config_file" ]; then
    echo "❌ 未找到配置文件: $config_file"
    break_end
    return 1
  fi

  read -erp "请输入要同步的 API 名称(provider)，直接回车同步全部: " provider_name
  if [ -z "$provider_name" ]; then
    if sync_openclaw_api_models; then
      start_gateway
    else
      echo "❌ API 模型同步失败，已中止重启网关。请检查 provider /models 返回后重试。"
      return 1
    fi
    break_end
    return 0
  fi

  install jq curl >/dev/null 2>&1

  python3 - "$config_file" "$provider_name" <<'PY2'
import copy
import json
import sys
import time
import urllib.parse
import urllib.request

path = sys.argv[1]
target = sys.argv[2]
SUPPORTED_APIS = {'openai-completions', 'openai-responses'}

with open(path, 'r', encoding='utf-8') as f:
    obj = json.load(f)

work = copy.deepcopy(obj)
models_cfg = work.setdefault('models', {})
providers = models_cfg.get('providers', {})
if not isinstance(providers, dict) or not providers:
    print('❌ 未检测到 API providers，无法同步')
    raise SystemExit(2)

provider = providers.get(target)
if not isinstance(provider, dict):
    print(f'❌ 未找到 provider: {target}')
    raise SystemExit(2)

agents = work.setdefault('agents', {})
defaults = agents.setdefault('defaults', {})
defaults_models_raw = defaults.get('models')
if isinstance(defaults_models_raw, dict):
    defaults_models = defaults_models_raw
elif isinstance(defaults_models_raw, list):
    defaults_models = {str(x): {} for x in defaults_models_raw if isinstance(x, str)}
else:
    defaults_models = {}
defaults['models'] = defaults_models


def model_ref(provider_name, model_id):
    return f"{provider_name}/{model_id}"


def get_primary_ref(defaults_obj):
    model_obj = defaults_obj.get('model')
    if isinstance(model_obj, str):
        return model_obj
    if isinstance(model_obj, dict):
        primary = model_obj.get('primary')
        if isinstance(primary, str):
            return primary
    return None


def set_primary_ref(defaults_obj, new_ref):
    model_obj = defaults_obj.get('model')
    if isinstance(model_obj, str):
        defaults_obj['model'] = new_ref
    elif isinstance(model_obj, dict):
        model_obj['primary'] = new_ref
    else:
        defaults_obj['model'] = {'primary': new_ref}


def fetch_remote_models_with_retry(base_url, api_key, retries=3):
    last_error = None
    host = (urllib.parse.urlparse(base_url).hostname or '').lower()
    domestic_rules = [
        'model-square.app.baizhi.cloud', '.baizhi.cloud', '.aliyuncs.com', '.modelscope.cn',
        '.deepseek.com', '.moonshot.cn', '.bigmodel.cn', '.siliconflow.cn', '.stepfun.com',
        '.minimax.chat', '.baichuan-ai.com', '.ppinfra.com', '.volces.com',
        '.ark.cn-beijing.volces.com', '.qianfan.baidubce.com', '.xf-yun.com',
        '.spark-api.xf-yun.com', '.hunyuan.cloud.tencent.com', '.tencentcloudapi.com'
    ]

    def is_domestic(h):
        if not h:
            return False
        for rule in domestic_rules:
            if rule.startswith('.'):
                if h.endswith(rule):
                    return True
            elif h == rule or h.endswith('.' + rule):
                return True
        return False

    for attempt in range(1, retries + 1):
        req = urllib.request.Request(
            base_url.rstrip('/') + '/models',
            headers={
                'Authorization': f'Bearer {api_key}',
                'User-Agent': 'Mozilla/5.0',
            },
        )
        try:
            if is_domestic(host):
                opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
                resp = opener.open(req, timeout=12)
            else:
                resp = urllib.request.urlopen(req, timeout=12)
            with resp:
                payload = resp.read().decode('utf-8', 'ignore')
            return json.loads(payload), None, attempt
        except Exception as e:
            last_error = e
            if attempt < retries:
                time.sleep(1)
    return None, last_error, retries


api = provider.get('api', '')
base_url = provider.get('baseUrl')
api_key = provider.get('apiKey')
model_list = provider.get('models', [])

if not base_url or not api_key or not isinstance(model_list, list) or not model_list:
    print(f'❌ provider {target} 缺少 baseUrl/apiKey/models，无法执行同步')
    raise SystemExit(3)

if api not in SUPPORTED_APIS:
    print(f'ℹ️ provider {target} 当前 api={api}，但脚本已不再探测/纠正协议；请手动设置为 openai-completions 或 openai-responses')

protocol_msg = None

data, err, attempts = fetch_remote_models_with_retry(base_url, api_key, retries=3)
if err is not None:
    print(f'❌ {target}: /models 探测失败，已重试 {attempts} 次 ({type(err).__name__}: {err})')
    raise SystemExit(4)

if not (isinstance(data, dict) and isinstance(data.get('data'), list)):
    print(f'❌ {target}: /models 返回结构不可识别')
    raise SystemExit(4)

remote_ids = []
for item in data['data']:
    if isinstance(item, dict) and item.get('id'):
        remote_ids.append(str(item['id']))
remote_set = set(remote_ids)
if not remote_set:
    print(f'❌ {target}: 上游 /models 为空，已中止同步')
    raise SystemExit(5)

local_models = [m for m in model_list if isinstance(m, dict) and m.get('id')]
local_ids = [str(m['id']) for m in local_models]
local_set = set(local_ids)

template = copy.deepcopy(local_models[0]) if local_models else None
if template is None:
    print(f'❌ {target}: 本地 models 无有效模板模型，无法补全新增模型')
    raise SystemExit(3)

removed_ids = [mid for mid in local_ids if mid not in remote_set]
added_ids = [mid for mid in remote_ids if mid not in local_set]

kept_models = [copy.deepcopy(m) for m in local_models if str(m['id']) in remote_set]
new_models = kept_models[:]
for mid in added_ids:
    nm = copy.deepcopy(template)
    nm['id'] = mid
    if isinstance(nm.get('name'), str):
        nm['name'] = f'{target} / {mid}'
    new_models.append(nm)

if not new_models:
    print(f'❌ {target}: 同步后无可用模型，已中止写入')
    raise SystemExit(5)

expected_refs = {model_ref(target, str(m['id'])) for m in new_models if isinstance(m, dict) and m.get('id')}
local_refs = {model_ref(target, mid) for mid in local_ids}
removed_refs = local_refs - expected_refs
first_ref = model_ref(target, str(new_models[0]['id']))

changed = False
primary_ref = get_primary_ref(defaults)
if isinstance(primary_ref, str) and primary_ref in removed_refs:
    set_primary_ref(defaults, first_ref)
    changed = True
    print(f'🔁 默认模型已兜底替换: {primary_ref} -> {first_ref}')

for fk in ('modelFallback', 'imageModelFallback'):
    val = defaults.get(fk)
    if isinstance(val, str) and val in removed_refs:
        defaults[fk] = first_ref
        changed = True
        print(f'🔁 {fk} 已兜底替换: {val} -> {first_ref}')

stale_refs = [r for r in list(defaults_models.keys()) if r.startswith(target + '/') and r not in expected_refs]
for r in stale_refs:
    defaults_models.pop(r, None)
    changed = True

for r in sorted(expected_refs):
    if r not in defaults_models:
        defaults_models[r] = {}
        changed = True

if removed_ids or added_ids or len(local_models) != len(new_models):
    provider['models'] = new_models
    changed = True


if changed:
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(work, f, ensure_ascii=False, indent=2)
        f.write('\n')

print(f'✅ {target}: 新增 {len(added_ids)} 个，删除 {len(removed_ids)} 个，当前 {len(new_models)} 个')

if added_ids:
    print(f'➕ 新增模型({len(added_ids)}):')
    for mid in added_ids:
        print(f'  + {mid}')
if removed_ids:
    print(f'➖ 删除模型({len(removed_ids)}):')
    for mid in removed_ids:
        print(f'  - {mid}')

if changed:
    print('✅ 指定 provider 模型一致性同步完成并已写入配置')
else:
    print('ℹ️ 无需同步：该 provider 配置已与上游 /models 保持一致')
PY2
  local rc=$?
  case "$rc" in
    0)
      echo "✅ 同步执行完成"
      start_gateway
      ;;
    2)
      echo "❌ 同步失败：provider 不存在或未配置"
      ;;
    3)
      echo "❌ 同步失败：provider 配置不完整或类型不支持"
      ;;
    4)
      echo "❌ 同步失败：上游 /models 请求失败"
      ;;
    5)
      echo "❌ 同步失败：上游模型为空或同步后无可用模型"
      ;;
    *)
      echo "❌ 同步失败：请检查配置文件结构或日志输出"
      ;;
  esac

  break_end
}

openclaw_detect_api_protocol_by_provider() {
  # 协议探测逻辑已移除：脚本不再自动探测/判定 API 类型。
  # 保留函数以兼容菜单调用，但不做任何改写。
  echo "ℹ️ 已关闭协议探测：请手动在 ${HOME}/.openclaw/openclaw.json 中设置 provider.api 为 openai-completions 或 openai-responses"
  return 0
}

fix-openclaw-provider-protocol-interactive() {
  local config_file="${HOME}/.openclaw/openclaw.json"
  send_stats "OpenClaw API协议切换"

  if [ ! -f "$config_file" ]; then
    echo "❌ 未找到配置文件: $config_file"
    break_end
    return 1
  fi

  read -erp "请输入要切换协议的 API 名称(provider): " provider_name
  if [ -z "$provider_name" ]; then
    echo "❌ provider 名称不能为空"
    break_end
    return 1
  fi

  echo "请选择要设置的 API 类型："
  echo "1. openai-completions"
  echo "2. openai-responses"
  read -erp "请输入你的选择 (1/2): " proto_choice

  local new_api=""
  case "$proto_choice" in
    1) new_api="openai-completions" ;;
    2) new_api="openai-responses" ;;
    *)
      echo "❌ 无效选择"
      break_end
      return 1
      ;;
  esac

  install python3 >/dev/null 2>&1

  python3 - "$config_file" "$provider_name" "$new_api" <<'PY'
import copy
import json
import sys

path = sys.argv[1]
name = sys.argv[2]
new_api = sys.argv[3]

SUPPORTED_APIS = {'openai-completions', 'openai-responses'}
if new_api not in SUPPORTED_APIS:
    print('❌ 非法协议值')
    raise SystemExit(3)

with open(path, 'r', encoding='utf-8') as f:
    obj = json.load(f)

work = copy.deepcopy(obj)
providers = ((work.get('models') or {}).get('providers') or {})
if not isinstance(providers, dict) or name not in providers or not isinstance(providers.get(name), dict):
    print(f'❌ 未找到 provider: {name}')
    raise SystemExit(2)

providers[name]['api'] = new_api

with open(path, 'w', encoding='utf-8') as f:
    json.dump(work, f, ensure_ascii=False, indent=2)
    f.write('\n')

print(f'✅ 已更新 provider {name} 协议为: {new_api}')
PY
  local rc=$?
  case "$rc" in
    0)
      start_gateway
      ;;
    2)
      echo "❌ 切换失败：provider 不存在或未配置"
      ;;
    3)
      echo "❌ 切换失败：协议值非法"
      ;;
    *)
      echo "❌ 切换失败：请检查配置文件结构或日志输出"
      ;;
  esac

  break_end
}

  delete-openclaw-provider-interactive() {
    local config_file
    config_file=$(openclaw_get_config_file)
    send_stats "OpenClaw API删除入口"

    if [ ! -f "$config_file" ]; then
      echo "❌ 未找到配置文件: $config_file"
      break_end
      return 1
    fi

    read -erp "请输入要删除的 API 名称(provider): " provider_name
    if [ -z "$provider_name" ]; then
      send_stats "OpenClaw API删除取消"
      echo "❌ provider 名称不能为空"
      break_end
      return 1
    fi

    python3 - "$config_file" "$provider_name" <<'PY'
import copy
import json
import sys

path = sys.argv[1]
name = sys.argv[2]

with open(path, 'r', encoding='utf-8') as f:
    obj = json.load(f)

work = copy.deepcopy(obj)
models_cfg = work.setdefault('models', {})
providers = models_cfg.get('providers', {})
if not isinstance(providers, dict) or name not in providers:
    print(f'❌ 未找到 provider: {name}')
    raise SystemExit(2)

agents = work.setdefault('agents', {})
defaults = agents.setdefault('defaults', {})
defaults_models_raw = defaults.get('models')
if isinstance(defaults_models_raw, dict):
    defaults_models = defaults_models_raw
elif isinstance(defaults_models_raw, list):
    defaults_models = {str(x): {} for x in defaults_models_raw if isinstance(x, str)}
else:
    defaults_models = {}
defaults['models'] = defaults_models


def model_ref(provider_name, model_id):
    return f"{provider_name}/{model_id}"


def ref_provider(ref):
    if not isinstance(ref, str) or '/' not in ref:
        return None
    return ref.split('/', 1)[0]


def get_primary_ref(defaults_obj):
    model_obj = defaults_obj.get('model')
    if isinstance(model_obj, str):
        return model_obj
    if isinstance(model_obj, dict):
        primary = model_obj.get('primary')
        if isinstance(primary, str):
            return primary
    return None


def set_primary_ref(defaults_obj, new_ref):
    model_obj = defaults_obj.get('model')
    if isinstance(model_obj, str):
        defaults_obj['model'] = new_ref
    elif isinstance(model_obj, dict):
        model_obj['primary'] = new_ref
    else:
        defaults_obj['model'] = {'primary': new_ref}


def collect_available_refs(exclude_provider=None):
    refs = []
    if not isinstance(providers, dict):
        return refs
    for pname, p in providers.items():
        if exclude_provider and pname == exclude_provider:
            continue
        if not isinstance(p, dict):
            continue
        for m in p.get('models', []) or []:
            if isinstance(m, dict) and m.get('id'):
                refs.append(model_ref(pname, str(m['id'])))
    return refs


replacement_candidates = collect_available_refs(exclude_provider=name)
replacement = replacement_candidates[0] if replacement_candidates else None

primary_ref = get_primary_ref(defaults)
if ref_provider(primary_ref) == name:
    if not replacement:
        print('❌ 删除中止：默认主模型指向该 provider，且无可用替代模型')
        raise SystemExit(3)
    set_primary_ref(defaults, replacement)
    print(f'🔁 默认主模型切换: {primary_ref} -> {replacement}')

for fk in ('modelFallback', 'imageModelFallback'):
    val = defaults.get(fk)
    if ref_provider(val) == name:
        if not replacement:
            print(f'❌ 删除中止：{fk} 指向该 provider，且无可用替代模型')
            raise SystemExit(3)
        defaults[fk] = replacement
        print(f'🔁 {fk} 切换: {val} -> {replacement}')

removed_refs = [r for r in list(defaults_models.keys()) if r.startswith(name + '/')]
for r in removed_refs:
    defaults_models.pop(r, None)

providers.pop(name, None)

with open(path, 'w', encoding='utf-8') as f:
    json.dump(work, f, ensure_ascii=False, indent=2)
    f.write('\n')

print(f'🗑️ 已删除 provider: {name}')
print(f'🧹 已清理 defaults.models 中 {len(removed_refs)} 个关联模型引用')
PY
    local rc=$?
    case "$rc" in
      0)
        send_stats "OpenClaw API删除确认"
        echo "✅ 删除完成"
        start_gateway
        ;;
      2)
        echo "❌ 删除失败：provider 不存在"
        ;;
      3)
        send_stats "OpenClaw API删除取消"
        echo "❌ 删除失败：无可用替代模型，已保持原配置"
        ;;
      *)
        echo "❌ 删除失败：请检查配置文件结构或日志输出"
        ;;
    esac

    break_end
  }

  openclaw_api_providers_showcase() {
    send_stats "OpenClaw API厂商推荐"

    clear
    echo ""
    echo -e "${gl_kjlan}╔════════════════════════════════════════════════════════════╗${gl_bai}"
    echo -e "${gl_kjlan}║${gl_bai}            ${gl_huang}🌟 API 厂商推荐列表${gl_bai}                          ${gl_kjlan}║${gl_bai}"
    echo -e "${gl_kjlan}║${gl_bai}            ${gl_zi}部分入口含 AFF${gl_bai}                            ${gl_kjlan}║${gl_bai}"
    echo -e "${gl_kjlan}╚════════════════════════════════════════════════════════════╝${gl_bai}"
    echo ""
    echo -e "  ${gl_lv}● DeepSeek${gl_bai}"
    echo -e "    ${gl_kjlan}https://api-docs.deepseek.com/${gl_bai}"
    echo ""
    echo -e "  ${gl_lv}● OpenRouter${gl_bai}"
    echo -e "    ${gl_kjlan}https://openrouter.ai/${gl_bai}"
    echo ""
    echo -e "  ${gl_lv}● Kimi${gl_bai}"
    echo -e "    ${gl_kjlan}https://platform.moonshot.cn/docs/guide/start-using-kimi-api${gl_bai}"
    echo ""
    echo -e "  ${gl_lv}● 超算互联网${gl_bai}"
    echo -e "    ${gl_kjlan}https://www.scnet.cn/${gl_bai}"
    echo ""
    echo -e "  ${gl_huang}● 优云智算${gl_bai} ${gl_zi}[AFF]${gl_bai}"
    echo -e "    ${gl_kjlan}https://passport.compshare.cn/register?referral_code=4mscFZXfutfFi8swMVsPuf${gl_bai}"
    echo ""
    echo -e "  ${gl_huang}● 硅基流动${gl_bai} ${gl_zi}[AFF]${gl_bai}"
    echo -e "    ${gl_kjlan}https://cloud.siliconflow.cn/i/irWVdPic${gl_bai}"
    echo ""
    echo -e "  ${gl_huang}● 智谱 GLM${gl_bai} ${gl_zi}[AFF]${gl_bai}"
    echo -e "    ${gl_kjlan}https://www.bigmodel.cn/glm-coding?ic=HYOTDOAJMR${gl_bai}"
    echo ""
    echo -e "  ${gl_huang}● PackyAPI${gl_bai} ${gl_zi}[AFF]${gl_bai}"
    echo -e "    ${gl_kjlan}https://www.packyapi.com/register?aff=wHri${gl_bai}"
    echo ""
    echo -e "  ${gl_huang}● 云雾 API${gl_bai} ${gl_zi}[AFF]${gl_bai}"
    echo -e "    ${gl_kjlan}https://yunwu.ai/register?aff=ZuyK${gl_bai}"
    echo ""
    echo -e "  ${gl_huang}● 柏拉图AI${gl_bai} ${gl_zi}[AFF]${gl_bai}"
    echo -e "    ${gl_kjlan}https://api.bltcy.ai/register?aff=TBzb114019${gl_bai}"
    echo ""
    echo -e "  ${gl_lv}● MiniMax${gl_bai}"
    echo -e "    ${gl_kjlan}https://www.minimaxi.com/${gl_bai}"
    echo ""
    echo -e "  ${gl_lv}● NVIDIA${gl_bai}"
    echo -e "    ${gl_kjlan}https://build.nvidia.com/settings/api-keys${gl_bai}"
    echo ""
    echo -e "  ${gl_lv}● Ollama${gl_bai}"
    echo -e "    ${gl_kjlan}https://ollama.com/${gl_bai}"
    echo ""
    echo -e "  ${gl_lv}● 白山云${gl_bai}"
    echo -e "    ${gl_kjlan}https://ai.baishan.com/${gl_bai}"
    echo ""
    echo -e "${gl_kjlan}────────────────────────────────────────────────────────────${gl_bai}"
    echo -e "  ${gl_zi}图例：${gl_lv}● 官方入口${gl_bai}  ${gl_huang}● AFF 推荐入口${gl_bai}"
    echo ""
    echo -e "${gl_huang}提示：复制链接到浏览器打开即可访问${gl_bai}"
    echo ""
    read -erp "按回车键返回..." dummy
  }

  openclaw_api_manage_menu() {
    send_stats "OpenClaw API入口"
    while true; do
      clear
      skpl_ui_header "API 管理" "供应商、协议与模型同步"
      openclaw_api_manage_list
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "添加 API" "写入新的提供商配置"
      skpl_ui_menu_item 2 "同步模型列表" "刷新供应商可用模型"
      skpl_ui_menu_item 3 "切换 API 类型" "completions / responses"
      skpl_ui_menu_item 4 "删除 API" "移除现有提供商"
      skpl_ui_menu_item 5 "厂商推荐" "查看推荐入口"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -er api_choice

      case "$api_choice" in
        1)
          add-openclaw-provider-interactive
          ;;
        2)
          sync-openclaw-provider-interactive
          ;;
        3)
          fix-openclaw-provider-protocol-interactive
          ;;
        4)
          delete-openclaw-provider-interactive
          ;;
        5)
          openclaw_api_providers_showcase
          ;;
        0)
          return 0
          ;;
        *)
          echo "无效的选择，请重试。"
          sleep 1
          ;;
      esac
    done
  }



  install_gum() {
      if command -v gum >/dev/null 2>&1; then
          return 0
      fi

    if command -v apt >/dev/null 2>&1; then
          mkdir -p /etc/apt/keyrings
          curl -fsSL https://repo.charm.sh/apt/gpg.key | gpg --dearmor -o /etc/apt/keyrings/charm.gpg
          echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | tee /etc/apt/sources.list.d/charm.list > /dev/null
          apt update && apt install -y gum
      elif command -v dnf >/dev/null 2>&1 || command -v yum >/dev/null 2>&1; then
          cat > /etc/yum.repos.d/charm.repo <<'REPO'
[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key
REPO
          rpm --import https://repo.charm.sh/yum/gpg.key
          if command -v dnf >/dev/null 2>&1; then
              dnf install -y gum
          else
              yum install -y gum
          fi
      elif command -v zypper >/dev/null 2>&1; then
          zypper --non-interactive refresh
          zypper --non-interactive install gum
      fi
  }



  change_model() {
    send_stats "换模型"

    local orange="#FF8C00"

    openclaw_probe_status_line() {
      local status_text="$1"
      local status_color_ok='[32m'
      local status_color_fail='[31m'
      local status_color_reset='[0m'
      if [ "$status_text" = "可用" ]; then
        printf "%b最小检测结果：%s%b
" "$status_color_ok" "$status_text" "$status_color_reset"
      else
        printf "%b最小检测结果：%s%b
" "$status_color_fail" "$status_text" "$status_color_reset"
      fi
    }

    openclaw_model_probe() {
      local target_model="$1"
      local probe_timeout=25
      local tmp_payload tmp_response probe_result probe_status reply_preview reply_trimmed
      local oc_config provider_name base_url api_key request_model
      local first_endpoint second_endpoint
      local first_exit first_http first_latency second_exit second_http second_latency
      local first_reply second_reply

      oc_config=$(openclaw_get_config_file)
      [ ! -f "$oc_config" ] && {
        OPENCLAW_PROBE_STATUS="ERROR"
        OPENCLAW_PROBE_MESSAGE="未找到 openclaw 配置文件"
        OPENCLAW_PROBE_LATENCY="-"
        OPENCLAW_PROBE_REPLY="-"
        return 1
      }

      provider_name="${target_model%%/*}"
      request_model="${target_model#*/}"
      base_url=$(jq -r --arg provider "$provider_name" '.models.providers[$provider].baseUrl // empty' "$oc_config" 2>/dev/null)
      api_key=$(jq -r --arg provider "$provider_name" '.models.providers[$provider].apiKey // empty' "$oc_config" 2>/dev/null)
      if [ -z "$provider_name" ] || [ -z "$base_url" ] || [ -z "$api_key" ]; then
        OPENCLAW_PROBE_STATUS="ERROR"
        OPENCLAW_PROBE_MESSAGE="未读取到 provider/baseUrl/apiKey"
        OPENCLAW_PROBE_LATENCY="-"
        OPENCLAW_PROBE_REPLY="-"
        return 1
      fi

      base_url="${base_url%/}"
      first_endpoint="/responses"
      second_endpoint="/chat/completions"

      openclaw_extract_probe_reply() {
        python3 - "$1" <<'PYTHON_EOF'
import json
import sys
from pathlib import Path
path = Path(sys.argv[1])
raw = path.read_text(encoding='utf-8', errors='replace').strip()
reply = ''
if raw:
    try:
        data = json.loads(raw)
        if isinstance(data, dict):
            choices = data.get('choices') or []
            if choices and isinstance(choices[0], dict):
                message = choices[0].get('message') or {}
                if isinstance(message, dict):
                    reply = message.get('content') or ''
            if not reply:
                output = data.get('output') or []
                if isinstance(output, list):
                    texts = []
                    for item in output:
                        if not isinstance(item, dict):
                            continue
                        for content in item.get('content') or []:
                            if not isinstance(content, dict):
                                continue
                            text = content.get('text')
                            if isinstance(text, str) and text.strip():
                                texts.append(text.strip())
                        if texts:
                            break
                    if texts:
                        reply = ' '.join(texts)
            if not reply:
                for key in ('error', 'message', 'detail'):
                    value = data.get(key)
                    if isinstance(value, str) and value.strip():
                        reply = value.strip()
                        break
                    if isinstance(value, dict):
                        nested = value.get('message')
                        if isinstance(nested, str) and nested.strip():
                            reply = nested.strip()
                            break
    except Exception:
        reply = raw
reply = ' '.join(str(reply).split())
print(reply)
PYTHON_EOF
      }

      openclaw_run_probe() {
        local endpoint="$1"
        tmp_payload=$(mktemp)
        tmp_response=$(mktemp)
        if [ "$endpoint" = "/responses" ]; then
          printf '{"model":"%s","input":"hi","temperature":0,"max_output_tokens":16}' "$request_model" > "$tmp_payload"
        else
          printf '{"model":"%s","messages":[{"role":"user","content":"hi"}],"temperature":0,"max_tokens":16}' "$request_model" > "$tmp_payload"
        fi

        probe_result=$(python3 - "$base_url" "$api_key" "$tmp_payload" "$tmp_response" "$probe_timeout" "$endpoint" <<'PYTHON_EOF'
import sys
import time
import urllib.error
import urllib.request

base_url, api_key, payload_path, response_path, timeout, endpoint = sys.argv[1:7]
timeout = int(timeout)
url = base_url + endpoint
payload = open(payload_path, 'rb').read()
req = urllib.request.Request(
    url,
    data=payload,
    headers={
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {api_key}',
    },
    method='POST',
)
start = time.time()
body = b''
status = 0
exit_code = 0
try:
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        status = getattr(resp, 'status', 200)
        body = resp.read()
except urllib.error.HTTPError as e:
    status = getattr(e, 'code', 0) or 0
    body = e.read()
    exit_code = 22
except Exception as e:
    body = str(e).encode('utf-8', errors='replace')
    exit_code = 1
elapsed = int((time.time() - start) * 1000)
with open(response_path, 'wb') as f:
    f.write(body)
print(f"{exit_code}|{status}|{elapsed}")
PYTHON_EOF
)
        probe_status=$?
        reply_preview=$(openclaw_extract_probe_reply "$tmp_response")
        rm -f "$tmp_payload" "$tmp_response"
        return $probe_status
      }

      openclaw_run_probe "$first_endpoint"
      first_exit=${probe_result%%|*}
      first_http=${probe_result#*|}
      first_http=${first_http%%|*}
      first_latency=${probe_result##*|}
      first_reply="$reply_preview"

      reply_trimmed=$(printf '%s' "$first_reply" | cut -c1-120)
      [ -z "$reply_trimmed" ] && reply_trimmed="(空返回)"

      if [ "$first_exit" = "0" ] && [ "$first_http" -ge 200 ] && [ "$first_http" -lt 300 ]; then
        OPENCLAW_PROBE_STATUS="OK"
        OPENCLAW_PROBE_MESSAGE="${first_endpoint} -> HTTP ${first_http}"
        OPENCLAW_PROBE_LATENCY="${first_latency}ms"
        OPENCLAW_PROBE_REPLY="$reply_trimmed"
        return 0
      fi

      openclaw_run_probe "$second_endpoint"
      second_exit=${probe_result%%|*}
      second_http=${probe_result#*|}
      second_http=${second_http%%|*}
      second_latency=${probe_result##*|}
      second_reply="$reply_preview"

      reply_trimmed=$(printf '%s' "$second_reply" | cut -c1-120)
      [ -z "$reply_trimmed" ] && reply_trimmed="(空返回)"

      if [ "$second_exit" = "0" ] && [ "$second_http" -ge 200 ] && [ "$second_http" -lt 300 ]; then
        OPENCLAW_PROBE_STATUS="OK"
        OPENCLAW_PROBE_MESSAGE="${first_endpoint} -> HTTP ${first_http:-0}，切换 ${second_endpoint} -> HTTP ${second_http}"
        OPENCLAW_PROBE_LATENCY="${second_latency}ms"
        OPENCLAW_PROBE_REPLY="$reply_trimmed"
        return 0
      fi

      reply_trimmed=$(printf '%s' "$first_reply" | cut -c1-120)
      [ -z "$reply_trimmed" ] && reply_trimmed=$(printf '%s' "$second_reply" | cut -c1-120)
      [ -z "$reply_trimmed" ] && reply_trimmed="(空返回)"

      OPENCLAW_PROBE_STATUS="FAIL"
      OPENCLAW_PROBE_MESSAGE="${first_endpoint} -> HTTP ${first_http:-0} / exit ${first_exit:-1}；${second_endpoint} -> HTTP ${second_http:-0} / exit ${second_exit:-1}"
      OPENCLAW_PROBE_LATENCY="${first_latency:-?}ms -> ${second_latency:-?}ms"
      OPENCLAW_PROBE_REPLY="$reply_trimmed"
      return 1
    }

    clear

    while true; do
      local models_raw models_list default_model model_count selected_model confirm_switch

      # 从配置文件读取模型键（不调用 openclaw models list）
      local oc_config
      oc_config=$(openclaw_get_config_file)

      models_raw=$(jq -r '.agents.defaults.models | if type == "object" then keys[] else .[] end' "$oc_config" 2>/dev/null | sed '/^\s*$/d')
      if [ -z "$models_raw" ]; then
        echo "获取模型列表失败：配置文件中未找到 agents.defaults.models。"
        break_end
        return 1
      fi

      # 为每个模型加编号，便于快速定位（例如："(10) or-api/...:free"）
      models_list=$(echo "$models_raw" | awk '{print "(" NR ") " $0}')
      model_count=$(echo "$models_list" | sed '/^\s*$/d' | wc -l | tr -d ' ')

      # 从配置文件读取默认模型（更快）；失败再回退到 openclaw 命令
      default_model=$(jq -r '.agents.defaults.model.primary // empty' "$oc_config" 2>/dev/null)
      [ -z "$default_model" ] && default_model="(unknown)"

      clear

      install_gum
      install gum

      # 若 gum 不存在，降级为原始手动输入流程
      if ! command -v gum >/dev/null 2>&1 || ! gum --version >/dev/null 2>&1; then
        echo "--- 模型管理 ---"
        echo "当前可用模型:"
        jq -r '.agents.defaults.models | if type == "object" then keys[] else .[] end' "$oc_config" 2>/dev/null | sed '/^\s*$/d'
        echo "----------------"
        read -e -p "请输入要设置的模型名称 (例如 openrouter/openai/gpt-4o)（输入 0 退出）： " selected_model

        if [ "$selected_model" = "0" ]; then
          echo "操作已取消，正在退出..."
          break
        fi

        if [ -z "$selected_model" ]; then
          echo "错误：模型名称不能为空。请重试。"
          echo ""
          continue
        fi

        echo "正在切换模型为: $selected_model ..."
        if ! openclaw models set "$selected_model"; then
          echo "切换失败：openclaw models set 返回错误。"
          break_end
          return 1
        fi
        openclaw_sync_sessions_model "$selected_model"
        start_gateway

        break_end
        return 0
      else
        if ! command -v gum >/dev/null 2>&1 || ! gum --version >/dev/null 2>&1; then
          echo "gum 不可用，返回旧版输入模式。"
          sleep 1
          continue
        fi
        gum style --foreground "$orange" --bold "模型管理"
        gum style --foreground "$orange" "可用模型（Auth=yes）：${model_count}"
        gum style --foreground "$orange" "当前默认：${default_model}"
        echo ""
        gum style --faint "↑↓ 选择 / Enter 测试 / Esc 退出"
        echo ""

        selected_model=$(echo "$models_list" | gum filter           --placeholder "搜索模型（如 cli-api/gpt-5.2）"           --prompt "选择模型 > "          --indicator "➜ "          --prompt.foreground "$orange"           --indicator.foreground "$orange"          --cursor-text.foreground "$orange"          --match.foreground "$orange"          --header ""           --height 35)

        if [ -z "$selected_model" ] || echo "$selected_model" | head -n 1 | grep -iqE '^(error|usage|gum:)'; then
          echo "操作已取消，正在退出..."
          break
        fi
      fi

      selected_model=$(echo "$selected_model" | sed -E 's/^\([0-9]+\)[[:space:]]+//')

      echo ""
      echo "正在检测模型: $selected_model"
      if openclaw_model_probe "$selected_model"; then
        openclaw_probe_status_line "可用"
      else
        openclaw_probe_status_line "不可用"
      fi
      echo "状态：$OPENCLAW_PROBE_MESSAGE"
      echo "延迟：$OPENCLAW_PROBE_LATENCY"
      echo "摘要：$OPENCLAW_PROBE_REPLY"
      echo ""

      printf "是否切换到该模型？[y/N，Esc 返回列表]: "
      IFS= read -rsn1 confirm_switch
      echo ""
      if [ "$confirm_switch" = $'' ]; then
        confirm_switch="no"
      else
        case "$confirm_switch" in
          [yY])
            IFS= read -rsn1 -t 5 _enter_key
            confirm_switch="yes"
            ;;
          [nN]|"") confirm_switch="no" ;;
          *) confirm_switch="no" ;;
        esac
      fi

      if [ "$confirm_switch" != "yes" ]; then
        echo "已返回模型选择列表。"
        sleep 1
        continue
      fi

      echo "正在切换模型为: $selected_model ..."
      if ! openclaw models set "$selected_model"; then
        echo "切换失败：openclaw models set 返回错误。"
        break_end
        return 1
      fi
      openclaw_sync_sessions_model "$selected_model"
      start_gateway

      break_end
      done
    }


    openclaw_get_config_file() {
      local user_config="${HOME}/.openclaw/openclaw.json"
      local root_config="/root/.openclaw/openclaw.json"
      if [ -f "$user_config" ]; then
        echo "$user_config"
      elif [ "$HOME" = "/root" ] && [ -f "$root_config" ]; then
        echo "$root_config"
      else
        echo "$user_config"
      fi
    }

    openclaw_get_agents_dir() {
      local user_agents="${HOME}/.openclaw/agents"
      local root_agents="/root/.openclaw/agents"
      if [ -d "$user_agents" ]; then
        echo "$user_agents"
      elif [ "$HOME" = "/root" ] && [ -d "$root_agents" ]; then
        echo "$root_agents"
      else
        echo "$user_agents"
      fi
    }

    openclaw_sync_sessions_model() {
      local model_ref="$1"
      [ -z "$model_ref" ] && return 1

      local agents_dir
      agents_dir=$(openclaw_get_agents_dir)
      [ ! -d "$agents_dir" ] && return 0

      local provider="${model_ref%%/*}"
      local model="${model_ref#*/}"
      [ "$provider" = "$model_ref" ] && { provider=""; model="$model_ref"; }

      local count=0
      local agent_dir sessions_file backup_file

      for agent_dir in "$agents_dir"/*/; do
        [ ! -d "$agent_dir" ] && continue
        sessions_file="$agent_dir/sessions/sessions.json"
        [ ! -f "$sessions_file" ] && continue

        backup_file="${sessions_file}.bak"
        cp "$sessions_file" "$backup_file" 2>/dev/null || continue

        if command -v jq >/dev/null 2>&1; then
          local tmp_json
          tmp_json=$(mktemp)
          if [ -n "$provider" ]; then
            jq --arg model "$model" --arg provider "$provider" \
              'to_entries | map(.value.modelOverride = $model | .value.providerOverride = $provider) | from_entries' \
              "$sessions_file" > "$tmp_json" 2>/dev/null && \
              mv "$tmp_json" "$sessions_file" && \
              count=$((count + 1))
          else
            jq --arg model "$model" \
              'to_entries | map(.value.modelOverride = $model | del(.value.providerOverride)) | from_entries' \
              "$sessions_file" > "$tmp_json" 2>/dev/null && \
              mv "$tmp_json" "$sessions_file" && \
              count=$((count + 1))
          fi
        fi
      done

      [ "$count" -gt 0 ] && echo "✅ 已同步 $count 个 agent 的会话模型为 $model_ref"
      return 0
    }

    resolve_openclaw_plugin_id() {
      local raw_input="$1"
      local plugin_id="$raw_input"

      plugin_id="${plugin_id#@openclaw/}"
      if [[ "$plugin_id" == @*/* ]]; then
        plugin_id="${plugin_id##*/}"
      fi
      plugin_id="${plugin_id%%@*}"
      echo "$plugin_id"
    }

    sync_openclaw_plugin_allowlist() {
      local plugin_id="$1"
      [ -z "$plugin_id" ] && return 1

      local config_file
      config_file=$(openclaw_get_config_file)

      mkdir -p "$(dirname "$config_file")"
      if [ ! -s "$config_file" ]; then
        echo '{}' > "$config_file"
      fi

      if command -v jq >/dev/null 2>&1; then
        local tmp_json
        tmp_json=$(mktemp)
        if jq --arg pid "$plugin_id" '
          .plugins = (if (.plugins | type) == "object" then .plugins else {} end)
          | .plugins.allow = (if (.plugins.allow | type) == "array" then .plugins.allow else [] end)
          | if (.plugins.allow | index($pid)) == null then .plugins.allow += [$pid] else . end
        ' "$config_file" > "$tmp_json" 2>/dev/null && mv "$tmp_json" "$config_file"; then
          echo "✅ 已同步 plugins.allow 白名单: $plugin_id"
          return 0
        fi
        rm -f "$tmp_json"
      fi

      if command -v python3 >/dev/null 2>&1; then
        if python3 - "$config_file" "$plugin_id" <<'PYTHON_EOF'
import json
import sys
from pathlib import Path

config_file = Path(sys.argv[1])
plugin_id = sys.argv[2]

try:
    data = json.loads(config_file.read_text(encoding='utf-8')) if config_file.exists() else {}
    if not isinstance(data, dict):
        data = {}
except Exception:
    data = {}

plugins = data.get('plugins')
if not isinstance(plugins, dict):
    plugins = {}

a = plugins.get('allow')
if not isinstance(a, list):
    a = []

if plugin_id not in a:
    a.append(plugin_id)

plugins['allow'] = a
data['plugins'] = plugins
config_file.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding='utf-8')
PYTHON_EOF
        then
          echo "✅ 已同步 plugins.allow 白名单: $plugin_id"
          return 0
        fi
      fi

      echo "⚠️ 已安装插件，但同步 plugins.allow 失败，请手动检查: $config_file"
      return 1
    }

    sync_openclaw_plugin_denylist() {
      local plugin_id="$1"
      [ -z "$plugin_id" ] && return 1

      local config_file
      config_file=$(openclaw_get_config_file)

      mkdir -p "$(dirname "$config_file")"
      if [ ! -s "$config_file" ]; then
        echo '{}' > "$config_file"
      fi

      if command -v jq >/dev/null 2>&1; then
        local tmp_json
        tmp_json=$(mktemp)
        if jq --arg pid "$plugin_id" '
          .plugins = (if (.plugins | type) == "object" then .plugins else {} end)
          | .plugins.allow = (if (.plugins.allow | type) == "array" then .plugins.allow else [] end)
          | .plugins.allow = (.plugins.allow | map(select(. != $pid)))
        ' "$config_file" > "$tmp_json" 2>/dev/null && mv "$tmp_json" "$config_file"; then
          echo "✅ 已从 plugins.allow 移除: $plugin_id"
          return 0
        fi
        rm -f "$tmp_json"
      fi

      if command -v python3 >/dev/null 2>&1; then
        if python3 - "$config_file" "$plugin_id" <<'PYTHON_EOF'
import json
import sys
from pathlib import Path

config_file = Path(sys.argv[1])
plugin_id = sys.argv[2]

try:
    data = json.loads(config_file.read_text(encoding='utf-8')) if config_file.exists() else {}
    if not isinstance(data, dict):
        data = {}
except Exception:
    data = {}

plugins = data.get('plugins')
if not isinstance(plugins, dict):
    plugins = {}

a = plugins.get('allow')
if not isinstance(a, list):
    a = []

a = [x for x in a if x != plugin_id]
plugins['allow'] = a
data['plugins'] = plugins
config_file.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding='utf-8')
PYTHON_EOF
        then
          echo "✅ 已从 plugins.allow 移除: $plugin_id"
          return 0
        fi
      fi

      echo "⚠️ plugins.allow 移除失败，请手动检查: $config_file"
      return 1
    }






    install_plugin() {
    send_stats "插件管理"
    while true; do
      clear
      skpl_ui_header "插件管理" "安装、启用、删除与常用插件参考"
      skpl_ui_section "当前插件列表"
      openclaw plugins list
      echo
      skpl_ui_section "推荐插件"
      echo "直接复制括号内的 ID 即可："
      echo "📱 通讯渠道:"
      echo "  - [feishu]        # 飞书/Lark 集成"
      echo "  - [telegram]      # Telegram 机器人"
      echo "  - [slack]         # Slack 企业通讯"
      echo "  - [msteams]       # Microsoft Teams"
      echo "  - [discord]       # Discord 社区管理"
      echo "  - [whatsapp]      # WhatsApp 自动化"
      echo ""
      echo "🧠 记忆与 AI:"
      echo "  - [memory-core]   # 基础记忆 (文件检索)"
      echo "  - [memory-lancedb]  # 增强记忆 (向量数据库)"
      echo "  - [copilot-proxy] # Copilot 接口转发"
      echo ""
      echo "⚙️ 功能扩展:"
      echo "  - [lobster]       # 审批流 (带人工确认)"
      echo "  - [voice-call]    # 语音通话能力"
      echo "  - [nostr]         # 加密隐私聊天"
      echo

      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "安装或启用插件" "支持一次输入多个插件 ID"
      skpl_ui_menu_item 2 "删除或禁用插件" "移除现有插件"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请选择操作: "
      read -e plugin_action

      [ "$plugin_action" = "0" ] && break
      [ -z "$plugin_action" ] && continue

      read -e -p "请输入插件 ID（空格分隔，输入 0 退出）： " raw_input
      [ "$raw_input" = "0" ] && break
      [ -z "$raw_input" ] && continue

      local success_list=""
      local failed_list=""
      local skipped_list=""
      local changed=false
      local token

      for token in $raw_input; do
        local plugin_id
        local plugin_full
        plugin_id=$(resolve_openclaw_plugin_id "$token")
        plugin_full="$token"
        [ -z "$plugin_id" ] && continue

        if [ "$plugin_action" = "1" ]; then
          echo "🔍 正在检查插件状态: $plugin_id"
          local plugin_list
          plugin_list=$(openclaw plugins list 2>/dev/null)

          if echo "$plugin_list" | grep -qw "$plugin_id" && echo "$plugin_list" | grep "$plugin_id" | grep -q "disabled"; then
            echo "💡 插件 [$plugin_id] 已预装，正在激活..."
            if openclaw plugins enable "$plugin_id"; then
              sync_openclaw_plugin_allowlist "$plugin_id"
              success_list="$success_list $plugin_id"
              changed=true
            else
              failed_list="$failed_list $plugin_id"
            fi
            continue
          fi

          if [ -d "/usr/lib/node_modules/openclaw/extensions/$plugin_id" ]; then
            echo "💡 发现系统内置目录存在该插件，尝试直接启用..."
            if openclaw plugins enable "$plugin_id"; then
              sync_openclaw_plugin_allowlist "$plugin_id"
              success_list="$success_list $plugin_id"
              changed=true
            else
              failed_list="$failed_list $plugin_id"
            fi
            continue
          fi

          echo "📥 本地未发现，尝试下载安装: $plugin_full"
          rm -rf "${HOME}/.openclaw/extensions/$plugin_id"
          [ "$HOME" != "/root" ] && rm -rf "/root/.openclaw/extensions/$plugin_id"
          if openclaw plugins install "$plugin_full"; then
            echo "✅ 下载成功，正在启用..."
            if openclaw plugins enable "$plugin_id"; then
              sync_openclaw_plugin_allowlist "$plugin_id"
              success_list="$success_list $plugin_id"
              changed=true
            else
              failed_list="$failed_list $plugin_id"
            fi
          else
            echo "❌ 安装失败：$plugin_full"
            failed_list="$failed_list $plugin_id"
          fi
        else
          echo "🗑️ 正在删除/禁用插件: $plugin_id"
          openclaw plugins disable "$plugin_id" >/dev/null 2>&1
          if openclaw plugins uninstall "$plugin_id"; then
            echo "✅ 已卸载: $plugin_id"
          else
            echo "⚠️ 卸载失败，可能为预装插件，仅禁用: $plugin_id"
          fi
          sync_openclaw_plugin_denylist "$plugin_id" >/dev/null 2>&1
          success_list="$success_list $plugin_id"
          changed=true
        fi
      done

      echo ""
      echo "====== 操作汇总 ======"
      echo "✅ 成功:$success_list"
      [ -n "$failed_list" ] && echo "❌ 失败:$failed_list"
      [ -n "$skipped_list" ] && echo "⏭️ 跳过:$skipped_list"

      if [ "$changed" = true ]; then
        echo "🔄 正在重启 OpenClaw 服务以加载变更..."
        start_gateway
      fi
      break_end
    done
  }


  install_skill() {
    send_stats "技能管理"
    while true; do
      clear
      skpl_ui_header "技能管理" "安装、删除与查看推荐技能"
      skpl_ui_section "当前已安装技能"
      openclaw skills list
      echo

      # 输出推荐的实用技能列表
      skpl_ui_section "推荐技能"
      echo "可直接复制名称输入："
      echo "github             # 管理 GitHub Issues/PR/CI (gh CLI)"
      echo "notion             # 操作 Notion 页面、数据库和块"
      echo "apple-notes        # macOS 原生笔记管理 (创建/编辑/搜索)"
      echo "apple-reminders    # macOS 提醒事项管理 (待办清单)"
      echo "1password          # 自动化读取和注入 1Password 密钥"
      echo "gog                # Google Workspace (Gmail/云盘/文档) 全能助手"
      echo "things-mac         # 深度整合 Things 3 任务管理"
      echo "bluebubbles        # 通过 BlueBubbles 完美收发 iMessage"
      echo "himalaya           # 终端邮件管理 (IMAP/SMTP 强力工具)"
      echo "summarize          # 网页/播客/YouTube 视频内容一键总结"
      echo "openhue            # 控制 Philips Hue 智能灯光场景"
      echo "video-frames       # 视频抽帧与短片剪辑 (ffmpeg 驱动)"
      echo "openai-whisper     # 本地音频转文字 (离线隐私保护)"
      echo "coding-agent       # 自动运行 Claude Code/Codex 等编程助手"
      echo

      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "安装技能" "输入一个或多个技能名"
      skpl_ui_menu_item 2 "删除技能" "仅影响用户目录下的技能"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请选择操作: "
      read -e skill_action

      [ "$skill_action" = "0" ] && break
      [ -z "$skill_action" ] && continue

      read -e -p "请输入技能名称（空格分隔，输入 0 退出）： " skill_input
      [ "$skill_input" = "0" ] && break
      [ -z "$skill_input" ] && continue

      local success_list=""
      local failed_list=""
      local skipped_list=""
      local changed=false
      local token

      if [ "$skill_action" = "2" ]; then
        read -e -p "二次确认：删除仅影响用户目录 ~/.openclaw/workspace/skills，确认继续？(y/N): " confirm_del
        if [[ ! "$confirm_del" =~ ^[Yy]$ ]]; then
          echo "已取消删除。"
          break_end
          continue
        fi
      fi

      for token in $skill_input; do
        local skill_name
        skill_name="$token"
        [ -z "$skill_name" ] && continue

        if [ "$skill_action" = "1" ]; then
          local skill_found=false
          if [ -d "${HOME}/.openclaw/workspace/skills/${skill_name}" ]; then
            echo "💡 技能 [$skill_name] 已在用户目录安装。"
            skill_found=true
          elif [ -d "/usr/lib/node_modules/openclaw/skills/${skill_name}" ]; then
            echo "💡 技能 [$skill_name] 已在系统目录安装。"
            skill_found=true
          fi

          if [ "$skill_found" = true ]; then
            read -e -p "技能 [$skill_name] 已安装，是否重新安装？(y/N): " reinstall
            if [[ ! "$reinstall" =~ ^[Yy]$ ]]; then
              skipped_list="$skipped_list $skill_name"
              continue
            fi
          fi

          echo "正在安装技能：$skill_name ..."
          if npx clawhub install "$skill_name" --yes --no-input 2>/dev/null || npx clawhub install "$skill_name"; then
            echo "✅ 技能 $skill_name 安装成功。"
            success_list="$success_list $skill_name"
            changed=true
          else
            echo "❌ 安装失败：$skill_name"
            failed_list="$failed_list $skill_name"
          fi
        else
          echo "🗑️ 正在删除技能: $skill_name"
          npx clawhub uninstall "$skill_name" --yes --no-input 2>/dev/null || npx clawhub uninstall "$skill_name" >/dev/null 2>&1
          if [ -d "${HOME}/.openclaw/workspace/skills/${skill_name}" ]; then
            rm -rf "${HOME}/.openclaw/workspace/skills/${skill_name}"
            echo "✅ 已删除用户技能目录: $skill_name"
            success_list="$success_list $skill_name"
            changed=true
          else
            echo "⏭️ 未发现用户技能目录: $skill_name"
            skipped_list="$skipped_list $skill_name"
          fi
        fi
      done

      echo ""
      echo "====== 操作汇总 ======"
      echo "✅ 成功:$success_list"
      [ -n "$failed_list" ] && echo "❌ 失败:$failed_list"
      [ -n "$skipped_list" ] && echo "⏭️ 跳过:$skipped_list"

      if [ "$changed" = true ]; then
        echo "🔄 正在重启 OpenClaw 服务以加载变更..."
        start_gateway
      fi
      break_end
    done
  }

openclaw_json_get_bool() {
    local expr="$1"
    local config_file
    config_file=$(openclaw_get_config_file)
    if [ ! -s "$config_file" ]; then
      echo "false"
      return
    fi
    jq -r "$expr" "$config_file" 2>/dev/null || echo "false"
  }

  openclaw_channel_has_cfg() {
    local channel="$1"
    local config_file
    config_file=$(openclaw_get_config_file)
    if [ ! -s "$config_file" ]; then
      echo "false"
      return
    fi
    jq -r --arg c "$channel" '
      (.channels[$c] // null) as $v
      | if ($v | type) != "object" then
        false
        else
        ([ $v
           | to_entries[]
           | select((.key == "enabled" or .key == "dmPolicy" or .key == "groupPolicy" or .key == "streaming") | not)
           | .value
           | select(. != null and . != "" and . != false)
         ] | length) > 0
        end
    ' "$config_file" 2>/dev/null || echo "false"
  }

  openclaw_dir_has_files() {
    local dir="$1"
    [ -d "$dir" ] && find "$dir" -type f -print -quit 2>/dev/null | grep -q .
  }

  openclaw_plugin_local_installed() {
    local plugin="$1"
    local config_file
    config_file=$(openclaw_get_config_file)
    if [ -s "$config_file" ] && jq -e --arg p "$plugin" '.plugins.installs[$p]' "$config_file" >/dev/null 2>&1; then
      return 0
    fi

    # 兼容两种常见目录命名：
    # - ~/.openclaw/extensions/qqbot
    # - ~/.openclaw/extensions/openclaw-qqbot
    # 避免无脑 substring，优先精确匹配与 openclaw- 前缀匹配。
    [ -d "${HOME}/.openclaw/extensions/${plugin}" ] \
      || [ -d "${HOME}/.openclaw/extensions/openclaw-${plugin}" ] \
      || [ -d "/usr/lib/node_modules/openclaw/extensions/${plugin}" ] \
      || [ -d "/usr/lib/node_modules/openclaw/extensions/openclaw-${plugin}" ]
  }

  openclaw_bot_status_text() {
    local enabled="$1"
    local configured="$2"
    local connected="$3"
    local abnormal="$4"
    if [ "$abnormal" = "true" ]; then
      echo "异常"
    elif [ "$enabled" != "true" ]; then
      echo "未启用"
    elif [ "$connected" = "true" ]; then
      echo "已连接"
    elif [ "$configured" = "true" ]; then
      echo "已配置"
    else
      echo "未配置"
    fi
  }

  openclaw_colorize_bot_status() {
    local status="$1"
    case "$status" in
      已连接) echo -e "${gl_lv}${status}${gl_bai}" ;;
      已配置) echo -e "${gl_huang}${status}${gl_bai}" ;;
      异常) echo -e "${gl_hong}${status}${gl_bai}" ;;
      *) echo "$status" ;;
    esac
  }

  openclaw_print_bot_status_line() {
    local label="$1"
    local status="$2"
    echo -e "- ${label}: $(openclaw_colorize_bot_status "$status")"
  }

  openclaw_show_bot_local_status_block() {
    local config_file
    config_file=$(openclaw_get_config_file)
    local json_ok="false"
    if [ -s "$config_file" ] && jq empty "$config_file" >/dev/null 2>&1; then
      json_ok="true"
    fi

    local tg_enabled tg_cfg tg_connected tg_abnormal tg_status
    tg_enabled=$(openclaw_json_get_bool '.channels.telegram.enabled // .plugins.entries.telegram.enabled // false')
    tg_cfg=$(openclaw_channel_has_cfg "telegram")
    tg_connected="false"
    if openclaw_dir_has_files "${HOME}/.openclaw/telegram"; then
      tg_connected="true"
    fi
    tg_abnormal="false"
    if [ "$tg_enabled" = "true" ] && [ "$json_ok" != "true" ]; then
      tg_abnormal="true"
    fi
    tg_status=$(openclaw_bot_status_text "$tg_enabled" "$tg_cfg" "$tg_connected" "$tg_abnormal")

    local feishu_enabled feishu_cfg feishu_connected feishu_abnormal feishu_status
    feishu_enabled=$(openclaw_json_get_bool '.plugins.entries.feishu.enabled // .plugins.entries["openclaw-lark"].enabled // .channels.feishu.enabled // .channels.lark.enabled // false')
    feishu_cfg=$(openclaw_channel_has_cfg "feishu")
    if [ "$feishu_cfg" != "true" ]; then
      feishu_cfg=$(openclaw_channel_has_cfg "lark")
    fi
    feishu_connected="false"
    if openclaw_dir_has_files "${HOME}/.openclaw/feishu" || openclaw_dir_has_files "${HOME}/.openclaw/lark" || openclaw_dir_has_files "${HOME}/.openclaw/openclaw-lark"; then
      feishu_connected="true"
    fi
    feishu_abnormal="false"
    if [ "$feishu_enabled" = "true" ] && ! openclaw_plugin_local_installed "feishu" && ! openclaw_plugin_local_installed "lark" && ! openclaw_plugin_local_installed "openclaw-lark"; then
      feishu_abnormal="true"
    fi
    if [ "$feishu_enabled" = "true" ] && [ "$json_ok" != "true" ]; then
      feishu_abnormal="true"
    fi
    if [ "$feishu_connected" != "true" ] && [ "$feishu_enabled" = "true" ] && [ "$feishu_cfg" = "true" ] && { openclaw_plugin_local_installed "feishu" || openclaw_plugin_local_installed "lark" || openclaw_plugin_local_installed "openclaw-lark"; }; then
      feishu_connected="true"
    fi
    feishu_status=$(openclaw_bot_status_text "$feishu_enabled" "$feishu_cfg" "$feishu_connected" "$feishu_abnormal")

    local wa_enabled wa_cfg wa_connected wa_abnormal wa_status
    wa_enabled=$(openclaw_json_get_bool '.plugins.entries.whatsapp.enabled // .channels.whatsapp.enabled // false')
    wa_cfg=$(openclaw_channel_has_cfg "whatsapp")
    wa_connected="false"
    if openclaw_dir_has_files "${HOME}/.openclaw/whatsapp"; then
      wa_connected="true"
    fi
    wa_abnormal="false"
    if [ "$wa_enabled" = "true" ] && ! openclaw_plugin_local_installed "whatsapp" && ! openclaw_plugin_local_installed "openclaw-whatsapp"; then
      wa_abnormal="true"
    fi
    if [ "$wa_enabled" = "true" ] && [ "$json_ok" != "true" ]; then
      wa_abnormal="true"
    fi
    if [ "$wa_connected" != "true" ] && [ "$wa_enabled" = "true" ] && [ "$wa_cfg" = "true" ] && { openclaw_plugin_local_installed "whatsapp" || openclaw_plugin_local_installed "openclaw-whatsapp"; }; then
      wa_connected="true"
    fi
    wa_status=$(openclaw_bot_status_text "$wa_enabled" "$wa_cfg" "$wa_connected" "$wa_abnormal")

    local dc_enabled dc_cfg dc_connected dc_abnormal dc_status
    dc_enabled=$(openclaw_json_get_bool '.channels.discord.enabled // .plugins.entries.discord.enabled // false')
    dc_cfg=$(openclaw_channel_has_cfg "discord")
    dc_connected="false"
    if openclaw_dir_has_files "${HOME}/.openclaw/discord"; then
      dc_connected="true"
    fi
    dc_abnormal="false"
    if [ "$dc_enabled" = "true" ] && [ "$json_ok" != "true" ]; then
      dc_abnormal="true"
    fi
    dc_status=$(openclaw_bot_status_text "$dc_enabled" "$dc_cfg" "$dc_connected" "$dc_abnormal")

    local slack_enabled slack_cfg slack_connected slack_abnormal slack_status
    slack_enabled=$(openclaw_json_get_bool '.plugins.entries.slack.enabled // .channels.slack.enabled // false')
    slack_cfg=$(openclaw_channel_has_cfg "slack")
    slack_connected="false"
    if openclaw_dir_has_files "${HOME}/.openclaw/slack"; then
      slack_connected="true"
    fi
    slack_abnormal="false"
    if [ "$slack_enabled" = "true" ] && ! openclaw_plugin_local_installed "slack"; then
      slack_abnormal="true"
    fi
    if [ "$slack_enabled" = "true" ] && [ "$json_ok" != "true" ]; then
      slack_abnormal="true"
    fi
    slack_status=$(openclaw_bot_status_text "$slack_enabled" "$slack_cfg" "$slack_connected" "$slack_abnormal")

    local qq_enabled qq_cfg qq_connected qq_abnormal qq_status
    qq_enabled=$(openclaw_json_get_bool '.plugins.entries.qqbot.enabled // .channels.qqbot.enabled // false')
    qq_cfg=$(openclaw_channel_has_cfg "qqbot")
    qq_connected="false"
    if openclaw_dir_has_files "${HOME}/.openclaw/qqbot/sessions" || openclaw_dir_has_files "${HOME}/.openclaw/qqbot/data"; then
      qq_connected="true"
    fi
    qq_abnormal="false"
    if [ "$qq_enabled" = "true" ] && ! openclaw_plugin_local_installed "qqbot"; then
      qq_abnormal="true"
    fi
    if [ "$qq_enabled" = "true" ] && [ "$json_ok" != "true" ]; then
      qq_abnormal="true"
    fi
    qq_status=$(openclaw_bot_status_text "$qq_enabled" "$qq_cfg" "$qq_connected" "$qq_abnormal")

    local wx_enabled wx_cfg wx_connected wx_abnormal wx_status
    wx_enabled=$(openclaw_json_get_bool '.plugins.entries.weixin.enabled // .plugins.entries["openclaw-weixin"].enabled // .channels.weixin.enabled // .channels["openclaw-weixin"].enabled // false')
    wx_cfg=$(openclaw_channel_has_cfg "weixin")
    if [ "$wx_cfg" != "true" ]; then
      wx_cfg=$(openclaw_channel_has_cfg "openclaw-weixin")
    fi
    wx_connected="false"
    if openclaw_dir_has_files "${HOME}/.openclaw/weixin" || openclaw_dir_has_files "${HOME}/.openclaw/openclaw-weixin"; then
      wx_connected="true"
    fi
    wx_abnormal="false"
    if [ "$wx_enabled" = "true" ] && ! openclaw_plugin_local_installed "weixin" && ! openclaw_plugin_local_installed "openclaw-weixin"; then
      wx_abnormal="true"
    fi
    if [ "$wx_enabled" = "true" ] && [ "$json_ok" != "true" ]; then
      wx_abnormal="true"
    fi
    wx_status=$(openclaw_bot_status_text "$wx_enabled" "$wx_cfg" "$wx_connected" "$wx_abnormal")

    echo "本地状态（仅本机配置/缓存，不做网络探测）："
    openclaw_print_bot_status_line "Telegram" "$tg_status"
    openclaw_print_bot_status_line "飞书(Lark)" "$feishu_status"
    openclaw_print_bot_status_line "WhatsApp" "$wa_status"
    openclaw_print_bot_status_line "Discord" "$dc_status"
    openclaw_print_bot_status_line "Slack" "$slack_status"
    openclaw_print_bot_status_line "QQ Bot" "$qq_status"
    openclaw_print_bot_status_line "微信 (Weixin)" "$wx_status"
  }

  change_tg_bot_code() {
    send_stats "机器人对接"
    while true; do
      clear
      skpl_ui_header "机器人连接对接" "批准连接码或安装对应渠道接入"
      openclaw_show_bot_local_status_block
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "Telegram 对接" "批准 Telegram 连接码"
      skpl_ui_menu_item 2 "飞书对接" "安装 Lark 集成"
      skpl_ui_menu_item 3 "WhatsApp 对接" "批准 WhatsApp 连接码"
      skpl_ui_menu_item 4 "QQ 对接" "查看官方接入地址"
      skpl_ui_menu_item 5 "微信对接" "安装 Weixin CLI"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e bot_choice

      case $bot_choice in
        1)
          read -e -p "请输入TG机器人收到的连接码 (例如 NYA99R2F)（输入 0 退出）： " code
          if [ "$code" = "0" ]; then continue; fi
          if [ -z "$code" ]; then echo "错误：连接码不能为空。"; sleep 1; continue; fi
          openclaw pairing approve telegram "$code"
          break_end
          ;;
        2)
          npx -y @larksuite/openclaw-lark install
          openclaw config set channels.feishu.streaming true
          openclaw config set channels.feishu.requireMention true --json
          break_end
          ;;
        3)
          read -e -p "请输入WhatsApp收到的连接码 (例如 NYA99R2F)（输入 0 退出）： " code
          if [ "$code" = "0" ]; then continue; fi
          if [ -z "$code" ]; then echo "错误：连接码不能为空。"; sleep 1; continue; fi
          openclaw pairing approve whatsapp "$code"
          break_end
          ;;
        4)
          echo "QQ 官方对接地址："
          echo "https://q.qq.com/qqbot/openclaw/login.html"
          break_end
          ;;
        5)
          npx -y @tencent-weixin/openclaw-weixin-cli@latest install
          break_end
          ;;
        0)
          return 0
          ;;
        *)
          echo "无效的选择，请重试。"
          sleep 1
          ;;
      esac
    done
  }


  openclaw_backup_root() {
    echo "${HOME}/.openclaw/backups"
  }

  openclaw_is_interactive_terminal() {
    [ -t 0 ] && [ -t 1 ]
  }

  openclaw_has_command() {
    command -v "$1" >/dev/null 2>&1
  }


  openclaw_is_safe_relpath() {
    local rel="$1"
    [ -z "$rel" ] && return 1
    [[ "$rel" = /* ]] && return 1
    [[ "$rel" == *"//"* ]] && return 1
    [[ "$rel" == *$'\n'* ]] && return 1
    [[ "$rel" == *$'\r'* ]] && return 1
    case "$rel" in
      ../*|*/../*|*/..|..)
        return 1
        ;;
    esac
    return 0
  }

  openclaw_restore_path_allowed() {
    local mode="$1"
    local rel="$2"
    case "$mode" in
      memory)
        case "$rel" in
          MEMORY.md|AGENTS.md|USER.md|SOUL.md|TOOLS.md|memory/*) return 0 ;;
          *) return 1 ;;
        esac
        ;;
      project)
        case "$rel" in
          openclaw.json|workspace/*|extensions/*|skills/*|prompts/*|tools/*|telegram/*|feishu/*|whatsapp/*|discord/*|slack/*|qqbot/*|logs/*) return 0 ;;
          *) return 1 ;;
        esac
        ;;
      *)
        return 1
        ;;
    esac
  }

  openclaw_pack_backup_archive() {
    local backup_type="$1"
    local export_mode="$2"
    local payload_dir="$3"
    local output_file="$4"

    local tmp_root
    tmp_root=$(mktemp -d) || return 1
    local pack_dir="$tmp_root/package"
    mkdir -p "$pack_dir"

    cp -a "$payload_dir" "$pack_dir/payload"

    (
      cd "$pack_dir/payload" || exit 1
      find . -type f | sed 's|^\./||' | sort > "$pack_dir/manifest.files"
      : > "$pack_dir/manifest.sha256"
      while IFS= read -r f; do
        [ -z "$f" ] && continue
        sha256sum "$f" >> "$pack_dir/manifest.sha256"
      done < "$pack_dir/manifest.files"
    ) || { rm -rf "$tmp_root"; return 1; }

    cat > "$pack_dir/backup.meta" <<EOF
TYPE=$backup_type
MODE=$export_mode
CREATED_AT=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
HOST=$(hostname)
EOF

    mkdir -p "$(dirname "$output_file")"
    tar -C "$pack_dir" -czf "$output_file" backup.meta manifest.files manifest.sha256 payload
    local rc=$?
    rm -rf "$tmp_root"
    return $rc
  }

  openclaw_offer_transfer_hint() {
    local file_path="$1"

    echo "可使用以下方式下载备份文件："
    echo "- 本地路径: $file_path"
    echo "- scp 示例: scp root@你的服务器:$file_path ./"
    echo "- 或使用 SFTP 客户端下载"
  }

  openclaw_prepare_import_archive() {
    local expected_type="$1"
    local archive_path="$2"
    local unpack_root="$3"

    [ ! -f "$archive_path" ] && { echo "❌ 文件不存在: $archive_path"; return 1; }
    mkdir -p "$unpack_root"
    tar -xzf "$archive_path" -C "$unpack_root" || { echo "❌ 备份包解压失败"; return 1; }

    local pkg_dir="$unpack_root/package"
    if [ -f "$unpack_root/backup.meta" ]; then
      pkg_dir="$unpack_root"
    fi

    for required in backup.meta manifest.files manifest.sha256 payload; do
      [ -e "$pkg_dir/$required" ] || { echo "❌ 备份包缺少必要文件: $required"; return 1; }
    done

    local real_type
    real_type=$(grep '^TYPE=' "$pkg_dir/backup.meta" | head -n1 | cut -d'=' -f2-)
    if [ "$real_type" != "$expected_type" ]; then
      echo "❌ 备份类型不匹配，期望: $expected_type，实际: ${real_type:-未知}"
      return 1
    fi

    (
      cd "$pkg_dir/payload" || exit 1
      sha256sum -c ../manifest.sha256 >/dev/null
    ) || { echo "❌ sha256 校验失败，拒绝还原"; return 1; }

    echo "$pkg_dir"
    return 0
  }

  openclaw_get_all_agent_workspaces() {
    local config_file
    config_file=$(openclaw_get_config_file)
    if [ -f "$config_file" ]; then
      python3 - "$config_file" <<'PY'
import json, sys, os
try:
    with open(sys.argv[1]) as f: data = json.load(f)
    agents = data.get("agents", {}).get("list", [])
    results = [{"id": "main", "ws": os.path.expanduser("~/.openclaw/workspace")}]
    for a in agents:
        aid = a.get("id"); ws = a.get("workspace")
        if aid and ws and aid != "main": results.append({"id": aid, "ws": os.path.expanduser(ws)})
    print(json.dumps(results))
except: print("[]")
PY
    else
      echo '[{"id": "main", "ws": "'"${HOME}"'/.openclaw/workspace"}]'
    fi
  }

  openclaw_memory_backup_export() {
    send_stats "OpenClaw记忆全量备份"
    local backup_root=$(openclaw_backup_root)
    local ts=$(date +%Y%m%d-%H%M%S)
    local out_file="$backup_root/openclaw-memory-full-${ts}.tar.gz"
    mkdir -p "$backup_root"
    local tmp_payload=$(mktemp -d) || return 1
    local workspaces_json=$(openclaw_get_all_agent_workspaces)
    python3 -c "import json, sys, os, shutil;
workspaces = json.loads(sys.argv[1]); tmp_payload = sys.argv[2]
for item in workspaces:
    aid = item['id']; ws = item['ws']
    if not os.path.isdir(ws): continue
    target_dir = os.path.join(tmp_payload, 'agents', aid)
    os.makedirs(target_dir, exist_ok=True)
    for f in ['MEMORY.md', 'memory']:
        src = os.path.join(ws, f)
        if os.path.exists(src):
            if os.path.isfile(src): shutil.copy2(src, target_dir)
            else: shutil.copytree(src, os.path.join(target_dir, f), dirs_exist_ok=True)
" "$workspaces_json" "$tmp_payload"
    if ! find "$tmp_payload" -mindepth 1 -print -quit | grep -q .; then
      echo "❌ 未找到可备份的记忆文件"; rm -rf "$tmp_payload"; break_end; return 1
    fi
    if openclaw_pack_backup_archive "memory-full" "multi-agent" "$tmp_payload" "$out_file"; then
      echo "✅ 记忆全量备份完成 (含多智能体): $out_file"; openclaw_offer_transfer_hint "$out_file"
    else
      echo "❌ 记忆全量备份失败"
    fi
    rm -rf "$tmp_payload"; break_end
  }

  openclaw_memory_backup_import() {
    send_stats "OpenClaw记忆全量还原"
    local archive_path=$(openclaw_read_import_path "还原记忆全量 (支持多智能体)")
    [ -z "$archive_path" ] && { echo "❌ 未输入路径"; break_end; return 1; }
    local tmp_unpack=$(mktemp -d) || return 1
    local pkg_dir=$(openclaw_prepare_import_archive "memory-full" "$archive_path" "$tmp_unpack") || { rm -rf "$tmp_unpack"; break_end; return 1; }
    local workspaces_json=$(openclaw_get_all_agent_workspaces)
    python3 -c 'import json, sys, os, shutil;
workspaces = {item["id"]: item["ws"] for item in json.loads(sys.argv[1])};
payload_dir = sys.argv[2]; agents_root = os.path.join(payload_dir, "agents")
if os.path.isdir(agents_root):
    for aid in os.listdir(agents_root):
        if aid in workspaces:
            src_agent_dir = os.path.join(agents_root, aid); dest_ws = workspaces[aid]
            os.makedirs(dest_ws, exist_ok=True)
            for f in os.listdir(src_agent_dir):
                src = os.path.join(src_agent_dir, f); dest = os.path.join(dest_ws, f)
                if os.path.isfile(src): shutil.copy2(src, dest)
                else: shutil.copytree(src, dest, dirs_exist_ok=True)
            print(f"✅ 已还原智能体记忆: {aid}")' "$workspaces_json" "$pkg_dir/payload"
    rm -rf "$tmp_unpack"; echo "✅ 记忆全量还原完成"; break_end
  }


  openclaw_project_backup_export() {
    send_stats "OpenClaw项目备份"
    local config_file
    config_file=$(openclaw_get_config_file)
    local openclaw_root
    openclaw_root=$(dirname "$config_file")
    if [ ! -d "$openclaw_root" ]; then
      echo "❌ 未找到 OpenClaw 根目录: $openclaw_root"
      break_end
      return 1
    fi

    skpl_ui_header "项目备份" "导出当前 OpenClaw 项目状态"
    skpl_ui_section "模式"
    skpl_ui_menu_item 1 "安全模式" "workspace + openclaw.json + extensions / skills / prompts / tools"
    skpl_ui_menu_item_tone 2 "完整模式" "包含更多运行状态，敏感风险更高" "warn"
    read -e -p "请选择备份模式（默认 1）: " export_mode
    [ -z "$export_mode" ] && export_mode="1"

    local mode_label="safe"
    local tmp_payload
    tmp_payload=$(mktemp -d) || return 1

    if [ "$export_mode" = "2" ]; then
      mode_label="full"
      for d in workspace extensions skills prompts tools; do
        [ -e "$openclaw_root/$d" ] && cp -a "$openclaw_root/$d" "$tmp_payload/"
      done
      [ -f "$openclaw_root/openclaw.json" ] && cp -a "$openclaw_root/openclaw.json" "$tmp_payload/"
      for d in telegram feishu whatsapp discord slack qqbot logs; do
        [ -e "$openclaw_root/$d" ] && cp -a "$openclaw_root/$d" "$tmp_payload/"
      done
    else
      [ -d "$openclaw_root/workspace" ] && cp -a "$openclaw_root/workspace" "$tmp_payload/"
      [ -f "$openclaw_root/openclaw.json" ] && cp -a "$openclaw_root/openclaw.json" "$tmp_payload/"
      for d in extensions skills prompts tools; do
        [ -e "$openclaw_root/$d" ] && cp -a "$openclaw_root/$d" "$tmp_payload/"
      done
    fi

    if ! find "$tmp_payload" -mindepth 1 -print -quit | grep -q .; then
      echo "❌ 未找到可备份的 OpenClaw 项目内容"
      rm -rf "$tmp_payload"
      break_end
      return 1
    fi

    local backup_root
    backup_root=$(openclaw_backup_root)
    mkdir -p "$backup_root"
    local out_file="$backup_root/openclaw-project-${mode_label}-$(date +%Y%m%d-%H%M%S).tar.gz"

    if openclaw_pack_backup_archive "openclaw-project" "$mode_label" "$tmp_payload" "$out_file"; then
      echo "✅ OpenClaw 项目备份完成 (${mode_label}): $out_file"
      openclaw_offer_transfer_hint "$out_file"
    else
      echo "❌ OpenClaw 项目备份失败"
    fi

    rm -rf "$tmp_payload"
    break_end
  }

  openclaw_project_backup_import() {
    send_stats "OpenClaw项目还原"
    local config_file
    config_file=$(openclaw_get_config_file)
    local openclaw_root
    openclaw_root=$(dirname "$config_file")
    mkdir -p "$openclaw_root"

    skpl_ui_header "项目还原" "高风险操作"
    skpl_ui_alert "danger" "项目还原会覆盖 OpenClaw 配置与工作区内容。" "还原前会执行 manifest/sha256 校验、白名单恢复、gateway 停启与健康检查。"
    read -e -p "请输入确认词【我已知晓高风险并继续还原】后继续: " confirm_text
    if [ "$confirm_text" != "我已知晓高风险并继续还原" ]; then
      echo "❌ 确认词不匹配，已取消还原"
      break_end
      return 1
    fi

    local archive_path
    archive_path=$(openclaw_read_import_path "请输入 OpenClaw 项目备份包路径")
    [ -z "$archive_path" ] && { echo "❌ 未输入备份路径"; break_end; return 1; }

    local tmp_unpack
    tmp_unpack=$(mktemp -d) || return 1
    local pkg_dir
    pkg_dir=$(openclaw_prepare_import_archive "openclaw-project" "$archive_path" "$tmp_unpack") || { rm -rf "$tmp_unpack"; break_end; return 1; }

    local invalid=0
    local valid_list
    valid_list=$(mktemp)
    while IFS= read -r rel; do
      [ -z "$rel" ] && continue
      if ! openclaw_is_safe_relpath "$rel" || ! openclaw_restore_path_allowed project "$rel"; then
        echo "❌ 检测到非法或越权路径: $rel"
        invalid=1
        break
      fi
      echo "$rel" >> "$valid_list"
    done < "$pkg_dir/manifest.files"

    if [ "$invalid" -ne 0 ]; then
      rm -f "$valid_list"
      rm -rf "$tmp_unpack"
      echo "❌ 还原中止：存在不安全路径"
      break_end
      return 1
    fi


    if command -v openclaw >/dev/null 2>&1; then
      echo "⏸️ 还原前停止 OpenClaw gateway..."
      openclaw gateway stop >/dev/null 2>&1
    fi

    while IFS= read -r rel; do
      mkdir -p "$openclaw_root/$(dirname "$rel")"
      cp -a "$pkg_dir/payload/$rel" "$openclaw_root/$rel"
    done < "$valid_list"

    if command -v openclaw >/dev/null 2>&1; then
      echo "▶️ 还原后启动 OpenClaw gateway..."
      openclaw gateway start >/dev/null 2>&1
      sleep 2
      echo "🩺 gateway 健康检查："
      openclaw gateway status || true
    fi

    rm -f "$valid_list"
    rm -rf "$tmp_unpack"
    echo "✅ OpenClaw 项目还原完成"
    break_end
  }

  openclaw_backup_detect_type() {
    local file_name="$1"
    if [[ "$file_name" == openclaw-memory-full-*.tar.gz ]]; then
      echo "记忆备份文件"
    elif [[ "$file_name" == openclaw-project-*.tar.gz ]]; then
      echo "项目备份文件"
    else
      echo "其他备份文件"
    fi
  }

  openclaw_backup_collect_files() {
    local backup_root
    backup_root=$(openclaw_backup_root)
    mkdir -p "$backup_root"
    mapfile -t OPENCLAW_BACKUP_FILES < <(find "$backup_root" -maxdepth 1 -type f -name '*.tar.gz' -printf '%f\n' | sort -r)
  }


  openclaw_backup_render_file_list() {
    local backup_root i file_name file_path file_type file_size file_time
    local has_memory=0 has_project=0 has_other=0
    backup_root=$(openclaw_backup_root)
    openclaw_backup_collect_files

    echo "备份目录: $backup_root"
    if [ ${#OPENCLAW_BACKUP_FILES[@]} -eq 0 ]; then
      echo "暂无备份文件"
      return 0
    fi

    for i in "${!OPENCLAW_BACKUP_FILES[@]}"; do
      file_type=$(openclaw_backup_detect_type "${OPENCLAW_BACKUP_FILES[$i]}")
      case "$file_type" in
        "记忆备份文件") has_memory=1 ;;
        "项目备份文件") has_project=1 ;;
        "其他备份文件") has_other=1 ;;
      esac
    done

    if [ "$has_memory" -eq 1 ]; then
      echo "记忆备份文件"
      for i in "${!OPENCLAW_BACKUP_FILES[@]}"; do
        file_name="${OPENCLAW_BACKUP_FILES[$i]}"
        file_type=$(openclaw_backup_detect_type "$file_name")
        [ "$file_type" != "记忆备份文件" ] && continue
        file_path="$backup_root/$file_name"
        file_size=$(ls -lh "$file_path" | awk '{print $5}')
        file_time=$(date -d "$(stat -c %y "$file_path")" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || stat -c %y "$file_path" | awk '{print $1" "$2}')
        printf "%s | %s | %s\n" "$file_name" "$file_size" "$file_time"
      done
    fi

    if [ "$has_project" -eq 1 ]; then
      echo "项目备份文件"
      for i in "${!OPENCLAW_BACKUP_FILES[@]}"; do
        file_name="${OPENCLAW_BACKUP_FILES[$i]}"
        file_type=$(openclaw_backup_detect_type "$file_name")
        [ "$file_type" != "项目备份文件" ] && continue
        file_path="$backup_root/$file_name"
        file_size=$(ls -lh "$file_path" | awk '{print $5}')
        file_time=$(date -d "$(stat -c %y "$file_path")" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || stat -c %y "$file_path" | awk '{print $1" "$2}')
        printf "%s | %s | %s\n" "$file_name" "$file_size" "$file_time"
      done
    fi

    if [ "$has_other" -eq 1 ]; then
      echo "其他备份文件"
      for i in "${!OPENCLAW_BACKUP_FILES[@]}"; do
        file_name="${OPENCLAW_BACKUP_FILES[$i]}"
        file_type=$(openclaw_backup_detect_type "$file_name")
        [ "$file_type" != "其他备份文件" ] && continue
        file_path="$backup_root/$file_name"
        file_size=$(ls -lh "$file_path" | awk '{print $5}')
        file_time=$(date -d "$(stat -c %y "$file_path")" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || stat -c %y "$file_path" | awk '{print $1" "$2}')
        printf "%s | %s | %s\n" "$file_name" "$file_size" "$file_time"
      done
    fi
  }

  openclaw_backup_file_exists_in_list() {
    local target_file="$1"
    local item
    for item in "${OPENCLAW_BACKUP_FILES[@]}"; do
      [ "$item" = "$target_file" ] && return 0
    done
    return 1
  }

  openclaw_backup_delete_file() {
    send_stats "OpenClaw删除备份文件"
    local backup_root backup_root_real user_input target_file target_path target_type
    backup_root=$(openclaw_backup_root)

    openclaw_backup_render_file_list
    if [ ${#OPENCLAW_BACKUP_FILES[@]} -eq 0 ]; then
      break_end
      return 0
    fi

    read -e -p "请输入要删除的文件名或完整路径（0 取消）: " user_input
    if [ "$user_input" = "0" ]; then
      echo "已取消删除。"
      break_end
      return 0
    fi
    if [ -z "$user_input" ]; then
      echo "❌ 输入不能为空。"
      break_end
      return 1
    fi

    backup_root_real=$(realpath -m "$backup_root")
    if [[ "$user_input" == /* ]]; then
      target_path=$(realpath -m "$user_input")
      case "$target_path" in
        "$backup_root_real"/*) ;;
        *)
          echo "❌ 路径越界：仅允许删除备份根目录内的文件。"
          break_end
          return 1
          ;;
      esac
      target_file=$(basename "$target_path")
    else
      target_file=$(basename -- "$user_input")
      target_path="$backup_root/$target_file"
    fi

    if [ ! -f "$target_path" ]; then
      echo "❌ 目标文件不存在: $target_path"
      break_end
      return 1
    fi

    if ! openclaw_backup_file_exists_in_list "$target_file"; then
      echo "❌ 目标文件不在当前备份列表中。"
      break_end
      return 1
    fi

    target_type=$(openclaw_backup_detect_type "$target_file")

    skpl_ui_alert "danger" "即将删除备份文件" "[$target_type] $target_path"
    read -e -p "第一次确认：输入 yes 确认继续: " confirm_step1
    if [ "$confirm_step1" != "yes" ]; then
      echo "已取消删除。"
      break_end
      return 0
    fi
    read -e -p "二次确认：输入 DELETE 执行删除: " confirm_step2
    if [ "$confirm_step2" != "DELETE" ]; then
      echo "已取消删除。"
      break_end
      return 0
    fi

    if rm -f -- "$target_path"; then
      echo "✅ 删除成功: $target_file"
    else
      echo "❌ 删除失败: $target_file"
    fi
    break_end
  }

  openclaw_backup_list_files() {
    openclaw_backup_render_file_list
    break_end
  }

  openclaw_memory_config_file() {
    local user_config="${HOME}/.openclaw/openclaw.json"
    local root_config="/root/.openclaw/openclaw.json"
    if [ -f "$user_config" ]; then
      echo "$user_config"
    elif [ "$HOME" = "/root" ] && [ -f "$root_config" ]; then
      echo "$root_config"
    else
      echo "$user_config"
    fi
  }

  openclaw_memory_config_get() {
    local key="$1"
    local default_value="${2:-}"
    local value
    value=$(openclaw config get "$key" 2>/dev/null | head -n 1 | sed -e 's/^"//' -e 's/"$//')
    if [ -z "$value" ] || [ "$value" = "null" ] || [ "$value" = "undefined" ]; then
      echo "$default_value"
      return 0
    fi
    echo "$value"
  }

  openclaw_memory_config_set() {
    local key="$1"
    shift
    openclaw config set "$key" "$@" >/dev/null 2>&1
  }

openclaw_memory_config_unset() {
  local key="$1"
  openclaw config unset "$key" >/dev/null 2>&1
}

openclaw_memory_cache_fresh() {
  local cache_file="$1"
  local ttl="${2:-10}"
  [ -f "$cache_file" ] || return 1
  python3 - "$cache_file" "$ttl" <<'PY'
import os, sys, time
path = sys.argv[1]
ttl = int(sys.argv[2])
try:
    age = time.time() - os.path.getmtime(path)
except OSError:
    raise SystemExit(1)
raise SystemExit(0 if age <= ttl else 1)
PY
}

openclaw_memory_refresh_agents_cache() {
  local agents_json config_path
  if command -v openclaw >/dev/null 2>&1; then
    agents_json=$(timeout 6 openclaw agents list --json 2>/dev/null || true)
    if [ -n "$agents_json" ]; then
      python3 - "$agents_json" "$SKPL_MEMORY_AGENTS_CACHE_FILE" <<'PY'
import json, os, sys
raw, path = sys.argv[1:3]
try:
    data = json.loads(raw)
except Exception:
    raise SystemExit(1)
seen = set()
rows = []
if isinstance(data, list):
    for item in data:
        if not isinstance(item, dict):
            continue
        aid = item.get('id')
        if not aid or aid in seen:
            continue
        ws = item.get('workspace') or ('~/.openclaw/workspace' if aid == 'main' else f'~/.openclaw/workspace-{aid}')
        rows.append(f"{aid}\t{os.path.expanduser(ws)}")
        seen.add(aid)
if rows:
    with open(path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(rows) + '\n')
    raise SystemExit(0)
raise SystemExit(1)
PY
      [ $? -eq 0 ] && return 0
    fi
  fi

  config_path=$(openclaw_memory_config_file)
  python3 - "$config_path" "$SKPL_MEMORY_AGENTS_CACHE_FILE" <<'PY'
import json, os, sys
config_path, out_path = sys.argv[1:3]
results = [("main", os.path.expanduser("~/.openclaw/workspace"))]
seen = {"main"}
try:
    if os.path.exists(config_path):
        with open(config_path, encoding='utf-8') as f:
            data = json.load(f)
        agents = data.get('agents', {}).get('list', [])
        if isinstance(agents, list):
            for item in agents:
                if not isinstance(item, dict):
                    continue
                aid = item.get('id')
                ws = item.get('workspace')
                if not aid or aid in seen:
                    continue
                if not ws:
                    ws = f"~/.openclaw/workspace-{aid}"
                results.append((aid, os.path.expanduser(ws)))
                seen.add(aid)
except Exception:
    pass
with open(out_path, 'w', encoding='utf-8') as f:
    for aid, ws in results:
        f.write(f"{aid}\t{ws}\n")
PY
}

openclaw_memory_refresh_status_cache() {
  local json_output
  json_output=$(timeout 8 openclaw memory status --json 2>/dev/null || true)
  if [ -z "$json_output" ]; then
    return 1
  fi
  printf '%s' "$json_output" > "$SKPL_MEMORY_STATUS_CACHE_FILE"
}

openclaw_memory_refresh_runtime_state() {
  echo "正在刷新记忆状态缓存..."
  openclaw_memory_refresh_agents_cache >/dev/null 2>&1 || true
  if openclaw_memory_refresh_status_cache; then
    echo "✅ 记忆状态已刷新"
    return 0
  fi
  echo "⚠️ 记忆状态刷新失败，将尝试显示缓存或基础信息。"
  return 1
}

openclaw_memory_cleanup_legacy_keys() {
  openclaw_memory_config_unset "memory.local"
}

openclaw_memory_list_agents() {
  if ! openclaw_memory_cache_fresh "$SKPL_MEMORY_AGENTS_CACHE_FILE" 30; then
    openclaw_memory_refresh_agents_cache >/dev/null 2>&1 || true
  fi
  if [ -s "$SKPL_MEMORY_AGENTS_CACHE_FILE" ]; then
    cat "$SKPL_MEMORY_AGENTS_CACHE_FILE"
    return 0
  fi
  printf 'main\t%s\n' "$HOME/.openclaw/workspace"
}

  openclaw_memory_status_value() {
    local key="$1"
    local agent_id="${2:-}"
    if [ -n "$agent_id" ]; then
      openclaw memory status --agent "$agent_id" 2>/dev/null | awk -F': ' -v k="$key" '$1==k {print $2; exit}'
    else
      openclaw memory status 2>/dev/null | awk -F': ' -v k="$key" '$1==k {print $2; exit}'
    fi
  }

  openclaw_memory_expand_path() {
    local raw_path="$1"
    if [ -z "$raw_path" ]; then
      echo ""
      return 0
    fi
    raw_path=$(echo "$raw_path" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    if [[ "$raw_path" == ~* ]]; then
      echo "${raw_path/#\~/$HOME}"
    else
      echo "$raw_path"
    fi
  }

  openclaw_memory_rebuild_index_single() {
    local agent_id="${1:-main}"
    local store_raw store_file ts backup_file
    store_raw=$(openclaw_memory_status_value "Store" "$agent_id")
    store_file=$(openclaw_memory_expand_path "$store_raw")
    if [ -z "$store_file" ] || [ ! -f "$store_file" ]; then
      echo "⚠️ [$agent_id] 未找到索引库文件，可能为空或不存在。"
      echo "   Store 原始值: ${store_raw:-<空>}"
      echo "   仍将执行重建索引。"
    else
      ts=$(date +%Y%m%d_%H%M%S)
      backup_file="${store_file}.bak.${ts}"
      if mv "$store_file" "$backup_file"; then
        echo "✅ [$agent_id] 已备份索引: $backup_file"
      else
        echo "⚠️ [$agent_id] 索引备份失败，继续重建。"
      fi
    fi
    openclaw memory index --agent "$agent_id" --force
  }

  openclaw_memory_rebuild_index_safe() {
    local agent_id="${1:-main}"
    openclaw_memory_rebuild_index_single "$agent_id"
    openclaw gateway restart
    echo "✅ 索引已重建并自动重启网关"
    echo ""
    openclaw_memory_render_status
  }

  openclaw_memory_rebuild_index_all() {
    local count=0
    local agent_lines agent_id workspace
    agent_lines=$(openclaw_memory_list_agents)
    while IFS=$'\t' read -r agent_id workspace; do
      [ -z "$agent_id" ] && continue
      openclaw_memory_rebuild_index_single "$agent_id"
      count=$((count+1))
    done <<EOF
$agent_lines
EOF
    openclaw gateway restart
    echo "✅ 索引已重建并自动重启网关"
    echo "✅ 已为 ${count} 个智能体重建索引"
    echo ""
    openclaw_memory_render_status
  }

  openclaw_memory_prepare_workspace() {
    local agent_id="${1:-main}"
    local workspace memory_dir
    workspace=$(openclaw_memory_status_value "Workspace" "$agent_id")
    if [ -z "$workspace" ]; then
      workspace="$HOME/.openclaw/workspace"
      [ "$agent_id" != "main" ] && workspace="$HOME/.openclaw/workspace-$agent_id"
    fi
    memory_dir="$workspace/memory"
    if [ ! -d "$memory_dir" ]; then
      echo "🔧 [$agent_id] 记忆目录不存在，已自动创建: $memory_dir"
      mkdir -p "$memory_dir"
    fi
    return 0
  }

  openclaw_memory_prepare_workspace_all() {
    local count=0
    local agent_lines agent_id workspace
    agent_lines=$(openclaw_memory_list_agents)
    echo "检查并准备 $(printf '%s\n' "$agent_lines" | sed '/^\s*$/d' | wc -l | tr -d ' ') 个智能体工作区"
    while IFS=$'\t' read -r agent_id workspace; do
      [ -z "$agent_id" ] && continue
      openclaw_memory_prepare_workspace "$agent_id"
      count=$((count+1))
    done <<EOF
$agent_lines
EOF
    return 0
  }

openclaw_memory_render_basic_status() {
  local backend provider model_path model_status workspace
  backend=$(openclaw_memory_get_backend)
  provider=$(openclaw_memory_config_get "agents.defaults.memorySearch.provider")
  model_path=$(openclaw_memory_get_local_model_path)
  model_status=$(openclaw_memory_local_model_status "$model_path")
  workspace="$HOME/.openclaw/workspace"
  echo "当前显示为基础配置视图（尚未刷新运行时状态）"
  echo "Agent: main"
  echo "  底层方案: ${backend:--}"
  echo "  搜索提供方: ${provider:--}"
  case "$model_status" in
    ok) echo "  本地模型: 已就绪" ;;
    hf) echo "  本地模型: 来自远端下载源" ;;
    *) echo "  本地模型: 未就绪" ;;
  esac
  echo "  工作区: $workspace"
}

openclaw_memory_render_status() {
  local json_output cache_note=""
  if ! openclaw_memory_cache_fresh "$SKPL_MEMORY_STATUS_CACHE_FILE" 60 && [ -s "$SKPL_MEMORY_STATUS_CACHE_FILE" ]; then
    cache_note="当前显示缓存状态，可手动刷新获取最新结果。"
  fi
  json_output=$(cat "$SKPL_MEMORY_STATUS_CACHE_FILE" 2>/dev/null || true)
  if [ -z "$json_output" ]; then
    openclaw_memory_render_basic_status
    return 0
  fi
  [ -n "$cache_note" ] && echo "$cache_note"
  python3 - "$json_output" <<'PY'
import json, sys
raw = sys.argv[1]
try:
    data = json.loads(raw)
except Exception:
    print("获取记忆状态失败（JSON 解析错误）")
    raise SystemExit(1)
if not isinstance(data, list) or len(data) == 0:
    print("未检测到任何智能体记忆状态。")
    raise SystemExit(0)
first = True
for entry in data:
    if not isinstance(entry, dict):
        continue
    agent_id = entry.get("agentId", "?")
    s = entry.get("status", {})
    if not isinstance(s, dict):
        s = {}
    if not first:
        print("")
    first = False
    print("Agent: %s" % agent_id)
    backend = s.get("backend") or s.get("provider") or "-"
    print("  底层方案: %s" % backend)
    files = s.get("files", 0)
    chunks = s.get("chunks", 0)
    print("  已收录: %s 文件 / %s 块" % (files, chunks))
    dirty = s.get("dirty")
    dirty_str = "是" if dirty else "否"
    print("  待刷新: %s" % dirty_str)
    vec = s.get("vector", {})
    if isinstance(vec, dict) and vec.get("enabled"):
        vec_str = "就绪" if vec.get("available") else "已启用(不可用)"
    else:
        vec_str = "未启用"
    print("  向量库: %s" % vec_str)
    ws = s.get("workspaceDir") or "-"
    print("  工作区: %s" % ws)
    db = s.get("dbPath") or "-"
    print("  索引库: %s" % db)
    scan = entry.get("scan", {})
    if isinstance(scan, dict):
        issues = scan.get("issues", [])
        if issues:
            for issue in issues[:3]:
                print("  ⚠️ %s" % issue)
PY
  }

  openclaw_memory_get_backend() {
    local backend
    backend=$(openclaw_memory_config_get "memory.backend")
    if [ "$backend" = "local" ]; then
      echo "builtin"
    else
      echo "$backend"
    fi
  }

  openclaw_memory_get_local_model_path() {
    openclaw_memory_config_get "agents.defaults.memorySearch.local.modelPath"
  }

  openclaw_memory_local_model_status() {
    local model_path="$1"
    if [ -z "$model_path" ]; then
      echo "missing"
      return
    fi
    if [[ "$model_path" == hf:* ]]; then
      echo "hf"
      return
    fi
    if [ -f "$model_path" ]; then
      echo "ok"
    else
      echo "missing"
    fi
  }

  openclaw_memory_qmd_available() {
    if command -v qmd >/dev/null 2>&1; then
      echo "true"
      return
    fi
    local backend
    backend=$(openclaw_memory_config_get "memory.backend")
    if [ "$backend" = "qmd" ]; then
      echo "true"
      return
    fi
    echo "false"
  }

  openclaw_memory_probe_url() {
    local url="$1"
    if ! command -v curl >/dev/null 2>&1; then
      echo "unknown"
      return
    fi
    if [ -z "$url" ]; then
      echo "unknown"
      return
    fi
    if curl -I -m 2 -s "$url" >/dev/null 2>&1; then
      echo "ok"
    else
      echo "fail"
    fi
  }

  openclaw_memory_recommend() {
    local qmd_ok model_path model_status hf_ok mirror_ok
    qmd_ok=$(openclaw_memory_qmd_available)
    model_path=$(openclaw_memory_get_local_model_path)
    model_status=$(openclaw_memory_local_model_status "$model_path")
    hf_ok=$(openclaw_memory_probe_url "https://huggingface.co")
    mirror_ok=$(openclaw_memory_probe_url "https://hf-mirror.com")

    OPENCLAW_MEMORY_RECOMMEND_REASON=()
    if [ "$qmd_ok" = "true" ]; then
      OPENCLAW_MEMORY_RECOMMEND_REASON+=("QMD 可用")
    else
      OPENCLAW_MEMORY_RECOMMEND_REASON+=("未检测到 QMD")
    fi
    if [ -n "$model_path" ]; then
      OPENCLAW_MEMORY_RECOMMEND_REASON+=("本地模型路径: $model_path")
    else
      OPENCLAW_MEMORY_RECOMMEND_REASON+=("未配置本地模型路径")
    fi
    case "$model_status" in
      ok) OPENCLAW_MEMORY_RECOMMEND_REASON+=("本地模型文件存在") ;;
      hf) OPENCLAW_MEMORY_RECOMMEND_REASON+=("模型来自 HF 下载源（国内可能慢/失败）") ;;
      *) OPENCLAW_MEMORY_RECOMMEND_REASON+=("本地模型文件不存在或不可用") ;;
    esac
    if [ "$hf_ok" = "ok" ]; then
      OPENCLAW_MEMORY_RECOMMEND_REASON+=("huggingface.co 可访问")
    elif [ "$mirror_ok" = "ok" ]; then
      OPENCLAW_MEMORY_RECOMMEND_REASON+=("hf-mirror.com 可访问")
    else
      OPENCLAW_MEMORY_RECOMMEND_REASON+=("huggingface.co / hf-mirror.com 可能不可达（疑似国内/受限网络）")
    fi

    if [ "$qmd_ok" = "true" ]; then
      if [ "$model_status" = "ok" ]; then
        OPENCLAW_MEMORY_RECOMMEND="local"
      elif [ "$model_status" = "hf" ] && { [ "$hf_ok" = "ok" ] || [ "$mirror_ok" = "ok" ]; }; then
        OPENCLAW_MEMORY_RECOMMEND="local"
      elif [ "$model_status" = "hf" ] && [ "$hf_ok" = "fail" ] && [ "$mirror_ok" = "fail" ]; then
        OPENCLAW_MEMORY_RECOMMEND="qmd"
      else
        OPENCLAW_MEMORY_RECOMMEND="qmd"
      fi
    else
      if [ "$model_status" = "ok" ]; then
        OPENCLAW_MEMORY_RECOMMEND="local"
      else
        OPENCLAW_MEMORY_RECOMMEND="qmd"
      fi
    fi
  }


  openclaw_memory_detect_region() {
    OPENCLAW_MEMORY_COUNTRY="unknown"
    OPENCLAW_MEMORY_USE_MIRROR="false"
    if command -v curl >/dev/null 2>&1; then
      OPENCLAW_MEMORY_COUNTRY=$(curl -s -m 2 ipinfo.io/country | tr -d '
' | tr -d '
')
    fi
    case "$OPENCLAW_MEMORY_COUNTRY" in
      CN|HK)
        OPENCLAW_MEMORY_USE_MIRROR="true"
        ;;
    esac
  }

  openclaw_memory_select_sources() {
    local hf_ok mirror_ok
    hf_ok=$(openclaw_memory_probe_url "https://huggingface.co")
    mirror_ok=$(openclaw_memory_probe_url "https://hf-mirror.com")
    OPENCLAW_MEMORY_HF_OK="$hf_ok"
    OPENCLAW_MEMORY_MIRROR_OK="$mirror_ok"
    if [ "$OPENCLAW_MEMORY_USE_MIRROR" = "true" ]; then
      if [ "$mirror_ok" = "ok" ]; then
        OPENCLAW_MEMORY_HF_BASE="https://hf-mirror.com"
      elif [ "$hf_ok" = "ok" ]; then
        OPENCLAW_MEMORY_HF_BASE="https://huggingface.co"
      else
        OPENCLAW_MEMORY_HF_BASE="https://hf-mirror.com"
      fi
    else
      if [ "$hf_ok" = "ok" ]; then
        OPENCLAW_MEMORY_HF_BASE="https://huggingface.co"
      elif [ "$mirror_ok" = "ok" ]; then
        OPENCLAW_MEMORY_HF_BASE="https://hf-mirror.com"
      else
        OPENCLAW_MEMORY_HF_BASE="https://huggingface.co"
      fi
    fi
  }

  openclaw_memory_download_file() {
    local url="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    if command -v curl >/dev/null 2>&1; then
      curl -L --fail --retry 2 -o "$dest" "$url"
      return $?
    fi
    if command -v wget >/dev/null 2>&1; then
      wget -O "$dest" "$url"
      return $?
    fi
    echo "❌ 未检测到 curl 或 wget，无法下载。"
    return 1
  }

  openclaw_memory_check_sqlite() {
    if ! command -v sqlite3 >/dev/null 2>&1; then
      echo "⚠️ 未检测到 sqlite3，QMD 可能无法正常运行。"
      return 1
    fi
    local ver
    ver=$(sqlite3 --version 2>/dev/null | awk '{print $1}')
    echo "✅ sqlite3 可用: ${ver:-unknown}"
    echo "ℹ️ sqlite 扩展支持无法可靠检测，将继续。"
    return 0
  }

  openclaw_memory_ensure_bun() {
    if [ -x "$HOME/.bun/bin/bun" ]; then
      export PATH="$HOME/.bun/bin:$PATH"
    fi
    if command -v bun >/dev/null 2>&1; then
      echo "✅ bun 已存在"
      return 0
    fi
    echo "⬇️ 安装 bun..."
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL https://bun.sh/install | bash
    elif command -v wget >/dev/null 2>&1; then
      wget -qO- https://bun.sh/install | bash
    else
      echo "❌ 未检测到 curl 或 wget，无法安装 bun。"
      return 1
    fi
    if [ -d "$HOME/.bun/bin" ]; then
      export PATH="$HOME/.bun/bin:$PATH"
    fi
    if command -v bun >/dev/null 2>&1; then
      echo "✅ bun 安装完成"
      return 0
    fi
    echo "❌ bun 安装失败"
    return 1
  }

  openclaw_memory_ensure_qmd() {
    local qmd_path
    qmd_path=$(command -v qmd 2>/dev/null || true)
    if [ -n "$qmd_path" ]; then
      if qmd --version >/dev/null 2>&1; then
        echo "✅ qmd 已存在且可用: $qmd_path"
        OPENCLAW_MEMORY_QMD_PATH="$qmd_path"
        return 0
      else
        echo "⚠️ qmd 命令存在但模块损坏，重新安装..."
      fi
    fi
    echo "⬇️ 通过 npm 安装 qmd: @tobilu/qmd"
    npm install -g @tobilu/qmd
    qmd_path=$(command -v qmd 2>/dev/null || true)
    if [ -z "$qmd_path" ]; then
      echo "❌ qmd 安装失败"
      return 1
    fi
    if ! qmd --version >/dev/null 2>&1; then
      echo "❌ qmd 安装后仍无法运行"
      return 1
    fi
    OPENCLAW_MEMORY_QMD_PATH="$qmd_path"
    echo "✅ qmd 安装完成: $qmd_path"
    return 0
  }

  openclaw_memory_render_auto_summary() {
    skpl_ui_rule "$gl_hui" "─" 60
    echo "✅ 环境就绪"
    echo "方案: ${OPENCLAW_MEMORY_AUTO_SCHEME:-unknown}"
    if [ "$OPENCLAW_MEMORY_CONFIG_ONLY" = "true" ]; then
      echo "模式: 仅写配置（未安装/未下载）"
    fi
    if [ "$OPENCLAW_MEMORY_PREHEAT" = "true" ]; then
      echo "索引: 已执行"
    else
      echo "索引: 已跳过"
    fi
    if [ "$OPENCLAW_MEMORY_RESTARTED" = "true" ]; then
      echo "重启: 已执行"
    else
      echo "重启: 已跳过"
    fi
    if [ -n "$OPENCLAW_MEMORY_QMD_PATH" ]; then
      echo "qmd: $OPENCLAW_MEMORY_QMD_PATH"
    fi
    if [ -n "$OPENCLAW_MEMORY_MODEL_PATH" ]; then
      echo "模型: $OPENCLAW_MEMORY_MODEL_PATH"
    fi
    if [ -n "$OPENCLAW_MEMORY_COUNTRY" ]; then
      echo "地区: $OPENCLAW_MEMORY_COUNTRY"
    fi
    if [ -n "$OPENCLAW_MEMORY_HF_BASE" ]; then
      echo "下载源: $OPENCLAW_MEMORY_HF_BASE"
    fi
    echo "最终状态:"
    openclaw_memory_render_status
    skpl_ui_rule "$gl_hui" "─" 60
  }

  openclaw_memory_auto_confirm() {
    local scheme_label="$1"
    OPENCLAW_MEMORY_PREHEAT="true"
    OPENCLAW_MEMORY_RESTARTED="false"
    OPENCLAW_MEMORY_CONFIG_ONLY="false"
    echo "即将执行自动部署（详细模式）"
    echo "目标方案: $scheme_label"
    echo "地区: ${OPENCLAW_MEMORY_COUNTRY:-unknown}"
    echo "镜像源探测: huggingface.co=${OPENCLAW_MEMORY_HF_OK:-unknown} hf-mirror.com=${OPENCLAW_MEMORY_MIRROR_OK:-unknown}"
    echo "下载源: ${OPENCLAW_MEMORY_HF_BASE:-unknown}"
    if [ -n "$OPENCLAW_MEMORY_EXPECT_PATH" ]; then
      echo "预计下载路径: $OPENCLAW_MEMORY_EXPECT_PATH"
    fi
    if [ -n "$OPENCLAW_MEMORY_EXPECT_SIZE" ]; then
      echo "可能流量/磁盘占用: $OPENCLAW_MEMORY_EXPECT_SIZE"
    else
      echo "可能流量/磁盘占用: 视实际情况而定"
    fi
    echo "确认后将自动安装/下载、写入配置、构建索引并重启网关"
    echo "高级选项: 输入 config 仅写配置（不安装不下载、不索引、不重启）"
    read -e -p "输入 yes 确认继续（默认 N）: " confirm_step
    case "$confirm_step" in
      yes|YES)
        OPENCLAW_MEMORY_PREHEAT="true"
        ;;
      config|CONFIG)
        OPENCLAW_MEMORY_CONFIG_ONLY="true"
        OPENCLAW_MEMORY_PREHEAT="false"
        ;;
      *)
        echo "已取消自动部署。"
        return 1
        ;;
    esac
    if [ "$OPENCLAW_MEMORY_CONFIG_ONLY" = "true" ]; then
      echo "⚠️ 已选择仅写配置，不安装不下载"
    else
      echo "✅ 将自动构建索引并重启网关"
    fi
    return 0
  }

  openclaw_memory_auto_setup_qmd() {
    echo "🔍 检测 QMD 环境"
    openclaw_memory_cleanup_legacy_keys
    openclaw_memory_check_sqlite || true
    if [ "$OPENCLAW_MEMORY_CONFIG_ONLY" = "true" ]; then
      if command -v qmd >/dev/null 2>&1; then
        OPENCLAW_MEMORY_QMD_PATH=$(command -v qmd)
      else
        OPENCLAW_MEMORY_QMD_PATH="qmd"
      fi
    else
      openclaw_memory_ensure_qmd || return 1
    fi
    local backend
    backend=$(openclaw_memory_get_backend)
    if [ "$backend" = "qmd" ]; then
      echo "✅ memory.backend 已是 qmd"
    else
      openclaw_memory_config_set "memory.backend" "qmd"
      echo "✅ 已设置 memory.backend=qmd"
    fi
    local qmd_cmd
    qmd_cmd=$(openclaw_memory_config_get "memory.qmd.command")
    if [ -z "$qmd_cmd" ] || [[ "$qmd_cmd" != /* ]] || [ "$qmd_cmd" != "$OPENCLAW_MEMORY_QMD_PATH" ]; then
      openclaw_memory_config_set "memory.qmd.command" "$OPENCLAW_MEMORY_QMD_PATH"
      echo "✅ 已写入 memory.qmd.command: $OPENCLAW_MEMORY_QMD_PATH"
    else
      echo "✅ memory.qmd.command 已正确"
    fi
    if [ "$OPENCLAW_MEMORY_PREHEAT" = "true" ]; then
      echo "🔥 预热索引（可能下载模型）"
      openclaw_memory_prepare_workspace_all
      local preh_agent_lines preh_agent_id preh_workspace
      preh_agent_lines=$(openclaw_memory_list_agents)
      while IFS=$'\t' read -r preh_agent_id preh_workspace; do
        [ -z "$preh_agent_id" ] && continue
        openclaw memory index --agent "$preh_agent_id" --force
      done <<EOF
$preh_agent_lines
EOF
    else
      echo "⏭️ 已跳过预热"
    fi
    echo "✅ QMD 自动部署完成"
  }

  openclaw_memory_auto_setup_local() {
    echo "🔍 检测 Local 环境"
    openclaw_memory_cleanup_legacy_keys
    local backend provider
    backend=$(openclaw_memory_get_backend)
    if [ "$backend" = "builtin" ] || [ "$backend" = "local" ]; then
      echo "✅ memory.backend 已是 builtin"
    else
      openclaw_memory_config_set "memory.backend" "builtin"
      echo "✅ 已设置 memory.backend=builtin"
    fi
    provider=$(openclaw_memory_config_get "agents.defaults.memorySearch.provider")
    if [ "$provider" = "local" ]; then
      echo "✅ memorySearch.provider 已是 local"
    else
      openclaw_memory_config_set "agents.defaults.memorySearch.provider" "local"
      echo "✅ 已设置 agents.defaults.memorySearch.provider=local"
    fi

    local model_path model_status
    model_path=$(openclaw_memory_get_local_model_path)
    model_path=$(openclaw_memory_expand_path "$model_path")
    model_status=$(openclaw_memory_local_model_status "$model_path")
    if [ "$model_status" = "ok" ]; then
      echo "✅ 模型文件已存在: $model_path"
      OPENCLAW_MEMORY_MODEL_PATH="$model_path"
    else
      local model_name="embeddinggemma-300M-Q8_0.gguf"
      local model_dir="$HOME/.openclaw/models/embedding"
      local model_dest="$model_dir/$model_name"
      local model_url="${OPENCLAW_MEMORY_HF_BASE}/ggml-org/embeddinggemma-300M-GGUF/resolve/main/$model_name"
      if [ "$OPENCLAW_MEMORY_CONFIG_ONLY" = "true" ]; then
        echo "ℹ️ 仅写配置模式：跳过模型下载"
        OPENCLAW_MEMORY_MODEL_PATH="$model_dest"
      else
        if [ -f "$model_dest" ]; then
          echo "✅ 已发现默认模型文件: $model_dest"
        else
          echo "⬇️ 下载模型: $model_url"
          openclaw_memory_download_file "$model_url" "$model_dest" || return 1
          echo "✅ 模型已下载: $model_dest"
        fi
        OPENCLAW_MEMORY_MODEL_PATH="$model_dest"
      fi
      openclaw_memory_config_set "agents.defaults.memorySearch.local.modelPath" "$model_dest"
      echo "✅ 已写入模型路径"
    fi
    if [ "$OPENCLAW_MEMORY_PREHEAT" = "true" ]; then
      echo "🔥 预热索引（可能下载模型）"
      openclaw_memory_prepare_workspace_all
      local preh_agent_lines preh_agent_id preh_workspace
      preh_agent_lines=$(openclaw_memory_list_agents)
      while IFS=$'\t' read -r preh_agent_id preh_workspace; do
        [ -z "$preh_agent_id" ] && continue
        openclaw memory index --agent "$preh_agent_id" --force
      done <<EOF
$preh_agent_lines
EOF
    else
      echo "⏭️ 已跳过预热"
    fi
    echo "✅ Local 自动部署完成"
  }

  openclaw_memory_auto_setup_run() {
    local scheme="$1"
    local scheme_label
    OPENCLAW_MEMORY_QMD_PATH=""
    OPENCLAW_MEMORY_MODEL_PATH=""
    OPENCLAW_MEMORY_EXPECT_PATH=""
    OPENCLAW_MEMORY_EXPECT_SIZE=""
    openclaw_memory_detect_region
    openclaw_memory_select_sources
    if [ "$scheme" = "auto" ]; then
      openclaw_memory_recommend
      scheme="$OPENCLAW_MEMORY_RECOMMEND"
    fi
    case "$scheme" in
      qmd)
        scheme_label="QMD"
        OPENCLAW_MEMORY_EXPECT_PATH="$HOME/.bun (qmd 安装目录)"
        OPENCLAW_MEMORY_EXPECT_SIZE="约 20-50MB"
        ;;
      local)
        scheme_label="Local"
        OPENCLAW_MEMORY_EXPECT_PATH="$HOME/.openclaw/models/embedding/embeddinggemma-300M-Q8_0.gguf"
        OPENCLAW_MEMORY_EXPECT_SIZE="约 350-600MB"
        ;;
      *)
        echo "❌ 未知方案: $scheme"
        return 1
        ;;
    esac
    OPENCLAW_MEMORY_AUTO_SCHEME="$scheme_label"
    openclaw_memory_auto_confirm "$scheme_label" || return 0
    case "$scheme" in
      qmd) openclaw_memory_auto_setup_qmd || return 1 ;;
      local) openclaw_memory_auto_setup_local || return 1 ;;
      *) return 1 ;;
    esac
    if [ "$OPENCLAW_MEMORY_CONFIG_ONLY" = "true" ]; then
      OPENCLAW_MEMORY_RESTARTED="false"
      openclaw_memory_render_auto_summary
      return 0
    fi
    echo "♻️ 重启 OpenClaw 网关"
    if declare -F start_gateway >/dev/null 2>&1; then
      start_gateway
    else
      openclaw gateway restart
    fi
    OPENCLAW_MEMORY_RESTARTED="true"
    openclaw_memory_render_auto_summary
    return 0
  }

  openclaw_memory_auto_setup_menu() {
    while true; do
      clear
      skpl_ui_header "记忆方案自动部署" "根据所选方案完成配置与依赖准备"
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "QMD" "轻量索引方案"
      skpl_ui_menu_item 2 "Local" "本地向量检索方案"
      skpl_ui_menu_item 3 "Auto" "自动选择推荐方案"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e auto_choice
      case "$auto_choice" in
        1)
          openclaw_memory_auto_setup_run "qmd"
          break_end
          ;;
        2)
          openclaw_memory_auto_setup_run "local"
          break_end
          ;;
        3)
          openclaw_memory_auto_setup_run "auto"
          break_end
          ;;
        0)
          return 0
          ;;
        *)
          echo "无效的选择，请重试。"
          sleep 1
          ;;
      esac
    done
  }

  openclaw_memory_apply_scheme() {
    local scheme="$1"
    openclaw_memory_cleanup_legacy_keys
    case "$scheme" in
      qmd)
        openclaw_memory_config_set "memory.backend" "qmd"
        if [ $? -ne 0 ]; then
          echo "❌ 写入配置失败"
          return 1
        fi
        openclaw_memory_config_set "memory.qmd.command" "qmd" >/dev/null 2>&1
        ;;
      local)
        openclaw_memory_config_set "memory.backend" "builtin"
        if [ $? -ne 0 ]; then
          echo "❌ 写入配置失败"
          return 1
        fi
        openclaw_memory_config_set "agents.defaults.memorySearch.provider" "local" >/dev/null 2>&1
        ;;
      *)
        echo "❌ 未知方案: $scheme"
        return 1
      esac
    echo "✅ 已更新记忆方案配置"
    return 0
  }

  openclaw_memory_offer_restart() {
    echo "配置已写入，需要重启 OpenClaw 网关后生效。"
    read -e -p "是否立即重启 OpenClaw 网关？(Y/n): " restart_choice
    if [[ "$restart_choice" =~ ^[Nn]$ ]]; then
      echo "已跳过重启，可稍后执行: openclaw gateway restart"
      return 0
    fi
    if declare -F start_gateway >/dev/null 2>&1; then
      start_gateway
    else
      openclaw gateway restart
    fi
  }

  openclaw_memory_fix_index() {
    local backend include_dm
    backend=$(openclaw_memory_get_backend)
    if [ "$backend" = "qmd" ] && ! command -v qmd >/dev/null 2>&1; then
      echo "⚠️ 检测到当前方案为 QMD，但未安装 qmd 命令。"
      echo "   可切换 Local，或安装 bun + qmd 后再试。"
    fi
    include_dm=$(openclaw config get memory.qmd.includeDefaultMemory 2>/dev/null)
    skpl_ui_header "索引修复诊断" "检查 includeDefaultMemory 与索引重建路径"
    skpl_ui_kv "includeDefaultMemory" "${include_dm:-未设置}"
    echo ""
    if [ "$include_dm" = "false" ]; then
      echo "⚠️ 检测到 includeDefaultMemory=false"
      echo "   这会导致默认记忆文件（MEMORY.md + memory/*.md）不被索引"
      echo "   所以 Indexed 会一直显示 0/N"
      echo ""
      read -e -p "是否恢复为 true 并重建索引？(Y/n): " fix_choice
      if [[ ! "$fix_choice" =~ ^[Nn]$ ]]; then
        openclaw_memory_config_set "memory.qmd.includeDefaultMemory" true
        if [ $? -ne 0 ]; then
          echo "❌ 写入配置失败"
          break_end
          return 1
        fi
        echo "✅ 已恢复 includeDefaultMemory=true"
        openclaw_memory_rebuild_index_all
      else
        echo "已取消。"
      fi
    else
      echo "includeDefaultMemory 配置正常。"
      echo "将执行：清理旧索引 → 全量重建所有智能体索引"
      echo ""
      read -e -p "确认执行？(Y/n): " confirm_fix
      if [[ ! "$confirm_fix" =~ ^[Nn]$ ]]; then
        openclaw_memory_rebuild_index_all
      else
        echo "已取消。"
      fi
    fi
    break_end
  }

  openclaw_memory_scheme_menu() {
    while true; do
      clear
      skpl_ui_header "记忆方案" "QMD / Local / Auto"
      local backend current_label
      backend=$(openclaw_memory_get_backend)
      case "$backend" in
        qmd) current_label="QMD" ;;
        builtin|local) current_label="Local" ;;
        *) current_label="未配置" ;;
      esac
      skpl_ui_section "当前设置"
      skpl_ui_kv "当前方案" "$current_label"
      echo ""
      skpl_ui_section "说明"
      echo "QMD  : 轻量索引，依赖 qmd 命令（适合网络受限）"
      echo "Local: 本地向量检索，依赖 embedding 模型文件"
      echo "Auto : 自动推荐（基于可用性 + 网络探测）"
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "切换 QMD" "自动部署 / 已装则跳过"
      skpl_ui_menu_item 2 "切换 Local" "自动部署 / 已装则跳过"
      skpl_ui_menu_item 3 "Auto" "自动推荐并部署"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e scheme_choice
      case "$scheme_choice" in
        1)
          openclaw_memory_auto_setup_run "qmd"
          break_end
          ;;
        2)
          openclaw_memory_auto_setup_run "local"
          break_end
          ;;
        3)
          openclaw_memory_auto_setup_run "auto"
          break_end
          ;;
        0)
          return 0
          ;;
        *)
          echo "无效的选择，请重试。"
          sleep 1
          ;;
      esac
    done
  }

  openclaw_memory_file_collect() {
    OPENCLAW_MEMORY_FILES=()
    OPENCLAW_MEMORY_FILE_LABELS=()
    local agent_lines agent_id base_dir memory_dir memory_file rel
    agent_lines=$(openclaw_memory_list_agents)
    while IFS=$'\t' read -r agent_id base_dir; do
      [ -z "$agent_id" ] && continue
      memory_dir="$base_dir/memory"
      memory_file="$base_dir/MEMORY.md"
      if [ -f "$memory_file" ]; then
        OPENCLAW_MEMORY_FILES+=("$memory_file")
        OPENCLAW_MEMORY_FILE_LABELS+=("$agent_id/MEMORY.md")
      fi
      if [ -d "$memory_dir" ]; then
        while IFS= read -r file; do
          [ -f "$file" ] || continue
          rel="${file#$base_dir/}"
          OPENCLAW_MEMORY_FILES+=("$file")
          OPENCLAW_MEMORY_FILE_LABELS+=("$agent_id/$rel")
        done < <(find "$memory_dir" -type f -name '*.md' | sort)
      fi
    done <<EOF
$agent_lines
EOF
  }

  openclaw_memory_file_render_list() {
    openclaw_memory_file_collect
    if [ ${#OPENCLAW_MEMORY_FILES[@]} -eq 0 ]; then
      skpl_ui_alert "info" "未找到记忆文件" "当前工作区下没有可浏览的 MEMORY.md 或 memory/*.md 文件。"
      return 0
    fi
    skpl_ui_section "文件清单"
    echo "编号 | 归属 | 大小 | 修改时间"
    skpl_ui_rule "$gl_hui" "─" 60
    local i file rel size mtime
    for i in "${!OPENCLAW_MEMORY_FILES[@]}"; do
      file="${OPENCLAW_MEMORY_FILES[$i]}"
      rel="${OPENCLAW_MEMORY_FILE_LABELS[$i]}"
      size=$(ls -lh "$file" | awk '{print $5}')
      mtime=$(date -d "$(stat -c %y "$file")" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || stat -c %y "$file" | awk '{print $1" "$2}')
      printf "%s | %s | %s | %s\\n" "$((i+1))" "$rel" "$size" "$mtime"
    done
  }

  openclaw_memory_view_file() {
    local file="$1"
    [ -f "$file" ] || {
      echo "❌ 文件不存在: $file"
      return 1
    }
    local total_lines
    total_lines=$(wc -l < "$file" 2>/dev/null || echo 0)
    local default_lines=120
    local start_line count
    skpl_ui_header "记忆文件预览" "按行号抽样查看文件内容"
    skpl_ui_kv "文件" "$file"
    skpl_ui_kv "总行数" "$total_lines"
    read -e -p "请输入起始行（回车默认末尾 $default_lines 行）: " start_line
    read -e -p "请输入显示行数（回车默认 $default_lines）: " count
    [ -z "$count" ] && count=$default_lines
    if [ -z "$start_line" ]; then
      if [ "$total_lines" -le "$count" ]; then
        start_line=1
      else
        start_line=$((total_lines - count + 1))
      fi
    fi
    if ! [[ "$start_line" =~ ^[0-9]+$ ]] || ! [[ "$count" =~ ^[0-9]+$ ]]; then
      echo "❌ 请输入有效的数字。"
      return 1
    fi
    if [ "$start_line" -lt 1 ]; then
      start_line=1
    fi
    if [ "$count" -le 0 ]; then
      echo "❌ 行数必须大于 0。"
      return 1
    fi
    local end_line=$((start_line + count - 1))
    if [ "$end_line" -gt "$total_lines" ]; then
      end_line=$total_lines
    fi
    if [ "$total_lines" -eq 0 ]; then
      echo "(空文件)"
      return 0
    fi
    echo
    skpl_ui_section "内容"
    skpl_ui_rule "$gl_hui" "─" 60
    sed -n "${start_line},${end_line}p" "$file"
    skpl_ui_rule "$gl_hui" "─" 60
  }

  openclaw_memory_files_menu() {
    while true; do
      clear
      skpl_ui_header "记忆文件" "浏览 MEMORY.md 与 memory 目录内的 Markdown 内容"
      openclaw_memory_file_render_list
      echo
      skpl_ui_footer_prompt "请输入文件编号查看（0 返回）: "
      read -e file_choice
      if [ "$file_choice" = "0" ]; then
        return 0
      fi
      if ! [[ "$file_choice" =~ ^[0-9]+$ ]]; then
        skpl_ui_alert "warn" "无效的选择" "请输入列表中的数字编号。"
        sleep 1
        continue
      fi
      openclaw_memory_file_collect
      if [ ${#OPENCLAW_MEMORY_FILES[@]} -eq 0 ]; then
        read -p "未找到记忆文件，按回车返回..."
        return 0
      fi
      local idx=$((file_choice-1))
      if [ "$idx" -lt 0 ] || [ "$idx" -ge ${#OPENCLAW_MEMORY_FILES[@]} ]; then
        skpl_ui_alert "warn" "编号超出范围" "请从当前文件列表中重新选择。"
        sleep 1
        continue
      fi
      openclaw_memory_view_file "${OPENCLAW_MEMORY_FILES[$idx]}"
      read -p "按回车返回列表..."
      done
  }


  openclaw_memory_search_test() {
    read -e -p "输入搜索关键词: " query
    if [ -z "$query" ]; then
      echo "关键词不能为空。"
      return 1
    fi
    echo "正在搜索记忆..."
    openclaw memory search "$query" --max-results 5
  }

  openclaw_memory_deep_status() {
    echo "正在探测嵌入模型就绪状态..."
    openclaw memory status --deep
  }

  openclaw_memory_menu() {
    if [ "$(openclaw_memory_config_get "memory.qmd.includeDefaultMemory")" = "false" ]; then
      openclaw_memory_config_set "memory.qmd.includeDefaultMemory" true >/dev/null 2>&1 || true
    fi
    send_stats "OpenClaw记忆管理"
    while true; do
      clear
      skpl_ui_header "记忆管理" "索引、方案、检索与预热"
      openclaw_memory_render_status
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "刷新记忆状态" "读取最新运行时状态"
      skpl_ui_menu_item 2 "更新记忆索引" "增量或全量重建"
      skpl_ui_menu_item 3 "查看记忆文件" "浏览 MEMORY.md 与 memory/"
      skpl_ui_menu_item 4 "索引修复" "处理 Indexed 异常"
      skpl_ui_menu_item 5 "记忆方案" "QMD / Local / Auto"
      skpl_ui_menu_item 6 "搜索测试" "验证索引是否工作"
      skpl_ui_menu_item 7 "深度状态探测" "检查嵌入模型"
      skpl_ui_menu_item 8 "后台预热日志" "查看 bootstrap 输出"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e memory_choice
      case "$memory_choice" in
        1)
          openclaw_memory_refresh_runtime_state
          break_end
          ;;
        2)
          echo "即将更新记忆索引。"
          read -e -p "第一次确认：输入 yes 继续: " confirm_step1
          if [ "$confirm_step1" != "yes" ]; then
            echo "已取消。"
            break_end
            continue
          fi
          openclaw_memory_prepare_workspace_all
          read -e -p "二次确认：输入 force 使用全量（留空为增量）: " confirm_step2
          if [ "$confirm_step2" = "force" ]; then
            echo "⚠️ 全量重建更彻底，但耗时更长。"
            echo "推荐：输入 rebuild 进行安全重建（先备份索引库）。"
            read -e -p "第三次确认：输入 rebuild 执行安全重建；直接回车继续普通 force: " confirm_step3
            if [ "$confirm_step3" = "rebuild" ]; then
              openclaw_memory_rebuild_index_all
            else
              local fl_agent_lines fl_agent_id fl_workspace
              fl_agent_lines=$(openclaw_memory_list_agents)
              while IFS=$'\t' read -r fl_agent_id fl_workspace; do
                [ -z "$fl_agent_id" ] && continue
                openclaw memory index --agent "$fl_agent_id" --force
              done <<EOF
$fl_agent_lines
EOF
              openclaw gateway restart
              echo "✅ 已对所有智能体执行 force 重建并自动重启网关"
            fi
          else
            openclaw memory index
          fi
          openclaw_memory_refresh_status_cache >/dev/null 2>&1 || true
          break_end
          ;;
        3)
          openclaw_memory_files_menu
          ;;
        4)
          openclaw_memory_fix_index
          ;;
        5)
          openclaw_memory_scheme_menu
          ;;
        6)
          openclaw_memory_search_test
          break_end
          ;;
        7)
          openclaw_memory_deep_status
          break_end
          ;;
        8)
          openclaw_memory_show_bootstrap_log
          break_end
          ;;
        0)
          return 0
          ;;
        *)
          echo "无效的选择，请重试。"
          sleep 1
          ;;
      esac
    done
  }

  openclaw_permission_config_file() {
    echo "$(openclaw_get_config_file)"
  }

  openclaw_permission_backup_file() {
    local backup_root
    backup_root=$(openclaw_backup_root)
    echo "${backup_root}/openclaw-permission-last.json"
  }

  openclaw_permission_require_openclaw() {
    if ! openclaw_has_command openclaw; then
      echo "❌ 未检测到 openclaw 命令，请先安装或初始化 OpenClaw。"
      return 1
    fi
    return 0
  }

  openclaw_permission_backup_current() {
    local config_file backup_file
    config_file=$(openclaw_permission_config_file)
    backup_file=$(openclaw_permission_backup_file)
    if [ ! -s "$config_file" ]; then
      echo "⚠️ 未找到 OpenClaw 配置文件，跳过权限备份。"
      return 1
    fi
    mkdir -p "$(dirname "$backup_file")"
    cp -f "$config_file" "$backup_file" >/dev/null 2>&1 || {
      echo "⚠️ 权限备份失败：$backup_file"
      return 1
    }
    echo "✅ 已备份当前权限配置: $backup_file"
    return 0
  }

  openclaw_permission_restore_backup() {
    local config_file backup_file
    config_file=$(openclaw_permission_config_file)
    backup_file=$(openclaw_permission_backup_file)
    if [ ! -s "$backup_file" ]; then
      echo "❌ 未找到可恢复的权限备份文件。"
      return 1
    fi
    cp -f "$backup_file" "$config_file" >/dev/null 2>&1 || {
      echo "❌ 权限恢复失败：$backup_file"
      return 1
    }
    echo "✅ 已恢复切换前权限配置"
    openclaw_permission_restart_gateway || true
    return 0
  }

  openclaw_permission_restart_gateway() {
    if ! openclaw_has_command openclaw; then
      echo "❌ 未检测到 openclaw，无法重启 OpenClaw Gateway。"
      return 1
    fi
    echo "正在重启 OpenClaw Gateway..."
    openclaw gateway restart >/dev/null 2>&1 || {
      openclaw gateway stop >/dev/null 2>&1
      openclaw gateway start >/dev/null 2>&1
    }
  }

  openclaw_permission_get_value() {
    local path="$1"
    local config_file
    config_file=$(openclaw_permission_config_file)

    if openclaw_has_command openclaw; then
      local value
      value=$(openclaw config get "$path" 2>&1 | head -n 1)
      if [ -n "$value" ]; then
        if echo "$value" | grep -qi "config path not found"; then
          echo "(unset)"
          return 0
        fi
        if [ "$value" = "null" ]; then
          echo "(unset)"
        else
          if echo "$value" | grep -q '^".*"$'; then
            value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//')
          fi
          echo "$value"
        fi
        return 0
      fi
    fi

    [ -f "$config_file" ] || { echo "(unset)"; return 0; }

    if openclaw_has_command jq; then
      local jq_value
      jq_value=$(jq -r --arg p "$path" 'getpath($p|split(".")) // "(unset)"' "$config_file" 2>/dev/null) || jq_value="(unset)"
      [ "$jq_value" = "null" ] && jq_value="(unset)"
      echo "$jq_value"
      return 0
    fi

    if openclaw_has_command python3; then
      python3 - "$config_file" "$path" <<'PY'
import json, sys
path = sys.argv[2]
with open(sys.argv[1], 'r', encoding='utf-8') as f:
    obj = json.load(f)
cur = obj
for part in path.split('.'):
    if isinstance(cur, dict) and part in cur:
        cur = cur[part]
    else:
        print('(unset)')
        raise SystemExit(0)
if isinstance(cur, bool):
    print('true' if cur else 'false')
elif cur is None:
    print('(unset)')
else:
    print(json.dumps(cur, ensure_ascii=False) if isinstance(cur, (dict, list)) else str(cur))
PY
      return 0
    fi

    echo "(unset)"
    return 0
  }

  openclaw_permission_unset_optional() {
    local key="$1"
    local probe
    if ! openclaw_has_command openclaw; then
      return 1
    fi
    if openclaw config unset "$key" >/dev/null 2>&1; then
      return 0
    fi
    probe=$(openclaw config get "$key" 2>&1 | head -n 1)
    if [ -z "$probe" ] || [ "$probe" = "null" ] || [ "$probe" = "(unset)" ] || echo "$probe" | grep -qi "config path not found"; then
      return 0
    fi
    return 1
  }

  openclaw_permission_detect_mode() {
    local config_file
    config_file=$(openclaw_permission_config_file)
    [ ! -f "$config_file" ] && { echo "未知模式"; return; }

    python3 - "$config_file" <<'PY'
import json, sys

def get_v(o, p):
    for k in p.split('.'):
        if isinstance(o, dict) and k in o:
            o = o[k]
        else:
            return "(unset)"
    return str(o).lower()

try:
    with open(sys.argv[1], 'r', encoding='utf-8') as f:
        d = json.load(f)
    p = get_v(d, "tools.profile")
    s = get_v(d, "tools.exec.security")
    a = get_v(d, "tools.exec.ask")
    e = get_v(d, "tools.elevated.enabled")
    b = get_v(d, "commands.bash")
    ap = get_v(d, "tools.exec.applyPatch.enabled")
    w = get_v(d, "tools.exec.applyPatch.workspaceOnly")

    if p == "coding" and s == "allowlist" and a == "on-miss" and e == "false" and b == "false" and ap == "false":
        print("标准安全模式")
    elif p == "coding" and s == "allowlist" and a == "on-miss" and e == "true" and b == "true" and ap == "true" and w == "true":
        print("开发增强模式")
    elif (p == "full" or p == "(unset)") and s == "full" and a == "off" and e == "true" and b == "true" and ap == "true":
        print("完全开放模式")
    else:
        print("自定义模式")
except Exception:
    print("自定义模式")
PY
  }

    openclaw_permission_update_exec_approvals() {
    local sec="$1"
    local ask="$2"
    local fallback="$3"
    local approvals_file="$HOME/.openclaw/exec-approvals.json"

    mkdir -p "$HOME/.openclaw"

    # 生成 JSON 并通过 openclaw approvals set --stdin 写入（优先）
    # 若 CLI 不支持则回退直接写文件
    local json_payload
    json_payload=$(python3 -c '
import json, sys, os
path = sys.argv[1]
try:
    if os.path.exists(path):
        with open(path, "r") as f:
            data = json.load(f)
    else:
        data = {"version": 1, "defaults": {}}
except Exception:
    data = {"version": 1, "defaults": {}}
if "defaults" not in data:
    data["defaults"] = {}
data["defaults"]["security"] = sys.argv[2]
data["defaults"]["ask"] = sys.argv[3]
data["defaults"]["askFallback"] = sys.argv[4]
data["defaults"]["autoAllowSkills"] = True
print(json.dumps(data, indent=2))
' "$approvals_file" "$sec" "$ask" "$fallback")

    if openclaw_has_command openclaw && echo "$json_payload" | openclaw approvals set --stdin >/dev/null 2>&1; then
      return 0
    fi
    # 回退：直接写文件
    echo "$json_payload" > "$approvals_file"
  }

  openclaw_permission_render_status() {
    skpl_ui_section "配置路径"
    skpl_ui_kv "应用层配置" "~/.openclaw/openclaw.json"
    skpl_ui_kv "宿主机审批" "~/.openclaw/exec-approvals.json"
    skpl_ui_rule "$gl_hui" "─" 60
    local current_profile current_sec current_ask current_elevated
    current_profile=$(openclaw config get tools.profile 2>/dev/null | head -n 1 | sed 's/^"//;s/"$//')
    current_sec=$(openclaw config get tools.exec.security 2>/dev/null | head -n 1 | sed 's/^"//;s/"$//')
    current_ask=$(openclaw config get tools.exec.ask 2>/dev/null | head -n 1 | sed 's/^"//;s/"$//')
    current_elevated=$(openclaw config get tools.elevated.enabled 2>/dev/null | head -n 1 | sed 's/^"//;s/"$//')
    # 清理空值
    [ -z "$current_profile" ] || echo "$current_profile" | grep -qi "config path not found" && current_profile=""
    [ -z "$current_sec" ] || echo "$current_sec" | grep -qi "config path not found" && current_sec=""
    [ -z "$current_ask" ] || echo "$current_ask" | grep -qi "config path not found" && current_ask=""
    [ -z "$current_elevated" ] || echo "$current_elevated" | grep -qi "config path not found" && current_elevated=""

    local current_mode="未知 / 自定义"
    if [ "$current_profile" = "full" ] && [ "$current_sec" = "full" ] && [ "$current_ask" = "off" ]; then
      current_mode="\033[1;31m完全开放模式\033[0m"
    elif [ "$current_profile" = "coding" ] && [ "$current_sec" = "allowlist" ] && [ "$current_ask" = "on-miss" ] && [ "$current_elevated" = "true" ]; then
      current_mode="\033[1;33m开发增强模式\033[0m"
    elif [ "$current_profile" = "coding" ] && [ "$current_sec" = "allowlist" ] && [ "$current_ask" = "on-miss" ] && [ "$current_elevated" != "true" ]; then
      current_mode="\033[1;32m标准安全模式\033[0m"
    elif [ -z "$current_profile" ] && [ -z "$current_sec" ]; then
      current_mode="\033[1;36m官方沙盒兜底\033[0m"
    fi
    echo -e "  当前综合安全等级: ${current_mode}"
    skpl_ui_rule "$gl_hui" "─" 60
    echo -e "${gl_huang}[应用层 Tool Policy 状态]${gl_bai}"
    echo "  Profile (预设): ${current_profile:-(unset)}"
    echo "  Exec 限制: ${current_sec:-(unset)}"
    echo "  审批提示: ${current_ask:-(unset)}"
    echo "  提权开关: ${current_elevated:-(unset)}"

    echo -e "\n${gl_huang}[底层 Exec Approvals 状态]${gl_bai}"
    if openclaw_has_command openclaw; then
      local approvals_json
      approvals_json=$(openclaw approvals get --json 2>/dev/null)
      if [ -n "$approvals_json" ]; then
        python3 -c '
import json, sys
try:
    d = json.loads(sys.argv[1])
    defaults = d.get("file", {}).get("defaults", {})
    if not defaults:
        defaults = d.get("defaults", {})
    sec = defaults.get("security", "(unset)")
    ask = defaults.get("ask", "(unset)")
    fb = defaults.get("askFallback", "(unset)")
    auto = defaults.get("autoAllowSkills", False)
    print("  拦截策略 (Security): " + str(sec))
    print("  提示策略 (Ask): " + str(ask))
    print("  无UI兜底 (AskFallback): " + str(fb))
    print("  自动放行技能 (autoAllowSkills): " + ("on" if auto else "off"))
    exists = d.get("exists", True)
    if not exists:
        print("  (审批文件不存在，使用系统内置安全兜底)")
except Exception as e:
    print("  (解析失败: " + str(e) + ")")
' "$approvals_json"
      else
        echo "  (openclaw approvals get --json 无输出)"
      fi
    elif [ -f "$HOME/.openclaw/exec-approvals.json" ]; then
      python3 -c '
import json, os
path = os.path.expanduser("~/.openclaw/exec-approvals.json")
try:
    with open(path) as f:
        d = json.load(f).get("defaults", {})
    print("  拦截策略 (Security): " + str(d.get("security", "(unset)")))
    print("  提示策略 (Ask): " + str(d.get("ask", "(unset)")))
    print("  无UI兜底 (AskFallback): " + str(d.get("askFallback", "(unset)")))
except Exception:
    print("  (配置文件解析失败)")
'
    else
      echo "  (未配置，强制使用系统内置安全兜底策略)"
    fi
  }

  openclaw_permission_apply_standard() {
    send_stats "OpenClaw权限-标准安全模式"
    openclaw_permission_require_openclaw || return 1

    echo "正在配置应用层策略..."
    openclaw config set tools.profile coding >/dev/null 2>&1
    openclaw config set tools.exec.security allowlist >/dev/null 2>&1
    openclaw config set tools.exec.ask on-miss >/dev/null 2>&1
    openclaw config set tools.elevated.enabled false >/dev/null 2>&1
    openclaw config set tools.exec.strictInlineEval true >/dev/null 2>&1  # 拦截危险的内联代码
    openclaw config unset commands.bash >/dev/null 2>&1 # 废弃旧版参数

    echo "正在配置宿主机审批拦截..."
    openclaw_permission_update_exec_approvals "allowlist" "on-miss" "deny"

    openclaw_permission_restart_gateway
    echo -e "${gl_lv}✅ 已切换为标准安全模式 (所有危险命令将通过UI/TG请求你的审批)${gl_bai}"
  }

  openclaw_permission_apply_developer() {
    send_stats "OpenClaw权限-开发增强模式"
    openclaw_permission_require_openclaw || return 1

    echo "正在配置应用层策略..."
    openclaw config set tools.profile coding >/dev/null 2>&1
    openclaw config set tools.exec.security allowlist >/dev/null 2>&1
    openclaw config set tools.exec.ask on-miss >/dev/null 2>&1
    openclaw config set tools.elevated.enabled true >/dev/null 2>&1 # 允许智能体申请提权
    openclaw config set tools.exec.strictInlineEval false >/dev/null 2>&1

    echo "正在配置宿主机审批拦截..."
    openclaw_permission_update_exec_approvals "allowlist" "on-miss" "deny"

    openclaw_permission_restart_gateway
    echo -e "${gl_lv}✅ 已切换为开发增强模式 (允许提权，但常规危险命令依然需要审批)${gl_bai}"
  }

  openclaw_permission_apply_full() {
    send_stats "OpenClaw权限-完全开放模式"
    openclaw_permission_require_openclaw || return 1

    echo "正在配置应用层策略..."
    openclaw config set tools.profile full >/dev/null 2>&1
    openclaw config set tools.exec.security full >/dev/null 2>&1
    openclaw config set tools.exec.ask off >/dev/null 2>&1
    openclaw config set tools.elevated.enabled true >/dev/null 2>&1
    openclaw config set tools.exec.strictInlineEval false >/dev/null 2>&1

    echo "正在瓦解宿主机拦截防御..."
    # 这里的 full 和 off 将彻底绕过底层宿主机的 exec 审批系统
    openclaw_permission_update_exec_approvals "full" "off" "full"

    openclaw_permission_restart_gateway
    echo -e "${gl_lv}✅ 已切换为完全开放模式 (警告：所有宿主机命令拦截已失效，智能体具有最高权限)${gl_bai}"
  }

  openclaw_permission_restore_official_defaults() {
    send_stats "OpenClaw权限-恢复官方默认"
    openclaw_permission_require_openclaw || return 1

    echo "清理应用层强制覆盖..."
    openclaw config unset tools.profile >/dev/null 2>&1
    openclaw config unset tools.exec.security >/dev/null 2>&1
    openclaw config unset tools.exec.ask >/dev/null 2>&1
    openclaw config unset tools.elevated.enabled >/dev/null 2>&1
    openclaw config unset tools.exec.strictInlineEval >/dev/null 2>&1

    echo "清理宿主机拦截配置..."
    # 优先通过 CLI 清空审批配置，回退直接删文件
    if echo '{"version":1,"defaults":{}}' | openclaw approvals set --stdin >/dev/null 2>&1; then
      true
    else
      rm -f "$HOME/.openclaw/exec-approvals.json"
    fi

    openclaw_permission_restart_gateway
    echo -e "${gl_lv}✅ 已恢复到 OpenClaw 官方安全沙盒防御机制${gl_bai}"
  }

  openclaw_permission_run_audit() {
    clear
    skpl_ui_header "安全审计与修复" "调用 OpenClaw 官方体检并按需执行修复"
    openclaw security audit
    echo
    read -e -p "是否尝试自动修复发现的安全隐患？(y/n): " fix_choice
    if [[ "$fix_choice" == "y" || "$fix_choice" == "Y" || "$fix_choice" == "yes" ]]; then
      openclaw security audit --fix
      echo -e "${gl_lv}✅ 自动修复完成。${gl_bai}"
    fi
    echo "按任意键返回..."
    read -n 1 -s
  }


  openclaw_permission_manage_allowlist() {
    while true; do
      clear
      skpl_ui_header "Exec 命令白名单" "管理 allowlist 放行规则"
      skpl_ui_section "当前白名单"
      local allowlist_json
      allowlist_json=$(openclaw approvals get --json 2>/dev/null)
      if [ -n "$allowlist_json" ]; then
        python3 -c '
import json, sys
try:
    d = json.loads(sys.argv[1])
    f = d.get("file", {})
    agents = f.get("agents", {})
    found = False
    for agent_id, agent_data in agents.items():
        al = agent_data.get("allowlist", [])
        if al:
            found = True
            print("  智能体 [%s]:" % agent_id)
            for item in al:
                print("    - %s" % item)
    if not found:
        print("  (空，未配置任何白名单规则)")
except Exception as e:
    print("  (解析失败: " + str(e) + ")")
' "$allowlist_json"
      else
        echo "  (无法获取)"
      fi
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "添加白名单规则" "支持 glob，如 /usr/bin/git"
      skpl_ui_menu_item 2 "移除白名单规则" "从 allowlist 删除命令路径"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请选择: "
      read -e al_choice
      case "$al_choice" in
        1)
          read -e -p "输入要放行的命令路径 (支持 glob，如 /usr/bin/git): " pattern
          [ -z "$pattern" ] && { echo "不能为空"; break_end; continue; }
          read -e -p "指定智能体ID (留空=所有智能体 *): " agent_id
          agent_id="${agent_id:-*}"
          openclaw approvals allowlist add --agent "$agent_id" "$pattern"
          break_end
          ;;
        2)
          read -e -p "输入要移除的命令路径: " pattern
          [ -z "$pattern" ] && { echo "不能为空"; break_end; continue; }
          openclaw approvals allowlist remove "$pattern"
          break_end
          ;;
        0) return 0 ;;
        *) echo "无效选择"; sleep 1 ;;
      esac
    done
  }

  openclaw_permission_menu() {
    send_stats "OpenClaw权限管理"
    while true; do
      clear
      skpl_ui_header "权限管理" "策略、审批与白名单"
      openclaw_permission_render_status
      echo
      skpl_ui_section "模式切换"
      skpl_ui_menu_item_tone 1 "标准安全模式" "日常推荐，弹卡片审批" "ok"
      skpl_ui_menu_item_tone 2 "开发增强模式" "允许智能体申请提权" "warn"
      skpl_ui_menu_item_tone 3 "完全开放模式" "高风险，解除宿主机拦截" "danger"
      skpl_ui_menu_item 4 "恢复官方默认" "恢复初始沙盒防御策略"
      skpl_ui_menu_item 5 "安全审计与修复" "检查并自动修复"
      skpl_ui_menu_item 6 "Exec 命令白名单" "管理 allowlist"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e perm_choice
      case "$perm_choice" in
        1)
          echo "准备应用：标准安全模式"
          read -e -p "输入 yes 确认: " confirm
          if [ "$confirm" = "yes" ]; then openclaw_permission_apply_standard; else echo "已取消"; fi
          break_end
          ;;
        2)
          echo "准备应用：开发增强模式"
          read -e -p "输入 yes 确认: " confirm
          if [ "$confirm" = "yes" ]; then openclaw_permission_apply_developer; else echo "已取消"; fi
          break_end
          ;;
        3)
          skpl_ui_alert "danger" "完全开放模式会彻底瓦解 exec 审批并自动放行高危代码。" "仅适用于你明确知晓风险并需要最高权限的场景。"
          read -e -p "输入 FULL 确认继续: " confirm
          if [ "$confirm" = "FULL" ]; then openclaw_permission_apply_full; else echo "已取消"; fi
          break_end
          ;;
        4)
          echo "将清除所有定制覆盖，恢复 OpenClaw 刚安装时的严格沙盒状态。"
          read -e -p "输入 yes 确认: " confirm
          if [ "$confirm" = "yes" ]; then openclaw_permission_restore_official_defaults; else echo "已取消"; fi
          break_end
          ;;
        5)
          openclaw_permission_run_audit
          ;;
        6)
          openclaw_permission_manage_allowlist
          ;;
        0)
          return 0
          ;;
        *)
          echo "无效的选择，请重试。"
          sleep 1
          ;;
      esac
    done
  }

  openclaw_multiagent_config_file() {
    local config_file
    config_file=$(openclaw_permission_config_file)
    if [ -s "$config_file" ]; then
      echo "$config_file"
      return 0
    fi
    openclaw config file 2>/dev/null | tail -n 1
  }

  openclaw_multiagent_default_agent() {
    local config_file
    config_file=$(openclaw_permission_config_file)
    if [ -s "$config_file" ]; then
      python3 - "$config_file" <<'PY'
import json,sys,os
path=sys.argv[1]
value="(unset)"
try:
    with open(path) as f:
        data=json.load(f)
    defaults=data.get("agents",{}).get("defaults",{}) if isinstance(data,dict) else {}
    value=defaults.get("agent") or None
    if not value:
        for item in data.get("agents",{}).get("list",[]) or []:
            if isinstance(item,dict) and (item.get("isDefault") or item.get("default")):
                value=item.get("id")
                break
    if not value:
        for item in data.get("agents",{}).get("list",[]) or []:
            if isinstance(item,dict) and item.get("id"):
                value=item.get("id")
                break
except Exception:
    value="(unset)"
print(value or "(unset)")
PY
      return 0
    fi
    local value
    value=$(openclaw config get agents.defaults.agent 2>&1 | head -n 1)
    if [ -z "$value" ] || echo "$value" | grep -qi "config path not found"; then
      value=$(openclaw agents list --json 2>/dev/null | python3 -c 'import json,sys
try:
 data=json.load(sys.stdin)
 print(next((x.get("id","(unset)") for x in data if x.get("isDefault")), "(unset)"))
except Exception:
 print("(unset)")' 2>/dev/null)
    fi
    [ -z "$value" ] && value="(unset)"
    if echo "$value" | grep -q '^".*"$'; then
      value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//')
    fi
    echo "$value"
  }

  openclaw_multiagent_require_openclaw() {
    if ! openclaw_has_command openclaw; then
      echo "❌ 未检测到 openclaw 命令，请先安装或初始化 OpenClaw。"
      return 1
    fi
    return 0
  }

  openclaw_multiagent_write_cache() {
    local cache_file="$1"
    local payload="$2"
    printf '%s' "$payload" > "$cache_file"
  }

  openclaw_multiagent_refresh_runtime_cache() {
    local result rc=0
    echo "正在刷新多智能体运行时缓存..."

    if openclaw_has_command openclaw; then
      result=$(timeout 8 openclaw agents list --json 2>/dev/null || true)
      if [ -n "$result" ] && python3 -c "import json,sys; json.loads(sys.argv[1])" "$result" 2>/dev/null; then
        openclaw_multiagent_write_cache "$SKPL_MULTIAGENT_AGENTS_CACHE_FILE" "$result"
      else
        rc=1
      fi

      result=$(timeout 8 openclaw agents bindings --json 2>/dev/null || true)
      if [ -n "$result" ] && python3 -c "import json,sys; json.loads(sys.argv[1])" "$result" 2>/dev/null; then
        openclaw_multiagent_write_cache "$SKPL_MULTIAGENT_BINDINGS_CACHE_FILE" "$result"
      else
        rc=1
      fi

      result=$(timeout 8 bash -lc "openclaw sessions --json 2>/dev/null | grep -v '^\\['" || true)
      if [ -n "$result" ] && python3 -c "import json,sys; json.loads(sys.argv[1])" "$result" 2>/dev/null; then
        openclaw_multiagent_write_cache "$SKPL_MULTIAGENT_SESSIONS_CACHE_FILE" "$result"
      else
        rc=1
      fi
    else
      rc=1
    fi

    if [ $rc -eq 0 ]; then
      echo "✅ 多智能体缓存已刷新"
    else
      echo "⚠️ 运行时缓存刷新未完全成功，当前将继续使用本地配置或旧缓存。"
    fi
    return 0
  }

  openclaw_multiagent_agents_json() {
    local result
    if [ -s "$SKPL_MULTIAGENT_AGENTS_CACHE_FILE" ] && openclaw_memory_cache_fresh "$SKPL_MULTIAGENT_AGENTS_CACHE_FILE" 60; then
      cat "$SKPL_MULTIAGENT_AGENTS_CACHE_FILE"
      return 0
    fi
    # 回退：从配置文件读取
    local config_file
    config_file=$(openclaw_permission_config_file)
    if [ -s "$config_file" ]; then
      result=$(python3 - "$config_file" <<'PY'
import json,sys,os
path=sys.argv[1]
try:
    with open(path) as f:
        data=json.load(f)
    agents=data.get("agents",{}).get("list",[])
    if not isinstance(agents,list):
        agents=[]
    print(json.dumps(agents, ensure_ascii=False))
except Exception:
    print("[]")
PY
)
      openclaw_multiagent_write_cache "$SKPL_MULTIAGENT_AGENTS_CACHE_FILE" "$result"
      echo "$result"
      return 0
    fi
    echo '[]'
  }

  openclaw_multiagent_bindings_json() {
    local result
    if [ -s "$SKPL_MULTIAGENT_BINDINGS_CACHE_FILE" ] && openclaw_memory_cache_fresh "$SKPL_MULTIAGENT_BINDINGS_CACHE_FILE" 60; then
      cat "$SKPL_MULTIAGENT_BINDINGS_CACHE_FILE"
      return 0
    fi
    # 回退：从配置文件读取
    local config_file
    config_file=$(openclaw_permission_config_file)
    if [ -s "$config_file" ]; then
      result=$(python3 - "$config_file" <<'PY'
import json,sys
path=sys.argv[1]
try:
    with open(path) as f:
        data=json.load(f)
    bindings=data.get("agents",{}).get("bindings",[])
    if not isinstance(bindings,list):
        bindings=[]
    results=[]
    for item in bindings:
        if not isinstance(item,dict):
            continue
        results.append({"agentId": item.get("agentId") or item.get("agent") or "?", "description": item.get("description") or "-"})
    print(json.dumps(results, ensure_ascii=False))
except Exception:
    print("[]")
PY
)
      openclaw_multiagent_write_cache "$SKPL_MULTIAGENT_BINDINGS_CACHE_FILE" "$result"
      echo "$result"
      return 0
    fi
    echo '[]'
  }

  openclaw_multiagent_sessions_json() {
    local result
    if [ -s "$SKPL_MULTIAGENT_SESSIONS_CACHE_FILE" ] && openclaw_memory_cache_fresh "$SKPL_MULTIAGENT_SESSIONS_CACHE_FILE" 60; then
      cat "$SKPL_MULTIAGENT_SESSIONS_CACHE_FILE"
      return 0
    fi
    # 回退：从文件系统读取
    result=$(python3 <<'PY'
import json,os
base=os.path.expanduser("~/.openclaw/agents")
sessions=[]
try:
    agent_dirs=[d for d in os.listdir(base) if os.path.isdir(os.path.join(base,d))]
except Exception:
    agent_dirs=[]
for agent_id in agent_dirs:
    path=os.path.join(base,agent_id,"sessions","sessions.json")
    if not os.path.exists(path):
        continue
    try:
        with open(path) as f:
            data=json.load(f)
    except Exception:
        continue
    if isinstance(data,dict):
        items=data.items()
    elif isinstance(data,list):
        items=[(item.get("key") or "?", item) for item in data if isinstance(item,dict)]
    else:
        continue
    for key,item in items:
        if not isinstance(item,dict):
            continue
        model=item.get("model") or "-"
        sessions.append({"agentId": agent_id, "key": key, "model": model})
print(json.dumps({"path":"(filesystem)","count":len(sessions),"sessions":sessions}, ensure_ascii=False))
PY
)
    openclaw_multiagent_write_cache "$SKPL_MULTIAGENT_SESSIONS_CACHE_FILE" "$result"
    echo "$result"
  }

  openclaw_multiagent_render_status() {
    local config_file default_agent cache_note=""
    config_file=$(openclaw_multiagent_config_file)
    default_agent=$(openclaw_multiagent_default_agent)
    if [ -s "$SKPL_MULTIAGENT_AGENTS_CACHE_FILE" ] && ! openclaw_memory_cache_fresh "$SKPL_MULTIAGENT_AGENTS_CACHE_FILE" 60; then
      cache_note="当前显示缓存或本地配置视图，可手动刷新运行时信息。"
    fi
    echo "配置文件: ${config_file:-$(openclaw_permission_config_file)}"
    echo "默认智能体: $default_agent"
    [ -n "$cache_note" ] && echo "$cache_note"
    python3 -c '
import json,sys
agents=json.loads(sys.argv[1] or "[]")
bindings=json.loads(sys.argv[2] or "[]")
sess_obj=json.loads(sys.argv[3] or "{}")
sessions=sess_obj.get("sessions",[]) if isinstance(sess_obj,dict) else []
print("已配置智能体数: %s" % len(agents))
print("路由绑定数: %s" % len(bindings))
print("会话总数: %s" % len(sessions))
print("---------------------------------------")
if not agents:
    print("当前未配置任何多智能体。")
else:
    for item in agents[:8]:
        aid = item.get("id","?")
        identity = item.get("identityName") or item.get("name") or "-"
        emoji = item.get("identityEmoji") or ""
        ws = item.get("workspace") or "-"
        model = item.get("model") or "-"
        is_default = item.get("isDefault", False)
        bcount = item.get("bindings", 0)
        default_tag = " [默认]" if is_default else ""
        print("- 智能体ID: \033[1;36m%s\033[0m%s" % (aid, default_tag))
        print("  身份名称: %s %s" % (identity, emoji))
        print("  模型: %s" % model)
        print("  工作目录: %s" % ws)
        print("  绑定数: %s" % bcount)
' "$(openclaw_multiagent_agents_json)" "$(openclaw_multiagent_bindings_json)" "$(openclaw_multiagent_sessions_json)"
  }

  openclaw_multiagent_list_agents() {
    send_stats "OpenClaw多智能体-列出Agent"
    python3 -c 'import json,sys; agents=json.loads(sys.argv[1] or "[]");
if not agents: print("暂无已配置 Agent。"); raise SystemExit(0)
for idx,item in enumerate(agents,1):
 print("%s. %s" % (idx, item.get("id","?"))); print("   workspace : %s" % item.get("workspace","-")); ident=(item.get("identityName") or "-") + ((" " + item.get("identityEmoji")) if item.get("identityEmoji") else ""); print("   identity  : %s" % ident.strip()); print("   model     : %s" % (item.get("model") or "-")); print("   bindings  : %s" % item.get("bindings",0)); print("   default   : %s" % ("yes" if item.get("isDefault") else "no"))' "$(openclaw_multiagent_agents_json)"
  }

  openclaw_multiagent_add_agent() {
    send_stats "OpenClaw多智能体-新增Agent"
    openclaw_multiagent_require_openclaw || return 1
    local agent_id workspace confirm
    read -e -p "请输入新的 Agent ID: " agent_id
    [ -z "$agent_id" ] && echo "已取消：Agent ID 不能为空。" && return 1
    read -e -p "请输入 workspace 路径（默认 ~/.openclaw/workspace-${agent_id}）: " workspace
    [ -z "$workspace" ] && workspace="~/.openclaw/workspace-${agent_id}"
    echo "将创建智能体: $agent_id"
    echo "工作目录: $workspace"
    read -e -p "输入 yes 确认继续: " confirm
    [ "$confirm" = "yes" ] || { echo "已取消"; return 1; }
    if openclaw agents add "$agent_id" --workspace "$workspace"; then
      echo "✅ 智能体创建成功: $agent_id"
      local name theme
      read -e -p "请输入智能体身份名称 (如: 代码专家): " name
      [ -z "$name" ] && name="$agent_id"
      read -e -p "请输入智能体性格主题 (如: 严谨、高效): " theme
      [ -z "$theme" ] && theme="助手"
      echo "正在配置智能体身份..."
      openclaw agents set-identity --agent "$agent_id" --name "$name" --theme "$theme"
      openclaw_multiagent_refresh_runtime_cache >/dev/null 2>&1 || true
    else
      echo "❌ 智能体创建失败"
      return 1
    fi
  }

  openclaw_multiagent_delete_agent() {
    send_stats "OpenClaw多智能体-删除Agent"
    openclaw_multiagent_require_openclaw || return 1
    local agent_id confirm
    read -e -p "请输入要删除的 Agent ID: " agent_id
    [ -z "$agent_id" ] && echo "已取消：Agent ID 不能为空。" && return 1
    echo "⚠️ 删除智能体可能影响其工作目录、路由绑定与会话路由。"
    read -e -p "输入 DELETE 确认删除 ${agent_id}: " confirm
    [ "$confirm" = "DELETE" ] || { echo "已取消"; return 1; }
    if openclaw agents delete "$agent_id"; then
      echo "✅ 智能体删除成功: $agent_id"
      openclaw_multiagent_refresh_runtime_cache >/dev/null 2>&1 || true
    else
      echo "❌ 智能体删除失败"
      return 1
    fi
  }

  openclaw_multiagent_list_bindings() {
    send_stats "OpenClaw多智能体-查看路由绑定"
    python3 -c '
import json,sys
bindings=json.loads(sys.argv[1] or "[]")
if not bindings:
    print("暂无路由绑定。")
    raise SystemExit(0)
for idx,item in enumerate(bindings,1):
    desc = item.get("description") or "-"
    print("%s. agent=%s | %s" % (idx, item.get("agentId","?"), desc))
' "$(openclaw_multiagent_bindings_json)"
  }

  openclaw_multiagent_add_binding() {
    send_stats "OpenClaw多智能体-新增路由绑定"
    openclaw_multiagent_require_openclaw || return 1
    local agent_id bind_value confirm
    read -e -p "请输入智能体 ID: " agent_id
    read -e -p "请输入路由绑定值（如 telegram:ops / discord:guild-a）: " bind_value
    { [ -z "$agent_id" ] || [ -z "$bind_value" ]; } && echo "已取消：参数不能为空。" && return 1
    echo "将绑定智能体 [$agent_id] -> [$bind_value]"
    read -e -p "输入 yes 确认继续: " confirm
    [ "$confirm" = "yes" ] || { echo "已取消"; return 1; }
    if openclaw agents bind --agent "$agent_id" --bind "$bind_value"; then
      echo "✅ 路由绑定添加成功"
      openclaw_multiagent_refresh_runtime_cache >/dev/null 2>&1 || true
    else
      echo "❌ 路由绑定添加失败"
      return 1
    fi
  }

  openclaw_multiagent_remove_binding() {
    send_stats "OpenClaw多智能体-移除路由绑定"
    openclaw_multiagent_require_openclaw || return 1
    local agent_id bind_value confirm
    read -e -p "请输入智能体 ID: " agent_id
    read -e -p "请输入要移除的路由绑定值: " bind_value
    { [ -z "$agent_id" ] || [ -z "$bind_value" ]; } && echo "已取消：参数不能为空。" && return 1
    echo "将移除智能体 [$agent_id] 的路由绑定 [$bind_value]"
    read -e -p "输入 yes 确认继续: " confirm
    [ "$confirm" = "yes" ] || { echo "已取消"; return 1; }
    if openclaw agents unbind --agent "$agent_id" --bind "$bind_value"; then
      echo "✅ 路由绑定移除成功"
      openclaw_multiagent_refresh_runtime_cache >/dev/null 2>&1 || true
    else
      echo "❌ 路由绑定移除失败"
      return 1
    fi
  }


  openclaw_multiagent_show_sessions() {
    send_stats "OpenClaw多智能体-会话概况"
    python3 -c '
import json,sys
sess_obj=json.loads(sys.argv[1] or "{}")
sessions=sess_obj.get("sessions",[]) if isinstance(sess_obj,dict) else []
if not sessions:
    print("暂无 session 数据。")
    raise SystemExit(0)
by_agent={}
for item in sessions:
    aid = item.get("agentId","?")
    by_agent[aid] = by_agent.get(aid, 0) + 1
print("会话汇总:")
for agent_id,count in sorted(by_agent.items()):
    print("- %s: %s" % (agent_id, count))
print("---------------------------------------")
for item in sessions[:10]:
    key = item.get("key","-")
    model = item.get("model") or "-"
    aid = item.get("agentId","?")
    tokens = ""
    it = item.get("inputTokens")
    ot = item.get("outputTokens")
    if it is not None:
        tokens = " | in=%s out=%s" % (it, ot or 0)
    print("%s | %s | %s%s" % (aid, key, model, tokens))
' "$(openclaw_multiagent_sessions_json)"
  }

  openclaw_multiagent_health_check() {
    send_stats "OpenClaw多智能体-健康检查"
    openclaw_multiagent_require_openclaw || return 1
    local config_file
    config_file=$(openclaw_multiagent_config_file)
    echo "检查配置文件: ${config_file:-$(openclaw_permission_config_file)}"
    openclaw config validate || echo "⚠️ 配置校验未通过，请检查上方输出。"
    python3 -c '
import json,sys,os
agents=json.loads(sys.argv[1] or "[]")
bindings=json.loads(sys.argv[2] or "[]")
print("---------------------------------------")
if not agents:
    print("⚠️ 未发现已配置智能体。")
else:
    for item in agents:
        ws = item.get("workspace") or ""
        aid = item.get("id","?")
        if ws and os.path.isdir(os.path.expanduser(ws)):
            state = "OK"
        elif aid == "main":
            state = "OK"
        else:
            state = "MISSING"
        model = item.get("model") or "-"
        bcount = item.get("bindings", 0)
        print("agent=%s workspace=%s model=%s bindings=%s [%s]" % (aid, ws or "-", model, bcount, state))
print("路由绑定数=%s" % len(bindings))
print("✅ 多智能体健康检查完成")
' "$(openclaw_multiagent_agents_json)" "$(openclaw_multiagent_bindings_json)"
    echo ""
    echo "运行安全审计..."
    openclaw security audit 2>/dev/null || echo "⚠️ 安全审计命令不可用"
  }


  openclaw_multiagent_set_identity() {
    openclaw_multiagent_require_openclaw || return 1
    openclaw_multiagent_list_agents
    read -e -p "输入要修改身份的智能体ID: " agent_id
    [ -z "$agent_id" ] && { echo "ID 不能为空"; return 1; }
    echo "修改选项（留空跳过）："
    read -e -p "  新名称: " new_name
    read -e -p "  新 Emoji: " new_emoji
    local cmd="openclaw agents set-identity --agent $agent_id"
    [ -n "$new_name" ] && cmd="$cmd --name $new_name"
    [ -n "$new_emoji" ] && cmd="$cmd --emoji $new_emoji"
    echo "也可以从 IDENTITY.md 自动读取身份信息。"
    read -e -p "是否从 IDENTITY.md 读取？(y/n): " from_id
    if [ "$from_id" = "y" ]; then
      cmd="openclaw agents set-identity --agent $agent_id --from-identity"
    fi
    eval "$cmd"
    openclaw_multiagent_refresh_runtime_cache >/dev/null 2>&1 || true
  }

  openclaw_multiagent_cleanup_sessions() {
    openclaw_multiagent_require_openclaw || return 1
    echo "即将清理过期/冗余会话数据..."
    read -e -p "输入 yes 确认: " confirm
    [ "$confirm" != "yes" ] && { echo "已取消"; return 0; }
    openclaw sessions cleanup
  }

  openclaw_multiagent_menu() {
    send_stats "OpenClaw多智能体管理"
    while true; do
      clear
      skpl_ui_header "多智能体管理" "智能体、绑定与会话"
      openclaw_multiagent_render_status
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "刷新运行时状态" "更新 agents / bindings / sessions 缓存"
      skpl_ui_menu_item 2 "新增智能体" "创建 Agent 与工作区"
      skpl_ui_menu_item_tone 3 "删除智能体" "移除 Agent 配置" "danger"
      skpl_ui_menu_item 4 "查看路由绑定" "查看当前绑定"
      skpl_ui_menu_item 5 "新增路由绑定" "绑定入口到 Agent"
      skpl_ui_menu_item 6 "移除路由绑定" "解除现有绑定"
      skpl_ui_menu_item 7 "查看会话概况" "会话汇总与模型"
      skpl_ui_menu_item 8 "健康检查" "检查配置与工作区"
      skpl_ui_menu_item 9 "修改智能体身份" "名称 / Emoji / IDENTITY.md"
      skpl_ui_menu_item 10 "清理过期会话" "执行 sessions cleanup"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e multi_choice
      case "$multi_choice" in
        1) openclaw_multiagent_refresh_runtime_cache; break_end ;;
        2) openclaw_multiagent_add_agent; break_end ;;
        3) openclaw_multiagent_delete_agent; break_end ;;
        4) openclaw_multiagent_list_bindings; break_end ;;
        5) openclaw_multiagent_add_binding; break_end ;;
        6) openclaw_multiagent_remove_binding; break_end ;;
        7) openclaw_multiagent_show_sessions; break_end ;;
        8) openclaw_multiagent_health_check; break_end ;;
        9) openclaw_multiagent_set_identity; break_end ;;
        10) openclaw_multiagent_cleanup_sessions; break_end ;;
        0) return 0 ;;
        *) echo "无效的选择，请重试。"; sleep 1 ;;
      esac
    done
  }


openclaw_backup_restore_menu() {

    send_stats "OpenClaw备份与还原"
    while true; do
      clear
      skpl_ui_header "备份与还原" "记忆与项目归档"
      openclaw_backup_render_file_list
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "备份记忆全量" "支持多智能体"
      skpl_ui_menu_item 2 "还原记忆全量" "按包内容恢复"
      skpl_ui_menu_item 3 "备份 OpenClaw 项目" "默认安全模式"
      skpl_ui_menu_item_tone 4 "还原 OpenClaw 项目" "高级 / 高风险" "danger"
      skpl_ui_menu_item_tone 5 "删除备份文件" "从备份目录移除归档" "danger"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e backup_choice

      case "$backup_choice" in
        1) openclaw_memory_backup_export ;;
        2) openclaw_memory_backup_import ;;
        3) openclaw_project_backup_export ;;
        4) openclaw_project_backup_import ;;
        5) openclaw_backup_delete_file ;;
        0) return 0 ;;
        *)
          echo "无效的选择，请重试。"
          sleep 1
          ;;
      esac
    done
  }



  openclaw_evomap_menu() {
    while true; do
      clear
      skpl_ui_header "EvoMap 管理" "安装、更新与记忆目录"
      evomap_print_status
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "安装 EvoMap" "克隆、依赖、初始化"
      skpl_ui_menu_item_tone 2 "卸载 EvoMap" "保留备份后移除" "danger"
      skpl_ui_menu_item 3 "更新 EvoMap" "拉取最新代码并重启"
      skpl_ui_menu_item 4 "EvoMap 记忆管理" "查看目录与备份"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e evomap_choice
      case "$evomap_choice" in
        1) evomap_install; break_end ;;
        2) evomap_uninstall; break_end ;;
        3) evomap_update; break_end ;;
        4) evomap_memory_menu ;;
        0) return 0 ;;
        *) echo "无效的选择，请重试。"; sleep 1 ;;
      esac
    done
  }

  update_openclaw_panel() {
    echo "更新 OpenClaw..."
    send_stats "更新 OpenClaw..."
    install_node_and_tools
    echo "正在更新 OpenClaw CLI..."
    install_openclaw_global
    crontab -l 2>/dev/null | grep -v "s gateway" | crontab -
    start_gateway
    if ! openclaw_gateway_status_quick; then
      echo "⚠️ OpenClaw 网关状态暂未就绪，可稍后在面板中执行健康检测与修复。"
    fi
    hash -r
    add_app_id
    echo "更新完成"
    break_end
  }


  uninstall_openclaw_panel() {
    clear
    skpl_ui_header "卸载 OpenClaw" "移除 CLI、网关服务与当前用户数据目录"
    skpl_ui_alert "danger" "该操作会删除当前用户目录下的 OpenClaw 数据" "如需保留工作区或配置，请先在备份与还原菜单中导出。"
    send_stats "卸载 OpenClaw..."
    remove_openclaw_gateway_service
    openclaw uninstall
    npm uninstall -g openclaw
    crontab -l 2>/dev/null | grep -v "s gateway" | crontab -
    rm -rf "$HOME/.openclaw"
    [ "$HOME" != "/root" ] && [ -d /root/.openclaw ] && echo "⚠️ 检测到 root 目录下仍存在 /root/.openclaw，如需清理请手动处理"
    hash -r
    if [ -f /home/docker/appno.txt ]; then
      sed -i "/\b${app_id}\b/d" /home/docker/appno.txt
    fi
    echo
    skpl_ui_alert "ok" "卸载完成" "OpenClaw CLI、计划任务与当前用户目录已清理。"
    break_end
  }

  nano_openclaw_json() {
    send_stats "编辑 OpenClaw 配置文件"
    install nano
    nano "$(openclaw_get_config_file)"
    start_gateway
  }






  openclaw_find_webui_domain() {
    local conf domain_list

    domain_list=$(
      grep -R "18789" /home/web/conf.d/*.conf 2>/dev/null \
      | awk -F: '{print $1}' \
      | sort -u \
      | while read conf; do
        basename "$conf" .conf
      done
    )

    if [ -n "$domain_list" ]; then
      echo "$domain_list"
    fi
  }

  openclaw_webui_refresh_token_cache() {
    local token
    token=$(timeout 8 openclaw dashboard 2>/dev/null \
      | sed -n 's/.*:18789\/#token=\([^[:space:]"&]\+\).*/\1/p' \
      | head -n 1)
    if [ -n "$token" ]; then
      printf '%s' "$token" > "$SKPL_WEBUI_TOKEN_CACHE_FILE"
      echo "$token"
      return 0
    fi
    return 1
  }

  openclaw_webui_ensure_origins() {
    local config_file tmp_json origins_json
    config_file=$(openclaw_get_config_file)
    [ -f "$config_file" ] || return 0
    command -v jq >/dev/null 2>&1 || return 0
    origins_json=$(python3 - "$@" <<'PY'
import json
import sys

print(json.dumps([origin for origin in sys.argv[1:] if origin]))
PY
)

    tmp_json=$(mktemp)
    if jq '
      .gateway = (.gateway // {})
      | .gateway.controlUi = (.gateway.controlUi // {})
      | .gateway.controlUi.allowedOrigins = (((.gateway.controlUi.allowedOrigins // []) + $origins) | unique)
    ' --argjson origins "$origins_json" "$config_file" > "$tmp_json" && mv "$tmp_json" "$config_file"; then
      return 0
    fi
    rm -f "$tmp_json"
    return 1
  }

  openclaw_webui_ensure_local_origins() {
    openclaw_webui_ensure_origins "http://127.0.0.1:18789" "http://localhost:18789" "http://127.0.0.1" "http://localhost"
  }

  openclaw_webui_get_cached_token() {
    if [ -s "$SKPL_WEBUI_TOKEN_CACHE_FILE" ]; then
      cat "$SKPL_WEBUI_TOKEN_CACHE_FILE"
      return 0
    fi
    return 1
  }



  openclaw_show_webui_addr() {
    local local_ip token domains

    skpl_ui_header "WebUI 访问设置" "本机访问优先，域名入口按需接入"
    openclaw_webui_ensure_local_origins >/dev/null 2>&1 || true
    local_ip="127.0.0.1"

    token=$(openclaw_webui_get_cached_token 2>/dev/null || true)
    skpl_ui_section "本机地址"
    if [ -n "$token" ]; then
      echo "http://${local_ip}:18789/#token=${token}"
    else
      echo "http://${local_ip}:18789/"
      echo "当前未缓存 token，可在菜单中手动刷新。"
    fi

    domains=$(openclaw_find_webui_domain)
    if [ -n "$domains" ]; then
      echo
      skpl_ui_section "域名地址"
      echo "$domains" | while read d; do
        if [ -n "$token" ]; then
          echo "https://${d}/#token=${token}"
        else
          echo "https://${d}/"
        fi
      done
    fi
  }



  # 添加域名（调用你给的函数）
  openclaw_domain_webui() {
    local proxy_scheme token config_file new_origin tmp_json

    add_yuming
    if ! ldnmp_Proxy "${yuming}" 127.0.0.1 18789; then
      echo "域名代理未自动配置，已停止后续设备配对流程。"
      return 1
    fi
    proxy_scheme="${SKPL_LAST_PROXY_SCHEME:-http}"

    token=$(openclaw_webui_refresh_token_cache 2>/dev/null || openclaw_webui_get_cached_token 2>/dev/null || true)

    clear
    echo "访问地址:"
    echo "${proxy_scheme}://${yuming}/#token=$token"
    echo "先访问URL触发设备ID，然后回车下一步进行配对。"
    read
    echo -e "${gl_kjlan}正在加载设备列表……${gl_bai}"
    # 自动添加域名到 allowedOrigins
    config_file=$(openclaw_get_config_file)
    if [ -f "$config_file" ]; then
      new_origin="${proxy_scheme}://${yuming}"
      # 使用 jq 安全修改 JSON，确保结构存在且不重复添加域名
      if command -v jq >/dev/null 2>&1; then
        if openclaw_webui_ensure_origins "http://127.0.0.1:18789" "http://localhost:18789" "http://127.0.0.1" "http://localhost" "$new_origin"; then
          echo -e "${gl_kjlan}已将域名 ${yuming} 加入 allowedOrigins 配置${gl_bai}"
          openclaw gateway restart >/dev/null 2>&1
        else
          echo "❌ 写入 allowedOrigins 失败，请检查 OpenClaw 配置文件是否为合法 JSON。"
          return 1
        fi
      fi
    fi

    if ! timeout 12 openclaw devices list; then
      echo "❌ 设备列表加载超时或失败，请确认网关已就绪后重试。"
      return 1
    fi

    read -e -p "请输入 Request_Key: " Request_Key

    [ -z "$Request_Key" ] && {
      echo "Request_Key 不能为空"
      return 1
    }

    if ! timeout 12 openclaw devices approve "$Request_Key"; then
      echo "❌ 设备授权超时或失败，请稍后重试。"
      return 1
    fi

  }

  # 删除域名
  openclaw_remove_domain() {
    echo "域名格式 example.com 不带https://"
    web_del
  }

  # 主菜单
  openclaw_webui_menu() {

    send_stats "WebUI访问与设置"
    while true; do
      clear
      openclaw_show_webui_addr
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "刷新访问 Token" "重新获取 dashboard token"
      skpl_ui_menu_item 2 "添加域名访问" "自动写入 allowedOrigins"
      skpl_ui_menu_item_tone 3 "删除域名访问" "移除反向代理域名" "danger"
      skpl_ui_menu_item 0 "退出"
      skpl_ui_footer_prompt "请选择: "
      read -e choice

      case "$choice" in
        1)
          if openclaw_webui_refresh_token_cache >/dev/null 2>&1; then
            echo "✅ WebUI Token 已刷新"
          else
            echo "⚠️ Token 刷新失败，请确认网关与 dashboard 可用"
          fi
          echo
          read -p "按回车返回菜单..."
          ;;
        2)
          openclaw_domain_webui
          echo
          read -p "按回车返回菜单..."
          ;;
        3)
          openclaw_remove_domain
          read -p "按回车返回菜单..."
          ;;
        0)
          break
          ;;
        *)
          echo "无效选项"
          sleep 1
          ;;
      esac
    done
  }



  # 主循环
  while true; do
    show_menu
    read choice
    case $choice in
      1) install_openclaw_panel ;;
      2) start_bot ;;
      3) stop_bot ;;
      4) view_logs ;;
      5) change_model ;;
      6) openclaw_api_manage_menu ;;
      7) change_tg_bot_code ;;
      8) install_plugin ;;
      9) install_skill ;;
      10) nano_openclaw_json ;;
      11) send_stats "初始化配置向导"
        openclaw_run_onboard_wizard
        break_end
        ;;
      12) send_stats "健康检测与修复"
        openclaw doctor --fix
        send_stats "OpenClaw API同步触发"
        if sync_openclaw_api_models; then
          start_gateway
        else
          echo "❌ API 模型同步失败，已中止重启网关。请检查 provider /models 返回后重试。"
        fi
        break_end
        ;;
      13) openclaw_webui_menu ;;
      14) send_stats "TUI命令行对话"
        openclaw tui
        break_end
        ;;
      15) openclaw_memory_menu ;;
      16) openclaw_permission_menu ;;
      17) openclaw_multiagent_menu ;;
      18) openclaw_backup_restore_menu ;;
      19) update_openclaw_panel ;;
      20) uninstall_openclaw_panel ;;
      21) openclaw_evomap_menu ;;
      *) break ;;
    esac
  done

}

OPENCLAW_PANEL_EOF
)"
}

openclaw_enable_local_memory_auto() {
  local model_path bootstrap_log
  model_path="$(openclaw_memory_prepare_prefetch)"

  if [ -f "${model_path}" ]; then
    echo "记忆模型已存在，安装阶段跳过后台预热。"
    return 0
  fi

  bootstrap_log="$(openclaw_memory_prefetch_bootstrap "$model_path")"
  echo "记忆模型将在后台预热下载，不阻塞安装流程。"
  echo "安装阶段不会提前切换到 Local 记忆方案。"
  echo "后台日志: ${bootstrap_log}"
}

install_openclaw_direct() {
  echo "开始直装 OpenClaw..."
  install git jq
  install_node_and_tools

  echo "正在安装 OpenClaw CLI..."
  install_openclaw_global
  if ! ensure_openclaw_cli_on_path >/dev/null 2>&1; then
    echo "OpenClaw CLI 安装失败：未检测到 openclaw 命令。"
    return 1
  fi

  openclaw_onboard_if_needed
  openclaw_ensure_local_gateway_config >/dev/null 2>&1 || true
  refresh_openclaw_gateway_service >/dev/null 2>&1 || true

  if [ "${SKPL_BATCH_MODE:-0}" = "1" ]; then
    echo "批量安装模式：跳过第 2 步网关启动，交由下一步网络优化统一接管。"
    return 0
  fi

  if ! openclaw_ensure_gateway_ready; then
    echo "OpenClaw 网关启动校验未通过。"
    return 1
  fi

  return 0
}

run_openclaw_install_step() {
  prewarm_openclaw_dependencies
  ensure_openclaw_cli_on_path >/dev/null 2>&1 || true
  if ! command -v openclaw >/dev/null 2>&1 || ! openclaw --version >/dev/null 2>&1; then
    install_openclaw_direct
  else
    refresh_runtime_proxy_env
    refresh_openclaw_gateway_service >/dev/null 2>&1 || true
    openclaw gateway status >/dev/null 2>&1 || openclaw_ensure_gateway_ready || true
  fi
}

run_openclaw2_network_optimization() {
  set +e
  echo "执行 openclaw2 网络优化（稳定模式）..."

  local openclaw_js
  refresh_runtime_proxy_env
  openclaw_js=$(resolve_openclaw_js_entry 2>/dev/null || true)

  if [ ! -f "$openclaw_js" ]; then
    npm_try_with_registries install -g openclaw@latest --no-fund --no-audit --loglevel=error --prefer-online --fetch-retries=2 --fetch-timeout=300000 >/dev/null 2>&1 || true
    openclaw_js=$(resolve_openclaw_js_entry 2>/dev/null || true)
  fi

  mkdir -p /root/.config/systemd/user
  mkdir -p /root/.openclaw/credentials /root/.openclaw/logs /root/.openclaw/agents
  chmod 700 /root/.openclaw 2>/dev/null || true

  openclaw_ensure_local_gateway_config >/dev/null 2>&1 || true

  loginctl enable-linger root >/dev/null 2>&1 || true
  openclaw_ensure_gateway_ready >/dev/null 2>&1 || true
  set -e
}

evomap_print_status() {
  skpl_ui_kv "EvoMap 目录" "$EVOMAP_DIR"
  if [ -d "$EVOMAP_DIR" ]; then
    skpl_ui_kv "状态" "已安装"
    if evomap_is_running; then
      skpl_ui_kv "运行状态" "运行中（低优先级）"
    else
      skpl_ui_kv "运行状态" "未运行"
    fi
  else
    skpl_ui_kv "状态" "未安装"
  fi
  skpl_ui_kv "记忆目录" "$EVOMAP_MEMORY_DIR"
  skpl_ui_kv "备份目录" "$EVOMAP_BACKUP_DIR"
}

evomap_backup_current() {
  mkdir -p "$EVOMAP_BACKUP_DIR"
  if [ -d "$EVOMAP_DIR" ]; then
    local backup_path
    backup_path="$EVOMAP_BACKUP_DIR/evolver.$(date +%Y%m%d%H%M%S).tgz"
    tar -czf "$backup_path" -C /root/.openclaw evolver
    echo "已备份 EvoMap: $backup_path"
  fi
}

evomap_is_running() {
  pgrep -f "node .*${EVOMAP_DIR}/index\.js --loop" >/dev/null 2>&1
}

evomap_stop_loop() {
  pkill -f "node .*${EVOMAP_DIR}/index\.js --loop" >/dev/null 2>&1 || true
}

evomap_start_loop() {
  local low_priority_prefix
  low_priority_prefix="$(skpl_low_priority_prefix)"
  evomap_stop_loop
  nohup bash -lc '
    set -e
    evomap_dir="$1"
    low_priority_prefix="$2"
    cd "$evomap_dir"
    exec ${low_priority_prefix}node "$evomap_dir/index.js" --loop
  ' _ "$EVOMAP_DIR" "$low_priority_prefix" > "$EVOMAP_DIR/nohup.out" 2>&1 &
  disown 2>/dev/null || true
}

evomap_refresh_gateway_if_needed() {
  if openclaw_gateway_is_running; then
    echo "OpenClaw 网关已运行，EvoMap 安装不主动重启网关，避免打断回复。"
  else
    echo "OpenClaw 网关未就绪，正在尝试启动。"
    start_gateway
  fi
}

evomap_install() {
  local node_id last_saved_node_id
  install git curl
  mkdir -p /root/.openclaw

  last_saved_node_id="$(state_get EVOMAP_NODE_ID)"
  if ! node_id="$(prompt_evomap_node_id "" "$last_saved_node_id")"; then
    return 1
  fi
  state_set EVOMAP_NODE_ID "$node_id"

  evomap_backup_current

  if [ -d "$EVOMAP_DIR" ]; then
    mv "$EVOMAP_DIR" "${EVOMAP_DIR}.old.$(date +%Y%m%d%H%M%S)"
  fi

  if ! timeout 180 git clone --depth 1 https://github.com/EvoMap/evolver.git "$EVOMAP_DIR" >/dev/null 2>&1; then
    echo "EvoMap 浅克隆失败，正在尝试一次受限完整克隆..."
    timeout 180 git clone https://github.com/EvoMap/evolver.git "$EVOMAP_DIR"
  fi
  cd "$EVOMAP_DIR"
  install_evomap_dependencies
  mkdir -p skills assets/gep memory

  cat > .env <<EOF_ENV
MEMORY_DIR=${EVOMAP_MEMORY_DIR}
A2A_HUB_URL=https://evomap.ai
A2A_NODE_ID=${node_id}
EVOLVE_STRATEGY=balanced
EOF_ENV

  cat > assets/gep/openclaw-core-genes.json <<'EOF_GENE'
{"genes":[{"id":"openclaw-log-parser","name":"OpenClaw日志解析基因","version":"1.0.0","signals":["openclaw","gateway","session","learning","error","crash","timeout"],"directives":["优先解析OpenClaw日志","提取网关和会话错误信号","过滤无效内容并保留结构化数据"],"validation":[],"priority":100}]}
EOF_GENE

  cat > assets/gep/core-repair-capsules.json <<'EOF_CAP'
{"capsules":[{"id":"core-repair-kit","name":"核心修复胶囊","version":"1.0.0","targets":["agent-loop","execution-failure","stagnation"],"steps":["识别循环停滞并输出修复建议","识别执行错误并输出标准方案","生成可审计修复记录"]}]}
EOF_CAP

  evomap_start_loop
  sleep 2
  evomap_refresh_gateway_if_needed

  echo "EvoMap 安装完成。"
}

evomap_uninstall() {
  evomap_stop_loop
  if [ -d "$EVOMAP_DIR" ]; then
    evomap_backup_current
    mv "$EVOMAP_DIR" "${EVOMAP_DIR}.removed.$(date +%Y%m%d%H%M%S)"
  fi
  echo "EvoMap 已卸载（目录已改名保留备份）。"
}

evomap_update() {
  if [ ! -d "$EVOMAP_DIR/.git" ]; then
    echo "EvoMap 未安装，先执行安装。"
    return 1
  fi
  evomap_backup_current
  cd "$EVOMAP_DIR"
  git pull --rebase
  install_evomap_dependencies
  evomap_start_loop
  evomap_refresh_gateway_if_needed
  echo "EvoMap 更新完成。"
}

evomap_memory_menu() {
  while true; do
    clear
    skpl_ui_header "EvoMap 记忆管理" "查看学习目录与备份归档"
    evomap_print_status
    echo
    skpl_ui_section "操作"
    skpl_ui_menu_item 1 "立即备份 EvoMap"
    skpl_ui_menu_item 2 "查看记忆目录"
    skpl_ui_menu_item 3 "查看备份目录"
    skpl_ui_menu_item 0 "返回上一级"
    skpl_ui_footer_prompt "请输入你的选择: "
    read -r evo_mem_choice
    case "$evo_mem_choice" in
      1) evomap_backup_current; break_end ;;
      2) ls -la "$EVOMAP_MEMORY_DIR" 2>/dev/null || echo "记忆目录不存在。"; break_end ;;
      3) ls -la "$EVOMAP_BACKUP_DIR" 2>/dev/null || echo "备份目录不存在。"; break_end ;;
      0) return 0 ;;
      *) echo "无效的选择，请重试。"; sleep 1 ;;
    esac
  done
}

run_evomap_install_step() {
  evomap_install
}

run_full_pipeline_once() {
  save_self_to_skpl
  init_skpl_runtime

  local SKPL_BATCH_MODE=1
  local step
  step=$(state_get STEP)
  [ -z "$step" ] && step=1

  if [ "$step" -le 1 ]; then
    echo "[1/4] 执行 wslwin 代理同步..."
    if ! run_step_guard "step1_wslwin" run_wslwin_proxy_sync; then
      print_failure_hint
      return 1
    fi
    state_set STEP 2
  fi

  step=$(state_get STEP)
  [ -z "$step" ] && step=2
  if [ "$step" -le 2 ]; then
    echo "[2/4] 安装 OpenClaw，并后台预热记忆模型资源..."
    if ! run_step_guard "step2_openclaw" run_openclaw_install_step; then
      print_failure_hint
      return 1
    fi
    state_set STEP 3
  fi

  step=$(state_get STEP)
  [ -z "$step" ] && step=3
  if [ "$step" -le 3 ]; then
    echo "[3/4] 执行 openclaw2 网络优化..."
    if ! run_step_guard "step3_openclaw2" run_openclaw2_network_optimization; then
      print_failure_hint
      return 1
    fi
    run_step_guard "step3_memory_fix" openclaw_enable_local_memory_auto || true
    state_set STEP 4
  fi

  step=$(state_get STEP)
  [ -z "$step" ] && step=4
  if [ "$step" -le 4 ]; then
    if [ "${SKPL_SKIP_EVOMAP:-0}" = "1" ]; then
      echo "[4/4] 已按 SKPL_SKIP_EVOMAP=1 跳过 EvoMap 安装。"
    else
      echo "[4/4] 安装 EvoMap..."
      if ! run_step_guard "step4_evomap" run_evomap_install_step; then
        print_failure_hint
        return 1
      fi
    fi
    state_set STEP 5
  fi

  echo "全部步骤执行完成。可使用 skpl 打开面板。"
}

rerun_full_pipeline_from_start() {
  state_reset_for_full_rerun
  run_full_pipeline_once
}

skpl_update_panel() {
  clear
  skpl_ui_header "面板更新"
  skpl_ui_kv "更新来源" "GitHub main"
  skpl_ui_kv "远程脚本" "$SKPL_REMOTE_SCRIPT_URL"
  echo
  if ! skpl_sync_remote_panel; then
    break_end
    return 1
  fi
  echo
  echo "正在重新载入最新面板..."
  exec bash "${SKPL_SCRIPT_PATH}" panel
}

skpl_update_system() {
  echo "开始更新系统软件包..."

  if command -v apt >/dev/null 2>&1; then
    DEBIAN_FRONTEND=noninteractive apt update -y >/dev/null 2>&1 || return 1
    DEBIAN_FRONTEND=noninteractive apt upgrade -y >/dev/null 2>&1 || return 1
    DEBIAN_FRONTEND=noninteractive apt autoremove -y >/dev/null 2>&1 || true
    echo "APT 系统更新完成。"
    return 0
  fi

  if command -v dnf >/dev/null 2>&1; then
    dnf upgrade -y >/dev/null 2>&1 || return 1
    echo "DNF 系统更新完成。"
    return 0
  fi

  if command -v yum >/dev/null 2>&1; then
    yum update -y >/dev/null 2>&1 || return 1
    echo "YUM 系统更新完成。"
    return 0
  fi

  echo "未识别的包管理器，无法自动更新系统。"
  return 1
}

skpl_wslwin_and_update_system() {
  if ! run_wslwin_proxy_sync; then
    return 1
  fi

  skpl_update_system
}

skpl_main_panel() {
  while true; do
    clear
    skpl_ui_header "SKPL-OpenClaw管理面板"
    skpl_ui_section "概览"
    skpl_ui_kv "运行脚本" "$SKPL_SCRIPT_PATH"
    skpl_ui_kv "更新来源" "GitHub main"

    echo
    skpl_ui_section "核心入口"
    skpl_ui_menu_item 1 "OpenClaw 面板" "进入 OpenClaw 主控制台"
    skpl_ui_menu_item 2 "EvoMap 管理" "管理记忆、进化与同步"

    echo
    skpl_ui_section "安装与维护"
    skpl_ui_menu_item 3 "重新执行完整安装流程" "重置状态后从头运行"
    skpl_ui_menu_item 7 "从中断点继续安装" "按当前步骤续跑"
    skpl_ui_menu_item 4 "SKPL 面板更新" "从 GitHub 拉取最新脚本"
    skpl_ui_menu_item 6 "查看最近日志" "读取安装与运行日志"
    skpl_ui_menu_item 8 "WSL 代理同步并更新系统" "执行 wslwin 与系统更新"
    skpl_ui_menu_item 5 "SKPL 面板卸载" "仅移除 SKPL 入口"

    echo
    skpl_ui_section "退出"
    skpl_ui_menu_item 0 "退出"
    skpl_ui_footer_prompt "请输入你的选择: "
    read -r skpl_choice
    case "$skpl_choice" in
      1) openclaw_panel_menu ;;
      2) openclaw_evomap_menu ;;
      3) rerun_full_pipeline_from_start; break_end ;;
      4) skpl_update_panel; break_end ;;
      5) remove_skpl_panel_only; break_end ;;
      6) show_recent_log; break_end ;;
      7) run_full_pipeline_once; break_end ;;
      8) skpl_wslwin_and_update_system; break_end ;;
      0) exit 0 ;;
      *) echo "无效的选择，请重试。"; sleep 1 ;;
    esac
  done
}

main() {
  ensure_root "$@"
  init_skpl_runtime
  save_self_to_skpl

  case "${1:-install}" in
    install)
      run_full_pipeline_once
      load_openclaw_panel
      skpl_main_panel
      ;;
    panel)
      save_self_to_skpl
      load_openclaw_panel
      skpl_main_panel
      ;;
    openclaw)
      save_self_to_skpl
      load_openclaw_panel
      openclaw_panel_menu
      ;;
    evomap)
      save_self_to_skpl
      load_openclaw_panel
      openclaw_evomap_menu
      ;;
    *)
      echo "用法: bash $0 [install|panel|openclaw|evomap]"
      exit 1
      ;;
  esac
}

main "$@"
