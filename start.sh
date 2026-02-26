#!/usr/bin/env bash
set -euo pipefail

: "${PORT:=18789}"
export NODE_OPTIONS="${NODE_OPTIONS:---max-old-space-size=1024}"

echo "HOME=$HOME USER=$(whoami) PORT=$PORT"
mkdir -p "$HOME/.openclaw" "$HOME/.codex"

CFG="$HOME/.openclaw/openclaw.json"
if [[ ! -f "$CFG" ]]; then
  cat > "$CFG" <<JSON
{
  "gateway": { "mode": "local" }
}
JSON
fi

exec openclaw gateway --port "$PORT"