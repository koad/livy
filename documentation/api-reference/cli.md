# koad CLI Reference

Complete reference for the `koad` command-line interface.

## Global Flags

These flags apply to all commands:

| Flag | Description |
|------|-------------|
| `--entity <name>` | Override the active entity for this command |
| `--daemon-host <host>` | Override daemon host (default: `localhost`) |
| `--daemon-port <port>` | Override daemon port (default: `4000`) |
| `--json` | Output as JSON instead of human-readable text |
| `--quiet` | Suppress output except errors |
| `--verbose` | Enable verbose logging |
| `--help` | Show help for any command |

---

## koad init

Initialize a new koad:io kingdom.

```
koad init [--name <name>] [--email <email>] [--handle <handle>]
```

**Flags:**

| Flag | Description |
|------|-------------|
| `--name` | Display name for the kingdom |
| `--email` | Entity contact email |
| `--handle` | Portal namespace handle (default: derived from email) |
| `--no-deploy` | Skip initial deployment registration |

**Example:**
```bash
koad init --name "Alice's Kingdom" --email alice@example.com --handle alice
```

Creates `~/.koad/` with daemon config, keypairs, and registers your portal namespace.

---

## koad start / stop / restart / status

Manage the daemon process.

```
koad start [--foreground]
koad stop [--force]
koad restart
koad status [--watch]
```

**`koad status` output fields:**

| Field | Description |
|-------|-------------|
| `daemon` | `running` or `stopped`, with PID |
| `uptime` | How long the daemon has been running |
| `workers` | Count of active/idle/failed workers |
| `ring` | Ring connection status and peer count |
| `portal` | Your portal URL |

**Example:**
```bash
koad status --watch    # refresh every 5 seconds
koad status --json     # machine-readable output
```

---

## koad worker

Manage workers.

```
koad worker list [--entity <name>] [--status running|idle|failed|all]
koad worker run <name> [--entity <name>] [--wait] [--timeout <seconds>]
koad worker stop <name> [--force]
koad worker logs <name> [--tail <n>] [--follow]
koad worker add <name> <command> [--description <text>]
koad worker remove <name>
koad worker enable <name>
koad worker disable <name>
```

**Example:**
```bash
koad worker run deploy --wait --timeout 120
koad worker logs deploy --tail 50 --follow
koad worker add build "npm run build" --description "Build frontend assets"
```

Workers are stored in `~/.koad/workers/` as TOML files.

---

## koad entity

Manage entities within the kingdom.

```
koad entity list
koad entity create <name> [--type personal|org|agent|service] [--email <email>]
koad entity remove <name> [--force]
koad entity use <name>
koad entity current
koad entity public-key [<name>]
koad entity config <name> set <key>=<value>
koad entity config <name> get <key>
```

**Entity types:**

| Type | Description |
|------|-------------|
| `personal` | Human user identity |
| `org` | Organization or team |
| `agent` | Automated AI entity |
| `service` | Long-running infrastructure service |

**Example:**
```bash
koad entity create vulcan --type agent --email vulcan@example.com
koad entity use vulcan
koad entity config vulcan set display_name="Vulcan Builder"
```

---

## koad ring

Manage trust ring membership and sponsorships.

```
koad ring status
koad ring sponsor add <public-key> <hostname> [--tier free|basic|pro|enterprise] [--entity <name>]
koad ring sponsor remove <public-key>
koad ring sponsor list
koad ring accept <sponsor-public-key>
koad ring leave
koad ring peers
```

**Example:**
```bash
koad ring sponsor add ed25519:AAAA... alice.example.com --tier basic
koad ring peers --json
```

---

## koad trust

Manage trust bonds between entities.

```
koad trust list [--entity <name>]
koad trust add <entity-name> [--scope <scope>]
koad trust remove <entity-name>
koad trust verify <entity-name>
koad trust sign <file> [--entity <name>]
koad trust verify-signature <file> <signature>
```

**Trust scopes:**

| Scope | Description |
|-------|-------------|
| `read` | Read-only access to entity state |
| `workers:run` | Can trigger workers |
| `workers:manage` | Can add/remove/configure workers |
| `ring:join` | Can join entity's ring |
| `admin` | Full administrative access |

**Example:**
```bash
koad trust add vulcan --scope workers:run
koad trust verify juno
koad trust sign deploy-manifest.txt --entity alice
```

---

## koad config

Manage daemon and kingdom configuration.

```
koad config get [<key>]
koad config set <key>=<value> [<key>=<value>...]
koad config unset <key>
koad config list
koad config edit    # opens in $EDITOR
```

**Common config keys:**

| Key | Default | Description |
|-----|---------|-------------|
| `daemon_port` | `4000` | Daemon peer port |
| `api_port` | `4001` | Local API port |
| `display_name` | (handle) | Portal display name |
| `description` | `` | Portal description |
| `tags` | `` | Comma-separated portal tags |
| `webhook_url` | `` | Webhook endpoint for events |
| `webhook_events` | `worker.fail` | Comma-separated event types |
| `log_level` | `info` | Daemon log verbosity |
| `log_retention_days` | `7` | How long to keep logs |

**Example:**
```bash
koad config set display_name="Alice's Kingdom" description="Personal automation kingdom"
koad config get daemon_port
```

---

## koad api-key

Manage API keys for programmatic access.

```
koad api-key create --name <name> [--scope <scope>] [--expires <duration>]
koad api-key list
koad api-key revoke <key-id>
```

**Example:**
```bash
koad api-key create --name "github-ci" --scope workers:run --expires 90d
koad api-key revoke koad_key_xxxxxxxx
```

---

## koad deploy

Register or update your kingdom's network presence.

```
koad deploy [--hostname <host>] [--force]
```

Registers your daemon's public key and hostname with the koad:io network, activating your portal namespace.

---

## koad logs

Access daemon and worker logs.

```
koad logs [--follow] [--tail <n>] [--worker <name>] [--entity <name>] [--since <time>] [--level debug|info|warn|error]
```

**Example:**
```bash
koad logs --follow --level warn
koad logs --worker deploy --tail 100
koad logs --since "2026-04-03T00:00:00Z" --json
```

---

## Environment Variables

All flags can be set via environment variables:

| Variable | Flag equivalent |
|----------|----------------|
| `KOAD_ENTITY` | `--entity` |
| `KOAD_DAEMON_HOST` | `--daemon-host` |
| `KOAD_DAEMON_PORT` | `--daemon-port` |
| `KOAD_API_KEY` | Auth token for API calls |
| `KOAD_LOG_LEVEL` | `--log-level` |
| `KOAD_JSON` | `--json` |

Environment variables take lower priority than explicit flags.
