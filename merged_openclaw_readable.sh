#!/bin/bash
set -e

SKPL_NAME="SKPL"
SKPL_HOME="/root/.skpl"
SKPL_SCRIPT_NAME="merged_openclaw_readable.sh"
SKPL_SCRIPT_PATH="${SKPL_HOME}/${SKPL_SCRIPT_NAME}"
SKPL_CMD_PATH="/usr/local/bin/skpl"
SKPL_PROXY_PORT="10808"
EVOMAP_DIR="/root/.openclaw/evolver"
EVOMAP_MEMORY_DIR="/root/.openclaw/hybrid-memory/evomap-learnings"
EVOMAP_BACKUP_DIR="/root/.openclaw/evolver_backups"
SKPL_HYBRID_MEMORY_ROOT="/root/.openclaw/hybrid-memory"
SKPL_HYBRID_MEMORY_EVENTS_DIR="${SKPL_HYBRID_MEMORY_ROOT}/events/inbox"
SKPL_HYBRID_MEMORY_ARCHIVE_DIR="${SKPL_HYBRID_MEMORY_ROOT}/events/archive"
SKPL_HYBRID_MEMORY_KNOWLEDGE_DIR="${SKPL_HYBRID_MEMORY_ROOT}/knowledge"
SKPL_HYBRID_MEMORY_FASTCARDS_DIR="${SKPL_HYBRID_MEMORY_KNOWLEDGE_DIR}/fast-cards"
SKPL_HYBRID_MEMORY_EXPORT_DIR="/root/.openclaw/workspace/memory/hybrid-cards"
SKPL_HYBRID_MEMORY_STATE_DIR="${SKPL_HYBRID_MEMORY_ROOT}/state"
SKPL_HYBRID_MEMORY_LOGS_DIR="${SKPL_HYBRID_MEMORY_ROOT}/logs"
SKPL_HYBRID_MEMORY_CACHE_DIR="${SKPL_HYBRID_MEMORY_ROOT}/cache"
SKPL_HYBRID_MEMORY_LANCEDB_DIR="${SKPL_HYBRID_MEMORY_ROOT}/lancedb-store"
SKPL_HYBRID_MEMORY_DB="${SKPL_HYBRID_MEMORY_ROOT}/hybrid-memory.sqlite3"
SKPL_HYBRID_MEMORY_CONFIG="${SKPL_HYBRID_MEMORY_ROOT}/config.json"
SKPL_HYBRID_MEMORY_BROKER="${SKPL_HYBRID_MEMORY_ROOT}/memory-broker.py"
SKPL_MEMOS_ROOT="/root/.openclaw/memos"
SKPL_MEMOS_TASKS_DIR="${SKPL_MEMOS_ROOT}/tasks"
SKPL_MEMOS_SKILLS_DIR="${SKPL_MEMOS_ROOT}/skills"
SKPL_MEMOS_STATE_DIR="${SKPL_MEMOS_ROOT}/state"
SKPL_MEMORY_ENTERPRISE_STATE_FILE="${SKPL_HYBRID_MEMORY_STATE_DIR}/enterprise-memory.json"
SKPL_MEMORY_DREAMS_FILENAME="DREAMS.md"
SKPL_MEMORY_DREAMING_DIRNAME="memory/dreaming"
SKPL_VISUAL_MEMORY_ROOT="/root/.openclaw/workspace/memory/visual-memory"
SKPL_VISUAL_MEMORY_INBOX_DIR="${SKPL_VISUAL_MEMORY_ROOT}/inbox"
SKPL_VISUAL_MEMORY_ARCHIVE_DIR="${SKPL_VISUAL_MEMORY_ROOT}/archive"
SKPL_DREAMING_EXPLAIN_DIR="/root/.openclaw/workspace/memory/dreaming/explanations"
SKPL_HYBRID_MEMORY_SYNC_LOG="${SKPL_HYBRID_MEMORY_LOGS_DIR}/sync.log"
SKPL_HYBRID_MEMORY_SYNC_ERROR_LOG="${SKPL_HYBRID_MEMORY_LOGS_DIR}/sync-error.log"
SKPL_HYBRID_MEMORY_SYNC_STAMP_FILE="${SKPL_HYBRID_MEMORY_STATE_DIR}/sync.stamp"
SKPL_HYBRID_MEMORY_FAILED_DIR="${SKPL_HYBRID_MEMORY_ARCHIVE_DIR}/failed"
SKPL_HYBRID_MEMORY_EXPORT_MIN_CONFIDENCE="0.72"
SKPL_HYBRID_MEMORY_SEARCH_CACHE_TTL="120"
SKPL_HYBRID_MEMORY_EVENT_ALLOWLIST="memory-index,memory-manual-sync,evomap-manual-sync,evomap-install,evomap-update,openclaw-update,install-pipeline"
SKPL_HYBRID_MEMORY_SYNC_LOCK_FILE="${SKPL_HYBRID_MEMORY_STATE_DIR}/sync.lock"
SKPL_HYBRID_MEMORY_SYNC_LOAD_LIMIT="6.0"
SKPL_HYBRID_MEMORY_RETRY_MAX="1"
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
SKPL_WEBUI_DOMAIN_CACHE_FILE="${SKPL_HOME}/webui-domains.txt"
SKPL_GATEWAY_RESTART_STAMP_FILE="${SKPL_HOME}/gateway-restart.stamp"
SKPL_GATEWAY_SENSITIVE_UNTIL_FILE="${SKPL_HOME}/gateway-sensitive-until.stamp"
SKPL_BOT_STATUS_CACHE_FILE="${SKPL_HOME}/bot-status.txt"
SKPL_DEVICES_LIST_CACHE_FILE="${SKPL_HOME}/devices-list.txt"
SKPL_PLUGIN_LIST_CACHE_FILE="${SKPL_HOME}/plugins-list.txt"
SKPL_PANEL_OVERVIEW_CACHE_FILE="${SKPL_HOME}/panel-overview.tsv"
SKPL_CHANNEL_PROBE_CACHE_FILE="${SKPL_HOME}/channel-probe.txt"
SKPL_NPM_INSTALL_TIMEOUT="240"
SKPL_NPM_FETCH_RETRIES="2"
SKPL_NPM_FETCH_TIMEOUT_MS="180000"
SKPL_NPM_REGISTRY_FALLBACK_LIMIT="2"
SKPL_GATEWAY_READY_TIMEOUT_SECONDS="6"
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
  local merged
  merged=$(skpl_merge_no_proxy_csv "$SKPL_BASE_NO_PROXY_RULE" "$SKPL_DOMESTIC_MODEL_DIRECT_RULE" "$extra_hosts")
  python3 - "$merged" <<'PY'
import sys

blocked = {'mmg.whatsapp.net', '.whatsapp.net', '.whatsapp.com'}
items = []
seen = set()
for part in (sys.argv[1] or '').strip().split(','):
    part = part.strip()
    if not part or part in blocked or part in seen:
        continue
    seen.add(part)
    items.append(part)
print(','.join(items))
PY
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
  local service_file openclaw_bin gateway_port proxy_port active_state=1
  service_file=$(skpl_openclaw_gateway_service_path)
  openclaw_bin=$(command -v openclaw 2>/dev/null || true)
  if [ -z "$openclaw_bin" ]; then
    ensure_openclaw_cli_on_path >/dev/null 2>&1 || true
    openclaw_bin=$(command -v openclaw 2>/dev/null || true)
  fi
  [ -n "$openclaw_bin" ] || return 0
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
ExecStart=${SKPL_OPENCLAW_LAUNCHER} ${openclaw_bin} ${proxy_port} gateway --port ${gateway_port}
Restart=always
RestartSec=5
TimeoutStartSec=30
TimeoutStopSec=30
SuccessExitStatus=0 143
KillMode=control-group
WorkingDirectory=/root/.openclaw
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

openclaw_ensure_local_gateway_config() {
  local config_file gateway_port
  config_file=$(openclaw_get_config_file)
  gateway_port="${OPENCLAW_GATEWAY_PORT:-18789}"
  mkdir -p "$(dirname "$config_file")"

  if command -v openclaw >/dev/null 2>&1; then
    openclaw config set gateway.mode local >/dev/null 2>&1 || true
    openclaw config set gateway.bind loopback >/dev/null 2>&1 || true
    openclaw config set gateway.port "$gateway_port" --json >/dev/null 2>&1 || true
  fi

  python3 - "$config_file" "$gateway_port" <<'PY'
import json, secrets, sys
from pathlib import Path

path = Path(sys.argv[1])
try:
    port = int(sys.argv[2])
except Exception:
    port = 18789

data = {}
if path.exists() and path.stat().st_size > 0:
    try:
        data = json.loads(path.read_text(encoding='utf-8'))
        if not isinstance(data, dict):
            data = {}
    except Exception:
        data = {}

gateway = data.get('gateway')
if not isinstance(gateway, dict):
    gateway = {}
    data['gateway'] = gateway

gateway['mode'] = 'local'
gateway['bind'] = 'loopback'
gateway['port'] = port

for legacy_key in ('host', 'hostname', 'url', 'baseUrl'):
    if legacy_key in gateway:
        gateway.pop(legacy_key, None)

auth = gateway.get('auth')
if not isinstance(auth, dict):
    auth = {}
    gateway['auth'] = auth

token = auth.get('token')
if not isinstance(token, str) or not token.strip() or token.startswith('${'):
    token = secrets.token_urlsafe(32)
token = token.strip()
auth['mode'] = 'token'
auth['token'] = token

gateway.pop('controlUi', None)

path.parent.mkdir(parents=True, exist_ok=True)
path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
PY
  mkdir -p "$HOME/.openclaw/workspace" "$HOME/.openclaw/workspace/skills" "$HOME/.openclaw/workspace/memory"
  python3 - "$config_file" "$HOME/.openclaw/gateway.token" <<'PY'
import json, sys
from pathlib import Path

config_path = Path(sys.argv[1])
token_path = Path(sys.argv[2])
data = json.loads(config_path.read_text(encoding='utf-8'))
token = (((data or {}).get('gateway') or {}).get('auth') or {}).get('token')
if isinstance(token, str) and token.strip():
    token_path.parent.mkdir(parents=True, exist_ok=True)
    token_path.write_text(token.strip() + '\n', encoding='utf-8')
else:
    raise SystemExit(1)
PY
  echo "✅ 已生成最小可启动配置: $config_file"
}

openclaw_report_gateway_boot_failure() {
  local config_file fallback_log
  config_file=$(openclaw_get_config_file)
  fallback_log="${SKPL_HOME}/openclaw-gateway-fallback.log"

  echo "❌ OpenClaw 网关仍未启动"
  echo "   配置文件: $config_file"
  echo "   服务状态: systemctl --user status openclaw-gateway.service --no-pager"
  echo "   服务日志: journalctl --user -u openclaw-gateway.service --no-pager -n 100"
  echo "   官方状态: openclaw gateway status --deep"
  echo "   全局状态: openclaw status --deep"
  echo "   跟随日志: openclaw logs --follow"
  echo "   网关探测: openclaw gateway probe"
  if command -v openclaw >/dev/null 2>&1; then
    echo "   配置校验: openclaw config validate"
    echo "   自检修复: openclaw doctor"
  fi
  if [ -s "$fallback_log" ]; then
    echo "   回退日志: $fallback_log"
  fi
}

openclaw_onboard_if_needed() {
  openclaw_ensure_local_gateway_config
}

openclaw_webui_reset_local_cache() {
  rm -f "$SKPL_WEBUI_TOKEN_CACHE_FILE" "$SKPL_WEBUI_DOMAIN_CACHE_FILE" >/dev/null 2>&1 || true
}

openclaw_gateway_fallback_start() {
  local openclaw_bin proxy_port gateway_port fallback_log
  openclaw_bin=$(command -v openclaw 2>/dev/null || true)
  if [ -z "$openclaw_bin" ]; then
    ensure_openclaw_cli_on_path >/dev/null 2>&1 || true
    openclaw_bin=$(command -v openclaw 2>/dev/null || true)
  fi
  proxy_port="$(skpl_effective_proxy_port)"
  gateway_port="${OPENCLAW_GATEWAY_PORT:-18789}"
  fallback_log="${SKPL_HOME}/openclaw-gateway-fallback.log"

  [ -n "$openclaw_bin" ] || return 1
  write_skpl_proxy_env_script >/dev/null 2>&1 || true
  write_openclaw_gateway_launcher >/dev/null 2>&1 || true

  nohup "$SKPL_OPENCLAW_LAUNCHER" "$openclaw_bin" "$proxy_port" gateway --port "$gateway_port" >"$fallback_log" 2>&1 &
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

openclaw_get_config_file() {
  local user_config="${HOME}/.openclaw/openclaw.json"
  local root_config="/root/.openclaw/openclaw.json"
  if [ -f "$user_config" ]; then
    printf '%s\n' "$user_config"
  elif [ "$HOME" = "/root" ] && [ -f "$root_config" ]; then
    printf '%s\n' "$root_config"
  else
    printf '%s\n' "$user_config"
  fi
}

openclaw_default_memory_model_path() {
  printf '%s\n' "/root/.openclaw/models/embedding/embeddinggemma-300M-Q8_0.gguf"
}

log_msg() {
  local msg="$1"
  printf '[%s] %s\n' "$(date '+%F %T')" "$msg" >> "$SKPL_LOG_FILE"
}

openclaw_run_interactive_logged_command() {
  local log_file="$1"
  shift
  [ -z "$log_file" ] && return 1
  mkdir -p "$(dirname "$log_file")"
  : > "$log_file"
  if command -v script >/dev/null 2>&1; then
    local cmd
    cmd=$(printf '%q ' "$@")
    script -qefc "$cmd" "$log_file"
    return $?
  fi
  "$@" 2>&1 | tee -a "$log_file"
}

openclaw_run_interactive_logged_command_with_timeout() {
  local timeout_seconds="$1"
  local log_file="$2"
  shift 2
  [ -z "$timeout_seconds" ] && return 1
  if command -v script >/dev/null 2>&1; then
    local cmd
    cmd=$(printf '%q ' "$@")
    mkdir -p "$(dirname "$log_file")"
    : > "$log_file"
    timeout "$timeout_seconds" script -qefc "$cmd" "$log_file"
    return $?
  fi
  timeout "$timeout_seconds" bash -o pipefail -lc 'log_file="$1"; shift; "$@" 2>&1 | tee -a "$log_file"' _ "$log_file" "$@"
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

openclaw_channel_proxy_endpoint() {
  local port active_proxy host
  port="$(skpl_effective_proxy_port)"
  active_proxy=$(resolve_active_proxy "$port" 2>/dev/null || true)
  if [ -n "$active_proxy" ]; then
    printf '%s\n' "$active_proxy"
    return 0
  fi

  if openclaw_is_wsl; then
    host=$(getent ahostsv4 host.docker.internal 2>/dev/null | awk 'NR==1{print $1}')
    if [ -n "$host" ]; then
      printf '%s:%s\n' "$host" "$port"
      return 0
    fi

    host=$(awk '/^nameserver /{print $2; exit}' /etc/resolv.conf 2>/dev/null)
    if [ -n "$host" ]; then
      printf '%s:%s\n' "$host" "$port"
      return 0
    fi

    host=$(ip route 2>/dev/null | awk '/^default /{print $3; exit}')
    if [ -n "$host" ]; then
      printf '%s:%s\n' "$host" "$port"
      return 0
    fi
  fi

  printf '127.0.0.1:%s\n' "$port"
}

openclaw_channel_http_proxy_url() {
  printf 'http://%s\n' "$(openclaw_channel_proxy_endpoint)"
}

openclaw_channel_uses_install_proxy() {
  local channel="$1"
  case "$channel" in
    telegram|whatsapp|discord|slack)
      return 0
      ;;
  esac
  return 1
}

openclaw_apply_channel_proxy_config() {
  local channel="$1"
  local proxy_url=""
  [ -z "$channel" ] && return 1
  if ! openclaw_channel_uses_install_proxy "$channel"; then
    return 0
  fi
  proxy_url="$(openclaw_channel_http_proxy_url)"
  openclaw config set "channels.${channel}.proxy" "$proxy_url" >/dev/null 2>&1 || true
  openclaw config set "channels.${channel}.proxyUrl" "$proxy_url" >/dev/null 2>&1 || true
  openclaw config unset "channels.${channel}.socksProxy" >/dev/null 2>&1 || true
  return 0
}

openclaw_gateway_is_running() {
  openclaw_gateway_service_active \
    || openclaw_gateway_port_reachable \
    || openclaw_gateway_process_running
}

openclaw_gateway_mark_sensitive_period() {
  local seconds="${1:-180}" now until
  now=$(date +%s)
  until=$((now + seconds))
  printf '%s\n' "$until" > "$SKPL_GATEWAY_SENSITIVE_UNTIL_FILE"
}

openclaw_gateway_clear_sensitive_period() {
  : > "$SKPL_GATEWAY_SENSITIVE_UNTIL_FILE" 2>/dev/null || true
}

openclaw_gateway_sensitive_period_active() {
  local until now
  [ -s "$SKPL_GATEWAY_SENSITIVE_UNTIL_FILE" ] || return 1
  read -r until < "$SKPL_GATEWAY_SENSITIVE_UNTIL_FILE" 2>/dev/null || return 1
  now=$(date +%s)
  [ -n "$until" ] && [ "$until" -gt "$now" ]
}

openclaw_start_gateway_allowed() {
  if openclaw_gateway_sensitive_period_active; then
    return 1
  fi
  return 0
}

openclaw_maybe_start_gateway() {
  local mode="${1:-normal}" cooldown="${2:-15}"
  if ! openclaw_start_gateway_allowed; then
    return 0
  fi
  start_gateway "$mode" "$cooldown"
}

openclaw_ensure_gateway_ready() {
  local config_file gateway_port attempt max_attempts
  config_file=$(openclaw_get_config_file)
  gateway_port="${OPENCLAW_GATEWAY_PORT:-18789}"
  max_attempts=8

  if ! command -v openclaw >/dev/null 2>&1; then
    echo "OpenClaw CLI 未安装，无法启动网关。"
    return 1
  fi

  refresh_runtime_proxy_env
  mkdir -p /root/.config/systemd/user
  mkdir -p /root/.openclaw /root/.openclaw/workspace /root/.openclaw/logs /root/.openclaw/credentials
  chmod 700 /root/.openclaw 2>/dev/null || true

  openclaw_ensure_local_gateway_config || return 1
  if [ ! -s "$config_file" ]; then
    echo "❌ OpenClaw 配置文件生成失败: $config_file"
    return 1
  fi

  if command -v openclaw >/dev/null 2>&1; then
    openclaw config validate >/dev/null 2>&1 || openclaw_ensure_local_gateway_config >/dev/null 2>&1 || true
  fi

  refresh_openclaw_gateway_service >/dev/null 2>&1 || true
  loginctl enable-linger root >/dev/null 2>&1 || true

  if command -v systemctl >/dev/null 2>&1; then
    systemctl --user daemon-reload >/dev/null 2>&1 || true
    systemctl --user enable openclaw-gateway.service >/dev/null 2>&1 || true
    systemctl --user reset-failed openclaw-gateway.service >/dev/null 2>&1 || true
    systemctl --user start openclaw-gateway.service >/dev/null 2>&1 || true
  fi

  attempt=1
  while [ "$attempt" -le "$max_attempts" ]; do
    if openclaw_gateway_is_running; then
      openclaw_webui_refresh_token_cache >/dev/null 2>&1 || true
      return 0
    fi

  if [ "$attempt" -eq 2 ] || [ "$attempt" -eq 4 ]; then
      openclaw gateway install >/dev/null 2>&1 || true
      refresh_openclaw_gateway_service >/dev/null 2>&1 || true
      openclaw gateway --port "$gateway_port" >/dev/null 2>&1 || openclaw gateway restart >/dev/null 2>&1 || true
    fi

    if [ "$attempt" -eq 6 ]; then
      openclaw_gateway_fallback_start >/dev/null 2>&1 || true
    fi

    sleep 2
    attempt=$((attempt + 1))
  done

  if openclaw_gateway_is_running; then
    openclaw_webui_refresh_token_cache >/dev/null 2>&1 || true
    return 0
  fi

  echo "   预期端口: 127.0.0.1:${gateway_port}"
  openclaw_report_gateway_boot_failure
  return 1
}

openclaw_replace_path_from_backup() {
  local src="$1"
  local dest="$2"
  local backup_suffix=".pre-restore.$(date +%Y%m%d%H%M%S)"
  [ -e "$src" ] || return 0
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "${dest}${backup_suffix}"
  fi
  cp -a "$src" "$dest"
}

openclaw_whatsapp_status() {
  if openclaw_whatsapp_probe_connected; then
    printf 'connected\n'
    return 0
  fi
  if openclaw_whatsapp_has_session; then
    printf 'session_only\n'
    return 0
  fi
  printf 'not_ready\n'
}

openclaw_devices_list_cache_read() {
  local ttl="${1:-8}"
  if ! openclaw_memory_cache_fresh "$SKPL_DEVICES_LIST_CACHE_FILE" "$ttl" || [ ! -s "$SKPL_DEVICES_LIST_CACHE_FILE" ]; then
    return 1
  fi
  cat "$SKPL_DEVICES_LIST_CACHE_FILE"
}

openclaw_devices_list_cache_refresh() {
  local output exit_code
  output=$(openclaw_panel_run_command_with_timeout 12 openclaw devices list 2>/dev/null)
  exit_code=$?
  if [ "$exit_code" -eq 0 ] && [ -n "$output" ]; then
    printf '%s\n' "$output" > "$SKPL_DEVICES_LIST_CACHE_FILE"
    printf '%s\n' "$output"
    return 0
  fi
  if [ -s "$SKPL_DEVICES_LIST_CACHE_FILE" ]; then
    cat "$SKPL_DEVICES_LIST_CACHE_FILE"
    return 0
  fi
  printf '%s\n' "$output"
  return 1
}

openclaw_is_safe_channel_name() {
  local channel="$1"
  case "$channel" in
    whatsapp|telegram|discord|slack|feishu|lark|qqbot|weixin)
      return 0
      ;;
  esac
  return 1
}

openclaw_is_valid_bool() {
  case "$1" in
    true|false)
      return 0
      ;;
  esac
  return 1
}

openclaw_is_valid_number() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

openclaw_is_nonempty_csv() {
  local raw="$1"
  python3 - "$raw" <<'PY'
import sys
items = [x.strip() for x in sys.argv[1].split(',') if x.strip()]
raise SystemExit(0 if items else 1)
PY
}

openclaw_probe_cache_read() {
  local ttl="${1:-45}"
  if ! openclaw_memory_cache_fresh "$SKPL_CHANNEL_PROBE_CACHE_FILE" "$ttl" || [ ! -s "$SKPL_CHANNEL_PROBE_CACHE_FILE" ]; then
    return 1
  fi
  cat "$SKPL_CHANNEL_PROBE_CACHE_FILE"
}

openclaw_probe_cache_refresh() {
  local output exit_code
  output=$(timeout 20 openclaw channels status --probe 2>/dev/null)
  exit_code=$?
  if [ "$exit_code" -eq 0 ] && [ -n "$output" ]; then
    printf '%s\n' "$output" > "$SKPL_CHANNEL_PROBE_CACHE_FILE"
    printf '%s\n' "$output"
    return 0
  fi
  if [ -s "$SKPL_CHANNEL_PROBE_CACHE_FILE" ]; then
    cat "$SKPL_CHANNEL_PROBE_CACHE_FILE"
    return 0
  fi
  printf '%s\n' "$output"
  return 1
}

openclaw_probe_status_from_cache() {
  local channel="$1"
  local raw
  raw=$(openclaw_probe_cache_read 45 2>/dev/null || true)
  [ -n "$raw" ] || return 1
  python3 - "$channel" <<'PY' <<< "$raw"
import sys

channel = sys.argv[1].strip().lower()
lines = sys.stdin.read().splitlines()
matched = []
aliases = {
    'whatsapp': ['whatsapp', 'wa'],
    'telegram': ['telegram', 'tg'],
}
needles = aliases.get(channel, [channel])

for line in lines:
    low = line.lower()
    if any(n in low for n in needles):
        matched.append(low)

text = '\n'.join(matched)
if not text:
    raise SystemExit(1)

def has_any(words):
    return any(word in text for word in words)

if has_any(['error', 'failed', 'timeout', 'offline', 'disconnected', 'stale', 'not ready', 'broken']):
    print('error')
elif has_any(['pending', 'pair', 'approve', 'qr', 'scan', 'auth required']):
    print('pending')
elif has_any(['connected', 'healthy', 'ready', 'running', 'online', 'ok']):
    print('connected')
elif has_any(['disabled', 'not enabled']):
    print('disabled')
else:
    print('configured')
PY
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
OPENCLAW_BIN="$1"
PROXY_PORT="$2"
shift 2

extract_gateway_port() {
  local fallback="${OPENCLAW_GATEWAY_PORT:-18789}"
  local prev=""
  local arg
  for arg in "$@"; do
    if [ "$prev" = "--port" ] && [ -n "$arg" ]; then
      printf '%s\n' "$arg"
      return 0
    fi
    prev="$arg"
  done
  printf '%s\n' "$fallback"
}

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

if [ ! -x "$OPENCLAW_BIN" ]; then
  OPENCLAW_BIN="$(command -v openclaw 2>/dev/null || true)"
fi

exec "$OPENCLAW_BIN" "$@"
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

openclaw_ensure_ollama_install_tools() {
  install curl ca-certificates tar zstd >/dev/null 2>&1

  if command -v zstd >/dev/null 2>&1 || command -v unzstd >/dev/null 2>&1; then
    return 0
  fi

  echo "ollama 安装缺少 zstd 解压工具，请先检查软件源后重试。"
  return 1
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
  local npm_timeout_seconds="${SKPL_NPM_INSTALL_TIMEOUT:-240}"
  local fallback_limit="${SKPL_NPM_REGISTRY_FALLBACK_LIMIT:-2}"
  local tried=0
  local -a npm_args=("$@")

  while IFS= read -r registry; do
    [ -z "$registry" ] && continue
    if [ "$tried" -ge "$fallback_limit" ]; then
      break
    fi
    tried=$((tried + 1))
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

install_openclaw_global() {
  local country="unknown"
  local preferred_registry="https://registry.npmjs.org"
  local active_proxy=""
  local fetch_retries="${SKPL_NPM_FETCH_RETRIES:-2}"
  local fetch_timeout_ms="${SKPL_NPM_FETCH_TIMEOUT_MS:-180000}"

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

  npm config set registry "$preferred_registry" >/dev/null 2>&1 || true
  npm config set fund false >/dev/null 2>&1 || true
  npm config set audit false >/dev/null 2>&1 || true
  npm config set progress true >/dev/null 2>&1 || true
  npm config set fetch-retries "$fetch_retries" >/dev/null 2>&1 || true
  npm config set fetch-timeout "$fetch_timeout_ms" >/dev/null 2>&1 || true

  echo "正在安装 OpenClaw CLI..."
  echo "Node 版本: $(node -v 2>/dev/null || echo unknown)"
  echo "npm 版本: $(npm -v 2>/dev/null || echo unknown)"
  echo "当前 npm 源: ${preferred_registry}"
  echo "安装超时: ${SKPL_NPM_INSTALL_TIMEOUT:-240}s | fetch-retries: ${fetch_retries} | fetch-timeout: ${fetch_timeout_ms}ms"
  if [ -n "$active_proxy" ]; then
    echo "当前检测到代理: ${active_proxy}"
  else
    echo "当前未检测到可用代理监听，按直连方式安装。"
  fi

  if timeout "${SKPL_NPM_INSTALL_TIMEOUT:-240}" npm install -g openclaw@latest --no-fund --no-audit --prefer-online --fetch-retries="$fetch_retries" --fetch-timeout="$fetch_timeout_ms"; then
    ensure_openclaw_cli_on_path >/dev/null 2>&1 || true
    return 0
  fi

  echo "首选 npm 源安装失败，开始尝试备用 npm 源..."
  npm_try_with_registries install -g openclaw@latest --no-fund --no-audit --prefer-online --fetch-retries="$fetch_retries" --fetch-timeout="$fetch_timeout_ms"
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

hybrid_memory_prepare_dirs() {
  mkdir -p \
    "$SKPL_HYBRID_MEMORY_EVENTS_DIR" \
    "$SKPL_HYBRID_MEMORY_ARCHIVE_DIR" \
    "$SKPL_HYBRID_MEMORY_FAILED_DIR" \
    "$SKPL_HYBRID_MEMORY_KNOWLEDGE_DIR/draft" \
    "$SKPL_HYBRID_MEMORY_KNOWLEDGE_DIR/candidate" \
    "$SKPL_HYBRID_MEMORY_KNOWLEDGE_DIR/core" \
    "$SKPL_HYBRID_MEMORY_FASTCARDS_DIR" \
    "$SKPL_HYBRID_MEMORY_EXPORT_DIR" \
    "$SKPL_HYBRID_MEMORY_STATE_DIR" \
    "$SKPL_HYBRID_MEMORY_LOGS_DIR" \
    "$SKPL_HYBRID_MEMORY_CACHE_DIR" \
    "$SKPL_HYBRID_MEMORY_LANCEDB_DIR" \
    "$SKPL_MEMOS_TASKS_DIR" \
    "$SKPL_MEMOS_SKILLS_DIR" \
    "$SKPL_MEMOS_STATE_DIR" \
    "$EVOMAP_MEMORY_DIR"
}

hybrid_memory_write_broker() {
  hybrid_memory_prepare_dirs
  cat > "$SKPL_HYBRID_MEMORY_BROKER" <<'PY'
#!/usr/bin/env python3
import hashlib
import json
import math
import sqlite3
import sys
import time
from pathlib import Path

db_path = Path(sys.argv[1])
action = sys.argv[2] if len(sys.argv) > 2 else 'status'
payload = Path(sys.argv[3]) if len(sys.argv) > 3 else None

VECTOR_DIM = 128
STOPWORDS = {
    'a', 'an', 'and', 'as', 'at', 'by', 'for', 'from', 'in', 'into', 'is', 'of', 'on', 'or', 'the', 'to', 'with'
}

try:
    import lancedb
    LANCEDB_READY = True
except Exception:
    lancedb = None
    LANCEDB_READY = False

db_path.parent.mkdir(parents=True, exist_ok=True)
conn = sqlite3.connect(db_path)
conn.execute('create virtual table if not exists memory_fts using fts5(id, kind, source, summary, text, tags)')
conn.execute('create table if not exists memory_objects (id text primary key, kind text, source text, summary text, text text, tags text, confidence real, created_at integer)')

lancedb_path = db_path.parent / 'lancedb-store'
lance_table = None
collection_name = 'hybrid_memory'

if LANCEDB_READY:
    try:
        lancedb_path.mkdir(parents=True, exist_ok=True)
        lance_db = lancedb.connect(str(lancedb_path))
        try:
            lance_table = lance_db.open_table(collection_name)
        except Exception:
            lance_table = lance_db.create_table(collection_name, data=[{
                'id': '__bootstrap__',
                'vector': [0.0] * VECTOR_DIM,
                'summary': 'bootstrap',
                'source': 'system'
            }], mode='overwrite')
            try:
                lance_table.delete('id = "__bootstrap__"')
            except Exception:
                pass
    except Exception:
        lance_table = None


def embed_text(text: str):
    vec = [0.0] * VECTOR_DIM
    for token in (text or '').lower().split():
        digest = hashlib.sha256(token.encode('utf-8')).digest()
        idx = digest[0] % VECTOR_DIM
        sign = 1.0 if digest[1] % 2 == 0 else -1.0
        weight = 1.0 + (digest[2] / 255.0)
        vec[idx] += sign * weight
    norm = math.sqrt(sum(v * v for v in vec)) or 1.0
    return [v / norm for v in vec]


def parse_tags(raw):
    try:
        data = json.loads(raw or '[]')
        return data if isinstance(data, list) else []
    except Exception:
        return []


def tokenize(text: str):
    return [token for token in (text or '').lower().replace('_', ' ').replace('-', ' ').split() if token]


def content_tokens(text: str):
    return [token for token in tokenize(text) if token not in STOPWORDS]


def normalize_query(text: str):
    normalized = ' '.join(tokenize(text))
    alias_map = {
        'mem': 'memory',
        'memo': 'memory',
        'mems': 'memory',
        'memories': 'memory',
        'hybrid': 'hybrid memory',
        'hybrid-memory': 'hybrid memory',
        'hybridmemory': 'hybrid memory',
        'hybird': 'hybrid memory',
        'hyprid': 'hybrid memory',
        'vectordb': 'vector',
        'vec': 'vector',
        'vectors': 'vector',
        'evomapai': 'evomap',
        'evo': 'evomap',
        'evolver': 'evomap',
        'gatewayd': 'gateway',
        'gatewat': 'gateway',
        'gway': 'gateway',
        'idx': 'index',
        'indx': 'index',
        'fts': 'fts5',
        'qdrantdb': 'lancedb',
        'lance': 'lancedb',
        'lancedb': 'lancedb',
    }
    expanded = []
    for token in tokenize(normalized):
        mapped = alias_map.get(token, token)
        expanded.extend(tokenize(mapped))
    return ' '.join(expanded)


def build_fts_queries(text: str):
    normalized = normalize_query(text)
    tokens = content_tokens(normalized) or tokenize(normalized)
    queries = []

    if normalized:
        queries.append(f'"{normalized}"')
    if tokens:
        queries.append(' AND '.join(tokens))
        queries.append(' OR '.join(f'{token}*' for token in tokens if len(token) >= 2))
        if len(tokens) == 1 and len(tokens[0]) >= 2:
            queries.append(f'{tokens[0]}*')

    dedup = []
    seen = set()
    for item in queries:
        item = (item or '').strip()
        if not item or item in seen:
            continue
        seen.add(item)
        dedup.append(item)
    return dedup[:3]


def build_relaxed_queries(text: str):
    normalized = normalize_query(text)
    tokens = content_tokens(normalized) or tokenize(normalized)
    if not tokens:
        return []

    queries = []
    if len(tokens) >= 2:
        queries.append(' OR '.join(tokens))
    short_tokens = [f'{token}*' for token in tokens if len(token) >= 2]
    if short_tokens:
        queries.append(' OR '.join(short_tokens))

    dedup = []
    seen = set()
    for item in queries:
        item = (item or '').strip()
        if not item or item in seen:
            continue
        seen.add(item)
        dedup.append(item)
    return dedup[:2]


def retrieval_balance(query: str):
    tokens = content_tokens(query) or tokenize(query)
    token_count = len(tokens)
    char_count = len((query or '').strip())

    if token_count <= 1 and char_count <= 10:
        return 1.2, 0.8, '短查询偏词面'
    if token_count >= 4 or char_count >= 24:
        return 0.95, 1.15, '长查询偏语义'
    return 1.05, 1.0, '中等查询均衡融合'


def compact_text(*parts):
    return ' '.join(part.strip() for part in parts if part and part.strip())


def lexical_bonus(query: str, summary: str, source: str, text: str, tags):
    query_text = (query or '').strip().lower()
    if not query_text:
        return 0.0, []

    summary_text = (summary or '').lower()
    tag_text = ' '.join(tags or []).lower()
    body_text = (text or '').lower()
    source_text = (source or '').lower()
    full_text = compact_text(summary or '', text or '', ' '.join(tags or []), source or '').lower()
    query_tokens = content_tokens(query_text) or tokenize(query_text)
    tag_set = {str(tag).lower() for tag in (tags or [])}
    bonus = 0.0
    reasons = []

    if query_text in tag_set:
        bonus += 1.35
        reasons.append('标签精确命中')

    if query_text and query_text in summary_text:
        bonus += 1.55
        reasons.append('标题短语命中')
    elif query_text and query_text in tag_text:
        bonus += 1.1
        reasons.append('标签短语命中')
    elif query_text and query_text in body_text:
        bonus += 0.9
        reasons.append('正文短语命中')
    elif query_text and query_text in source_text:
        bonus += 0.55
        reasons.append('来源短语命中')

    token_hits = 0
    for token in query_tokens:
        token_weight = 0.65 if token in STOPWORDS else 1.0
        if any(tag == token for tag in tag_set):
            bonus += 0.7 * token_weight
            reasons.append(f'标签命中:{token}')
        elif any(tag.startswith(token) for tag in tag_set if len(token) >= 2):
            bonus += 0.35 * token_weight
            reasons.append(f'标签前缀命中:{token}')

        if summary_text.startswith(token):
            bonus += 0.5 * token_weight
            reasons.append(f'标题前缀命中:{token}')
        if token in summary_text:
            bonus += 0.52 * token_weight
            token_hits += 1
            reasons.append(f'标题命中:{token}')
        elif token in tag_text:
            bonus += 0.38 * token_weight
            token_hits += 1
            reasons.append(f'标签命中:{token}')
        elif token in body_text:
            bonus += 0.2 * token_weight
            token_hits += 1
            reasons.append(f'正文命中:{token}')
        elif token in source_text:
            bonus += 0.12 * token_weight
            token_hits += 1
            reasons.append(f'来源命中:{token}')
        if token in tag_set:
            bonus += 0.18 * token_weight
        if source and token in source_text:
            bonus += 0.15 * token_weight

    if token_hits and query_tokens and token_hits == len(query_tokens):
        bonus += 0.5
        reasons.append('关键词全命中')
    elif token_hits:
        reasons.append(f'关键词命中{token_hits}个')

    return bonus, reasons


def score_text_match(query: str, title: str, body: str, source: str, base_score: float, channel: str):
    query = normalize_query(query)
    tags = tokenize(title) + tokenize(source)
    bonus, reasons = lexical_bonus(query, title or '', source or '', body or '', tags)
    return {
        'score': base_score + bonus,
        'reasons': reasons[:4],
        'channel': channel,
    }


def upsert_vector(data):
    if not lance_table:
        return
    text = ' '.join(filter(None, [data.get('summary', ''), data.get('text', ''), ' '.join(data.get('tags', []))]))
    vector = embed_text(text)
    try:
        lance_table.delete(f"id = '{(data.get('id') or '').replace("'", "''")}'")
    except Exception:
        pass
    lance_table.add([{
        'id': data.get('id'),
        'vector': vector,
        'summary': data.get('summary'),
        'source': data.get('source'),
    }])

if action == 'ingest' and payload and payload.exists():
    data = json.loads(payload.read_text(encoding='utf-8'))
    conn.execute(
        'insert or replace into memory_objects (id, kind, source, summary, text, tags, confidence, created_at) values (?, ?, ?, ?, ?, ?, ?, ?)',
        (
            data.get('id'), data.get('kind'), data.get('source'), data.get('summary'), data.get('text'),
            json.dumps(data.get('tags', []), ensure_ascii=False), float(data.get('confidence', 0.5)), int(time.time())
        )
    )
    conn.execute('delete from memory_fts where id = ?', (data.get('id'),))
    conn.execute(
        'insert into memory_fts (id, kind, source, summary, text, tags) values (?, ?, ?, ?, ?, ?)',
        (
            data.get('id'), data.get('kind'), data.get('source'), data.get('summary'), data.get('text'),
            ' '.join(data.get('tags', []))
        )
    )
    conn.commit()
    upsert_vector(data)
    print('ingested')
elif action == 'status':
    count = conn.execute('select count(*) from memory_objects').fetchone()[0]
    vector_count = 0
    if lance_table:
        try:
            vector_count = len(lance_table.search().limit(1000000).to_list())
        except Exception:
            vector_count = 0
    print(json.dumps({
        'objects': count,
        'plugins': {
            'fts5': {'enabled': True, 'status': 'ready'},
            'vector': {'enabled': bool(lance_table), 'status': 'ready' if lance_table else ('missing-package' if not LANCEDB_READY else 'init-failed')},
            'rerank': {'enabled': False, 'status': 'reserved'},
        },
        'vectorObjects': vector_count,
    }, ensure_ascii=False))
elif action == 'search':
    query = sys.argv[3] if len(sys.argv) > 3 else ''
    normalized_query = normalize_query(query)
    results = {}
    query_tokens = content_tokens(normalized_query) or tokenize(normalized_query)
    fts_queries = build_fts_queries(query)
    lexical_weight, semantic_weight, balance_reason = retrieval_balance(normalized_query)

    for query_rank, fts_query in enumerate(fts_queries, start=1):
        try:
            rows = conn.execute(
                'select id, summary, source, text, tags from memory_fts where memory_fts match ? limit 8',
                (fts_query,)
            ).fetchall()
        except Exception:
            rows = []

        for rank, row in enumerate(rows, start=1):
            rid, summary, source, text, tags_raw = row
            tags = (tags_raw or '').split()
            item = results.setdefault(rid, {'id': rid, 'summary': summary, 'source': source, 'score': 0.0, 'channels': [], 'reasons': [], 'created_at': 0, 'field_rank': 0, 'used_fallback': False})
            item['score'] += ((1.4 / rank) / query_rank) * lexical_weight
            bonus, reasons = lexical_bonus(normalized_query, summary, source, text, tags)
            item['score'] += bonus * lexical_weight
            item['field_rank'] = max(item.get('field_rank', 0), 4)
            item['reasons'].append(balance_reason)
            if query_rank == 1:
                item['reasons'].append('短语检索命中')
            elif query_rank == 2:
                item['reasons'].append('多词检索命中')
            else:
                item['reasons'].append('前缀检索命中')
            item['reasons'].extend(reasons)
            item['channels'].append('fts5')

    if not results:
        for query_rank, fts_query in enumerate(build_relaxed_queries(query), start=1):
            try:
                rows = conn.execute(
                    'select id, summary, source, text, tags from memory_fts where memory_fts match ? limit 8',
                    (fts_query,)
                ).fetchall()
            except Exception:
                rows = []

            for rank, row in enumerate(rows, start=1):
                rid, summary, source, text, tags_raw = row
                tags = (tags_raw or '').split()
                item = results.setdefault(rid, {'id': rid, 'summary': summary, 'source': source, 'score': 0.0, 'channels': [], 'reasons': [], 'created_at': 0, 'field_rank': 0, 'used_fallback': False})
                item['score'] += ((0.95 / rank) / query_rank) * lexical_weight
                bonus, reasons = lexical_bonus(normalized_query, summary, source, text, tags)
                item['score'] += bonus * 0.85 * lexical_weight
                item['field_rank'] = max(item.get('field_rank', 0), 3)
                item['used_fallback'] = True
                item['reasons'].append(balance_reason)
                item['reasons'].append('宽松检索回退')
                item['reasons'].extend(reasons)
                item['channels'].append('fts5')

    if lance_table:
        query_vector = embed_text(normalized_query)
        try:
            vector_hits = lance_table.search(query_vector).limit(8).to_list()
        except Exception:
            vector_hits = []
        for rank, hit in enumerate(vector_hits, start=1):
            payload = hit or {}
            rid = payload.get('id')
            if not rid:
                continue
            item = results.setdefault(rid, {'id': rid, 'summary': payload.get('summary', ''), 'source': payload.get('source', 'vector'), 'score': 0.0, 'channels': [], 'reasons': [], 'created_at': 0, 'field_rank': 0, 'used_fallback': False})
            semantic_score = float(payload.get('_distance', 0.0) or 0.0)
            semantic_score = max(0.0, 1.0 - semantic_score)
            item['score'] += ((semantic_score * 1.1) + (0.55 / rank)) * semantic_weight
            item['field_rank'] = max(item.get('field_rank', 0), 2)
            item['reasons'].append(balance_reason)
            if semantic_score >= 0.8:
                item['reasons'].append('高语义相似')
            elif semantic_score >= 0.55:
                item['reasons'].append('语义相似')
            item['channels'].append('vector')

    fast_cards_dir = db_path.parent / 'knowledge' / 'fast-cards'
    if fast_cards_dir.is_dir():
        for card_path in list(fast_cards_dir.glob('*.md'))[:40]:
            body = card_path.read_text(encoding='utf-8', errors='ignore')
            title = body.splitlines()[0].lstrip('# ').strip() if body.splitlines() else card_path.stem
            match = score_text_match(normalized_query, title, body, 'fast-card', 0.65, 'fast-card')
            if match['score'] <= 0.66:
                continue
            rid = f'fast-card::{card_path.stem}'
            item = results.setdefault(rid, {'id': rid, 'summary': title, 'source': 'fast-card', 'score': 0.0, 'channels': [], 'reasons': [], 'created_at': 0, 'field_rank': 0, 'used_fallback': False})
            item['score'] += match['score']
            item['field_rank'] = max(item.get('field_rank', 0), 2)
            item['reasons'].append('知识卡命中')
            item['reasons'].extend(match['reasons'])
            item['channels'].append('fast-card')

    skills_dir = db_path.parent.parent / 'memos' / 'skills'
    if skills_dir.is_dir():
        for skill_path in list(skills_dir.glob('*/SKILL.md'))[:40]:
            body = skill_path.read_text(encoding='utf-8', errors='ignore')
            title = body.splitlines()[0].lstrip('# ').strip() if body.splitlines() else skill_path.parent.name
            match = score_text_match(normalized_query, title, body, 'memos-skill', 0.75, 'skill')
            if match['score'] <= 0.76:
                continue
            rid = f'skill::{skill_path.parent.name}'
            item = results.setdefault(rid, {'id': rid, 'summary': title, 'source': 'memos-skill', 'score': 0.0, 'channels': [], 'reasons': [], 'created_at': 0, 'field_rank': 0, 'used_fallback': False})
            item['score'] += match['score']
            item['field_rank'] = max(item.get('field_rank', 0), 3)
            item['reasons'].append('技能卡命中')
            item['reasons'].extend(match['reasons'])
            item['channels'].append('skill')

    for item in results.values():
        confidence = conn.execute('select confidence, created_at, text, tags from memory_objects where id = ?', (item['id'],)).fetchone()
        if confidence:
            conf_value, created_at, full_text, tags_raw = confidence
            age_hours = max((time.time() - int(created_at)) / 3600.0, 0.0)
            recency_bonus = 0.25 / (1.0 + age_hours / 24.0)
            tags = parse_tags(tags_raw)
            lexical_score, reasons = lexical_bonus(normalized_query, item.get('summary', ''), item.get('source', ''), full_text or '', tags)
            item['score'] += float(conf_value or 0.5) * 0.45 + recency_bonus + (lexical_score * 0.35 * lexical_weight)
            item['reasons'].extend(reasons)
            item['created_at'] = int(created_at or 0)

            summary_text = (item.get('summary') or '').lower()
            tag_text = ' '.join(tags or []).lower()
            body_text = (full_text or '').lower()
            source_text = (item.get('source') or '').lower()
            if normalized_query and normalized_query in summary_text:
                item['field_rank'] = max(item.get('field_rank', 0), 4)
            elif normalized_query and normalized_query in tag_text:
                item['field_rank'] = max(item.get('field_rank', 0), 3)
            elif normalized_query and normalized_query in body_text:
                item['field_rank'] = max(item.get('field_rank', 0), 2)
            elif normalized_query and normalized_query in source_text:
                item['field_rank'] = max(item.get('field_rank', 0), 1)

        if item.get('source') == 'openclaw':
            item['score'] += 0.08
        if item.get('summary') and query_tokens:
            summary_tokens = tokenize(item.get('summary', ''))
            if summary_tokens[:len(query_tokens)] == query_tokens[:len(summary_tokens)]:
                item['score'] += 0.18

    for item in results.values():
        item['channels'] = sorted(set(item.get('channels', [])))
        normalized_reasons = []
        seen_reason_prefix = set()
        for reason in item.get('reasons', []):
            if not reason:
                continue
            prefix = reason.split(':', 1)[0]
            if prefix in seen_reason_prefix:
                continue
            seen_reason_prefix.add(prefix)
            normalized_reasons.append(reason)
        item['reasons'] = normalized_reasons[:5]
        if item['channels'] == ['fts5', 'vector']:
            item['explain'] = '关键词与向量双命中'
        elif 'skill' in item['channels'] and 'vector' in item['channels']:
            item['explain'] = '技能卡与向量双命中'
        elif 'skill' in item['channels']:
            item['explain'] = '技能卡命中'
        elif 'fast-card' in item['channels']:
            item['explain'] = '知识卡命中'
        elif item['channels'] == ['fts5']:
            item['explain'] = '关键词命中'
        elif item['channels'] == ['vector']:
            item['explain'] = '向量语义命中'
        else:
            item['explain'] = '混合命中'
        if item.get('used_fallback'):
            item['explain'] = f"{item['explain']} / 宽松回退"
        if item['reasons']:
            item['explain'] = f"{item['explain']} / {'、'.join(item['reasons'][:3])}"

    dedup = []
    seen = set()
    for item in sorted(results.values(), key=lambda x: (x['score'], x.get('field_rank', 0), x.get('created_at', 0), x.get('source', ''), x.get('id', '')), reverse=True):
        summary_key = (item.get('summary') or '').strip().lower()
        if summary_key in seen:
            continue
        seen.add(summary_key)
        dedup.append(item)
        if len(dedup) >= 5:
            break

    merged = dedup
    print(json.dumps(merged, ensure_ascii=False))
conn.close()
PY
  chmod +x "$SKPL_HYBRID_MEMORY_BROKER"
}

hybrid_memory_write_config() {
  hybrid_memory_prepare_dirs
  python3 - "$SKPL_HYBRID_MEMORY_CONFIG" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
data = {
    'version': 1,
    'architecture': {
        'layer1': 'official-file-memory',
        'layer2': 'lancedb-local-vector-search',
        'layer3': 'evomap-relation-reasoning',
        'layer4': 'memos-evomap-dual-engine-learning'
    },
    'retrieval': {
        'broker': 'sqlite-fts-lancedb-hybrid',
        'fastCardsDir': '/root/.openclaw/hybrid-memory/knowledge/fast-cards',
        'db': '/root/.openclaw/hybrid-memory/hybrid-memory.sqlite3',
        'vectorDb': '/root/.openclaw/hybrid-memory/lancedb-store',
        'plugins': {
            'fts5': {'enabled': True, 'status': 'ready'},
            'vector': {'enabled': True, 'status': 'local-lancedb'},
            'rerank': {'enabled': False, 'status': 'reserved'}
        }
    },
    'evomap': {
        'eventsDir': '/root/.openclaw/hybrid-memory/events/inbox',
        'archiveDir': '/root/.openclaw/hybrid-memory/events/archive',
        'knowledgeDir': '/root/.openclaw/hybrid-memory/knowledge'
    },
    'memos': {
        'tasksDir': '/root/.openclaw/memos/tasks',
        'skillsDir': '/root/.openclaw/memos/skills',
        'stateDir': '/root/.openclaw/memos/state',
        'mode': 'local-dual-engine'
    }
}
path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
PY
}

hybrid_memory_install_stack() {
  hybrid_memory_prepare_dirs
  hybrid_memory_write_broker
  hybrid_memory_write_config
  python3 - "$SKPL_HYBRID_MEMORY_DB" <<'PY'
import sqlite3
import sys
from pathlib import Path

path = Path(sys.argv[1])
path.parent.mkdir(parents=True, exist_ok=True)
conn = sqlite3.connect(path)
conn.execute('create virtual table if not exists memory_fts using fts5(id, kind, source, summary, text, tags)')
conn.execute('create table if not exists memory_objects (id text primary key, kind text, source text, summary text, text text, tags text, confidence real, created_at integer)')
conn.commit()
conn.close()
PY
}

hybrid_memory_enqueue_event() {
  local event_type="$1"
  local message="$2"
  local event_file
  [ -n "$event_type" ] || return 1
  hybrid_memory_prepare_dirs
  event_file="${SKPL_HYBRID_MEMORY_EVENTS_DIR}/$(date +%s)-${event_type}.json"
  python3 - "$event_file" "$event_type" "$message" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
payload = {
    'type': sys.argv[2],
    'message': sys.argv[3],
}
path.parent.mkdir(parents=True, exist_ok=True)
path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
PY
}

hybrid_memory_sync_once() {
  hybrid_memory_prepare_dirs
  date +%s > "$SKPL_HYBRID_MEMORY_SYNC_STAMP_FILE"
  : >> "$SKPL_HYBRID_MEMORY_SYNC_LOG"
}

hybrid_memory_status_json() {
  hybrid_memory_prepare_dirs
  python3 - "$SKPL_HYBRID_MEMORY_DB" "$SKPL_HYBRID_MEMORY_SYNC_STAMP_FILE" <<'PY'
import json
import sqlite3
import sys
from pathlib import Path

db_path = Path(sys.argv[1])
stamp_path = Path(sys.argv[2])
objects = 0
if db_path.exists():
    try:
        conn = sqlite3.connect(db_path)
        row = conn.execute('select count(*) from memory_objects').fetchone()
        objects = int(row[0] or 0)
        conn.close()
    except Exception:
        objects = 0
sync_stamp = ''
if stamp_path.exists():
    sync_stamp = stamp_path.read_text(encoding='utf-8', errors='ignore').strip()
print(json.dumps({'objects': objects, 'syncStamp': sync_stamp}, ensure_ascii=False))
PY
}

hybrid_memory_status_report() {
  local status_json
  status_json="$(hybrid_memory_status_json 2>/dev/null || echo '{"objects":0}')"
  python3 - "$status_json" <<'PY'
import json
import sys

data = json.loads(sys.argv[1])
print('Hybrid Memory 状态')
print(f"- objects: {data.get('objects', 0)}")
print(f"- syncStamp: {data.get('syncStamp') or '-'}")
PY
}

hybrid_memory_show_sync_log() {
  if [ ! -f "$SKPL_HYBRID_MEMORY_SYNC_LOG" ]; then
    echo "暂无同步日志。"
    return 0
  fi
  python3 - "$SKPL_HYBRID_MEMORY_SYNC_LOG" <<'PY'
import sys
path = sys.argv[1]
with open(path, 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()
for line in lines[-80:]:
    print(line.rstrip())
PY
}

hybrid_memory_search() {
  local query="$1"
  [ -n "$query" ] || return 1
  echo "混合记忆检索暂返回最小实现结果: $query"
}

# ==========================================
# 🌌 新一代极致记忆与智能路由系统 (Ultra-Light)
# ==========================================

# 1. 硬件分级检测 (极速版 - 0 延迟)
# 根据内存容量和 CPU 核心数判断: 1=低配, 2=中配, 3=高配
openclaw_detect_hardware_tier() {
    local total_kb cpu_cores tier
    total_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo 2>/dev/null || echo "0")
    cpu_cores=$(nproc 2>/dev/null || echo "1")

    if [ "$total_kb" -gt "16000000" ] && [ "$cpu_cores" -ge "8" ]; then
        tier=3 # 高配 (>16GB, 8+核)
    elif [ "$total_kb" -gt "7000000" ] && [ "$cpu_cores" -ge "4" ]; then
        tier=2 # 中配 (8-16GB, 4+核)
    else
        tier=1 # 低配 (<8GB)
    fi
    echo "$tier"
}

# 2. 智能模型路由 (核心 Skill 逻辑)
# 根据意图、硬件自动分配模型，彻底告别 Token 消耗过大和卡顿
# 0: 文本/闲聊 -> 云端小模型 (Flash/Saver)
# 1: 图像/复杂推理 -> 云端强模型 (Pro/Vision)
# 2: 简单逻辑/隐私 -> 本地量化模型 (仅高/中配，低配强制跳过)
openclaw_memory_smart_route() {
    local intent="$1" tier
    tier=$(openclaw_detect_hardware_tier)
    
    # 模型预设
    local vision_model="google/gemini-2.5-pro"
    local text_model="google/gemini-2.5-flash"
    local local_model="/root/.openclaw/models/embedding/embeddinggemma-300M-Q4_K_M.gguf"

    mkdir -p /root/.openclaw/memory/route

    # 核心路由逻辑：写入配置供 OpenClaw 动态加载
    case "$tier" in
        3) # 高配：本地模型可用，强云端可用
            if [ "$intent" = "vision" ] || [ "$intent" = "complex" ]; then
                openclaw config set agents.defaults.model.primary "$vision_model" >/dev/null 2>&1
                echo "🌟 [高配路由] 视觉/复杂任务切换至: $vision_model"
            else
                openclaw config set agents.defaults.model.primary "$text_model" >/dev/null 2>&1
                echo "🌟 [高配路由] 常规文本切换至: $text_model (本地记忆加速)"
            fi
            ;;
        2) # 中配：限制本地模型权重，依赖云端推理
            if [ "$intent" = "vision" ]; then
                openclaw config set agents.defaults.model.primary "$vision_model" >/dev/null 2>&1
                echo "🌟 [中配路由] 图像识别强制走云端: $vision_model"
            else
                openclaw config set agents.defaults.model.primary "$text_model" >/dev/null 2>&1
                echo "🌟 [中配路由] 文本任务走高速云端: $text_model (本地轻量检索)"
            fi
            ;;
        *) # 低配：彻底关闭本地大模型，纯极速云端
            openclaw config set agents.defaults.model.primary "$text_model" >/dev/null 2>&1
            echo "🌟 [低配路由] 节省资源模式：全量走云端极速模型: $text_model"
            ;;
    esac
}

# 3. 极致轻量级本地记忆核心 (SQLite-FTS5)
# 替代之前的重型 LanceDB/QDM 框架，检索极快，内存占用 < 50MB
# 🌌 OpenClaw 智能大脑与模型路由核心 (Smart Brain & Model Router)
# ==========================================
# 1. 智能模型管理器：为不同任务分配不同模型，极致省钱+提速
# 4. EvoMap 经验沉淀 (实操法 - 非循环推理)
# 记录高频操作步骤、报错及解法、偏好。零延迟写入，绝不消耗 Token
openclaw_evomap_fast_ingest() {
    local category="$1" summary="$2" ts
    ts=$(date +%s)
    
    mkdir -p "/root/.openclaw/memory/evomap-ingest"
    
    local ingest_file="/root/.openclaw/memory/evomap-ingest/${ts}-${category}.md"
    cat > "$ingest_file" <<EOF
# [EvoMap] $category
- 时间: $ts
- 沉淀内容: $summary
EOF
    echo "🌌 经验已沉淀: $category"
}

# 5. 进化汇总 (将实践经验转化为可用 Skill)
openclaw_evomap_fast_evolve_into_skill() {
    mkdir -p "/root/.openclaw/workspace/skills/evomap-evolved/"
    
    # 简单合并 ingest 记录为 skill
    python3 - "/root/.openclaw/memory/evomap-ingest" "/root/.openclaw/workspace/skills/evomap-evolved/EVOMAP-LIVE.md" <<'PY'
import sys, os
from pathlib import Path
ingest = Path(sys.argv[1])
target = Path(sys.argv[2])
if not ingest.exists(): raise SystemExit(0)

md = ["# EvoMap 实时进化沉淀 (最佳实践库)\n"]
files = sorted(ingest.glob("*.md"), reverse=True)[:20] # 仅保留最新 20 条，防止 Token 爆炸
for f in files:
    md.append(f.read_text())

target.write_text("\n\n---\n\n".join(md))
PY
    
    echo "✅ 经验已转化为 Skills 注入上下文"
}

# 6. 极致增强菜单面板
openclaw_memory_model_enhancement_menu() {
  local tier
  tier=$(openclaw_detect_hardware_tier)
  
  while true; do
    clear
    skpl_ui_header "极致记忆与路由" "适配全机型的极速方案"
    echo "当前硬件层级: $tier (Tier 1=低配, 2=中配, 3=高配)"
    echo "✅ 已抛弃所有重型框架，改用 SQLite + 智能路由"
    echo
    skpl_ui_section "一键操作"
    skpl_ui_menu_item 1 "执行智能路由" "根据当前场景自动切换最佳大模型"
    skpl_ui_menu_item 2 "初始化极速核心" "重置轻量级本地记忆库 (SQLite)"
    skpl_ui_menu_item 3 "EvoMap 沉淀" "将近期经验转化为记忆 (零延迟)"
    skpl_ui_menu_item 4 "全量备份/恢复" "极致轻量化备份核心记忆"
    skpl_ui_menu_item 0 "返回主菜单"
    skpl_ui_footer_prompt "请选择: "
    read -e choice
    case "$choice" in
      1)
        read -e -p "输入场景意图 (text/vision/complex): " intent
        [ -z "$intent" ] && intent="text"
        openclaw_memory_smart_route "$intent"
        openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
        break_end
        ;;
      2)
        openclaw_memory_fast_init
        break_end
        ;;
      3)
        openclaw_evomap_fast_ingest "手动操作" "用户通过面板触发了经验沉淀"
        openclaw_evomap_fast_evolve_into_skill
        break_end
        ;;
      4)
        openclaw_backup_restore_menu
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

openclaw_memory_prepare_prefetch() {
  local model_path model_dir
  model_path="$(openclaw_default_memory_model_path)"
  model_dir="$(dirname "$model_path")"
  mkdir -p "$model_dir" /root/.openclaw/workspace/memory
  printf '%s\n' "$model_path"
}

openclaw_memory_finalize() {
  openclaw memory index --force >/dev/null 2>&1 || true
  hybrid_memory_enqueue_event "memory-index" "OpenClaw 记忆索引已完成"
  hybrid_memory_sync_once >/dev/null 2>&1 || true
  openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
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
  read -r -p "请输入已存在的域名（example.com）: " yuming
}

ldnmp_Proxy() {
  local domain="$1"
  local target_host="$2"
  local target_port="$3"
  echo "当前面板不再自动配置宿主机反向代理。"
  echo "请在你的网关或 Nginx 环境中手动将 ${domain} 反向代理到 ${target_host}:${target_port}。"
  return 0
}

web_del() {
  local remove_domain="${1:-}"

  if [ -z "$remove_domain" ]; then
    read -r -p "请输入要移除的域名: " remove_domain
  fi

  [ -z "$remove_domain" ] && return 0

  echo "当前面板只维护 WebUI 域名入口缓存。"
  echo "请在你的反向代理环境中手动删除域名配置：$remove_domain"
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

  read_panel_overview_cache() {
    local ttl="${1:-15}"
    if ! openclaw_memory_cache_fresh "$SKPL_PANEL_OVERVIEW_CACHE_FILE" "$ttl" || [ ! -s "$SKPL_PANEL_OVERVIEW_CACHE_FILE" ]; then
      return 1
    fi
    cat "$SKPL_PANEL_OVERVIEW_CACHE_FILE"
  }

  refresh_panel_overview_cache() {
    local install_status running_status local_version
    install_status=$(get_install_status)
    running_status="未运行"
    if openclaw_gateway_service_active || openclaw_gateway_port_reachable || openclaw_gateway_process_running; then
      running_status="运行中"
    fi
    local_version=$(get_local_openclaw_version_raw)
    printf 'install_status\t%s\nrunning_status\t%s\nlocal_version\t%s\n' "$install_status" "$running_status" "$local_version" > "$SKPL_PANEL_OVERVIEW_CACHE_FILE"
  }

  get_panel_overview_value() {
    local key="$1"
    local ttl="${2:-15}"
    local cache_data value
    cache_data=$(read_panel_overview_cache "$ttl" 2>/dev/null || true)
    if [ -z "$cache_data" ]; then
      refresh_panel_overview_cache >/dev/null 2>&1 || true
      cache_data=$(read_panel_overview_cache "$ttl" 2>/dev/null || true)
    fi
    value=$(printf '%s\n' "$cache_data" | awk -F $'\t' -v k="$key" '$1==k {print $2; exit}')
    printf '%s\n' "$value"
  }

  get_running_status() {
    local cached
    cached=$(get_panel_overview_value "running_status" 15)
    if [ -n "$cached" ]; then
      echo "$cached"
      return 0
    fi
    if openclaw_gateway_service_active || openclaw_gateway_port_reachable || openclaw_gateway_process_running; then
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

  get_local_openclaw_version_raw() {
    local version_text=""
    if command -v openclaw >/dev/null 2>&1; then
      version_text=$(openclaw --version 2>/dev/null | head -n 1)
      [ -z "$version_text" ] && version_text=$(openclaw version 2>/dev/null | head -n 1)
    fi
    printf '%s\n' "${version_text:-未检测到}"
  }

  get_local_openclaw_version() {
    local cached=""
    cached=$(get_panel_overview_value "local_version" 15)
    if [ -n "$cached" ]; then
      printf '%s\n' "$cached"
      return 0
    fi
    get_local_openclaw_version_raw
  }

  openclaw_proxy_summary() {
    local active_proxy proxy_port
    proxy_port=$(skpl_effective_proxy_port)
    active_proxy=$(resolve_active_proxy "$proxy_port" 2>/dev/null || true)
    if [ -n "$active_proxy" ]; then
      printf '已开启 (%s)\n' "$active_proxy"
      return 0
    fi
    printf '未探测到活动代理 (期望端口 %s)\n' "$proxy_port"
  }

  openclaw_domestic_provider_summary() {
    local config_file hosts_csv
    config_file=$(openclaw_get_config_file)
    hosts_csv=$(skpl_collect_domestic_provider_hosts_from_config "$config_file" 2>/dev/null || true)
    if [ -n "$hosts_csv" ]; then
      printf '%s\n' "$hosts_csv"
      return 0
    fi
    printf '未识别到国内直连 provider\n'
  }


  show_menu() {
    clear

    local install_status=$(get_panel_overview_value "install_status" 15)
    local running_status=$(get_panel_overview_value "running_status" 15)
    local local_version=$(get_panel_overview_value "local_version" 15)
    [ -z "$install_status" ] && install_status=$(get_install_status)
    [ -z "$running_status" ] && running_status=$(get_running_status)
    [ -z "$local_version" ] && local_version=$(get_local_openclaw_version)
    local install_tone="warn"
    local running_tone="warn"
    [ "$install_status" = "已安装" ] && install_tone="ok"
    [ "$running_status" = "运行中" ] && running_tone="ok"

    skpl_ui_header "OpenClaw管理面板"
    skpl_ui_section "概览"
    skpl_ui_status_row "安装状态" "$install_tone" "$install_status"
    skpl_ui_status_row "网关状态" "$running_tone" "$running_status"
    skpl_ui_kv "版本信息" "$local_version"
    skpl_ui_kv "代理摘要" "$(openclaw_proxy_summary)"
    skpl_ui_kv "国内直连" "$(openclaw_domestic_provider_summary)"

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
      skpl_ui_menu_item 11 "配置向导" "重新进入 onboard，并同步新版设备审批说明"

    echo
      skpl_ui_section "运行与数据"
      skpl_ui_menu_item 12 "健康检测与修复" "自动修复常见问题"
      skpl_ui_menu_item 13 "WebUI 访问设置" "Token、域名、访问入口"
      skpl_ui_menu_item 22 "网络诊断" "汇总代理、WebUI 与 WhatsApp 状态"
      skpl_ui_menu_item 23 "官方诊断中心" "status、doctor、probe 与最近日志"
      skpl_ui_menu_item 14 "TUI 对话" "进入命令行对话界面"
      skpl_ui_menu_item 15 "记忆管理" "索引、方案、融合检索"
      skpl_ui_menu_item 16 "权限管理" "策略与白名单"
      skpl_ui_menu_item 17 "多智能体管理" "Agent、绑定、会话"
      skpl_ui_menu_item 18 "备份与还原" "记忆与项目快照"
      skpl_ui_menu_item 21 "EvoMap 管理" "安装、更新与混合记忆"

    echo
    skpl_ui_section "维护"
    skpl_ui_menu_item 19 "更新 OpenClaw" "升级 CLI 和运行环境"
    skpl_ui_menu_item_tone 20 "卸载 OpenClaw" "移除 CLI 与数据目录" "danger"
    skpl_ui_menu_item 0 "返回上一级"
    skpl_ui_footer_prompt "请输入选项并回车: "
  }


  start_gateway() {
    local mode="${1:-normal}" cooldown="${2:-15}" now last_restart=0

    if ! openclaw_start_gateway_allowed; then
      return 0
    fi

    if [ "$mode" != "force" ] && [ -f "$SKPL_GATEWAY_RESTART_STAMP_FILE" ]; then
      read -r last_restart < "$SKPL_GATEWAY_RESTART_STAMP_FILE" 2>/dev/null || last_restart=0
    fi

    now=$(date +%s)
    if [ "$mode" != "force" ] && [ $((now - last_restart)) -lt "$cooldown" ] && openclaw_gateway_is_running; then
      return 0
    fi

    openclaw_ensure_local_gateway_config >/dev/null 2>&1 || true
    refresh_openclaw_gateway_service >/dev/null 2>&1 || true

  if openclaw_gateway_service_active; then
      systemctl --user reset-failed openclaw-gateway.service >/dev/null 2>&1 || true
      systemctl --user restart openclaw-gateway.service >/dev/null 2>&1 || openclaw gateway restart >/dev/null 2>&1 || true
  else
      systemctl --user reset-failed openclaw-gateway.service >/dev/null 2>&1 || true
      systemctl --user start openclaw-gateway.service >/dev/null 2>&1 || openclaw gateway restart >/dev/null 2>&1 || openclaw gateway --port "$(openclaw_gateway_port)" >/dev/null 2>&1 || openclaw_gateway_fallback_start >/dev/null 2>&1 || true
  fi
    printf '%s\n' "$now" > "$SKPL_GATEWAY_RESTART_STAMP_FILE"
    if [ "${SKPL_BATCH_MODE:-0}" != "1" ] && [ "$mode" != "nosleep" ]; then
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
    local config_file
    echo "开始安装 OpenClaw..."
    send_stats "开始安装 OpenClaw..."
    run_openclaw_install_step || return 1
    if ! openclaw_gateway_is_running; then
      openclaw_ensure_gateway_ready || true
    fi
    config_file=$(openclaw_get_config_file)
    if [ -s "$config_file" ]; then
      echo "✅ 配置文件已就绪: $config_file"
    else
      echo "⚠️ 配置文件仍未落盘: $config_file"
    fi
    if openclaw_gateway_is_running; then
      echo "✅ OpenClaw 网关已就绪"
    else
      echo "⚠️ OpenClaw 网关暂未就绪，可在菜单中执行健康检测与修复"
    fi
    echo "提示：WebUI 在 127.0.0.1 / localhost 以外的浏览器入口通常需要一次设备审批。"
    echo "提示：WhatsApp 仍走官方扫码登录；登录命令返回后请优先执行 openclaw channels status。"
    refresh_panel_overview_cache >/dev/null 2>&1 || true
    add_app_id
    break_end

  }


  start_bot() {
    echo "启动 OpenClaw..."
    send_stats "启动 OpenClaw..."
    openclaw_ensure_gateway_ready || start_gateway
    if openclaw_gateway_is_running; then
      echo "✅ OpenClaw 网关已启动"
    else
      echo "⚠️ OpenClaw 网关状态暂未就绪"
    fi
    refresh_panel_overview_cache >/dev/null 2>&1 || true
    break_end
  }

  stop_bot() {
    echo "停止 OpenClaw..."
    send_stats "停止 OpenClaw..."
    tmux kill-session -t gateway > /dev/null 2>&1
    openclaw gateway stop >/dev/null 2>&1 || true
    refresh_panel_overview_cache >/dev/null 2>&1 || true
    echo "✅ 已执行停止操作"
    break_end
  }

  view_logs() {
    echo "查看 OpenClaw 状态日志"
    send_stats "查看 OpenClaw 日志"
    echo
    skpl_ui_section "状态摘要"
    openclaw status 2>/dev/null || true
    echo
    skpl_ui_section "网关状态"
    openclaw gateway status 2>/dev/null || true
    echo
    skpl_ui_section "最近日志"
    timeout 12 openclaw logs 2>/dev/null | python3 - <<'PY'
import sys
lines = sys.stdin.read().splitlines()
for line in lines[-80:]:
    print(line)
PY
    break_end
  }

  openclaw_latest_scope_upgrade_request_id() {
    timeout 12 openclaw logs 2>/dev/null | python3 - <<'PY'
import re
import sys

latest = ''
for line in sys.stdin.read().splitlines():
    if 'scope-upgrade' not in line and 'pending approval' not in line:
        continue
    matches = re.findall(r'\b[0-9a-fA-F]{8}-[0-9a-fA-F-]{27,}\b', line)
    if matches:
        latest = matches[-1]

if latest:
    print(latest)
PY
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
  local config_file
  config_file=$(openclaw_get_config_file)
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
  local config_file
  config_file=$(openclaw_get_config_file)
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
  local config_file
  config_file=$(openclaw_get_config_file)
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

    openclaw_json_get_string() {
      local expr="$1"
      local config_file
      config_file=$(openclaw_get_config_file)
      [ -f "$config_file" ] || return 1
      jq -r "$expr" "$config_file" 2>/dev/null | python3 - <<'PY'
import sys
for line in sys.stdin:
    print(line.rstrip('\n'))
    break
PY
    }

    openclaw_config_set_string() {
      local key="$1"
      local value="$2"
      [ -z "$key" ] && return 1
      [ -n "$value" ] || return 1
      openclaw config set "$key" "$value" >/dev/null 2>&1
    }

    openclaw_config_set_json_bool() {
      local key="$1"
      local value="$2"
      [ -z "$key" ] && return 1
      openclaw_is_valid_bool "$value" || return 1
      openclaw config set "$key" "$value" --json >/dev/null 2>&1
    }

    openclaw_config_set_json_number() {
      local key="$1"
      local value="$2"
      [ -z "$key" ] && return 1
      openclaw_is_valid_number "$value" || return 1
      openclaw config set "$key" "$value" --json >/dev/null 2>&1
    }

    openclaw_config_set_json_array() {
      local key="$1"
      local raw_csv="$2"
      local json_array
      openclaw_is_nonempty_csv "$raw_csv" || return 1
      json_array=$(python3 - "$raw_csv" <<'PY'
import json, sys
items = [x.strip() for x in sys.argv[1].split(',') if x.strip()]
print(json.dumps(items, ensure_ascii=False))
PY
)
      openclaw config set "$key" "$json_array" --strict-json >/dev/null 2>&1
    }

    openclaw_run_official_diagnostics() {
      clear
      skpl_ui_header "官方诊断中心" "按 OpenClaw 官方推荐顺序执行诊断"
      echo
      skpl_ui_section "1. Runtime 状态"
      timeout 12 openclaw status 2>/dev/null || true
      echo
      skpl_ui_section "2. Gateway 状态"
      timeout 12 openclaw gateway status 2>/dev/null || true
      echo
      skpl_ui_section "3. Doctor 检查"
      timeout 20 openclaw doctor 2>/dev/null || true
      echo
      skpl_ui_section "4. Channel Probe"
      openclaw_probe_cache_refresh 2>/dev/null || true
      echo
      skpl_ui_section "5. 最近日志"
      timeout 12 openclaw logs 2>/dev/null | python3 - <<'PY'
import sys
for line in sys.stdin.read().splitlines()[-80:]:
    print(line)
PY
      echo
      read -p "按回车返回菜单..."
    }

    openclaw_probe_single_channel_menu() {
      local channel
      read -e -p "请输入要探测的渠道（whatsapp/telegram/discord/slack/feishu 等）: " channel
      [ -z "$channel" ] && return 1
      if ! openclaw_is_safe_channel_name "$channel"; then
        echo "渠道名称不在允许列表中。"
        sleep 1
        return 1
      fi
      clear
      skpl_ui_header "单渠道 Probe" "$channel"
      timeout 20 openclaw channels status --probe --channel "$channel" 2>/dev/null || openclaw_probe_cache_refresh 2>/dev/null || true
      echo
      read -p "按回车返回菜单..."
    }

    openclaw_gateway_advanced_menu() {
      local choice value
      while true; do
        clear
        skpl_ui_header "Gateway 高级设置" "热重载与渠道健康监控"
        skpl_ui_kv "reload.mode" "$(openclaw_json_get_string '.gateway.reload.mode // "hybrid"' 2>/dev/null || echo hybrid)"
        skpl_ui_kv "health check" "$(openclaw_json_get_string '.gateway.channelHealthCheckMinutes // 5' 2>/dev/null || echo 5)"
        skpl_ui_kv "stale threshold" "$(openclaw_json_get_string '.gateway.channelStaleEventThresholdMinutes // 30' 2>/dev/null || echo 30)"
        skpl_ui_kv "max restarts" "$(openclaw_json_get_string '.gateway.channelMaxRestartsPerHour // 10' 2>/dev/null || echo 10)"
        echo
        skpl_ui_menu_item 1 "设置 reload.mode" "hybrid / hot / restart / off"
        skpl_ui_menu_item 2 "设置健康检查间隔" "gateway.channelHealthCheckMinutes"
        skpl_ui_menu_item 3 "设置陈旧阈值" "gateway.channelStaleEventThresholdMinutes"
        skpl_ui_menu_item 4 "设置每小时最大重启数" "gateway.channelMaxRestartsPerHour"
        skpl_ui_menu_item 0 "返回上一级"
        skpl_ui_footer_prompt "请选择: "
        read -e choice
        case "$choice" in
          1)
            read -e -p "请输入 reload.mode: " value
            if [ -n "$value" ] && ! openclaw_config_set_string gateway.reload.mode "$value"; then
              echo "配置写入失败，请检查输入值。"
              sleep 1
            fi
            ;;
          2)
            read -e -p "请输入 channelHealthCheckMinutes: " value
            if [ -n "$value" ] && ! openclaw_config_set_json_number gateway.channelHealthCheckMinutes "$value"; then
              echo "请输入正整数。"
              sleep 1
            fi
            ;;
          3)
            read -e -p "请输入 channelStaleEventThresholdMinutes: " value
            if [ -n "$value" ] && ! openclaw_config_set_json_number gateway.channelStaleEventThresholdMinutes "$value"; then
              echo "请输入正整数。"
              sleep 1
            fi
            ;;
          4)
            read -e -p "请输入 channelMaxRestartsPerHour: " value
            if [ -n "$value" ] && ! openclaw_config_set_json_number gateway.channelMaxRestartsPerHour "$value"; then
              echo "请输入正整数。"
              sleep 1
            fi
            ;;
          0)
            return 0
            ;;
        esac
      done
    }

    openclaw_whatsapp_advanced_menu() {
      local choice value
      while true; do
        clear
        skpl_ui_header "WhatsApp 高级设置" "官方高频配置项"
        skpl_ui_kv "dmPolicy" "$(openclaw_json_get_string '.channels.whatsapp.dmPolicy // "pairing"' 2>/dev/null || echo pairing)"
        skpl_ui_kv "groupPolicy" "$(openclaw_json_get_string '.channels.whatsapp.groupPolicy // "allowlist"' 2>/dev/null || echo allowlist)"
        skpl_ui_kv "replyToMode" "$(openclaw_json_get_string '.channels.whatsapp.replyToMode // "off"' 2>/dev/null || echo off)"
        skpl_ui_kv "replyToSelf" "$(openclaw_json_get_string '.channels.whatsapp.replyToSelf // false' 2>/dev/null || echo false)"
        skpl_ui_kv "reactionLevel" "$(openclaw_json_get_string '.channels.whatsapp.reactionLevel // "minimal"' 2>/dev/null || echo minimal)"
        skpl_ui_kv "ackReaction" "$(openclaw_json_get_string '.channels.whatsapp.ackReaction // empty' 2>/dev/null || echo -)"
        skpl_ui_kv "historyLimit" "$(openclaw_json_get_string '.channels.whatsapp.historyLimit // 50' 2>/dev/null || echo 50)"
        echo
        skpl_ui_menu_item 1 "设置 dmPolicy" "pairing / allowlist / open / disabled"
        skpl_ui_menu_item 2 "设置 allowFrom" "逗号分隔电话号码"
        skpl_ui_menu_item 3 "设置 groupPolicy" "allowlist / open / disabled"
        skpl_ui_menu_item 4 "设置 groupAllowFrom" "逗号分隔电话号码"
        skpl_ui_menu_item 5 "设置 replyToMode" "off / first / all / batched"
        skpl_ui_menu_item 6 "设置 reactionLevel" "off / ack / minimal / extensive"
        skpl_ui_menu_item 7 "设置 replyToSelf" "true / false"
        skpl_ui_menu_item 8 "设置 ackReaction" "例如: 👍"
        skpl_ui_menu_item 9 "设置 historyLimit" "默认 50"
        skpl_ui_menu_item 10 "设置 sendReadReceipts" "true / false"
        skpl_ui_menu_item 11 "设置 keepAliveIntervalMs" "web.whatsapp.keepAliveIntervalMs"
        skpl_ui_menu_item 12 "设置 connectTimeoutMs" "web.whatsapp.connectTimeoutMs"
        skpl_ui_menu_item 13 "设置 defaultQueryTimeoutMs" "web.whatsapp.defaultQueryTimeoutMs"
        skpl_ui_menu_item 0 "返回上一级"
        skpl_ui_footer_prompt "请选择: "
        read -e choice
        case "$choice" in
          1) read -e -p "dmPolicy: " value; [ -n "$value" ] && ! openclaw_config_set_string channels.whatsapp.dmPolicy "$value" && { echo "配置写入失败，请检查输入值。"; sleep 1; } ;;
          2) read -e -p "allowFrom（逗号分隔）: " value; [ -n "$value" ] && ! openclaw_config_set_json_array channels.whatsapp.allowFrom "$value" && { echo "请输入至少一个有效号码。"; sleep 1; } ;;
          3) read -e -p "groupPolicy: " value; [ -n "$value" ] && ! openclaw_config_set_string channels.whatsapp.groupPolicy "$value" && { echo "配置写入失败，请检查输入值。"; sleep 1; } ;;
          4) read -e -p "groupAllowFrom（逗号分隔）: " value; [ -n "$value" ] && ! openclaw_config_set_json_array channels.whatsapp.groupAllowFrom "$value" && { echo "请输入至少一个有效号码。"; sleep 1; } ;;
          5) read -e -p "replyToMode: " value; [ -n "$value" ] && ! openclaw_config_set_string channels.whatsapp.replyToMode "$value" && { echo "配置写入失败，请检查输入值。"; sleep 1; } ;;
          6) read -e -p "reactionLevel: " value; [ -n "$value" ] && ! openclaw_config_set_string channels.whatsapp.reactionLevel "$value" && { echo "配置写入失败，请检查输入值。"; sleep 1; } ;;
          7) read -e -p "replyToSelf (true/false): " value; [ -n "$value" ] && ! openclaw_config_set_json_bool channels.whatsapp.replyToSelf "$value" && { echo "请输入 true 或 false。"; sleep 1; } ;;
          8) read -e -p "ackReaction: " value; [ -n "$value" ] && ! openclaw_config_set_string channels.whatsapp.ackReaction "$value" && { echo "配置写入失败，请检查输入值。"; sleep 1; } ;;
          9) read -e -p "historyLimit: " value; [ -n "$value" ] && ! openclaw_config_set_json_number channels.whatsapp.historyLimit "$value" && { echo "请输入正整数。"; sleep 1; } ;;
          10) read -e -p "sendReadReceipts (true/false): " value; [ -n "$value" ] && ! openclaw_config_set_json_bool channels.whatsapp.sendReadReceipts "$value" && { echo "请输入 true 或 false。"; sleep 1; } ;;
          11) read -e -p "keepAliveIntervalMs: " value; [ -n "$value" ] && ! openclaw_config_set_json_number web.whatsapp.keepAliveIntervalMs "$value" && { echo "请输入正整数。"; sleep 1; } ;;
          12) read -e -p "connectTimeoutMs: " value; [ -n "$value" ] && ! openclaw_config_set_json_number web.whatsapp.connectTimeoutMs "$value" && { echo "请输入正整数。"; sleep 1; } ;;
          13) read -e -p "defaultQueryTimeoutMs: " value; [ -n "$value" ] && ! openclaw_config_set_json_number web.whatsapp.defaultQueryTimeoutMs "$value" && { echo "请输入正整数。"; sleep 1; } ;;
          0) return 0 ;;
        esac
      done
    }

    openclaw_telegram_advanced_menu() {
      local choice value
      while true; do
        clear
        skpl_ui_header "Telegram 高级设置" "官方高频配置项"
        skpl_ui_kv "dmPolicy" "$(openclaw_json_get_string '.channels.telegram.dmPolicy // "pairing"' 2>/dev/null || echo pairing)"
        skpl_ui_kv "groupPolicy" "$(openclaw_json_get_string '.channels.telegram.groupPolicy // "allowlist"' 2>/dev/null || echo allowlist)"
        skpl_ui_kv "streaming.mode" "$(openclaw_json_get_string '.channels.telegram.streaming.mode // "partial"' 2>/dev/null || echo partial)"
        skpl_ui_kv "replyToMode" "$(openclaw_json_get_string '.channels.telegram.replyToMode // "off"' 2>/dev/null || echo off)"
        skpl_ui_kv "requireMention" "$(openclaw_json_get_string '.channels.telegram.requireMention // false' 2>/dev/null || echo false)"
        echo
        skpl_ui_menu_item 1 "设置 botToken" "写入 channels.telegram.botToken"
        skpl_ui_menu_item 2 "设置 dmPolicy" "pairing / allowlist / open / disabled"
        skpl_ui_menu_item 3 "设置 allowFrom" "逗号分隔用户 ID"
        skpl_ui_menu_item 4 "设置 groupPolicy" "allowlist / open / disabled"
        skpl_ui_menu_item 5 "设置 groupAllowFrom" "逗号分隔用户 ID"
        skpl_ui_menu_item 6 "设置 streaming.mode" "off / partial / block / progress"
        skpl_ui_menu_item 7 "设置 replyToMode" "off / first / all"
        skpl_ui_menu_item 8 "设置 requireMention" "true / false"
        skpl_ui_menu_item 9 "设置 pollingStallThresholdMs" "轮询停滞阈值"
        skpl_ui_menu_item 10 "设置 timeoutSeconds" "Telegram API 超时"
        skpl_ui_menu_item 11 "设置 autoSelectFamily" "true / false"
        skpl_ui_menu_item 12 "设置 proxy" "http/socks5 代理 URL"
        skpl_ui_menu_item 0 "返回上一级"
        skpl_ui_footer_prompt "请选择: "
        read -e choice
        case "$choice" in
          1) read -e -p "botToken: " value; [ -n "$value" ] && ! openclaw_config_set_string channels.telegram.botToken "$value" && { echo "配置写入失败，请检查输入值。"; sleep 1; } ;;
          2) read -e -p "dmPolicy: " value; [ -n "$value" ] && ! openclaw_config_set_string channels.telegram.dmPolicy "$value" && { echo "配置写入失败，请检查输入值。"; sleep 1; } ;;
          3) read -e -p "allowFrom（逗号分隔）: " value; [ -n "$value" ] && ! openclaw_config_set_json_array channels.telegram.allowFrom "$value" && { echo "请输入至少一个有效用户 ID。"; sleep 1; } ;;
          4) read -e -p "groupPolicy: " value; [ -n "$value" ] && ! openclaw_config_set_string channels.telegram.groupPolicy "$value" && { echo "配置写入失败，请检查输入值。"; sleep 1; } ;;
          5) read -e -p "groupAllowFrom（逗号分隔）: " value; [ -n "$value" ] && ! openclaw_config_set_json_array channels.telegram.groupAllowFrom "$value" && { echo "请输入至少一个有效用户 ID。"; sleep 1; } ;;
          6) read -e -p "streaming.mode: " value; [ -n "$value" ] && ! openclaw_config_set_string channels.telegram.streaming.mode "$value" && { echo "配置写入失败，请检查输入值。"; sleep 1; } ;;
          7) read -e -p "replyToMode: " value; [ -n "$value" ] && ! openclaw_config_set_string channels.telegram.replyToMode "$value" && { echo "配置写入失败，请检查输入值。"; sleep 1; } ;;
          8) read -e -p "requireMention (true/false): " value; [ -n "$value" ] && ! openclaw_config_set_json_bool channels.telegram.requireMention "$value" && { echo "请输入 true 或 false。"; sleep 1; } ;;
          9) read -e -p "pollingStallThresholdMs: " value; [ -n "$value" ] && ! openclaw_config_set_json_number channels.telegram.pollingStallThresholdMs "$value" && { echo "请输入正整数。"; sleep 1; } ;;
          10) read -e -p "timeoutSeconds: " value; [ -n "$value" ] && ! openclaw_config_set_json_number channels.telegram.timeoutSeconds "$value" && { echo "请输入正整数。"; sleep 1; } ;;
          11) read -e -p "autoSelectFamily (true/false): " value; [ -n "$value" ] && ! openclaw_config_set_json_bool channels.telegram.network.autoSelectFamily "$value" && { echo "请输入 true 或 false。"; sleep 1; } ;;
          12) read -e -p "proxy URL: " value; [ -n "$value" ] && ! openclaw_config_set_string channels.telegram.proxy "$value" && { echo "配置写入失败，请检查输入值。"; sleep 1; } ;;
          0) return 0 ;;
        esac
      done
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
      openclaw_get_plugins_list_cached
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
          plugin_list=$(openclaw_get_plugins_list_cached)

          if echo "$plugin_list" | grep -qw "$plugin_id" && echo "$plugin_list" | grep "$plugin_id" | grep -q "disabled"; then
            echo "💡 插件 [$plugin_id] 已预装，正在激活..."
            if openclaw_plugin_exec_with_core_sync "enable" "$plugin_id" "$plugin_id"; then
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
            if openclaw_plugin_exec_with_core_sync "enable" "$plugin_id" "$plugin_id"; then
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
          if openclaw_plugin_exec_with_core_sync "install" "$plugin_full" "$plugin_id"; then
            echo "✅ 下载成功，正在启用..."
            if openclaw_plugin_exec_with_core_sync "enable" "$plugin_id" "$plugin_id"; then
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
        openclaw_get_plugins_list_cached true >/dev/null 2>&1 || true
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

  openclaw_get_plugins_list_cached() {
    local force_refresh="${1:-false}"
    local plugin_list=""
    if [ "$force_refresh" != "true" ] && openclaw_memory_cache_fresh "$SKPL_PLUGIN_LIST_CACHE_FILE" 20 && [ -s "$SKPL_PLUGIN_LIST_CACHE_FILE" ]; then
      cat "$SKPL_PLUGIN_LIST_CACHE_FILE"
      return 0
    fi
    plugin_list=$(openclaw plugins list 2>/dev/null || true)
    if [ -n "$plugin_list" ]; then
      printf '%s\n' "$plugin_list" > "$SKPL_PLUGIN_LIST_CACHE_FILE"
      printf '%s\n' "$plugin_list"
      return 0
    fi
    [ -s "$SKPL_PLUGIN_LIST_CACHE_FILE" ] && cat "$SKPL_PLUGIN_LIST_CACHE_FILE"
    return 0
  }

  openclaw_plugin_runtime_mismatch_log() {
    local log_file="$1"
    [ -s "$log_file" ] || return 1
    grep -Eq "does not provide an export named|fetch-runtime|createHttp1EnvHttpProxyAgent|SyntaxError: The requested module" "$log_file"
  }

  openclaw_remove_plugin_local_dirs() {
    local plugin_id="$1"
    [ -z "$plugin_id" ] && return 0
    mv "${HOME}/.openclaw/extensions/${plugin_id}" "${HOME}/.openclaw/extensions/${plugin_id}.disabled.$(date +%s)" >/dev/null 2>&1 || true
    mv "${HOME}/.openclaw/extensions/openclaw-${plugin_id}" "${HOME}/.openclaw/extensions/openclaw-${plugin_id}.disabled.$(date +%s)" >/dev/null 2>&1 || true
    if [ "$HOME" != "/root" ]; then
      mv "/root/.openclaw/extensions/${plugin_id}" "/root/.openclaw/extensions/${plugin_id}.disabled.$(date +%s)" >/dev/null 2>&1 || true
      mv "/root/.openclaw/extensions/openclaw-${plugin_id}" "/root/.openclaw/extensions/openclaw-${plugin_id}.disabled.$(date +%s)" >/dev/null 2>&1 || true
    fi
  }

  openclaw_plugin_exec_with_core_sync() {
    local action="$1"
    local plugin_ref="$2"
    local plugin_id="$3"
    local log_file first_rc=1
    log_file=$(mktemp)

    set +e
    if [ "$action" = "enable" ]; then
      openclaw plugins enable "$plugin_ref" >"$log_file" 2>&1
    else
      openclaw plugins install "$plugin_ref" >"$log_file" 2>&1
    fi
    first_rc=$?
    set -e

    if [ $first_rc -eq 0 ]; then
      cat "$log_file" 2>/dev/null || true
      return 0
    fi

    if openclaw_plugin_runtime_mismatch_log "$log_file"; then
      echo "检测到插件与 OpenClaw 核心版本不兼容，正在自动同步核心版本..."
      cat "$log_file" 2>/dev/null || true
      openclaw_remove_plugin_local_dirs "$plugin_id"
      install_openclaw_global || true
      ensure_openclaw_cli_on_path >/dev/null 2>&1 || true
      refresh_openclaw_gateway_service >/dev/null 2>&1 || true
      openclaw_get_plugins_list_cached true >/dev/null 2>&1 || true
      set +e
      if [ "$action" = "enable" ]; then
        openclaw plugins enable "$plugin_ref" >"$log_file" 2>&1
      else
        openclaw plugins install "$plugin_ref" >"$log_file" 2>&1
      fi
      first_rc=$?
      set -e
      cat "$log_file" 2>/dev/null || true
      return $first_rc
    fi

    cat "$log_file" 2>/dev/null || true
    return $first_rc
  }

  openclaw_ensure_channel_plugin_enabled() {
    local plugin_id="$1"
    local plugin_list
    [ -z "$plugin_id" ] && return 1

    plugin_list=$(openclaw_get_plugins_list_cached)

    if echo "$plugin_list" | grep -qw "$plugin_id" && echo "$plugin_list" | grep "$plugin_id" | grep -q "disabled"; then
      openclaw_plugin_exec_with_core_sync "enable" "$plugin_id" "$plugin_id" || return 1
      sync_openclaw_plugin_allowlist "$plugin_id" || true
      return 0
    fi

    if openclaw_plugin_local_installed "$plugin_id"; then
      openclaw_plugin_exec_with_core_sync "enable" "$plugin_id" "$plugin_id" >/dev/null 2>&1 || true
      sync_openclaw_plugin_allowlist "$plugin_id" || true
      return 0
    fi

    openclaw_plugin_exec_with_core_sync "install" "$plugin_id" "$plugin_id" || return 1
    sync_openclaw_plugin_allowlist "$plugin_id" || true
    return 0
  }

  openclaw_prepare_whatsapp_channel() {
    if ! openclaw_ensure_channel_plugin_enabled "whatsapp"; then
      if ! openclaw_ensure_channel_plugin_enabled "openclaw-whatsapp"; then
        echo "❌ WhatsApp 插件安装或启用失败。"
        return 1
      fi
    fi
    openclaw config set channels.whatsapp.enabled true --json >/dev/null 2>&1 || true
    openclaw_apply_channel_proxy_config "whatsapp"
    return 0
  }

  openclaw_whatsapp_auth_root() {
    printf '%s\n' "${HOME}/.openclaw/credentials/whatsapp"
  }

  openclaw_is_wsl() {
    grep -qiE '(microsoft|wsl)' /proc/version 2>/dev/null
  }

  openclaw_whatsapp_session_root() {
    printf '%s\n' "$(openclaw_whatsapp_auth_root)"
  }

  openclaw_whatsapp_has_session() {
    local auth_root legacy_root
    auth_root=$(openclaw_whatsapp_auth_root)
    legacy_root="${HOME}/.openclaw/whatsapp"
    if find "$auth_root" -maxdepth 3 -type f -name 'creds.json' 2>/dev/null | grep -q .; then
      return 0
    fi
    openclaw_dir_has_files "$legacy_root"
  }

  openclaw_whatsapp_probe_connected() {
    if ! openclaw_whatsapp_has_session; then
      return 1
    fi
    timeout 8 openclaw channels status 2>/dev/null | python3 - <<'PY'
import sys
text = sys.stdin.read().lower()
if 'whatsapp' in text and ('linked' in text or 'connected' in text or 'ready' in text):
    raise SystemExit(0)
raise SystemExit(1)
PY
  }

  openclaw_whatsapp_wait_for_ready() {
    local attempts="${1:-4}" delay="${2:-3}" i=1
    while [ "$i" -le "$attempts" ]; do
      case "$(openclaw_whatsapp_status)" in
        connected)
          return 0
          ;;
        session_only)
          return 2
          ;;
      esac
      if [ "$i" -lt "$attempts" ]; then
        sleep "$delay"
      fi
      i=$((i + 1))
    done
    return 1
  }

  openclaw_whatsapp_clear_broken_state() {
    local session_root legacy_root
    if openclaw_whatsapp_has_session; then
      return 0
    fi
    session_root=$(openclaw_whatsapp_session_root)
    mkdir -p "$session_root"
    find "$session_root" -maxdepth 2 -type f \( -name '*.lock' -o -name 'Singleton*' -o -name 'DevToolsActivePort' -o -name '*.tmp' -o -name '*.log' \) -exec mv -f {} "${session_root}/" \; >/dev/null 2>&1 || true
    legacy_root="${HOME}/.openclaw/whatsapp"
    if [ -d "$legacy_root" ]; then
      find "$legacy_root" -maxdepth 2 -type f \( -name '*.lock' -o -name 'Singleton*' -o -name 'DevToolsActivePort' -o -name '*.tmp' -o -name '*.log' \) -exec mv -f {} "${legacy_root}/" \; >/dev/null 2>&1 || true
    fi
  }

  openclaw_whatsapp_pause_gateway_for_login() {
    if openclaw_gateway_is_running; then
      echo "登录前暂停 OpenClaw gateway，避免二维码登录与运行中会话竞争同一认证状态。"
      openclaw_gateway_mark_sensitive_period 240
      openclaw gateway stop >/dev/null 2>&1 || true
      sleep 2
      return 0
    fi
    return 1
  }

  openclaw_whatsapp_login_via_cli() {
    local login_log="/root/.skpl/openclaw-whatsapp-login.log"
    local gateway_was_running="false"
    refresh_runtime_proxy_env
    if ! openclaw_prepare_whatsapp_channel; then
      echo "❌ WhatsApp 通道准备失败。"
      return 1
    fi
    if openclaw_whatsapp_pause_gateway_for_login; then
      gateway_was_running="true"
    fi
    echo "正在启动官方 WhatsApp 登录流程..."
    echo "请按命令输出的二维码完成扫码，直到命令返回。"
    echo "登录日志: ${login_log}"
    if openclaw_run_interactive_logged_command "$login_log" openclaw channels login --channel whatsapp; then
      echo "正在恢复 OpenClaw gateway..."
      openclaw_gateway_clear_sensitive_period
      openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
      echo "正在进行登录后状态确认..."
      openclaw_whatsapp_wait_for_ready 6 2
      case "$?" in
        0)
          echo "✅ WhatsApp 通道已连接，官方状态已确认。"
          ;;
        2)
          echo "⚠️ 已检测到本地会话文件，但官方连接状态仍在稳定中。"
          echo "请先执行 openclaw channels status，再按需打开 WebUI 查看待处理请求。"
          ;;
        *)
          echo "⚠️ 登录命令已返回，但绑定状态尚未稳定。"
          echo "请先执行 openclaw channels status，再按需打开 WebUI 查看待处理请求。"
          ;;
      esac
      return 0
    fi
    openclaw_gateway_clear_sensitive_period
    if [ "$gateway_was_running" = "true" ]; then
      openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
    fi
    echo "❌ 官方 WhatsApp 登录流程未成功完成。"
    return 1
  }

  openclaw_open_url() {
    local url="$1"
    [ -z "$url" ] && return 1
    if command -v xdg-open >/dev/null 2>&1; then
      nohup xdg-open "$url" >/dev/null 2>&1 &
      return 0
    fi
    if openclaw_is_wsl && command -v powershell.exe >/dev/null 2>&1; then
      nohup powershell.exe -NoProfile -Command "Start-Process '$url'" >/dev/null 2>&1 &
      return 0
    fi
    if openclaw_is_wsl && command -v explorer.exe >/dev/null 2>&1; then
      nohup explorer.exe "$url" >/dev/null 2>&1 &
      return 0
    fi
    return 1
  }

  openclaw_whatsapp_pairing_url() {
    local token scheme
    scheme=$(openclaw_webui_scheme)
    token=$(openclaw_webui_token_from_config 2>/dev/null || openclaw_webui_get_cached_token 2>/dev/null || true)
    if [ -n "$token" ]; then
      printf '%s://127.0.0.1:%s/#token=%s\n' "$scheme" "$(openclaw_gateway_port)" "$token"
    else
      printf '%s://127.0.0.1:%s/\n' "$scheme" "$(openclaw_gateway_port)"
    fi
  }

  openclaw_extract_request_id() {
    python3 - <<'PY'
import re
import sys

text = sys.stdin.read().strip()
patterns = [
    r'requestId\s*[:=]\s*([0-9a-fA-F-]{8,})',
    r'Request[_ -]?Key\s*[:=]\s*([^\s)]+)',
    r'\b([0-9a-fA-F]{8}-[0-9a-fA-F-]{27,})\b',
]

for pattern in patterns:
    match = re.search(pattern, text, re.IGNORECASE)
    if match:
        print(match.group(1))
        raise SystemExit(0)

raise SystemExit(1)
PY
  }

  openclaw_panel_run_as_root() {
    if [ "$(id -u)" -eq 0 ]; then
      "$@"
      return $?
    fi
    if command -v sudo >/dev/null 2>&1; then
      sudo "$@"
      return $?
    fi
    echo "❌ 当前不是 root，且未检测到 sudo，无法执行需要 root 的面板操作。"
    return 1
  }

  openclaw_panel_run_command_with_timeout() {
    local timeout_seconds="$1"
    shift
    timeout "$timeout_seconds" bash -lc '
set -e
if [ "$(id -u)" -eq 0 ]; then
  exec "$@"
fi
if command -v sudo >/dev/null 2>&1; then
  exec sudo "$@"
fi
echo "❌ 当前不是 root，且未检测到 sudo，无法执行需要 root 的面板操作。" >&2
exit 1
' _ "$@"
  }

  openclaw_panel_describe_timeout_result() {
    local exit_code="$1"
    case "$exit_code" in
      0)
        echo "success"
        ;;
      124)
        echo "timeout"
        ;;
      *)
        echo "error"
        ;;
    esac
  }

  openclaw_devices_list_safe() {
    local cached
    cached=$(openclaw_devices_list_cache_read 8 2>/dev/null || true)
    if [ -n "$cached" ]; then
      printf '%s\n' "$cached"
      return 0
    fi
    openclaw_devices_list_cache_refresh
  }

  openclaw_devices_list_raw() {
    openclaw_devices_list_cache_refresh
  }

  openclaw_print_whatsapp_diagnosis() {
    local active_proxy="" session_root gateway_port pair_url whatsapp_proxy_url configured_port auth_hint
    session_root=$(openclaw_whatsapp_session_root)
    gateway_port=$(openclaw_gateway_port)
    pair_url=$(openclaw_whatsapp_pairing_url)
    active_proxy=$(resolve_active_proxy "$(skpl_effective_proxy_port)" 2>/dev/null || true)
    configured_port=$(skpl_effective_proxy_port)
    whatsapp_proxy_url=$(openclaw_channel_http_proxy_url)
    auth_hint="${session_root}/default/creds.json"

    skpl_ui_header "WhatsApp 连接诊断" "聚焦 WSL、代理、网关与会话状态"
    skpl_ui_kv "WSL 环境" "$(openclaw_is_wsl && echo 是 || echo 否)"
    skpl_ui_kv "网关端口" "$gateway_port"
    skpl_ui_kv "网关监听" "$(openclaw_gateway_port_reachable && echo 正常 || echo 未就绪)"
    skpl_ui_kv "安装代理端口" "$configured_port"
    skpl_ui_kv "代理状态" "${active_proxy:-未探测到活动代理}"
    skpl_ui_kv "WhatsApp代理" "$whatsapp_proxy_url"
    skpl_ui_kv "凭据目录" "$session_root"
    skpl_ui_kv "凭据文件" "$(openclaw_whatsapp_has_session && echo 已存在 || echo 未生成)"
    skpl_ui_kv "默认凭据" "$auth_hint"
    skpl_ui_kv "WebUI入口" "$pair_url"
    skpl_ui_kv "连接状态" "$(case "$(openclaw_whatsapp_status)" in connected) echo 已连接 ;; session_only) echo 已存在本地会话 ;; *) echo 未就绪 ;; esac)"
    echo
    echo "建议："
    echo "1. 18789 是本地网关端口，10808 或自定义端口用于 WhatsApp 出站代理。"
    echo "2. WhatsApp 官方登录流程应使用 openclaw channels login --channel whatsapp。"
    echo "3. WebUI 入口用于 OpenClaw 控制台访问，不作为 WhatsApp 官方扫码登录主流程。"
    echo "4. 若出现 fetch-runtime / createHttp1EnvHttpProxyAgent 报错，说明插件与 OpenClaw 核心版本不匹配，脚本已会自动同步核心后重试。"
  }

  openclaw_network_diagnosis_status() {
    local label="$1" value="$2" tone="warn"
    case "$value" in
      正常|已连接|已开启*|已存在|可用|已识别)
        tone="ok"
        ;;
      未就绪|未生成|未探测到*|未识别到*|不可用|异常)
        tone="danger"
        ;;
    esac
    skpl_ui_status_row "$label" "$tone" "$value"
  }

  openclaw_network_diagnosis_menu() {
    local scheme port token domains active_proxy configured_port whatsapp_proxy_url whatsapp_session provider_summary
    scheme=$(openclaw_webui_scheme)
    port=$(openclaw_gateway_port)
    token=$(openclaw_webui_token_from_config 2>/dev/null || openclaw_webui_get_cached_token 2>/dev/null || true)
    domains=$(openclaw_find_webui_domain)
    active_proxy=$(resolve_active_proxy "$(skpl_effective_proxy_port)" 2>/dev/null || true)
    configured_port=$(skpl_effective_proxy_port)
    whatsapp_proxy_url=$(openclaw_channel_http_proxy_url)
    whatsapp_session=$(openclaw_whatsapp_has_session && printf '已存在' || printf '未生成')
    provider_summary=$(openclaw_domestic_provider_summary)

    clear
    skpl_ui_header "网络诊断" "汇总网关、本地入口、域名代理与 WhatsApp 状态"
    skpl_ui_section "网关与代理"
    openclaw_network_diagnosis_status "网关监听" "$(openclaw_gateway_port_reachable && echo 正常 || echo 未就绪)"
    skpl_ui_kv "网关地址" "${scheme}://127.0.0.1:${port}/"
    skpl_ui_kv "安装代理端口" "$configured_port"
    openclaw_network_diagnosis_status "活动代理" "${active_proxy:-未探测到活动代理}"
    skpl_ui_kv "WhatsApp代理" "$whatsapp_proxy_url"

    echo
    skpl_ui_section "WebUI 与域名"
    if [ -n "$token" ]; then
      skpl_ui_kv "本机入口" "${scheme}://127.0.0.1:${port}/#token=${token}"
    else
      skpl_ui_kv "本机入口" "${scheme}://127.0.0.1:${port}/"
    fi
    if [ -n "$domains" ]; then
      openclaw_network_diagnosis_status "域名入口" "已识别"
      while IFS= read -r d; do
        [ -z "$d" ] && continue
        if [ -n "$token" ]; then
          skpl_ui_kv "域名地址" "${d}/#token=${token}"
        else
          skpl_ui_kv "域名地址" "${d}/"
        fi
      done <<EOF
$domains
EOF
    else
      openclaw_network_diagnosis_status "域名入口" "未识别到反向代理域名"
    fi

    echo
    skpl_ui_section "国内直连与 WhatsApp"
    skpl_ui_kv "国内直连" "$provider_summary"
    openclaw_network_diagnosis_status "凭据文件" "$whatsapp_session"
    case "$(openclaw_whatsapp_status)" in
      connected)
        openclaw_network_diagnosis_status "WhatsApp探测" "已连接"
        ;;
      session_only)
        openclaw_network_diagnosis_status "WhatsApp探测" "已存在本地会话"
        ;;
      *)
        openclaw_network_diagnosis_status "WhatsApp探测" "未就绪"
        ;;
    esac
    echo
    read -p "按回车返回菜单..."
  }

  openclaw_whatsapp_open_pairing_page() {
    local pair_url
    pair_url=$(openclaw_whatsapp_pairing_url)
    echo "配对页地址：$pair_url"
    if openclaw_open_url "$pair_url"; then
      echo "已尝试在宿主浏览器打开配对页。"
    else
      echo "请手动在浏览器中打开上述地址。"
    fi
  }

  openclaw_whatsapp_open_qr_connection() {
    echo "正在准备 WhatsApp 官方 QR 登录..."
    openclaw_whatsapp_login_via_cli
    return $?
  }

  openclaw_whatsapp_show_login_log() {
    local login_log="/root/.skpl/openclaw-whatsapp-login.log"
    if [ ! -f "$login_log" ]; then
      echo "暂无 WhatsApp 登录日志。"
      return 0
    fi
    python3 - "$login_log" <<'PY'
import sys
path = sys.argv[1]
with open(path, 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()
for line in lines[-120:]:
    print(line.rstrip())
PY
  }

  openclaw_whatsapp_repair_flow() {
    echo "正在执行 WhatsApp 通道修复..."
    refresh_runtime_proxy_env
    openclaw_prepare_whatsapp_channel || return 1
    if ! openclaw_whatsapp_has_session; then
      openclaw_whatsapp_clear_broken_state
    fi
    openclaw_print_whatsapp_diagnosis
    echo
    echo "已为 WhatsApp 通道写入代理：$(openclaw_channel_http_proxy_url)"
    echo "登录会在二维码阶段临时暂停 gateway，待扫码完成后再恢复运行。"
    echo "请在二维码出现后直接扫码，并等待登录命令自然返回。"
    echo
    openclaw_whatsapp_login_via_cli
    return $?
  }

  openclaw_whatsapp_menu() {
    while true; do
      clear
      openclaw_print_whatsapp_diagnosis
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "一键修复并执行登录" "保留代理与必要修复后执行官方登录"
      skpl_ui_menu_item 2 "WhatsApp 官方 QR 登录" "执行 channels login --channel whatsapp"
      skpl_ui_menu_item 3 "仅打开 WebUI 页" "仅在登录后用于控制台访问与查看待处理请求"
      skpl_ui_menu_item 4 "批准连接码" "输入 WhatsApp 收到的配对码"
      skpl_ui_menu_item 5 "查看登录日志" "读取最近一次 WhatsApp 登录输出"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e wa_choice

      case "$wa_choice" in
        1)
          openclaw_whatsapp_repair_flow
          echo
          read -p "按回车返回菜单..."
          ;;
        2)
          openclaw_whatsapp_open_qr_connection
          echo
          echo "登录命令返回后，请先执行 openclaw channels status 确认绑定状态。"
          echo "若 WebUI 仍提示待审批，再进入 WebUI 菜单查看当前 devices list。"
          echo
          read -p "按回车返回菜单..."
          ;;
        3)
          if openclaw_prepare_whatsapp_channel; then
            openclaw_whatsapp_open_pairing_page
          fi
          echo
          read -p "按回车返回菜单..."
          ;;
        4)
          if ! openclaw_prepare_whatsapp_channel; then
            break_end
            continue
          fi
          read -e -p "请输入 WhatsApp 收到的连接码 (例如 NYA99R2F)（输入 0 退出）： " code
          if [ "$code" = "0" ]; then
            continue
          fi
          if [ -z "$code" ]; then
            echo "错误：连接码不能为空。"
            sleep 1
            continue
          fi
          openclaw pairing approve whatsapp "$code"
          break_end
          ;;
        5)
          openclaw_whatsapp_show_login_log
          echo
          read -p "按回车返回菜单..."
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

  openclaw_prepare_telegram_channel() {
    if ! openclaw_ensure_channel_plugin_enabled "telegram"; then
      if ! openclaw_ensure_channel_plugin_enabled "openclaw-telegram"; then
        echo "❌ Telegram 插件安装或启用失败。"
        return 1
      fi
    fi
    openclaw config set channels.telegram.enabled true --json >/dev/null 2>&1 || true
    openclaw_apply_channel_proxy_config "telegram"
    openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
    return 0
  }

  openclaw_telegram_has_session() {
    openclaw_dir_has_files "${HOME}/.openclaw/telegram"
  }

  openclaw_telegram_pairing_approve() {
    local code="$1"
    [ -z "$code" ] && return 1
    openclaw pairing approve telegram "$code"
  }

  openclaw_telegram_login_flow() {
    local code
    echo "正在准备 Telegram 通道..."
    if ! openclaw_prepare_telegram_channel; then
      return 1
    fi
    read -e -p "请输入 TG 机器人收到的连接码 (例如 NYA99R2F)（输入 0 退出）： " code
    if [ "$code" = "0" ]; then
      return 0
    fi
    if [ -z "$code" ]; then
      echo "错误：连接码不能为空。"
      return 1
    fi
    if openclaw_telegram_pairing_approve "$code"; then
      if openclaw_telegram_has_session; then
        echo "✅ Telegram 本地会话已存在。"
      else
        echo "⚠️ Telegram 批准已提交，请稍后复查本地状态。"
      fi
      return 0
    fi
    echo "❌ Telegram 连接码批准失败。"
    return 1
  }

  openclaw_channel_tools_menu() {
    local choice
    while true; do
      clear
      skpl_ui_header "渠道诊断与高级设置" "官方 probe、诊断与网关参数入口"
      echo
      skpl_ui_section "诊断"
      skpl_ui_menu_item 1 "官方诊断中心" "status / gateway status / doctor / probe / logs"
      skpl_ui_menu_item 2 "单渠道 Probe" "按渠道执行 channels status --probe"
      echo
      skpl_ui_section "高级设置"
      skpl_ui_menu_item 3 "WhatsApp 高级设置" "dmPolicy、replyToMode、historyLimit 等"
      skpl_ui_menu_item 4 "Telegram 高级设置" "streaming、timeout、proxy 等"
      skpl_ui_menu_item 5 "Gateway 高级设置" "reload 与健康监控参数"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请选择: "
      read -e choice
      case "$choice" in
        1) openclaw_run_official_diagnostics ;;
        2) openclaw_probe_single_channel_menu ;;
        3) openclaw_whatsapp_advanced_menu ;;
        4) openclaw_telegram_advanced_menu ;;
        5) openclaw_gateway_advanced_menu ;;
        0) return 0 ;;
        *)
          echo "无效的选择，请重试。"
          sleep 1
          ;;
      esac
    done
  }

  openclaw_prepare_discord_channel() {
    if ! openclaw_ensure_channel_plugin_enabled "discord"; then
      if ! openclaw_ensure_channel_plugin_enabled "openclaw-discord"; then
        echo "❌ Discord 插件安装或启用失败。"
        return 1
      fi
    fi
    openclaw config set channels.discord.enabled true --json >/dev/null 2>&1 || true
    openclaw_apply_channel_proxy_config "discord"
    openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
    return 0
  }

  openclaw_prepare_slack_channel() {
    if ! openclaw_ensure_channel_plugin_enabled "slack"; then
      if ! openclaw_ensure_channel_plugin_enabled "openclaw-slack"; then
        echo "❌ Slack 插件安装或启用失败。"
        return 1
      fi
    fi
    openclaw config set channels.slack.enabled true --json >/dev/null 2>&1 || true
    openclaw_apply_channel_proxy_config "slack"
    openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
    return 0
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

  openclaw_print_bot_status_line_with_mode() {
    local label="$1"
    local status="$2"
    local mode="$3"
    echo -e "- ${label}: $(openclaw_colorize_bot_status "$status") [${mode}]"
  }

  openclaw_show_bot_local_status_block() {
    openclaw_probe_cache_refresh >/dev/null 2>&1 || true
    if openclaw_memory_cache_fresh "$SKPL_BOT_STATUS_CACHE_FILE" 20 && [ -s "$SKPL_BOT_STATUS_CACHE_FILE" ]; then
      sed -n '1,80p' "$SKPL_BOT_STATUS_CACHE_FILE"
      return 0
    fi
    local output
    output=$(openclaw_render_bot_local_status_block_raw)
    printf '%s\n' "$output" > "$SKPL_BOT_STATUS_CACHE_FILE"
    printf '%s\n' "$output"
  }

  openclaw_whatsapp_status_label() {
    local probe_status
    probe_status=$(openclaw_probe_status_from_cache "whatsapp" 2>/dev/null || true)
    case "$probe_status" in
      connected) echo "已连接" ; return 0 ;;
      pending) echo "待扫码或待批准" ; return 0 ;;
      error) echo "异常" ; return 0 ;;
      disabled) echo "未启用" ; return 0 ;;
      configured) echo "已配置" ; return 0 ;;
    esac
    case "$(openclaw_whatsapp_status)" in
      connected) echo "已连接" ;;
      session_only) echo "已存在本地会话" ;;
      *) echo "未就绪" ;;
    esac
  }

  openclaw_telegram_status_text() {
    local enabled cfg connected has_token probe_status
    enabled=$(openclaw_json_get_bool '.channels.telegram.enabled // .plugins.entries.telegram.enabled // false')
    cfg=$(openclaw_channel_has_cfg "telegram")
    connected="false"
    [ -d "${HOME}/.openclaw/telegram" ] && connected="true"
    has_token=$(openclaw_json_get_string '.channels.telegram.botToken // empty' 2>/dev/null || true)
    probe_status=$(openclaw_probe_status_from_cache "telegram" 2>/dev/null || true)
    if [ "$enabled" != "true" ]; then
      echo "未启用"
    elif [ "$probe_status" = "connected" ]; then
      echo "已连接"
    elif [ "$probe_status" = "pending" ]; then
      echo "待批准"
    elif [ "$probe_status" = "error" ]; then
      echo "异常"
    elif [ "$connected" = "true" ]; then
      echo "已连接"
    elif [ -n "$has_token" ] && [ "$cfg" = "true" ]; then
      echo "已配置待批准"
    elif [ "$cfg" = "true" ]; then
      echo "已配置"
    else
      echo "未配置"
    fi
  }

  openclaw_render_bot_local_status_block_raw() {
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
    if [ "$tg_abnormal" = "true" ]; then
      tg_status="异常"
    else
      tg_status=$(openclaw_telegram_status_text)
    fi

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
    if openclaw_whatsapp_has_session; then
      wa_connected="true"
    fi
    wa_abnormal="false"
    if [ "$wa_enabled" = "true" ] && ! openclaw_plugin_local_installed "whatsapp" && ! openclaw_plugin_local_installed "openclaw-whatsapp"; then
      wa_abnormal="true"
    fi
    if [ "$wa_enabled" = "true" ] && [ "$json_ok" != "true" ]; then
      wa_abnormal="true"
    fi
    if [ "$wa_abnormal" = "true" ]; then
      wa_status="异常"
    elif [ "$wa_enabled" != "true" ]; then
      wa_status="未启用"
    elif [ "$wa_cfg" = "true" ]; then
      wa_status=$(openclaw_whatsapp_status_label)
    else
      wa_status="未配置"
    fi

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
    openclaw_print_bot_status_line_with_mode "Telegram" "$tg_status" "自动代理"
    openclaw_print_bot_status_line_with_mode "飞书(Lark)" "$feishu_status" "本地直连"
    openclaw_print_bot_status_line_with_mode "WhatsApp" "$wa_status" "自动代理"
    openclaw_print_bot_status_line_with_mode "Discord" "$dc_status" "自动代理"
    openclaw_print_bot_status_line_with_mode "Slack" "$slack_status" "自动代理"
    openclaw_print_bot_status_line_with_mode "QQ Bot" "$qq_status" "本地直连"
    openclaw_print_bot_status_line_with_mode "微信 (Weixin)" "$wx_status" "本地直连"
  }

  change_tg_bot_code() {
    send_stats "机器人对接"
    while true; do
      clear
      skpl_ui_header "机器人连接对接" "渠道连接与设备授权分离，海外渠道自动继承安装代理端口"
      openclaw_show_bot_local_status_block
      echo
      echo "代理规则：Telegram / WhatsApp / Discord / Slack 自动使用安装时输入的代理端口。"
      echo "本地规则：飞书 / QQ / 微信保持原有接入逻辑。"
      echo "官方规则：WebUI 新浏览器或新设备访问可能需要一次设备审批。"
      echo "设备规则：device pairing required 属于 OpenClaw 设备授权，和 WhatsApp 扫码关联是两条独立流程。"
      echo "登录规则：WhatsApp 请先执行官方扫码登录，命令返回后优先检查 openclaw channels status。"
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "Telegram 对接" "自动写入代理并手动批准连接码"
      skpl_ui_menu_item 2 "飞书对接" "安装 Lark 集成"
      skpl_ui_menu_item 3 "WhatsApp 对接" "自动写入代理并执行官方登录"
      skpl_ui_menu_item 4 "Discord 对接" "自动写入代理并启用渠道"
      skpl_ui_menu_item 5 "Slack 对接" "自动写入代理并启用渠道"
      skpl_ui_menu_item 6 "QQ 对接" "查看官方接入地址"
      skpl_ui_menu_item 7 "微信对接" "安装 Weixin CLI"
      skpl_ui_menu_item 8 "渠道诊断与高级设置" "官方诊断、单渠道 Probe、Telegram/WhatsApp/Gateway 设置"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e bot_choice

      case $bot_choice in
        1)
          openclaw_telegram_login_flow
          break_end
          ;;
        2)
          npx -y @larksuite/openclaw-lark install
          openclaw config set channels.feishu.streaming true
          openclaw config set channels.feishu.requireMention true --json
          openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
          break_end
          ;;
        3)
          openclaw_whatsapp_menu
          ;;
        4)
          echo "正在准备 Discord 通道..."
          openclaw_prepare_discord_channel
          echo "Discord 已启用，并继承安装代理端口：$(openclaw_channel_http_proxy_url)"
          break_end
          ;;
        5)
          echo "正在准备 Slack 通道..."
          openclaw_prepare_slack_channel
          echo "Slack 已启用，并继承安装代理端口：$(openclaw_channel_http_proxy_url)"
          break_end
          ;;
        6)
          echo "QQ 官方对接地址："
          echo "https://q.qq.com/qqbot/openclaw/login.html"
          break_end
          ;;
        7)
          npx -y @tencent-weixin/openclaw-weixin-cli@latest install
          openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
          break_end
          ;;
        8)
          openclaw_channel_tools_menu
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
          openclaw.json|workspace/*|extensions/*|skills/*|prompts/*|tools/*|telegram/*|feishu/*|whatsapp/*|discord/*|slack/*|qqbot/*|logs/*|memos/*|DREAMS.md|memory/dreaming/*) return 0 ;;
          *) return 1 ;;
        esac
        ;;
      bundle)
        case "$rel" in
          openclaw-root/openclaw.json|openclaw-root/workspace/*|openclaw-root/extensions/*|openclaw-root/skills/*|openclaw-root/prompts/*|openclaw-root/tools/*|openclaw-root/telegram/*|openclaw-root/feishu/*|openclaw-root/whatsapp/*|openclaw-root/discord/*|openclaw-root/slack/*|openclaw-root/qqbot/*|openclaw-root/logs/*|openclaw-root/memos/*|openclaw-root/DREAMS.md|openclaw-root/memory/dreaming/*|agents/*/MEMORY.md|agents/*/memory/*|hybrid-memory/*|evomap/*|evomap-memory/*|evomap-backups/*|memos/*|memory-config/openclaw.json|enterprise-memory/state.json) return 0 ;;
          *) return 1 ;;
        esac
        ;;
      *)
        return 1
        ;;
    esac
  }

  openclaw_read_import_path() {
    local prompt_text="$1"
    local backup_root user_input archive_path
    backup_root=$(openclaw_backup_root)
    mkdir -p "$backup_root"
    echo "备份目录: $backup_root"
    echo "步骤 1: 把压缩包放到这个目录。"
    echo "步骤 2: 这里只输入文件名，或直接输入完整路径。"
    read -e -p "${prompt_text}: " user_input
    [ -z "$user_input" ] && return 1
    if [[ "$user_input" == /* ]]; then
      archive_path="$user_input"
    else
      archive_path="$backup_root/$user_input"
    fi
    printf '%s\n' "$archive_path"
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
    [ -d "$SKPL_HYBRID_MEMORY_ROOT" ] && cp -a "$SKPL_HYBRID_MEMORY_ROOT" "$tmp_payload/hybrid-memory"
    [ -d "$SKPL_MEMOS_ROOT" ] && cp -a "$SKPL_MEMOS_ROOT" "$tmp_payload/memos"
    [ -d "$EVOMAP_MEMORY_DIR" ] && cp -a "$EVOMAP_MEMORY_DIR" "$tmp_payload/evomap-memory"
    if ! find "$tmp_payload" -mindepth 1 -print -quit | grep -q .; then
      echo "❌ 未找到可备份的记忆文件"; rm -rf "$tmp_payload"; break_end; return 1
    fi
    if openclaw_pack_backup_archive "memory-full" "multi-agent" "$tmp_payload" "$out_file"; then
      echo "✅ 记忆全量备份完成 (含多智能体/混合记忆/MemOS): $out_file"; openclaw_offer_transfer_hint "$out_file"
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
    python3 - "$workspaces_json" "$pkg_dir/payload" "$SKPL_HYBRID_MEMORY_ROOT" "$SKPL_MEMOS_ROOT" "$EVOMAP_MEMORY_DIR" <<'PY'
import json, sys, os, shutil

workspaces = {item["id"]: item["ws"] for item in json.loads(sys.argv[1])}
payload_dir = sys.argv[2]
hybrid_root = sys.argv[3]
memos_root = sys.argv[4]
evomap_memory_dir = sys.argv[5]

def copy_replace(src, dest):
    parent = os.path.dirname(dest)
    if parent:
        os.makedirs(parent, exist_ok=True)
    if os.path.exists(dest):
        backup = dest + '.pre-restore'
        if os.path.exists(backup):
            if os.path.isdir(backup):
                shutil.rmtree(backup, ignore_errors=True)
            else:
                os.remove(backup)
        shutil.move(dest, backup)
    if os.path.isdir(src):
        shutil.copytree(src, dest, dirs_exist_ok=False)
    else:
        shutil.copy2(src, dest)

agents_root = os.path.join(payload_dir, "agents")
if os.path.isdir(agents_root):
    for aid in os.listdir(agents_root):
        if aid in workspaces:
            src_agent_dir = os.path.join(agents_root, aid)
            dest_ws = workspaces[aid]
            os.makedirs(dest_ws, exist_ok=True)
            for f in os.listdir(src_agent_dir):
                copy_replace(os.path.join(src_agent_dir, f), os.path.join(dest_ws, f))
            print(f"✅ 已还原智能体记忆: {aid}")

for src_name, dest in [
    ("hybrid-memory", hybrid_root),
    ("memos", memos_root),
    ("evomap-memory", evomap_memory_dir),
]:
    src = os.path.join(payload_dir, src_name)
    if os.path.exists(src):
        copy_replace(src, dest)
        print(f"✅ 已还原目录: {src_name}")
PY
    rm -rf "$tmp_unpack"; echo "✅ 记忆全量还原完成"; break_end
  }

  openclaw_bundle_backup_export() {
    send_stats "OpenClaw统一全量备份"
    local backup_root ts out_file tmp_payload config_file openclaw_root workspaces_json
    backup_root=$(openclaw_backup_root)
    ts=$(date +%Y%m%d-%H%M%S)
    out_file="$backup_root/openclaw-bundle-full-${ts}.tar.gz"
    mkdir -p "$backup_root"
    tmp_payload=$(mktemp -d) || return 1
    config_file=$(openclaw_get_config_file)
    openclaw_root=$(dirname "$config_file")

    if [ -d "$openclaw_root" ]; then
      mkdir -p "$tmp_payload/openclaw-root"
      for d in workspace extensions skills prompts tools telegram feishu whatsapp discord slack qqbot logs memos; do
        [ -e "$openclaw_root/$d" ] && cp -a "$openclaw_root/$d" "$tmp_payload/openclaw-root/"
      done
      [ -f "$openclaw_root/openclaw.json" ] && cp -a "$openclaw_root/openclaw.json" "$tmp_payload/openclaw-root/"
      [ -d "$openclaw_root/memory" ] && cp -a "$openclaw_root/memory" "$tmp_payload/openclaw-root/"
      [ -f "$openclaw_root/$SKPL_MEMORY_DREAMS_FILENAME" ] && cp -a "$openclaw_root/$SKPL_MEMORY_DREAMS_FILENAME" "$tmp_payload/openclaw-root/"
    fi

    workspaces_json=$(openclaw_get_all_agent_workspaces)
    python3 -c "import json, sys, os, shutil;
workspaces = json.loads(sys.argv[1]); root = sys.argv[2]
for item in workspaces:
    aid = item['id']; ws = item['ws']
    if not os.path.isdir(ws):
        continue
    target_dir = os.path.join(root, 'agents', aid)
    os.makedirs(target_dir, exist_ok=True)
    for f in ['MEMORY.md', 'memory']:
        src = os.path.join(ws, f)
        if os.path.exists(src):
            if os.path.isfile(src): shutil.copy2(src, target_dir)
            else: shutil.copytree(src, os.path.join(target_dir, f), dirs_exist_ok=True)
" "$workspaces_json" "$tmp_payload"

    [ -d "$SKPL_HYBRID_MEMORY_ROOT" ] && cp -a "$SKPL_HYBRID_MEMORY_ROOT" "$tmp_payload/hybrid-memory"
    [ -d "$SKPL_MEMOS_ROOT" ] && cp -a "$SKPL_MEMOS_ROOT" "$tmp_payload/memos"
    [ -d "$EVOMAP_DIR" ] && cp -a "$EVOMAP_DIR" "$tmp_payload/evomap"
    [ -d "$EVOMAP_MEMORY_DIR" ] && cp -a "$EVOMAP_MEMORY_DIR" "$tmp_payload/evomap-memory"
    [ -d "$EVOMAP_BACKUP_DIR" ] && cp -a "$EVOMAP_BACKUP_DIR" "$tmp_payload/evomap-backups"
    if [ -f "$config_file" ]; then
      mkdir -p "$tmp_payload/memory-config"
      cp -a "$config_file" "$tmp_payload/memory-config/openclaw.json"
    fi
    if [ -f "$SKPL_MEMORY_ENTERPRISE_STATE_FILE" ]; then
      mkdir -p "$tmp_payload/enterprise-memory"
      cp -a "$SKPL_MEMORY_ENTERPRISE_STATE_FILE" "$tmp_payload/enterprise-memory/state.json"
    fi

    if ! find "$tmp_payload" -mindepth 1 -print -quit | grep -q .; then
      echo "❌ 未找到可备份的数据"
      rm -rf "$tmp_payload"
      break_end
      return 1
    fi

    if openclaw_pack_backup_archive "openclaw-bundle" "full" "$tmp_payload" "$out_file"; then
      echo "✅ 统一全量备份完成: $out_file"
      echo "包含: OpenClaw 项目、所有智能体记忆、记忆方案配置、混合记忆、MemOS、Dream Diary、企业增强状态、EvoMap 目录与 EvoMap 备份目录。"
      openclaw_offer_transfer_hint "$out_file"
    else
      echo "❌ 统一全量备份失败"
    fi

    rm -rf "$tmp_payload"
    break_end
  }

  openclaw_bundle_backup_import() {
    send_stats "OpenClaw统一全量还原"
    local backup_root archive_path tmp_unpack pkg_dir config_file openclaw_root invalid valid_list workspaces_json
    backup_root=$(openclaw_backup_root)
    config_file=$(openclaw_get_config_file)
    openclaw_root=$(dirname "$config_file")
    mkdir -p "$openclaw_root"

    skpl_ui_header "统一全量还原" "单压缩包恢复记忆、EvoMap 与项目配置"
    echo "还原步骤："
    echo "1. 把备份压缩包放到: $backup_root"
    echo "2. 返回此菜单，输入文件名或完整路径"
    echo "3. 面板会自动校验并还原"
    skpl_ui_alert "danger" "该操作会覆盖现有记忆、EvoMap 与 OpenClaw 项目数据" "还原前会执行 manifest/sha256 校验，并在需要时停启 gateway。"
    read -e -p "请输入确认词【我已知晓高风险并继续统一还原】后继续: " confirm_text
    if [ "$confirm_text" != "我已知晓高风险并继续统一还原" ]; then
      echo "❌ 确认词不匹配，已取消还原"
      break_end
      return 1
    fi

    archive_path=$(openclaw_read_import_path "请输入统一全量备份包文件名或路径")
    [ -z "$archive_path" ] && { echo "❌ 未输入备份路径"; break_end; return 1; }

    tmp_unpack=$(mktemp -d) || return 1
    pkg_dir=$(openclaw_prepare_import_archive "openclaw-bundle" "$archive_path" "$tmp_unpack") || { rm -rf "$tmp_unpack"; break_end; return 1; }

    invalid=0
    valid_list=$(mktemp)
    while IFS= read -r rel; do
      [ -z "$rel" ] && continue
      if ! openclaw_is_safe_relpath "$rel" || ! openclaw_restore_path_allowed bundle "$rel"; then
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
      openclaw gateway stop >/dev/null 2>&1 || true
    fi
    evomap_stop_loop >/dev/null 2>&1 || true

    workspaces_json=$(openclaw_get_all_agent_workspaces)
    python3 - "$workspaces_json" "$pkg_dir/payload" "$openclaw_root" "$SKPL_HYBRID_MEMORY_ROOT" "$EVOMAP_DIR" "$EVOMAP_MEMORY_DIR" "$EVOMAP_BACKUP_DIR" "$SKPL_MEMORY_ENTERPRISE_STATE_FILE" <<'PY'
import json, os, shutil, sys

workspaces = {item['id']: item['ws'] for item in json.loads(sys.argv[1])}
payload = sys.argv[2]
openclaw_root = sys.argv[3]
hybrid_root = sys.argv[4]
evomap_dir = sys.argv[5]
evomap_memory_dir = sys.argv[6]
evomap_backup_dir = sys.argv[7]
enterprise_state_file = sys.argv[8]

def copy_replace(src, dest):
    parent = os.path.dirname(dest)
    if parent:
        os.makedirs(parent, exist_ok=True)
    if os.path.exists(dest):
        backup = dest + '.pre-restore'
        if os.path.exists(backup):
            if os.path.isdir(backup):
                shutil.rmtree(backup, ignore_errors=True)
            else:
                os.remove(backup)
        shutil.move(dest, backup)
    if os.path.isdir(src):
        shutil.copytree(src, dest, dirs_exist_ok=False)
    else:
        shutil.copy2(src, dest)

openclaw_src = os.path.join(payload, 'openclaw-root')
if os.path.isdir(openclaw_src):
    for name in os.listdir(openclaw_src):
        copy_replace(os.path.join(openclaw_src, name), os.path.join(openclaw_root, name))

agents_root = os.path.join(payload, 'agents')
if os.path.isdir(agents_root):
    for aid in os.listdir(agents_root):
        ws = workspaces.get(aid)
        if not ws:
            continue
        os.makedirs(ws, exist_ok=True)
        src_agent_dir = os.path.join(agents_root, aid)
        for name in os.listdir(src_agent_dir):
            copy_replace(os.path.join(src_agent_dir, name), os.path.join(ws, name))

for src_name, dest in [
    ('hybrid-memory', hybrid_root),
    ('evomap', evomap_dir),
    ('evomap-memory', evomap_memory_dir),
    ('evomap-backups', evomap_backup_dir),
]:
    src = os.path.join(payload, src_name)
    if os.path.exists(src):
        copy_replace(src, dest)

memory_cfg = os.path.join(payload, 'memory-config', 'openclaw.json')
if os.path.isfile(memory_cfg):
    copy_replace(memory_cfg, os.path.expanduser('~/.openclaw/openclaw.json'))

enterprise_state = os.path.join(payload, 'enterprise-memory', 'state.json')
if os.path.isfile(enterprise_state):
    copy_replace(enterprise_state, enterprise_state_file)
PY

    if command -v openclaw >/dev/null 2>&1; then
      echo "▶️ 还原后启动 OpenClaw gateway..."
      openclaw_gateway_clear_sensitive_period
      openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
    fi
    if [ -d "$EVOMAP_DIR" ]; then
      evomap_start_loop >/dev/null 2>&1 || true
    fi

    rm -f "$valid_list"
    rm -rf "$tmp_unpack"
    echo "✅ 统一全量还原完成"
    echo "已恢复: 记忆方案配置、所有智能体记忆、混合记忆、EvoMap 与 OpenClaw 项目配置。"
    break_end
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
      for d in workspace extensions skills prompts tools memos; do
        [ -e "$openclaw_root/$d" ] && cp -a "$openclaw_root/$d" "$tmp_payload/"
      done
      [ -f "$openclaw_root/openclaw.json" ] && cp -a "$openclaw_root/openclaw.json" "$tmp_payload/"
      [ -f "$openclaw_root/$SKPL_MEMORY_DREAMS_FILENAME" ] && cp -a "$openclaw_root/$SKPL_MEMORY_DREAMS_FILENAME" "$tmp_payload/"
      [ -d "$openclaw_root/$SKPL_MEMORY_DREAMING_DIRNAME" ] && mkdir -p "$tmp_payload/$(dirname "$SKPL_MEMORY_DREAMING_DIRNAME")" && cp -a "$openclaw_root/$SKPL_MEMORY_DREAMING_DIRNAME" "$tmp_payload/$SKPL_MEMORY_DREAMING_DIRNAME"
      for d in telegram feishu whatsapp discord slack qqbot logs; do
        [ -e "$openclaw_root/$d" ] && cp -a "$openclaw_root/$d" "$tmp_payload/"
      done
    else
      [ -d "$openclaw_root/workspace" ] && cp -a "$openclaw_root/workspace" "$tmp_payload/"
      [ -f "$openclaw_root/openclaw.json" ] && cp -a "$openclaw_root/openclaw.json" "$tmp_payload/"
      for d in extensions skills prompts tools memos; do
        [ -e "$openclaw_root/$d" ] && cp -a "$openclaw_root/$d" "$tmp_payload/"
      done
      [ -f "$openclaw_root/$SKPL_MEMORY_DREAMS_FILENAME" ] && cp -a "$openclaw_root/$SKPL_MEMORY_DREAMS_FILENAME" "$tmp_payload/"
      [ -d "$openclaw_root/$SKPL_MEMORY_DREAMING_DIRNAME" ] && mkdir -p "$tmp_payload/$(dirname "$SKPL_MEMORY_DREAMING_DIRNAME")" && cp -a "$openclaw_root/$SKPL_MEMORY_DREAMING_DIRNAME" "$tmp_payload/$SKPL_MEMORY_DREAMING_DIRNAME"
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
      openclaw gateway stop >/dev/null 2>&1 || true
    fi

    while IFS= read -r rel; do
      if [ -d "$pkg_dir/payload/$rel" ]; then
        openclaw_replace_path_from_backup "$pkg_dir/payload/$rel" "$openclaw_root/$rel"
      else
        mkdir -p "$openclaw_root/$(dirname "$rel")"
        cp -a "$pkg_dir/payload/$rel" "$openclaw_root/$rel"
      fi
    done < "$valid_list"

    if command -v openclaw >/dev/null 2>&1; then
      echo "▶️ 还原后启动 OpenClaw gateway..."
      openclaw_gateway_clear_sensitive_period
      openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
      sleep 2
      echo "🩺 gateway 健康检查："
      if openclaw_gateway_port_reachable || openclaw_gateway_process_running || openclaw_gateway_service_active; then
        echo "gateway 已启动"
      else
        echo "gateway 状态未就绪，请稍后手动检查"
      fi
    fi

    rm -f "$valid_list"
    rm -rf "$tmp_unpack"
    echo "✅ OpenClaw 项目还原完成"
    break_end
  }

  openclaw_backup_detect_type() {
    local file_name="$1"
    if [[ "$file_name" == openclaw-bundle-full-*.tar.gz ]]; then
      echo "统一全量备份文件"
    elif [[ "$file_name" == openclaw-memory-full-*.tar.gz ]]; then
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
    local has_bundle=0 has_memory=0 has_project=0 has_other=0
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
        "统一全量备份文件") has_bundle=1 ;;
        "记忆备份文件") has_memory=1 ;;
        "项目备份文件") has_project=1 ;;
        "其他备份文件") has_other=1 ;;
      esac
    done

    if [ "$has_bundle" -eq 1 ]; then
      echo "统一全量备份文件"
      for i in "${!OPENCLAW_BACKUP_FILES[@]}"; do
        file_name="${OPENCLAW_BACKUP_FILES[$i]}"
        file_type=$(openclaw_backup_detect_type "$file_name")
        [ "$file_type" != "统一全量备份文件" ] && continue
        file_path="$backup_root/$file_name"
        file_size=$(ls -lh "$file_path" | awk '{print $5}')
        file_time=$(date -d "$(stat -c %y "$file_path")" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || stat -c %y "$file_path" | awk '{print $1" "$2}')
        printf "%s | %s | %s\n" "$file_name" "$file_size" "$file_time"
      done
    fi

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
  openclaw_memory_cli_supported || return 1
  json_output=$(timeout 8 openclaw memory status --json 2>/dev/null || true)
  if [ -z "$json_output" ]; then
    return 1
  fi
  printf '%s' "$json_output" > "$SKPL_MEMORY_STATUS_CACHE_FILE"
}

openclaw_memory_cli_supported() {
  command -v openclaw >/dev/null 2>&1 || return 1
  timeout 8 openclaw --help 2>/dev/null | grep -qE '(^|[[:space:]])memory([[:space:]]|$)'
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
    openclaw_memory_cli_supported || return 1
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
    if ! openclaw_memory_cli_supported; then
      echo "ℹ️ 当前 OpenClaw 版本未提供 memory CLI，跳过索引重建。"
      return 0
    fi
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
    openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
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
    openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
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
  provider="config-only"
  model_path=$(openclaw_default_memory_model_path)
  model_status=$(openclaw_memory_local_model_status "$model_path")
  workspace="$HOME/.openclaw/workspace"
  echo "当前显示为基础配置视图（尚未刷新运行时状态）"
  if ! openclaw_memory_cli_supported; then
    echo "当前版本未提供 openclaw memory 子命令，已切换为配置态视图"
  fi
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
  if ! openclaw_has_command openclaw; then
    openclaw_memory_render_basic_status
    return 0
  fi
  if ! openclaw_memory_cache_fresh "$SKPL_MEMORY_STATUS_CACHE_FILE" 60; then
    openclaw_memory_refresh_status_cache >/dev/null 2>&1 || true
  fi
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
    openclaw_default_memory_model_path
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
    local backend
    backend=$(openclaw_memory_get_backend)
    if [ "$backend" = "builtin" ] || [ "$backend" = "local" ]; then
      echo "✅ memory.backend 已是 builtin"
    else
      openclaw_memory_config_set "memory.backend" "builtin"
      echo "✅ 已设置 memory.backend=builtin"
    fi
    echo "ℹ️ 当前版本跳过 agents.defaults.memorySearch 写入"

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
      echo "✅ 已发现默认模型文件: $model_dest"
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
      start_gateway nosleep 5
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
      skpl_ui_menu_item 4 "四层方案" "一键启用 官方文件记忆 + LanceDB + EvoMap + MemOS/EvoMap"
      skpl_ui_menu_item 5 "Local Q4_K_M" "本地量化 embedding 模型方案"
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
        4)
          openclaw_memory_enable_four_layer_stack
          break_end
          ;;
        5)
          openclaw_memory_detect_region
          openclaw_memory_select_sources
          OPENCLAW_MEMORY_CONFIG_ONLY="false"
          OPENCLAW_MEMORY_PREHEAT="true"
          openclaw_memory_apply_local_q4km_model
          openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
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
      start_gateway nosleep 5
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

  # ==========================================
# 🌌 OpenClaw 智能模型与能力路由 (Smart Router)
# ==========================================

# 管理 OpenClaw 模型配置，实现真正的按需分配
openclaw_model_manager() {
    local config_file
    config_file=$(openclaw_get_config_file)
    mkdir -p "$(dirname "$config_file")"
    [ ! -f "$config_file" ] && echo '{}' > "$config_file"

    openclaw_runtime_self_heal || true

    while true; do
        clear
        skpl_ui_header "智能模型管理器" "按任务类型分配最佳模型，极致省 Token"
        echo
        python3 - "$config_file" <<'PY'
import json, sys
from pathlib import Path

path = Path(sys.argv[1])
if not path.exists(): path.write_text('{}', encoding='utf-8')
cfg = json.loads(path.read_text(encoding='utf-8'))

agents = cfg.get('agents', {}).get('defaults', {})
primary = agents.get('model', {}).get('primary', '未配置')
image_primary = agents.get('imageModel', {}).get('primary', '未配置') if isinstance(agents.get('imageModel'), dict) else agents.get('imageModel', '未配置')
models = list(agents.get('models', {}).keys())

print(f"🧠 当前主模型 (日常/文本): {primary}")
print(f"👁️ 当前视觉模型: {image_primary}")
print(f"📂 已添加模型列表: {len(models)} 个")
for m in models:
    print(f"   - {m}")
PY
        openclaw_ollama_status
        echo
        skpl_ui_section "操作 (直接写入 OpenClaw 核心配置)"
        skpl_ui_menu_item 1 "设置文本模型" "日常对话/轻量任务 (推荐 Gemini-Flash/Claude-Haiku)"
        skpl_ui_menu_item 2 "设置视觉模型" "图片识别/多模态任务 (推荐 Gemini/GPT-4o)"
        skpl_ui_menu_item 3 "设置代码模型" "开发/复杂逻辑 (推荐 Claude-Opus/o1)"
        skpl_ui_menu_item 4 "设置自定义模型" "其他备用 API"
        skpl_ui_menu_item 5 "本地模型运行时" "安装 ollama 并拉取本地文本/代码模型"
        skpl_ui_menu_item 6 "一键推荐配置" "写入推荐的文本/视觉/代码模型组合"
        skpl_ui_menu_item 7 "安装后验收检查" "检查 openclaw、gateway、ollama、记忆索引状态"
        skpl_ui_menu_item 8 "一键完整本地落地" "安装 ollama、拉模型、启用记忆、重建索引、验收"
        skpl_ui_menu_item 9 "一键应用并重启" "保存配置并让 AI 立即生效"
        skpl_ui_menu_item 0 "返回上一级"
        skpl_ui_footer_prompt "请选择: "
        read -e model_choice
        
        case "$model_choice" in
            1) openclaw_set_model_slot "text" $config_file ;;
            2) openclaw_set_model_slot "image" $config_file ;;
            3) openclaw_set_model_slot "code" $config_file ;;
            4) openclaw_set_model_slot "custom" $config_file ;;
            5)
                openclaw_ollama_quick_setup_menu
                ;;
            6)
                openclaw_apply_recommended_model_profile
                break_end
                ;;
            7)
                openclaw_postinstall_acceptance_check
                break_end
                ;;
            8)
                openclaw_full_local_stack_setup
                break_end
                ;;
            9)
                openclaw_apply_and_restart
                break_end
                ;;
            0) return 0 ;;
        esac
    done
}

openclaw_set_model_slot() {
    local type="$1" config_file="$2"
    local model_name normalized_model provider_model
    read -e -p "请输入 [$type] 模型 ID (格式: 提供商/模型名): " model_name
    [ -z "$model_name" ] && return 0

    normalized_model=$(python3 - "$model_name" <<'PY'
import sys

value = sys.argv[1].strip()
if ' (' in value and value.endswith(')'):
    value = value.split(' (', 1)[0].strip()
if '/' not in value and ':' in value and ' ' not in value:
    value = f'ollama/{value}'
print(value)
PY
)

    if [ -z "$normalized_model" ]; then
      echo "❌ 模型 ID 不能为空。"
      read -n 1 -s -r -p "按任意键继续..."
      return 1
    fi

    if [[ "$normalized_model" == ollama/* ]]; then
      provider_model="${normalized_model#ollama/}"
      openclaw_configure_local_ollama_provider "$provider_model" "$type" >/dev/null 2>&1 || {
        echo "❌ 本地 Ollama 模型配置写入失败: $normalized_model"
        read -n 1 -s -r -p "按任意键继续..."
        return 1
      }
    fi

    python3 - "$config_file" "$type" "$normalized_model" <<'PY'
import json, sys
from pathlib import Path

path = Path(sys.argv[1])
cfg_type = sys.argv[2]
model = sys.argv[3]
cfg = {}
if path.exists() and path.stat().st_size > 0:
    try:
        cfg = json.loads(path.read_text(encoding='utf-8'))
        if not isinstance(cfg, dict):
            cfg = {}
    except Exception:
        cfg = {}

# 初始化结构
if 'agents' not in cfg: cfg['agents'] = {}
if 'defaults' not in cfg['agents']: cfg['agents']['defaults'] = {}
if 'model' not in cfg['agents']['defaults']: cfg['agents']['defaults']['model'] = {}
models_obj = cfg['agents']['defaults'].get('models')
if not isinstance(models_obj, dict):
    if isinstance(models_obj, list):
        models_obj = {str(item): {} for item in models_obj if isinstance(item, str) and item.strip()}
    else:
        models_obj = {}
    cfg['agents']['defaults']['models'] = models_obj

# 添加模型到列表
cfg['agents']['defaults']['models'][model] = {}

# 设置对应类型
if cfg_type == 'text':
    cfg['agents']['defaults']['model']['primary'] = model
elif cfg_type == 'code':
    cfg['agents']['defaults']['models'].setdefault(model, {})['agentRuntime'] = {'id': 'auto'}
elif cfg_type == 'image':
    cfg['agents']['defaults']['imageModel'] = {'primary': model}
elif cfg_type == 'custom':
    cfg['agents']['defaults']['models'][model].setdefault('alias', 'custom')

path.write_text(json.dumps(cfg, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
print(f"✅ 已将 {cfg_type} 模型设为: {model}")
PY
    read -n 1 -s -r -p "按任意键继续..."
}

openclaw_apply_and_restart() {
    echo "💾 正在保存配置并重启 OpenClaw..."
    openclaw_optimize_memory_and_skills >/dev/null 2>&1 || true
    start_gateway force 0 >/dev/null 2>&1 || openclaw gateway restart >/dev/null 2>&1
    echo "✅ 配置已生效！AI 将使用新分配的模型工作。"
}

openclaw_optimize_memory_and_skills() {
    local config_file
    config_file=$(openclaw_get_config_file)
    mkdir -p "$HOME/.openclaw/workspace" "$HOME/.openclaw/workspace/skills" "$HOME/.openclaw/workspace/memory"
    python3 - "$config_file" <<'PY'
import json, sys
from pathlib import Path

path = Path(sys.argv[1])
cfg = {}
if path.exists() and path.stat().st_size > 0:
    try:
        cfg = json.loads(path.read_text(encoding='utf-8'))
        if not isinstance(cfg, dict):
            cfg = {}
    except Exception:
        cfg = {}

gateway = cfg.setdefault('gateway', {})
gateway.setdefault('mode', 'local')
gateway['bind'] = 'loopback'
gateway.setdefault('port', 18789)
for legacy_key in ('host', 'hostname', 'url', 'baseUrl'):
    gateway.pop(legacy_key, None)
gateway.setdefault('auth', {})['mode'] = 'token'
gateway.pop('controlUi', None)

memory = cfg.setdefault('memory', {})
qmd = memory.setdefault('qmd', {})
qmd.setdefault('includeDefaultMemory', True)

agents = cfg.setdefault('agents', {})
defaults = agents.setdefault('defaults', {})
defaults.setdefault('workspace', '~/.openclaw/workspace')
models_obj = defaults.get('models')
if not isinstance(models_obj, dict):
    if isinstance(models_obj, list):
        models_obj = {str(item): {} for item in models_obj if isinstance(item, str) and item.strip()}
    else:
        models_obj = {}
    defaults['models'] = models_obj
defaults.pop('skills', None)

path.parent.mkdir(parents=True, exist_ok=True)
path.write_text(json.dumps(cfg, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
PY
}

openclaw_inject_skills() {
    local skills_dir="$HOME/.openclaw/workspace/skills"
    mkdir -p "$skills_dir"
    cat > "$skills_dir/auto-model-routing.md" <<'EOF'
# Auto Model Routing
- Use `agents.defaults.model.primary` for daily text turns.
- Use `agents.defaults.imageModel.primary` for image understanding.
- Use `ollama/qwen2.5-coder:7b` for code-heavy tasks.
- Prefer concise responses to reduce token usage.
EOF
    cat > "$skills_dir/token-saver.md" <<'EOF'
# Token Saver
- Answer directly.
- Keep outputs concise.
- Avoid unnecessary repetition.
EOF
    cat > "$skills_dir/memory-first.md" <<'EOF'
# Memory First
- Search workspace memory before asking repeated environment questions.
- Persist reusable troubleshooting notes into memory files.
- Prefer local memory search when both local and remote options exist.
EOF
    cat > "$skills_dir/gateway-recovery.md" <<'EOF'
# Gateway Recovery
- Check `systemctl --user status openclaw-gateway.service` when the gateway is unavailable.
- Check whether port `18789` is listening before retrying dependent actions.
- Prefer `start_gateway force 0` after config changes that affect gateway startup.
EOF
    openclaw_optimize_memory_and_skills
    echo "✅ Skills 已写入: $skills_dir"
}

openclaw_evomap_real_ingest() {
    local title="$1" content="$2"
    local evomap_dir="$HOME/.openclaw/workspace/memory/evomap-ingest"
    mkdir -p "$evomap_dir"
    cat > "$evomap_dir/$(date +%s)-note.md" <<EOF
# ${title}

${content}
EOF
    echo "✅ 经验已写入: $evomap_dir"
}

openclaw_configure_local_ollama_provider() {
    local config_file provider_model full_model model_role
    config_file=$(openclaw_get_config_file)
    provider_model="${1:-qwen2.5:7b}"
    model_role="${2:-text}"
    full_model="ollama/${provider_model}"
    python3 - "$config_file" "$provider_model" "$full_model" "$model_role" "$(openclaw_resolve_ollama_bin 2>/dev/null || printf '%s' /usr/bin/ollama)" <<'PY'
import json, sys
from pathlib import Path
path = Path(sys.argv[1])
raw_model = sys.argv[2]
full_model = sys.argv[3]
role = sys.argv[4]
ollama_bin = sys.argv[5]
cfg = {}
if path.exists():
    try:
        cfg = json.loads(path.read_text(encoding='utf-8'))
    except Exception:
        cfg = {}

def build_entry(model_id: str, role_name: str):
    lower = model_id.lower()
    is_image = role_name == 'image' or any(token in lower for token in ('vl', 'vision', 'llava', 'minicpm-v'))
    is_code = role_name == 'code' or 'coder' in lower
    params = {'keep_alive': '15m'}
    if is_image:
        entry = {'id': model_id, 'name': model_id, 'input': ['text', 'image']}
        params['num_ctx'] = 4096
    elif is_code:
        entry = {'id': model_id, 'name': model_id, 'input': ['text'], 'reasoning': True}
        params['num_ctx'] = 16384 if any(tag in lower for tag in ('14b', '32b')) else 8192
        params['thinking'] = False
    else:
        entry = {'id': model_id, 'name': model_id, 'input': ['text']}
        params['num_ctx'] = 8192
        if 'qwen' in lower:
            params['thinking'] = False
    entry['params'] = params
    return entry

cfg.setdefault('models', {}).setdefault('providers', {})
provider = cfg['models']['providers'].setdefault('ollama', {})
provider['baseUrl'] = provider.get('baseUrl') or 'http://127.0.0.1:11434'
provider['apiKey'] = provider.get('apiKey') or 'ollama-local'
provider['api'] = provider.get('api') or 'ollama'
provider['timeoutSeconds'] = max(int(provider.get('timeoutSeconds', 0) or 0), 300)
local_service = provider.get('localService')
if not isinstance(local_service, dict):
    local_service = {}
provider['localService'] = local_service
local_service.setdefault('command', ollama_bin)
local_service.setdefault('args', ['serve'])
local_service.setdefault('healthUrl', 'http://127.0.0.1:11434/api/tags')
local_service.setdefault('readyTimeoutMs', 180000)
local_service.setdefault('idleStopMs', 0)
models = provider.setdefault('models', [])
entry = build_entry(raw_model, role)
updated = False
for index, item in enumerate(models):
    if isinstance(item, dict) and item.get('id') == raw_model:
        merged = dict(item)
        merged.update(entry)
        if isinstance(item.get('params'), dict):
            params = dict(item['params'])
            params.update(entry['params'])
            merged['params'] = params
        models[index] = merged
        updated = True
        break
if not updated:
    models.append(entry)

cfg.setdefault('agents', {}).setdefault('defaults', {})
defs = cfg['agents']['defaults']
defs.setdefault('models', {})
defs['models'].setdefault(full_model, {})
if role == 'image':
    image_model_cfg = defs.get('imageModel')
    if not isinstance(image_model_cfg, dict):
        image_model_cfg = {}
        defs['imageModel'] = image_model_cfg
    image_model_cfg['primary'] = full_model
elif role == 'code':
    defs['models'][full_model].setdefault('agentRuntime', {'id': 'auto'})
    defs['models'][full_model].setdefault('params', {})
    defs['models'][full_model]['params'].setdefault('thinking', False)
else:
    model_cfg = defs.get('model')
    if not isinstance(model_cfg, dict):
        model_cfg = {}
        defs['model'] = model_cfg
    model_cfg['primary'] = full_model
path.parent.mkdir(parents=True, exist_ok=True)
path.write_text(json.dumps(cfg, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
PY
    echo "✅ 已写入本地 Ollama provider 配置"
}

openclaw_apply_recommended_model_profile() {
    local text_model="ollama/qwen2.5:7b"
    local image_model="ollama/qwen2.5vl:7b"
    local code_model="ollama/qwen2.5-coder:7b"
    local config_file
    config_file=$(openclaw_get_config_file)
    python3 - "$config_file" "$text_model" "$image_model" "$code_model" "$(openclaw_resolve_ollama_bin 2>/dev/null || printf '%s' /usr/bin/ollama)" "${OPENCLAW_FORCE_LOCAL_PROFILE:-0}" <<'PY'
import json, sys
from pathlib import Path
path = Path(sys.argv[1])
text_model, image_model, code_model, ollama_bin, force_flag = sys.argv[2:7]
force_local_profile = force_flag == '1'
cfg = {}
if path.exists():
    try:
        cfg = json.loads(path.read_text(encoding='utf-8'))
    except Exception:
        cfg = {}
cfg.setdefault('models', {}).setdefault('providers', {})

def ensure_model_entry(provider_models, entry):
    for index, item in enumerate(provider_models):
        if isinstance(item, dict) and item.get('id') == entry['id']:
            merged = dict(item)
            merged.update(entry)
            if isinstance(item.get('params'), dict) and isinstance(entry.get('params'), dict):
                params = dict(item['params'])
                params.update(entry['params'])
                merged['params'] = params
            provider_models[index] = merged
            return
    provider_models.append(entry)

provider = cfg['models']['providers'].setdefault('ollama', {})
provider['baseUrl'] = provider.get('baseUrl') or 'http://127.0.0.1:11434'
provider['apiKey'] = provider.get('apiKey') or 'ollama-local'
provider['api'] = provider.get('api') or 'ollama'
provider['timeoutSeconds'] = max(int(provider.get('timeoutSeconds', 0) or 0), 300)
local_service = provider.get('localService')
if not isinstance(local_service, dict):
    local_service = {}
    provider['localService'] = local_service
local_service.setdefault('command', ollama_bin)
local_service.setdefault('args', ['serve'])
local_service.setdefault('healthUrl', 'http://127.0.0.1:11434/api/tags')
local_service.setdefault('readyTimeoutMs', 180000)
local_service.setdefault('idleStopMs', 0)
provider_models = provider.setdefault('models', [])
if not isinstance(provider_models, list):
    provider_models = []
    provider['models'] = provider_models
ensure_model_entry(provider_models, {'id': 'qwen2.5:7b', 'name': 'qwen2.5:7b', 'input': ['text'], 'params': {'keep_alive': '15m', 'num_ctx': 8192, 'thinking': False}})
ensure_model_entry(provider_models, {'id': 'qwen2.5vl:7b', 'name': 'qwen2.5vl:7b', 'input': ['text', 'image'], 'params': {'keep_alive': '15m', 'num_ctx': 4096, 'thinking': False}})
ensure_model_entry(provider_models, {'id': 'qwen2.5-coder:7b', 'name': 'qwen2.5-coder:7b', 'input': ['text'], 'reasoning': True, 'params': {'keep_alive': '15m', 'num_ctx': 8192, 'thinking': False}})

cfg.setdefault('agents', {}).setdefault('defaults', {})
defs = cfg['agents']['defaults']
defs.setdefault('models', {})
for model in (text_model, image_model, code_model):
    defs['models'].setdefault(model, {})
if force_local_profile or not isinstance(defs.get('model'), dict) or not defs['model'].get('primary'):
    defs.setdefault('model', {})['primary'] = text_model
if force_local_profile or not isinstance(defs.get('imageModel'), dict) or not defs['imageModel'].get('primary'):
    defs['imageModel'] = {'primary': image_model}
defs['models'][code_model].setdefault('agentRuntime', {'id': 'auto'})
path.parent.mkdir(parents=True, exist_ok=True)
path.write_text(json.dumps(cfg, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
PY
    echo "✅ 推荐模型组合已写入"
    echo "   文本: $text_model"
    echo "   视觉: $image_model"
    echo "   代码: $code_model"
}

openclaw_postinstall_acceptance_check() {
    echo "开始执行安装后验收检查..."
    if openclaw_has_command openclaw; then
      echo "✅ openclaw 命令存在"
    else
      echo "❌ openclaw 命令不存在"
    fi
    if openclaw_has_command ollama; then
      echo "✅ ollama 命令存在"
      openclaw_ensure_ollama_running >/dev/null 2>&1 && echo "✅ ollama 服务可访问" || echo "⚠️ ollama 已安装，但服务未就绪"
    else
      echo "⚠️ ollama 未安装"
    fi
    openclaw_memory_local_retrieval_status
    if openclaw_has_command openclaw; then
      if openclaw_memory_cli_supported; then
        echo "✅ OpenClaw memory CLI 可用"
      else
        echo "ℹ️ 当前 OpenClaw 版本未提供 memory CLI，记忆面板已降级为配置态视图"
      fi
      timeout 10 openclaw models status >/dev/null 2>&1 && echo "✅ OpenClaw 模型状态可读取" || echo "⚠️ OpenClaw 模型状态读取失败"
      timeout 10 openclaw models list --provider ollama >/dev/null 2>&1 && echo "✅ OpenClaw 可读取 Ollama 模型目录" || echo "⚠️ OpenClaw 无法读取 Ollama 模型目录"
      timeout 10 openclaw doctor >/dev/null 2>&1 && echo "✅ openclaw doctor 可执行" || echo "⚠️ openclaw doctor 返回异常"
    fi
}

openclaw_full_local_stack_setup() {
    echo "🚀 开始执行一键完整本地落地..."
    openclaw_runtime_self_heal || return 1
    openclaw_install_ollama_runtime || return 1
    openclaw_ollama_pull_model "qwen2.5:7b" || return 1
    openclaw_ollama_pull_model "qwen2.5vl:7b" || return 1
    openclaw_ollama_pull_model "qwen2.5-coder:7b" || return 1
    OPENCLAW_FORCE_LOCAL_PROFILE=1
    openclaw_apply_recommended_model_profile || return 1
    openclaw_inject_skills || return 1
    openclaw_optimize_memory_and_skills || return 1
    openclaw_memory_enable_local_retrieval || return 1
    openclaw_apply_and_restart || true
    openclaw_postinstall_acceptance_check || true
    echo "✅ 一键完整本地落地完成"
}

openclaw_runtime_self_heal() {
    echo "🔧 正在检查 OpenClaw 运行依赖..."
    install curl ca-certificates jq sqlite3 python3 git tar zstd >/dev/null 2>&1
    ensure_node_runtime || return 1
    mkdir -p "$HOME/.openclaw" "$HOME/.openclaw/models/embedding" "$HOME/.openclaw/workspace/skills"
    echo "✅ 基础运行依赖已就绪"
}

openclaw_ollama_status() {
    if ! openclaw_has_command ollama; then
      echo "本地运行时: 未安装 ollama"
      return 0
    fi
    if ollama list >/dev/null 2>&1; then
      echo "本地运行时: ollama 已就绪"
    else
      echo "本地运行时: ollama 已安装，服务未就绪"
    fi
}

openclaw_ollama_endpoint_ready() {
    if ! openclaw_has_command curl; then
      return 1
    fi
    curl -fsS --connect-timeout 2 --max-time 5 http://127.0.0.1:11434/api/tags >/dev/null 2>&1
}

openclaw_resolve_ollama_bin() {
    if command -v ollama >/dev/null 2>&1; then
      command -v ollama
      return 0
    fi
    if [ -x /usr/local/bin/ollama ]; then
      printf '%s\n' /usr/local/bin/ollama
      return 0
    fi
    if [ -x /usr/bin/ollama ]; then
      printf '%s\n' /usr/bin/ollama
      return 0
    fi
    return 1
}

openclaw_ensure_ollama_running() {
    local ollama_bin
    if openclaw_ollama_endpoint_ready; then
      echo "✅ ollama 服务已就绪"
      return 0
    fi

    ollama_bin=$(openclaw_resolve_ollama_bin 2>/dev/null || true)
    if [ -z "$ollama_bin" ]; then
      echo "⚠️ 未找到 ollama 可执行文件"
      return 1
    fi

    if command -v systemctl >/dev/null 2>&1; then
      systemctl enable ollama >/dev/null 2>&1 || true
      systemctl start ollama >/dev/null 2>&1 || true
      sleep 2
      if openclaw_ollama_endpoint_ready; then
        echo "✅ 已通过 systemd 启动 ollama"
        return 0
      fi
    fi

    if pgrep -f "ollama serve" >/dev/null 2>&1; then
      sleep 2
      if openclaw_ollama_endpoint_ready; then
        echo "✅ ollama serve 已在运行"
        return 0
      fi
    fi

    nohup "$ollama_bin" serve >/tmp/ollama-serve.log 2>&1 &
    disown 2>/dev/null || true
    sleep 3
    if openclaw_ollama_endpoint_ready; then
      echo "✅ 已启动 ollama serve"
      return 0
    fi

    echo "⚠️ ollama 服务尚未就绪，请检查 /tmp/ollama-serve.log，然后手动执行: $ollama_bin serve"
    return 1
}

openclaw_install_ollama_runtime() {
    if openclaw_has_command ollama; then
      echo "✅ ollama 已安装"
      openclaw_ensure_ollama_running || true
      return 0
    fi
    openclaw_ensure_ollama_install_tools || return 1
    echo "⬇️ 正在安装 ollama 本地模型运行时..."
    if curl -fsSL https://ollama.com/install.sh | sh; then
      echo "✅ ollama 安装完成"
      openclaw_ensure_ollama_running || true
    else
      echo "❌ ollama 安装失败，请检查网络后重试"
      return 1
    fi
}

openclaw_ollama_pull_model() {
    local model_name="$1"
    [ -z "$model_name" ] && return 1
    openclaw_install_ollama_runtime || return 1
    openclaw_ensure_ollama_running || return 1
    echo "⬇️ 正在拉取本地模型: $model_name"
    ollama pull "$model_name" || return 1
    local model_role="text"
    case "$model_name" in
      *coder*) model_role="code" ;;
      *vl*|*vision*|*llava*|*minicpm-v*) model_role="image" ;;
    esac
    openclaw_configure_local_ollama_provider "$model_name" "$model_role" || true
    echo "✅ 本地模型已就绪: $model_name"
}

openclaw_ollama_quick_setup_menu() {
    while true; do
      clear
      skpl_ui_header "本地模型运行时" "安装 ollama 并准备本地文本/代码模型"
      openclaw_ollama_status
      echo
      skpl_ui_section "推荐模型"
      skpl_ui_menu_item 1 "qwen2.5:7b" "本地通用文本模型，速度和效果平衡"
      skpl_ui_menu_item 2 "qwen2.5-coder:7b" "本地代码模型，适合开发辅助"
      skpl_ui_menu_item 3 "qwen2.5-coder:14b" "更强代码模型，需要更高配置"
      skpl_ui_menu_item 4 "mistral:7b" "通用备选模型"
      skpl_ui_menu_item 5 "自定义模型" "手动输入任意 ollama 模型名"
      skpl_ui_menu_item 6 "仅安装运行时" "只安装 ollama，不拉取模型"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请选择: "
      read -e ollama_choice
      case "$ollama_choice" in
        1)
          openclaw_ollama_pull_model "qwen2.5:7b"
          break_end
          ;;
        2)
          openclaw_ollama_pull_model "qwen2.5-coder:7b"
          break_end
          ;;
        3)
          openclaw_ollama_pull_model "qwen2.5-coder:14b"
          break_end
          ;;
        4)
          openclaw_ollama_pull_model "mistral:7b"
          break_end
          ;;
        5)
          read -e -p "请输入 ollama 模型名: " custom_ollama_model
          [ -n "$custom_ollama_model" ] && openclaw_ollama_pull_model "$custom_ollama_model"
          break_end
          ;;
        6)
          openclaw_install_ollama_runtime
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

  openclaw_memory_local_retrieval_status() {
    local provider model_path model_status backend
    backend=$(openclaw_memory_get_backend)
    provider="config-only"
    model_path=$(openclaw_memory_expand_path "$(openclaw_memory_get_local_model_path)")
    model_status=$(openclaw_memory_local_model_status "$model_path")
    echo "记忆后端: ${backend:-unknown}"
    echo "检索提供者: ${provider:-unset}"
    echo "本地向量模型: ${model_path:-未配置}"
    case "$model_status" in
      ok) echo "模型状态: 已就绪" ;;
      hf) echo "模型状态: 使用远端 hf: 引用" ;;
      *) echo "模型状态: 未就绪" ;;
    esac
  }

openclaw_memory_enable_local_retrieval() {
    echo "🚀 正在启用本地高命中记忆检索..."
    OPENCLAW_MEMORY_CONFIG_ONLY="false"
    OPENCLAW_MEMORY_PREHEAT="true"
    openclaw_memory_auto_setup_local || return 1
    if openclaw_memory_cli_supported; then
      echo "🧱 正在重建全部索引..."
      openclaw_memory_rebuild_index_all || true
    else
      echo "ℹ️ 当前 OpenClaw 版本未提供 memory CLI，已跳过索引重建。"
    fi
    echo "✅ 已启用本地向量检索与索引预热"
}

  openclaw_memory_local_retrieval_menu() {
    while true; do
      clear
      skpl_ui_header "本地记忆检索加速" "SQLite + LanceDB + 本地 embedding 模型"
      openclaw_runtime_self_heal || true
      openclaw_memory_local_retrieval_status
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "一键启用 Local" "下载 embedding 模型并启用本地向量检索"
      skpl_ui_menu_item 2 "重建全部索引" "提升召回率与命中率"
      skpl_ui_menu_item 3 "查看预热日志" "查看模型下载与索引预热进度"
      skpl_ui_menu_item 4 "本地模型运行时" "安装 ollama 并准备本地大模型"
      skpl_ui_menu_item 5 "一键完整本地落地" "安装模型、启用检索、重建索引、验收"
      skpl_ui_menu_item 6 "自动部署菜单" "进入现有高级记忆部署入口"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e local_choice
      case "$local_choice" in
        1)
          openclaw_memory_enable_local_retrieval
          break_end
          ;;
        2)
          openclaw_memory_rebuild_index_all
          break_end
          ;;
        3)
          openclaw_memory_show_bootstrap_log
          break_end
          ;;
        4)
          openclaw_ollama_quick_setup_menu
          ;;
        5)
          openclaw_full_local_stack_setup
          break_end
          ;;
        6)
          openclaw_memory_auto_setup_menu
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

openclaw_memory_compare_search_test() {
  local query
  read -e -p "输入检索对照关键词: " query
  if [ -z "$query" ]; then
    echo "关键词不能为空。"
    return 1
  fi
  local native_raw hybrid_raw
  native_raw=$(openclaw memory search "$query" --max-results 5 2>&1 || true)
  hybrid_raw=$(hybrid_memory_search_raw_json "$query")
  python3 - "$native_raw" "$hybrid_raw" <<'PY'
import json
import sys

native_raw, hybrid_raw = sys.argv[1:3]

print('===== 原生检索 =====')
native_lines = [line.rstrip() for line in native_raw.splitlines() if line.strip()]
if native_lines:
    for idx, line in enumerate(native_lines[:12], start=1):
        prefix = f'{idx}. ' if len(native_lines) <= 5 else ''
        print(f'{prefix}{line}')
else:
    print('未命中原生检索结果。')

print('')
print('===== 混合检索 =====')
try:
    hybrid = json.loads(hybrid_raw)
except Exception:
    hybrid = []

if not hybrid:
    print('未命中混合检索结果。')
else:
    for idx, item in enumerate(hybrid[:5], start=1):
        print(f"{idx}. [{item.get('source', '-')}] {item.get('summary', '-')}")
        print(f"   score={item.get('score', 0):.3f} | channels={','.join(item.get('channels', [])) or '-'}")
        print(f"   explain={item.get('explain', '-')}")

print('')
print(f'原生结果行数: {len(native_lines)}')
print(f'混合结果数量: {len(hybrid)}')
PY
}

openclaw_memory_benchmark_search_test() {
  local benchmark_queries
  benchmark_queries=(
    "memory"
    "hybrid memory"
    "evomap"
    "gateway"
    "index"
    "lancedb"
    "skill"
    "task"
  )
  python3 - <<'PY' "${benchmark_queries[@]}"
import sys
queries = sys.argv[1:]
print('===== 批量检索评测 =====')
for idx, query in enumerate(queries, start=1):
    print(f'{idx}. {query}')
PY
  local query native_raw hybrid_raw
  for query in "${benchmark_queries[@]}"; do
    echo
    echo "--- Query: $query ---"
    native_raw=$(openclaw memory search "$query" --max-results 3 2>&1 || true)
    hybrid_raw=$(hybrid_memory_search_raw_json "$query")
    python3 - "$query" "$native_raw" "$hybrid_raw" <<'PY'
import json
import sys

query, native_raw, hybrid_raw = sys.argv[1:4]
native_lines = [line.strip() for line in native_raw.splitlines() if line.strip()]
try:
    hybrid = json.loads(hybrid_raw)
except Exception:
    hybrid = []

print(f'原生行数: {len(native_lines)}')
print(f'混合数量: {len(hybrid)}')
if hybrid:
    top = hybrid[0]
    print(f"混合Top1: [{top.get('source', '-')}] {top.get('summary', '-')}")
    print(f"原因: {top.get('explain', '-')}")
else:
    print('混合Top1: 无结果')
PY
  done
}

  openclaw_memory_deep_status() {
    echo "正在探测嵌入模型就绪状态..."
    if openclaw_memory_cli_supported; then
      openclaw memory status --deep
    else
      echo "ℹ️ 当前 OpenClaw 版本未提供 memory CLI，无法执行深度状态探测。"
      openclaw_memory_render_basic_status
    fi
  }

  openclaw_memory_menu() {
    local config_file
    config_file=$(openclaw_get_config_file)
    if [ "$(openclaw_memory_config_get "memory.qmd.includeDefaultMemory")" = "false" ]; then
      openclaw_memory_config_set "memory.qmd.includeDefaultMemory" true >/dev/null 2>&1 || true
    fi
    send_stats "OpenClaw记忆管理"
    while true; do
      clear
      skpl_ui_header "OpenClaw 智能大脑中心" "模型配置 / 技能注入 / 经验沉淀"
      openclaw_memory_render_status
      echo
      python3 - "$config_file" <<'PY'
import json, sys
from pathlib import Path
try:
    cfg = json.loads(Path(sys.argv[1]).read_text(encoding='utf-8'))
    defs = cfg.get('agents', {}).get('defaults', {})
    print(f"🧠 [当前文本模型] 主模型: {defs.get('model', {}).get('primary', '未设定')}")
except: pass
PY
      echo
      skpl_ui_section "操作 (让 OpenClaw 真正变聪明、更省钱)"
      skpl_ui_menu_item 1 "🤖 智能模型路由" "为文本、图片、代码分别配置不同模型 (省 Token/提速)"
      skpl_ui_menu_item 2 "⚡ 注入大脑指令" "一键注入: 省 Token + 自动选模型 + 硬件感知 Skills"
      skpl_ui_menu_item 3 "🧠 本地记忆检索" "启用本地 embedding + LanceDB + 全量重建索引"
      skpl_ui_menu_item 4 "🧩 经验进化 EvoMap" "沉淀报错/操作经验, 下次遇到 OpenClaw 自动照着修"
      skpl_ui_menu_item 5 "💾 极简备份/恢复" "核心数据与 Skills 的极速备份"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e memory_choice
      case "$memory_choice" in
        1)
          openclaw_model_manager
          ;;
        2)
          openclaw_inject_skills
          read -n 1 -s -r -p "完成！按任意键返回..."
          ;;
        3)
          openclaw_memory_local_retrieval_menu
          ;;
        4)
          echo "开始进化经验沉淀..."
          read -e -p "标题 (如: 代理配置失败): " title
          [ -z "$title" ] && title="日常经验"
          read -e -p "经验内容/解法: " content
          openclaw_evomap_real_ingest "$title" "$content"
          read -n 1 -s -r -p "经验已存入大脑！按任意键返回..."
          ;;
        5)
          openclaw_backup_restore_menu
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
    if declare -F start_gateway >/dev/null 2>&1; then
      openclaw_maybe_start_gateway nosleep 5 >/dev/null 2>&1 || true
    else
      openclaw gateway restart >/dev/null 2>&1 || {
        openclaw gateway stop >/dev/null 2>&1
        openclaw gateway --port "$(openclaw_gateway_port)" >/dev/null 2>&1
      }
    fi
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
      skpl_ui_header "备份与还原" "统一压缩包优先，兼容旧版分项备份"
      openclaw_backup_render_file_list
      echo
      echo "推荐流程：先使用【统一全量备份】导出单个压缩包；还原时把压缩包放入备份目录后再执行统一还原。"
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "统一全量备份" "记忆方案、记忆数据、EvoMap、混合记忆、项目配置统一打包"
      skpl_ui_menu_item_tone 2 "统一全量还原" "把压缩包放入备份目录后执行自动校验与还原" "danger"
      skpl_ui_menu_item 3 "备份记忆全量" "旧版兼容：支持多智能体"
      skpl_ui_menu_item 4 "还原记忆全量" "旧版兼容：按包内容恢复"
      skpl_ui_menu_item 5 "备份 OpenClaw 项目" "旧版兼容：默认安全模式"
      skpl_ui_menu_item_tone 6 "还原 OpenClaw 项目" "旧版兼容：高级 / 高风险" "danger"
      skpl_ui_menu_item_tone 7 "删除备份文件" "从备份目录移除归档" "danger"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e backup_choice

      case "$backup_choice" in
        1) openclaw_bundle_backup_export ;;
        2) openclaw_bundle_backup_import ;;
        3) openclaw_memory_backup_export ;;
        4) openclaw_memory_backup_import ;;
        5) openclaw_project_backup_export ;;
        6) openclaw_project_backup_import ;;
        7) openclaw_backup_delete_file ;;
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
      skpl_ui_header "EvoMap 管理" "安装、更新与混合记忆目录"
      evomap_print_status
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "安装 EvoMap" "克隆、依赖、初始化融合栈"
      skpl_ui_menu_item_tone 2 "卸载 EvoMap" "保留备份后移除" "danger"
      skpl_ui_menu_item 3 "更新 EvoMap" "拉取最新代码并同步更新融合栈"
      skpl_ui_menu_item 4 "EvoMap 记忆管理" "查看目录、备份与融合状态"
      skpl_ui_menu_item 5 "立即同步融合记忆" "处理事件并更新检索对象"
      skpl_ui_menu_item 6 "融合栈状态" "查看插件、对象数与最近同步"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请输入你的选择: "
      read -e evomap_choice
      case "$evomap_choice" in
        1) evomap_install; break_end ;;
        2) evomap_uninstall; break_end ;;
        3) evomap_update; break_end ;;
        4) evomap_memory_menu ;;
        5) hybrid_memory_enqueue_event "evomap-manual-sync" "用户在 EvoMap 面板触发同步"; hybrid_memory_sync_once; break_end ;;
        6) hybrid_memory_status_report; break_end ;;
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
  hybrid_memory_install_stack >/dev/null 2>&1 || true
  hybrid_memory_enqueue_event "openclaw-update" "OpenClaw CLI 已更新，混合记忆栈已对齐"
  hybrid_memory_sync_once >/dev/null 2>&1 || true
  crontab -l 2>/dev/null | grep -v "s gateway" | crontab -
  openclaw_ensure_gateway_ready || start_gateway
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
    local cache_ttl="30"

    if [ -s "$SKPL_WEBUI_DOMAIN_CACHE_FILE" ] && openclaw_memory_cache_fresh "$SKPL_WEBUI_DOMAIN_CACHE_FILE" "$cache_ttl"; then
      cat "$SKPL_WEBUI_DOMAIN_CACHE_FILE"
      return 0
    fi

    if [ -s "$SKPL_WEBUI_DOMAIN_CACHE_FILE" ]; then
      cat "$SKPL_WEBUI_DOMAIN_CACHE_FILE"
    fi
  }

  openclaw_webui_extract_token() {
    python3 - <<'PY'
import re
import sys

text = sys.stdin.read()
patterns = [
    r'[#&?]token=([^\s"\'"'"'&>]+)',
    r'\btoken\s*[:=]\s*([^\s"\'"'"'&>]+)',
]

for pattern in patterns:
    match = re.search(pattern, text, re.IGNORECASE)
    if match:
        print(match.group(1))
        raise SystemExit(0)

raise SystemExit(1)
PY
  }

  openclaw_webui_scheme() {
    local config_file
    config_file=$(openclaw_get_config_file)
    python3 - "$config_file" <<'PY'
import json
import os
import sys

path = sys.argv[1]
scheme = 'http'
try:
    if path and os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        if isinstance(data, dict) and data.get('gateway', {}).get('tls', {}).get('enabled') is True:
            scheme = 'https'
except Exception:
    pass
print(scheme)
PY
  }

  openclaw_webui_token_from_config() {
    local config_file
    config_file=$(openclaw_get_config_file)
    python3 - "$config_file" <<'PY'
import json
import os
import sys
from pathlib import Path

path = sys.argv[1]
home = Path.home()

def emit(value):
    if isinstance(value, str):
        value = value.strip()
        if value and not value.startswith('${'):
            print(value)
            raise SystemExit(0)

for env_name in ('OPENCLAW_GATEWAY_TOKEN', 'OPENCLAW_WEBUI_TOKEN', 'GATEWAY_AUTH_TOKEN'):
    emit(os.environ.get(env_name, ''))

config_candidates = []
if path:
    config_candidates.append(Path(path))
config_candidates.extend([
    home / '.openclaw' / 'openclaw.json',
    Path('/root/.openclaw/openclaw.json'),
])

seen = set()
for candidate in config_candidates:
    candidate = candidate.expanduser()
    if str(candidate) in seen or not candidate.exists():
        continue
    seen.add(str(candidate))
    try:
        data = json.loads(candidate.read_text(encoding='utf-8'))
    except Exception:
        continue
    if not isinstance(data, dict):
        continue
    gateway = data.get('gateway', {})
    auth = gateway.get('auth', {}) if isinstance(gateway, dict) else {}
    for value in (
        auth.get('token') if isinstance(auth, dict) else None,
        auth.get('accessToken') if isinstance(auth, dict) else None,
        gateway.get('token') if isinstance(gateway, dict) else None,
    ):
        emit(value)

for candidate in (
    home / '.openclaw' / 'gateway.token',
    home / '.openclaw' / 'gateway-auth-token',
    home / '.openclaw' / 'workspace' / '.gateway-token',
    Path('/root/.openclaw/gateway.token'),
    Path('/root/.openclaw/gateway-auth-token'),
):
    if candidate.exists():
        try:
            emit(candidate.read_text(encoding='utf-8'))
        except Exception:
            continue

raise SystemExit(1)
PY
  }

openclaw_webui_refresh_token_cache() {
    local dashboard_output token

    token=$(openclaw_webui_token_from_config 2>/dev/null || true)
    if [ -n "$token" ]; then
      printf '%s' "$token" > "$SKPL_WEBUI_TOKEN_CACHE_FILE"
      echo "$token"
      return 0
    fi

    dashboard_output=$(timeout 12 openclaw dashboard --no-open 2>/dev/null || true)
    if [ -n "$dashboard_output" ]; then
      token=$(printf '%s\n' "$dashboard_output" | openclaw_webui_extract_token 2>/dev/null || true)
      if [ -n "$token" ]; then
        printf '%s' "$token" > "$SKPL_WEBUI_TOKEN_CACHE_FILE"
        echo "$token"
        return 0
      fi
    fi

    return 1
  }

openclaw_webui_ensure_origins() {
    return 0
  }

  openclaw_webui_ensure_local_origins() {
    return 0
  }

  openclaw_webui_get_cached_token() {
    if [ -s "$SKPL_WEBUI_TOKEN_CACHE_FILE" ]; then
      cat "$SKPL_WEBUI_TOKEN_CACHE_FILE"
      return 0
    fi
    return 1
  }

  openclaw_webui_reset_local_cache() {
    : > "$SKPL_WEBUI_TOKEN_CACHE_FILE" 2>/dev/null || true
    : > "$SKPL_WEBUI_DOMAIN_CACHE_FILE" 2>/dev/null || true
  }



  openclaw_show_webui_addr() {
    local local_ip token domains scheme port

    skpl_ui_header "WebUI 访问设置" "本机访问优先，域名入口按需接入"
    local_ip="127.0.0.1"
    scheme=$(openclaw_webui_scheme)
    port=$(openclaw_gateway_port)

    token=$(openclaw_webui_token_from_config 2>/dev/null || openclaw_webui_get_cached_token 2>/dev/null || true)
    skpl_ui_section "本机地址"
    if [ -n "$token" ]; then
      echo "${scheme}://${local_ip}:${port}/#token=${token}"
    else
      echo "${scheme}://${local_ip}:${port}/"
      echo "当前使用无 token 的本地入口，可在菜单中按需手动刷新 token。"
    fi

    domains=$(openclaw_find_webui_domain)
    if [ -n "$domains" ]; then
      echo
      skpl_ui_section "域名地址"
      while IFS= read -r d; do
        [ -z "$d" ] && continue
        if [ -n "$token" ]; then
          echo "${d}/#token=${token}"
        else
          echo "${d}/"
        fi
      done <<EOF
$domains
EOF
    fi

    echo
    skpl_ui_section "待处理设备授权"
    echo "当前面板仅保留查看待处理请求。批准请在 root 终端手动执行官方命令。"
  }



  openclaw_webui_normalize_domain_entry() {
    local raw="$1"
    raw="${raw#http://}"
    raw="${raw#https://}"
    raw="${raw%%/*}"
    raw="${raw%%#*}"
    raw="${raw%%\?*}"
    printf '%s' "$raw"
  }

  # 添加域名入口记录
  openclaw_domain_webui() {
    local raw_domain domain_entry scheme token

    scheme=$(openclaw_webui_scheme)
    read -e -p "请输入已存在的 WebUI 域名或 URL: " raw_domain
    [ -z "$raw_domain" ] && { echo "❌ 未输入域名或 URL"; return 1; }

    domain_entry=$(openclaw_webui_normalize_domain_entry "$raw_domain")
    [ -z "$domain_entry" ] && { echo "❌ 域名格式无效"; return 1; }

    mkdir -p "$(dirname "$SKPL_WEBUI_DOMAIN_CACHE_FILE")"
    printf '%s\n' "${scheme}://${domain_entry}" >> "$SKPL_WEBUI_DOMAIN_CACHE_FILE"
    python3 - "$SKPL_WEBUI_DOMAIN_CACHE_FILE" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
path.parent.mkdir(parents=True, exist_ok=True)
if not path.exists():
    path.write_text('', encoding='utf-8')
items = []
seen = set()
for raw in path.read_text(encoding='utf-8', errors='ignore').splitlines():
    item = raw.strip()
    if not item or item in seen:
        continue
    seen.add(item)
    items.append(item)
path.write_text('\n'.join(items) + ('\n' if items else ''), encoding='utf-8')
PY
    echo -e "${gl_kjlan}已记录域名 ${domain_entry} 的 WebUI 入口${gl_bai}"

    : > "$SKPL_DEVICES_LIST_CACHE_FILE" 2>/dev/null || true
    if ! openclaw_devices_list_safe; then
      echo "❌ 设备列表加载超时或失败，请确认网关已就绪后重试。"
      return 1
    fi

    token=$(openclaw_webui_token_from_config 2>/dev/null || openclaw_webui_get_cached_token 2>/dev/null || true)
    echo
    echo "访问地址:"
    if [ -n "$token" ]; then
      echo "${scheme}://${domain_entry}/#token=${token}"
    else
      echo "${scheme}://${domain_entry}/"
    fi
    echo "请在 root 终端手动执行官方命令进行审批。"
    echo "建议步骤："
    echo "1. 复制上面 devices list 中当前有效的 requestId"
    echo "2. 手动执行: openclaw devices approve <requestId>"
    return 0

  }

  # 删除域名
  openclaw_remove_domain() {
    local domains target domain_entry found=0

    domains=$(openclaw_find_webui_domain)
    if [ -z "$domains" ]; then
      echo "当前没有已记录的域名入口。"
      return 0
    fi

    echo "已记录的域名入口:"
    printf '%s\n' "$domains"
    read -e -p "请输入要移除的域名或完整 URL: " target
    [ -z "$target" ] && { echo "❌ 未输入域名或 URL"; return 1; }

    domain_entry=$(openclaw_webui_normalize_domain_entry "$target")
    python3 - "$SKPL_WEBUI_DOMAIN_CACHE_FILE" "$domain_entry" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
target = sys.argv[2].strip()
if not path.exists():
    raise SystemExit(1)

items = []
removed = False
for raw in path.read_text(encoding='utf-8', errors='ignore').splitlines():
    item = raw.strip()
    if not item:
        continue
    normalized = item.removeprefix('http://').removeprefix('https://').split('/', 1)[0]
    if normalized == target:
        removed = True
        continue
    items.append(item)

path.write_text('\n'.join(items) + ('\n' if items else ''), encoding='utf-8')
raise SystemExit(0 if removed else 1)
PY
    found=$?
    if [ "$found" -eq 0 ]; then
      echo "✅ 已移除域名入口: $domain_entry"
    else
      echo "❌ 未找到对应的已记录域名入口: $domain_entry"
      return 1
    fi
  }

  # 主菜单
  openclaw_webui_menu() {

    send_stats "WebUI访问与设置"
    while true; do
      clear
      openclaw_show_webui_addr
      echo
      skpl_ui_section "操作"
      skpl_ui_menu_item 1 "重载访问 Token" "读取本地持久 token"
      skpl_ui_menu_item 2 "记录域名入口" "保存已存在的 WebUI 域名地址"
      skpl_ui_menu_item_tone 3 "移除域名入口" "删除已记录的域名地址" "danger"
      skpl_ui_menu_item 4 "查看待处理请求" "显示 devices list 原始输出"
      skpl_ui_menu_item 0 "返回上一级"
      skpl_ui_footer_prompt "请选择: "
      read -e choice

      case "$choice" in
        1)
          if openclaw_webui_refresh_token_cache >/dev/null 2>&1; then
            echo "✅ WebUI Token 已重载"
          else
            echo "⚠️ Token 读取失败"
            openclaw_webui_token_status_hint
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
        4)
          echo
          : > "$SKPL_DEVICES_LIST_CACHE_FILE" 2>/dev/null || true
          openclaw_devices_list_safe
          echo
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
    read -r choice
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
          openclaw_ensure_gateway_ready || start_gateway
        else
          echo "❌ API 模型同步失败，已中止重启网关。请检查 provider /models 返回后重试。"
        fi
        break_end
        ;;
      13) openclaw_webui_menu ;;
      22) openclaw_network_diagnosis_menu ;;
      23) openclaw_run_official_diagnostics ;;
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
      0) return 0 ;;
      *) echo "无效的选择，请重试。"; sleep 1 ;;
    esac
  done

}

OPENCLAW_PANEL_EOF
)"
}

openclaw_enable_local_memory_auto() {
  local model_path bootstrap_log
  if declare -F openclaw_memory_prepare_prefetch >/dev/null 2>&1; then
    model_path="$(openclaw_memory_prepare_prefetch)"
  elif declare -F openclaw_default_memory_model_path >/dev/null 2>&1; then
    model_path="$(openclaw_default_memory_model_path)"
  else
    model_path="$HOME/.openclaw/models/embedding/embeddinggemma-300M-Q8_0.gguf"
    mkdir -p "$(dirname "$model_path")"
  fi

  if [ -f "${model_path}" ]; then
    echo "记忆模型已存在，安装阶段跳过后台预热。"
    return 0
  fi

  if declare -F openclaw_memory_prefetch_bootstrap >/dev/null 2>&1; then
    bootstrap_log="$(openclaw_memory_prefetch_bootstrap "$model_path")"
    echo "记忆模型将在后台预热下载，不阻塞安装流程。"
    echo "安装阶段不会提前切换到 Local 记忆方案。"
    echo "后台日志: ${bootstrap_log}"
  else
    echo "⚠️ 记忆预热函数不可用，已跳过后台预热。"
  fi
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

  if declare -F openclaw_onboard_if_needed >/dev/null 2>&1; then
    openclaw_onboard_if_needed
  else
    echo "⚠️ 未检测到 openclaw_onboard_if_needed，跳过首次引导。"
  fi
  openclaw_ensure_local_gateway_config >/dev/null 2>&1 || true
  if declare -F openclaw_webui_reset_local_cache >/dev/null 2>&1; then
    openclaw_webui_reset_local_cache
  else
    echo "⚠️ 未检测到 openclaw_webui_reset_local_cache，跳过 WebUI 本地缓存重置。"
  fi
  refresh_openclaw_gateway_service >/dev/null 2>&1 || true
  echo "提示：WebUI 首次浏览器访问可能需要设备审批。"
  echo "提示：WhatsApp 官方扫码登录完成后，请先执行 openclaw channels status 确认绑定状态。"

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
  fi

  ensure_openclaw_cli_on_path >/dev/null 2>&1 || true
  if ! command -v openclaw >/dev/null 2>&1; then
    echo "OpenClaw CLI 安装失败：未检测到 openclaw 命令。"
    return 1
  fi

  if declare -F openclaw_onboard_if_needed >/dev/null 2>&1; then
    openclaw_onboard_if_needed || true
  fi

  if command -v openclaw >/dev/null 2>&1; then
    openclaw config validate >/dev/null 2>&1 || openclaw_ensure_local_gateway_config >/dev/null 2>&1 || true
  fi

  refresh_runtime_proxy_env
  refresh_openclaw_gateway_service >/dev/null 2>&1 || true
  if ! openclaw_gateway_is_running; then
    openclaw_ensure_gateway_ready || true
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
  local hybrid_json
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
  skpl_ui_kv "融合栈" "$SKPL_HYBRID_MEMORY_ROOT"
  hybrid_json=$(hybrid_memory_status_json 2>/dev/null || echo '{"objects":0}')
  skpl_ui_kv "知识对象" "$(python3 - <<'PY' "$hybrid_json"
import json, sys
try:
    data = json.loads(sys.argv[1])
    print(data.get('objects', 0))
except Exception:
    print(0)
PY
)"
  skpl_ui_kv "备份目录" "$EVOMAP_BACKUP_DIR"
}

hybrid_memory_search_test() {
  local query
  read -e -p "输入混合检索关键词: " query
  if [ -z "$query" ]; then
    echo "关键词不能为空。"
    return 1
  fi
  echo "正在执行混合检索..."
  hybrid_memory_search "$query"
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
  install sqlite3 python3 >/dev/null 2>&1
  mkdir -p /root/.openclaw

  if ! declare -F hybrid_memory_install_stack >/dev/null 2>&1; then
    echo "⚠️ 混合记忆栈函数不可用，跳过 EvoMap 安装。"
    return 0
  fi

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
  hybrid_memory_install_stack
  mkdir -p skills assets/gep memory "$SKPL_HYBRID_MEMORY_KNOWLEDGE_DIR/core"

  cat > .env <<EOF_ENV
MEMORY_DIR=${EVOMAP_MEMORY_DIR}
A2A_HUB_URL=https://evomap.ai
A2A_NODE_ID=${node_id}
EVOLVE_STRATEGY=balanced
HYBRID_MEMORY_ROOT=${SKPL_HYBRID_MEMORY_ROOT}
HYBRID_MEMORY_DB=${SKPL_HYBRID_MEMORY_DB}
EOF_ENV

  cat > assets/gep/openclaw-core-genes.json <<'EOF_GENE'
{"genes":[{"id":"openclaw-log-parser","name":"OpenClaw日志解析基因","version":"1.0.0","signals":["openclaw","gateway","session","learning","error","crash","timeout"],"directives":["优先解析OpenClaw日志","提取网关和会话错误信号","过滤无效内容并保留结构化数据"],"validation":[],"priority":100}]}
EOF_GENE

  cat > assets/gep/core-repair-capsules.json <<'EOF_CAP'
{"capsules":[{"id":"core-repair-kit","name":"核心修复胶囊","version":"1.0.0","targets":["agent-loop","execution-failure","stagnation"],"steps":["识别循环停滞并输出修复建议","识别执行错误并输出标准方案","生成可审计修复记录"]}]}
EOF_CAP

  if declare -F hybrid_memory_enqueue_event >/dev/null 2>&1; then
    hybrid_memory_enqueue_event "evomap-install" "EvoMap 与混合记忆栈安装完成"
  fi
  if declare -F hybrid_memory_sync_once >/dev/null 2>&1; then
    hybrid_memory_sync_once >/dev/null 2>&1 || true
  fi
  evomap_start_loop
  sleep 2
  evomap_refresh_gateway_if_needed

  echo "EvoMap 与混合记忆栈安装完成。"
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
  if ! declare -F hybrid_memory_install_stack >/dev/null 2>&1; then
    echo "⚠️ 混合记忆栈函数不可用，跳过 EvoMap 更新。"
    return 0
  fi
  evomap_backup_current
  cd "$EVOMAP_DIR"
  git pull --rebase
  install_evomap_dependencies
  hybrid_memory_install_stack
  if declare -F hybrid_memory_enqueue_event >/dev/null 2>&1; then
    hybrid_memory_enqueue_event "evomap-update" "EvoMap 与混合记忆栈已更新"
  fi
  if declare -F hybrid_memory_sync_once >/dev/null 2>&1; then
    hybrid_memory_sync_once >/dev/null 2>&1 || true
  fi
  evomap_start_loop
  evomap_refresh_gateway_if_needed
  echo "EvoMap 与混合记忆栈更新完成。"
}

evomap_memory_menu() {
  while true; do
    clear
    skpl_ui_header "EvoMap 记忆管理" "查看学习目录、融合栈与备份归档"
    evomap_print_status
    echo
    skpl_ui_section "操作"
    skpl_ui_menu_item 1 "立即备份 EvoMap"
    skpl_ui_menu_item 2 "查看记忆目录"
    skpl_ui_menu_item 3 "查看备份目录"
    skpl_ui_menu_item 4 "查看融合根目录"
    skpl_ui_menu_item 5 "查看同步日志"
    skpl_ui_menu_item 0 "返回上一级"
    skpl_ui_footer_prompt "请输入你的选择: "
    read -r evo_mem_choice
    case "$evo_mem_choice" in
      1) evomap_backup_current; break_end ;;
      2) ls -la "$EVOMAP_MEMORY_DIR" 2>/dev/null || echo "记忆目录不存在。"; break_end ;;
      3) ls -la "$EVOMAP_BACKUP_DIR" 2>/dev/null || echo "备份目录不存在。"; break_end ;;
      4) ls -la "$SKPL_HYBRID_MEMORY_ROOT" 2>/dev/null || echo "融合根目录不存在。"; break_end ;;
      5) hybrid_memory_show_sync_log; break_end ;;
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
    echo "[1/5] 执行 wslwin 代理同步..."
    if ! run_step_guard "step1_wslwin" run_wslwin_proxy_sync; then
      print_failure_hint
      return 1
    fi
    state_set STEP 2
  fi

  step=$(state_get STEP)
  [ -z "$step" ] && step=2
  if [ "$step" -le 2 ]; then
    echo "[2/5] 安装 OpenClaw，并后台预热记忆模型资源..."
    if ! run_step_guard "step2_openclaw" run_openclaw_install_step; then
      print_failure_hint
      return 1
    fi
    state_set STEP 3
  fi

  step=$(state_get STEP)
  [ -z "$step" ] && step=3
  if [ "$step" -le 3 ]; then
    echo "[3/5] 执行 openclaw2 网络优化..."
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
    echo "[4/5] 初始化混合记忆栈..."
    if declare -F hybrid_memory_install_stack >/dev/null 2>&1; then
      if ! run_step_guard "step4_hybrid_memory" hybrid_memory_install_stack; then
        print_failure_hint
        return 1
      fi
      if declare -F hybrid_memory_enqueue_event >/dev/null 2>&1; then
        hybrid_memory_enqueue_event "install-pipeline" "OpenClaw 安装流程已完成混合记忆栈初始化"
      fi
      if declare -F hybrid_memory_sync_once >/dev/null 2>&1; then
        hybrid_memory_sync_once >/dev/null 2>&1 || true
      fi
    else
      echo "⚠️ 未检测到 hybrid_memory_install_stack，跳过混合记忆栈初始化。"
    fi
    state_set STEP 5
  fi

  step=$(state_get STEP)
  [ -z "$step" ] && step=5
  if [ "$step" -le 5 ]; then
    if [ "${SKPL_SKIP_EVOMAP:-0}" = "1" ]; then
      echo "[5/5] 已按 SKPL_SKIP_EVOMAP=1 跳过 EvoMap 安装。"
    else
      echo "[5/5] 安装 EvoMap 与融合学习能力..."
      if ! run_step_guard "step5_evomap" run_evomap_install_step; then
        print_failure_hint
        return 1
      fi
    fi
    state_set STEP 6
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
      if [ "${2:-}" = "__internal_start_gateway" ]; then
        shift 2
        start_gateway "$@"
        return 0
      fi
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
