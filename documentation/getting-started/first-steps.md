# First Steps with koad:io

This guide takes you from zero to a running koad:io kingdom. By the end you'll have koad:io installed, an entity running, and your kingdom visible on kingofalldata.com.

## System Requirements

| Requirement | Minimum | Notes |
|-------------|---------|-------|
| OS | Linux or macOS | Windows via WSL2 |
| Node.js | 18+ | `node --version` to check |
| Python | 3.10+ | Used by some workers |
| SSH | Any | Key-based auth required |
| Git | 2.30+ | For entity management |
| Disk | 1 GB free | For daemon, logs, and workers |
| Network | Outbound TCP 443, 4000-4010 | Daemon peer ports |

> **No root required.** koad:io runs entirely in your home directory.

## Step 1 — Install koad:io

```bash
# Download the installer
curl -fsSL https://install.koad.sh | bash

# Add koad to your PATH (the installer will prompt this)
echo 'export PATH="$HOME/.koad/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify installation
koad --version
```

Expected output:
```
koad:io 1.0.0
```

## Step 2 — Initialize Your Kingdom

```bash
koad init
```

You'll be asked a few questions:

```
Kingdom handle (e.g. alice): alice
Your email: alice@example.com
Display name (for your portal page): Alice's Kingdom
```

This creates `~/.koad/` with your daemon config, cryptographic keys, and a first entity named after your handle.

## Step 3 — Start the Daemon

```bash
koad start
```

The daemon runs in the background. Check that it's up:

```bash
koad status
```

Output:
```
daemon:    running (pid 12345)
uptime:    0:00:12
workers:   0 active
ring:      not connected
portal:    https://kingofalldata.com/alice-example-com
```

## Step 4 — Run a Hello World Worker

Workers are the units of work in koad:io. Let's run the built-in hello-world example.

```bash
koad worker run hello-world
```

Output:
```
[hello-world] starting...
[hello-world] Hello from koad:io! Your kingdom is alive.
[hello-world] done (0.3s)
```

You just ran your first worker. Check the portal link from `koad status` — the worker run should appear in your kingdom's live state.

## Step 5 — First Deployment

Once your daemon is running and you've verified your kingdom, deploy it so the portal can reach you:

```bash
koad deploy
```

This registers your daemon's public key and hostname with the koad:io network, making your portal namespace active:

```
https://kingofalldata.com/alice-example-com
```

Visit that URL — you'll see your kingdom's live state.

## What Just Happened?

- **Daemon**: A background process managing your workers and handling peer connections.
- **Worker**: A named task your daemon can start, monitor, and restart.
- **Kingdom**: Your local installation — daemon + workers + config.
- **Portal**: A public read-only view of your kingdom's live state.

## Common Issues

**`koad: command not found`** — Your PATH wasn't updated. Run `source ~/.bashrc` or open a new terminal.

**`Error: port 4000 in use`** — Another process is using the daemon port. Either stop it or configure a different port with `koad config set daemon_port=4001`.

**Portal not loading** — The daemon needs to be reachable from outside. Check that your firewall allows outbound connections on ports 4000–4010.

## Next Steps

- [Create your first entity](./entities.md) — Set up a named identity in your kingdom
- [Connect to a Trust Ring](../guides/trust-rings.md) — Link your kingdom to others
- [Understand the portal](../guides/portal.md) — What others see when they visit your namespace
