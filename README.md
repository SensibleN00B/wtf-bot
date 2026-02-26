# OpenClaw Docker Runbook (Codex Subscription)

This repository runs OpenClaw in Docker and uses **OpenAI Codex OAuth subscription** (not an API key).

## Prerequisites

- Docker Desktop (or Docker Engine + Compose plugin)
- A browser on the same machine
- An active OpenAI/Codex account

## Repository Layout

- `docker-compose.yml`: main runtime configuration
- `docker-data/openclaw`: persistent OpenClaw state
- `docker-data/codex`: Codex credentials mounted into the container

## Start the Stack

```bash
docker compose up -d
docker compose ps
```

Expected status:
- `openclaw` is `Up`
- health becomes `healthy` after startup checks

## First-Time OAuth Setup (Codex Subscription)

Run onboarding inside the container:

```bash
docker compose exec -it openclaw node /app/openclaw.mjs onboard --auth-choice openai-codex --mode local --gateway-bind loopback --gateway-port 18789 --skip-daemon --skip-skills --skip-ui --skip-health --skip-channels
```

Flow summary:
1. Accept security prompt.
2. Choose `QuickStart`.
3. Choose `Update values` when config handling appears.
4. Open the OAuth URL in your local browser.
5. Paste the redirect URL back into terminal.
6. At hooks step, you can choose `Skip for now`.

## Open the Dashboard

Get the signed dashboard URL:

```bash
docker compose exec openclaw node /app/openclaw.mjs dashboard --no-open
```

Open the printed `Dashboard URL` in your browser.

## If Dashboard Shows "pairing required"

Approve the latest pending web dashboard device:

```bash
docker compose exec openclaw node /app/openclaw.mjs devices approve --latest --json
```

Then hard-reload the browser tab (`Cmd+Shift+R` on macOS).

## Verify Runtime and Auth

Gateway health:

```bash
docker compose exec openclaw node /app/openclaw.mjs gateway health --json
```

Model and auth status:

```bash
docker compose exec openclaw node /app/openclaw.mjs models status --json
```

You should see:
- default model `openai-codex/gpt-5.3-codex`
- OAuth profile for `openai-codex`
- no missing providers in use

## Useful Operations

View logs:

```bash
docker compose logs -f openclaw
```

Restart service:

```bash
docker compose restart openclaw
```

Stop stack:

```bash
docker compose down
```

## Security Notes

- Do not share URLs containing `#token=...`.
- Do not commit credentials from `docker-data/`.
- If a token or callback URL is leaked, rotate credentials and re-run auth.
