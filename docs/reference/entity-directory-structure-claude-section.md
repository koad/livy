# Entity Directory Reference — CLAUDE.md Insert

This is a drop-in section for new entity `CLAUDE.md` files. Copy the block below into the `CLAUDE.md` under a `## Directory Reference` heading. Replace `<entity>` and `<Entity>` with the entity's actual name.

---

## Directory Reference

```
~/.<entity>/
├── CLAUDE.md            ← This file — agent orientation
├── README.md            ← Public identity and quick start
├── PRIMER.md            ← Session orientation (current state, key files)
├── .env                 ← Entity config: identity, git authorship, harness settings (committed)
├── .credentials         ← Secrets only — gitignored, never committed
├── KOAD_IO_VERSION      ← Framework version at gestation
├── passenger.json       ← Entity manifest for Electron app and daemon UI
├── commands/            ← Commands the user invokes (entity reaches out)
├── hooks/               ← Event-triggered behaviors (system calls in)
│   └── executed-without-arguments.sh  ← Fires when entity name typed with no subcommand
├── memories/            ← Long-term memory: committed markdown, loaded each session
│   ├── 001-identity.md
│   ├── 002-operational-preferences.md
│   └── MEMORY.md        ← Index of all memory files
├── trust/
│   └── bonds/           ← GPG-signed authorization agreements (.md + .md.asc pairs)
├── id/                  ← Cryptographic keys: ed25519, ecdsa, rsa, dsa (+ .pub, revocation)
├── home/<entity>/       ← Runtime session state — gitignored, machine-local
├── archive/             ← Historical files, removed from active use but preserved
└── var/
    └── metrics.md       ← Operational metrics log
```

### Two-Layer Architecture

```
~/.koad-io/    ← Framework layer: CLI, daemon, packages, gestation scripts (shared, not yours to commit)
~/.<entity>/   ← Entity layer: this repo — identity, memory, commands, trust, keys
```

Never commit to `~/.koad-io/`. Everything specific to this entity lives here.

### Key Directories

**`commands/`** — User-invoked capabilities. `<entity> commit self` runs `commands/commit/self/command.sh`. Commands = user reaches in.

**`hooks/`** — Event-triggered behaviors. `executed-without-arguments.sh` fires when the entity is invoked with no subcommand — handles interactive sessions (SSH + `claude -c`) and task mode (SSH + `claude -p`). Hooks = system calls out.

**`memories/`** — Long-term memory committed to git. Core numbered files (`001-identity.md`, etc.) loaded every session. Project and feedback files accumulated over time. `MEMORY.md` is the index.

**`trust/bonds/`** — Authorization chain. Each bond is `.md` (the agreement) + `.md.asc` (GPG signature). Bond types: `authorized-agent` (from koad only), `authorized-builder`, `peer`. Present bonds this entity holds and copies of bonds it has issued.

**`id/`** — Ed25519, ECDSA, RSA, DSA keys generated at gestation. Public keys distributed via `canon.koad.sh/<entity>.keys`. If compromised: regenerate, re-sign bonds, update canon.

### Cross-Entity Reading Rule

Before reading any file from another entity's directory:
```bash
cd ~/.<other-entity> && git pull
```
Always. Entities are live on multiple machines. Local copies go stale.
