# Configuration Schema

koad:io configuration lives in several places. This reference documents each file's schema and purpose.

---

## ~/.koad/config.toml

The main daemon configuration file. Created by `koad init`, updated via `koad config set`.

```toml
[daemon]
port = 4000                  # Peer-to-peer port (other kingdoms connect here)
api_port = 4001              # Local REST API port
log_level = "info"           # debug | info | warn | error
log_retention_days = 7       # How many days of logs to keep

[kingdom]
handle = "alice"             # Portal namespace identifier
display_name = "Alice's Kingdom"
description = ""             # Shown on portal page
tags = ""                    # Comma-separated, searchable on portal
email = "alice@example.com"

[portal]
enabled = true               # Whether to register with portal
hostname = ""                # Public hostname for daemon (auto-detected if empty)

[webhooks]
url = ""                     # POST target for events
events = "worker.fail"       # Comma-separated event list
secret = ""                  # HMAC secret for webhook signature header

[security]
allow_localhost_no_auth = false   # Skip API key for localhost requests (dev only)
api_key_expiry_warning_days = 7   # Warn N days before a key expires
```

---

## ~/.koad/workers/*.toml

Each worker is defined in its own TOML file in `~/.koad/workers/`.

```toml
[worker]
name = "deploy"
command = "bash scripts/deploy.sh"
description = "Deploy to production"
entity = "alice"             # Which entity runs this worker
enabled = true

[run]
timeout_seconds = 300        # Kill worker after N seconds (0 = no timeout)
max_retries = 0              # Retry on failure (0 = no retries)
retry_delay_seconds = 10     # Wait between retries

[env]
# Extra environment variables injected when this worker runs
NODE_ENV = "production"
DEPLOY_TARGET = "prod"

[hooks]
# Shell commands run before/after the worker
pre_run = ""                 # Run before worker starts
post_success = ""            # Run if worker exits 0
post_fail = ""               # Run if worker exits non-zero
```

---

## CLAUDE.md

Every entity's home directory contains a `CLAUDE.md` that loads into each Claude Code session. This is the entity's constitution — it defines identity, role, and operating rules.

### Required sections

```markdown
# CLAUDE.md — <EntityName>

[One-paragraph description of the entity and its purpose]

## Identity

\`\`\`env
ENTITY=<name>
ENTITY_DIR=/home/koad/.<name>
ENTITY_HOME=/home/koad/.<name>/home/<name>
GIT_AUTHOR_NAME=<DisplayName>
GIT_AUTHOR_EMAIL=<name>@kingofalldata.com
\`\`\`

## Role & Scope

**What <Entity> owns:**
- [responsibility 1]
- [responsibility 2]

**What <Entity> does NOT own:**
- [excluded area 1]

## Team Position

[How this entity relates to others]

## Session Start Protocol (VESTA-SPEC-012)

1. Verify identity and location
2. Sync with remote (git pull)
3. State review (git status, open issues, MEMORY.md)
4. Proceed with highest-priority work
```

### Optional sections

- `## Workflow` — step-by-step operational process
- `## Key Files` — table of important files and their purpose
- `## Operations` — how the entity is triggered and monitored
- `## Git Identity` — commit authorship details

---

## memories/MEMORY.md

The memory index file, loaded in every session. Lists all memory files with one-line descriptions.

```markdown
- [Title](filename.md) — one-line description of what this memory contains
```

Maximum 200 lines. Entries after line 200 are truncated.

### Memory file format

Each memory file has frontmatter and content:

```markdown
---
name: Memory Title
description: One-line description for the index
type: user | feedback | project | reference
---

[Memory content]
```

**Memory types:**

| Type | Purpose |
|------|---------|
| `user` | Facts about who the entity is, its role and preferences |
| `feedback` | Corrections and confirmations about how to work |
| `project` | Active project state, goals, deadlines |
| `reference` | Pointers to external resources |

---

## .env files

Entity home directories may contain `.env` files for secret configuration. These are **never committed to git**.

```bash
# ~/.atlas/.env (example — not committed)
ANTHROPIC_API_KEY=sk-ant-xxxxxxxx
GITHUB_TOKEN=ghp_xxxxxxxx
DEPLOY_KEY=supersecret
```

Load in sessions:
```bash
# hooks/executed-without-arguments.sh automatically sources .env if present
[ -f "$ENTITY_DIR/.env" ] && source "$ENTITY_DIR/.env"
```

---

## hooks/executed-without-arguments.sh

The entry point for interactive entity sessions. Created during gestation. Standard structure:

```bash
#!/usr/bin/env bash
set -euo pipefail

ENTITY_DIR="$HOME/.<entityname>"
IDENTITY="$ENTITY_DIR/memories/001-identity.md"
CALL_DIR="${CWD:-$PWD}"

PROMPT="${PROMPT:-}"
if [ -z "$PROMPT" ] && [ ! -t 0 ]; then
  PROMPT="$(cat)"
fi

cd "$ENTITY_DIR"

if [ -n "$PROMPT" ]; then
  exec claude --dangerously-skip-permissions -p "$(cat "$IDENTITY")

Working directory context: $CALL_DIR

$PROMPT" --add-dir "$CALL_DIR"
else
  exec claude . --model sonnet --dangerously-skip-permissions --add-dir "$CALL_DIR"
fi
```

**Invocation modes:**

| Invocation | Mode | Description |
|------------|------|-------------|
| `atlas` | Interactive | Full Claude Code session |
| `PROMPT="..." atlas` | Non-interactive | Run single prompt, exit |
| `echo "..." \| atlas` | Non-interactive | Pipe prompt via stdin |

---

## KOAD_IO_VERSION

A metadata file written at gestation time. Not a config file — do not edit.

```bash
# koad:io entity

GESTATED_BY=juno
GESTATE_VERSION=410fa60
BIRTHDAY=26:04:03:14:34:13
NAME=livy
```

Fields:
- `GESTATED_BY`: Entity that performed gestation (usually `juno`)
- `GESTATE_VERSION`: Git commit of koad:io at gestation time
- `BIRTHDAY`: Timestamp in `YY:MM:DD:HH:MM:SS` format
- `NAME`: Entity name
