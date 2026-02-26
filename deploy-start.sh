#!/usr/bin/env bash
set -euo pipefail

: "${PORT:=18789}"

echo "START (as root) PORT=$PORT"

mkdir -p /home/openclaw/.codex /home/openclaw/.openclaw
chown -R openclaw:openclaw /home/openclaw/.codex /home/openclaw/.openclaw || true

exec su -s /bin/bash openclaw -c '
set -euo pipefail

: "${PORT:=18789}"

echo "HOME=$HOME USER=$(whoami) PORT=$PORT"
echo "Ensuring dirs..."
mkdir -p "$HOME/.codex" "$HOME/.openclaw"

# --- restore Codex auth.json ---
if [[ -z "${CODEX_AUTH_JSON_B64:-}" ]]; then
  echo "ERROR: CODEX_AUTH_JSON_B64 is not set"
  exit 1
fi

echo "$CODEX_AUTH_JSON_B64" | tr -d '"'"'\r\n'"'"' | base64 -d -i > "$HOME/.codex/auth.json"
chmod 600 "$HOME/.codex/auth.json"
echo "Codex auth.json written: $(ls -la "$HOME/.codex/auth.json")"

# --- bootstrap OpenClaw config ---
CFG="$HOME/.openclaw/openclaw.json"

if [[ ! -f "$CFG" ]]; then
  echo "Bootstrapping OpenClaw config at $CFG"
  cat > "$CFG" <<JSON
{
  "gateway": {
    "mode": "local"
  }
}
JSON
fi

echo "OpenClaw config: $(ls -la "$CFG")"
echo "Config content:"
cat "$CFG"

# --- start gateway ---
exec openclaw gateway --port "$PORT"
'