#!/usr/bin/env bash
set -euo pipefail

: "${PORT:=18789}"

mkdir -p "$HOME/.codex"
if [[ -z "${CODEX_AUTH_JSON_B64:-}" ]]; then
  echo "ERROR: CODEX_AUTH_JSON_B64 is not set"
  exit 1
fi
echo "$CODEX_AUTH_JSON_B64" | base64 -d > "$HOME/.codex/auth.json"
chmod 600 "$HOME/.codex/auth.json"

mkdir -p "$HOME/.openclaw"

exec openclaw gateway --port "$PORT"