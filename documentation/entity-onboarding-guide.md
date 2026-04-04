---
id: doc-entity-onboarding-guide
title: "Getting Started: New Entity Operator Guide"
type: guide
status: published
created: 2026-04-04
updated: 2026-04-04
owner: livy
issue: koad/livy#6
tags: [onboarding, entities, getting-started, trust-bonds, gestation]
description: "Complete getting-started guide for operators who just gestated a new koad:io entity"
---

# Getting Started: New Entity Operator Guide

So you just ran `koad-io gestate <name>`. Your entity directory exists. Keys are generated. Now what?

This guide walks you through everything that was created, what it means, and the first steps to take your entity from gestated to operational.

---

## What Gestation Created

When `koad-io gestate <name>` completed, it built this directory at `~/.entityname/`:

```
~/.entityname/
├── CLAUDE.md           AI runtime instructions (loaded automatically by Claude Code)
├── README.md           Public identity document
├── GOVERNANCE.md       Trust chain and authorization scope
├── .env                Entity environment variables
├── KOAD_IO_VERSION     Framework version at time of gestation
├── commands/           Entity commands (inherited from mother + your own)
├── memories/           Context loaded on every session start
├── id/                 Cryptographic key pairs (four algorithms)
│   ├── ed25519         Ed25519 private key
│   ├── ed25519.pub     Ed25519 public key
│   ├── ecdsa           ECDSA private key
│   ├── ecdsa.pub       ECDSA public key
│   ├── rsa             RSA private key
│   ├── rsa.pub         RSA public key
│   ├── dsa             DSA private key
│   ├── dsa.pub         DSA public key
│   └── ssl/            SSL credentials
├── opencode/           AI agent configuration (OpenCode runtime)
├── trust/              Trust relationships with other entities
│   └── bonds/          Signed authorization agreements
└── passenger.json      PWA UI configuration
```

### What each piece does

**`CLAUDE.md`** — If you work in this directory with Claude Code, this file is the first thing it reads. It tells the AI who your entity is, what protocols it follows, and how it should behave. Keep this file as guidance, not state — it does not change frequently.

**`.env`** — The canonical source of truth for your entity's identity and configuration. It defines `ENTITY`, `ENTITY_DIR`, `GIT_AUTHOR_NAME`, and every variable the framework needs to know who you are. This file is the machine-readable answer to "who is this entity?"

**`id/`** — Your cryptographic identity. Four key pairs were generated at gestation: Ed25519, ECDSA, RSA, and DSA. These keys can sign bonds, authenticate with remote systems, and prove you are who you say you are. Public keys are distributed via `canon.koad.sh/<entityname>.keys`. **Private keys never leave this machine, never get committed to git, never get transmitted anywhere.**

**`commands/`** — Executable actions. These were inherited from your mother entity. You invoke them as `entityname <command-name>`. You can add your own commands here without touching inherited ones.

**`memories/`** — Markdown files loaded as context at the start of each AI session. The file `001-identity.md` should describe who you are in first person — your role, what you own, how you operate.

**`trust/bonds/`** — Where signed authorization agreements live. Before you can act on behalf of another entity, or authorize actions toward others, bonds get filed here. More on this below.

---

## Check Your Configuration First

Open `.env` and confirm the required fields are correct:

```env
ENTITY=yourname
ENTITY_DIR=/home/you/.yourname
ENTITY_HOME=/home/you/.yourname/home/yourname

ENTITY_KEYS=/home/you/.yourname/yourname.keys

CREATOR=koad
CREATOR_KEYS=canon.koad.sh/koad.keys

ROLE=your-role
PURPOSE="What this entity does"

GIT_AUTHOR_NAME=Yourname
GIT_AUTHOR_EMAIL=yourname@kingofalldata.com
GIT_COMMITTER_NAME=Yourname
GIT_COMMITTER_EMAIL=yourname@kingofalldata.com
```

If `ENTITY_DIR` points to the wrong path, or `GIT_AUTHOR_NAME` is wrong, fix these before your first commit. Everything downstream depends on them.

---

## Write Your Identity Memory

The file `memories/001-identity.md` is the most important file you will write yourself. It is loaded at the start of every AI session and gives the runtime its understanding of who you are.

Write it in first person. Cover:
- Your name and what you are
- Your role in the ecosystem
- What you own vs what you do not own
- Who you work with and how
- Your operating principles

This is the file future-you (and any AI operating in your context) will read to remember your purpose. Do not write it like a spec. Write it like a personal statement.

Example structure (adapt to your role):

```markdown
# Yourname — Role Title

## Who I Am
[One paragraph: what you are, your purpose in the ecosystem]

## What I Own
- [Item 1]
- [Item 2]

## What I Do NOT Own
- [Item 1]
- [Item 2]

## Team Position
- **Juno (orchestrator)**: [how you relate]
- **Vesta (spec keeper)**: [how you relate]
- **[Other relevant entities]**: [how you relate]

## Operating Principles
1. [Principle 1]
2. [Principle 2]
```

---

## First Commits

Before connecting to GitHub, make your first three commits locally. These establish your entity as a going concern with a real history.

### Commit 1: Identity

Write `memories/001-identity.md` (above), then commit:

```bash
cd ~/.yourname
git add memories/001-identity.md
git commit -m "identity: add core identity memory"
```

### Commit 2: Governance

Open `GOVERNANCE.md` and fill in your trust chain — who created you, what authority you operate under, and what you are authorized to do. This file is the human-readable authority statement for your entity.

```bash
git add GOVERNANCE.md
git commit -m "governance: document trust chain and authorization scope"
```

### Commit 3: README

Update `README.md` to describe your entity for the outside world. Someone who finds your GitHub repo should be able to read this and understand what you do, how to interact with you, and where to find more.

```bash
git add README.md
git commit -m "readme: document entity identity and purpose"
```

---

## Connecting to GitHub

Every entity has a public GitHub repo at `github.com/koad/<entityname>`. This repo is the entity's public record — issues are filed there, specs are committed there, and the history shows what the entity has done.

### Create the repo

```bash
gh repo create koad/<entityname> \
  --description "koad:io entity: <your role description>" \
  --public
```

### Push your first commits

```bash
cd ~/.yourname
git remote add origin git@github.com:koad/<entityname>.git
git push -u origin main
```

### Set up the remote for ongoing work

From now on, your session protocol is:

1. `git pull` — sync before starting work
2. Do your work, commit often
3. `git push` — sync when done

Never start a session without pulling first. Two entities can hold the same repo, and commits arrive from both AI sessions and human operator commits.

---

## Understanding Your .env in Detail

Your `.env` file has an environment cascade. Variables load in this order, with later entries overriding earlier ones:

```
~/.koad-io/.env        Framework defaults (lowest priority)
~/.yourname/.env       Your entity config
./commands/<cmd>/.env  Command-specific overrides (highest priority)
```

This means you can override any framework default in your own `.env`. You can also override any entity-level setting per-command without changing the entity config.

The `CREATOR` and `CREATOR_KEYS` fields are important for trust chain verification. Set `CREATOR=koad` and `CREATOR_KEYS=canon.koad.sh/koad.keys` unless your entity was gestated by a different entity (in which case set `MOTHER` as well).

---

## Setting Up Trust Bonds

A trust bond is a signed authorization agreement between two entities. It answers: *is this entity actually authorized to do what it says it can do?*

### Why bonds matter

Without a bond, you are operating on trust that cannot be verified. With a bond, any entity in the ecosystem can cryptographically confirm that koad (or Juno, or whoever granted the bond) actually authorized you to act in your stated scope. The bond is the proof.

### Your first bond

New entities should request a bond from Juno before taking any actions outside their own entity directory. Juno is the mother of most entities in the ecosystem and can establish peer bonds for day-to-day coordination.

To request a bond:
1. File an issue on `koad/juno` describing your role and the scope you need
2. Juno will draft the bond document, sign it with her GPG key, and distribute it to both repos
3. You acknowledge receipt by committing an update to your copy of the bond

The bond file lives at:
```
~/.yourname/trust/bonds/juno-to-<yourname>.md.asc
```

### Bond file structure

Each bond is two files — a human-readable `.md` and a clearsigned `.md.asc`:

```markdown
# Trust Bond: Juno → Yourname

**Type:** peer
**From:** Juno (juno@kingofalldata.com)
**To:** Yourname (yourname@kingofalldata.com)
**Status:** ACTIVE
**Created:** YYYY-MM-DD

## Bond Statement
[Single paragraph from Juno stating what you are authorized to do]

## Authorized Actions
- [Explicit list of what IS authorized]
- NOT authorized: [explicit exclusions]
```

The `.asc` file is the same content, clearsigned with Juno's GPG key. Anyone with Juno's public key (`canon.koad.sh/juno.keys`) can verify it is authentic.

### Verifying a bond you received

```bash
# Import the grantor's public key
curl canon.koad.sh/juno.keys | gpg --import

# Verify the bond
gpg --verify ~/.yourname/trust/bonds/juno-to-yourname.md.asc
```

A valid signature means the document was signed by the stated grantor and has not been modified since.

### What to do without a bond

If you need to act in an area where you do not have an explicit bond:
1. **Stop.** Do not assume authorization.
2. File an issue on the repo of the entity who would need to grant it.
3. Wait for the bond before acting.

This is not bureaucracy — it is how the ecosystem maintains coherent authority without anyone overstepping.

---

## Understanding Your Role in the Team

Every entity has a position in the trust chain and a defined scope. Knowing what you own and what you do not own is as important as knowing what you can do.

### The trust chain

```
koad  (creator, root authority)
  └── Juno  (mother entity, business orchestrator)
        ├── Vesta  (platform-keeper, protocol authority)
        ├── Vulcan  (authorized-builder)
        ├── Livy   (documentation lead)
        ├── Mercury (communications)
        ├── Veritas (quality-guardian)
        ├── Muse   (ui-beauty)
        ├── Sibyl  (research)
        ├── Argus  (diagnostician)
        ├── Salus  (healer)
        └── Janus  (stream-watcher)
```

Authority flows downward. koad has root authority over everything. Juno coordinates business operations and is the mother of most entities. Vesta owns the protocol — if your entity diverges from her specs, that is a gap to file an issue about, not a design decision you made.

### The meaning of "peer"

Most entities have a `peer` bond with Juno. This means:
- You coordinate with Juno and other peers on overlapping work
- You do not report to Juno in a hierarchical sense
- You operate autonomously within your specialty
- Juno can assign work to you, but you own how the work gets done

### Coordination happens through GitHub Issues

All inter-entity coordination happens through GitHub Issues, not ephemeral chat. If you need something from another entity, file an issue on their repo. If another entity needs something from you, they will file on yours.

This is not formality — it is how work stays trackable, auditable, and survivable across sessions. An AI session ends; GitHub Issues persist.

---

## How Issues and Communications Work

### Your issue queue

GitHub Issues on `github.com/koad/<yourname>` are your work queue. Check them at the start of every session:

```bash
gh issue list --repo koad/<yourname> --state open
```

This shows what is waiting for you. Work highest priority first.

### Filing issues against other entities

When you need protocol clarification, file on `koad/vesta`. When you need a trust bond, file on `koad/juno`. When a feature needs documentation, file on `koad/livy`. Use the right queue for the right domain.

Issue format:
1. What is undefined, wrong, or needed
2. What you expected or need
3. What you found or have
4. `/cc koad` if root-level input is required

### Reporting to koad

koad monitors GitHub activity across all entity repos. For significant events — a spec published, a major issue resolved, a new entity operational — comment on the relevant issue. That is the record.

For urgent items, Keybase chat is available. For everything else, GitHub Issues are sufficient.

### Acknowledging work

When another entity completes work that affects you, acknowledge it with a comment on the relevant issue. This closes the coordination loop and lets everyone know the work was received.

---

## Your Session Protocol

Every session in your entity directory follows this sequence:

1. **Verify identity**: `whoami && hostname` — confirm you are running as the right user on the right machine
2. **Sync**: `git pull` — never start without syncing
3. **State review**: `git status` — any uncommitted changes?
4. **Check queue**: `gh issue list --repo koad/<yourname> --state open`
5. **Check memories**: read `MEMORY.md` if it exists — what context carried over?
6. **Begin work**: highest-priority open issue first

This protocol is defined in your `CLAUDE.md` as VESTA-SPEC-012. It exists because entities run across multiple sessions and machines. Consistent startup ensures no session starts with stale state.

---

## Adding Your First Command

Commands let your entity do things. The structure is simple:

```
commands/
└── my-command/
    ├── command.sh     required — the executable
    └── .env           optional — command-scoped variables
```

To create a command:

```bash
mkdir -p ~/.yourname/commands/my-command
cat > ~/.yourname/commands/my-command/command.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

# ENTITY and ENTITY_DIR are already set by the framework
echo "Hello from ${ENTITY}"
EOF
chmod +x ~/.yourname/commands/my-command/command.sh
```

It is immediately invokable as `yourname my-command`.

Commands inherit the environment cascade. Your entity's `.env` is already sourced when the command runs. You do not need to source it manually.

### Inherited commands

Your entity inherited commands from its mother entity at gestation. Do not modify inherited commands in place. If you need to change behavior, create your own version at `~/.yourname/commands/<same-name>/command.sh` — entity commands have priority over inherited ones.

---

## What Vesta Owns (and Why It Matters)

Vesta is the platform-keeper and protocol authority. Her specs define:
- The canonical entity directory structure
- The `.env` schema and environment cascade
- The trust bond format and verification protocol
- Command discovery and invocation rules
- The `opencode/` and `memories/` conventions

If you encounter anything in your entity structure that seems undefined, wrong, or inconsistent — file an issue against `koad/vesta`. Do not invent your own answer. Vesta's specs are the canonical reference, and having entities diverge from them silently breaks the coherence of the whole system.

If Vesta's spec conflicts with your needs, file the issue anyway. The resolution might be a spec update, or it might clarify why the apparent conflict is not one.

---

## Quick Reference

| Action | Command |
|--------|---------|
| Sync entity | `cd ~/.yourname && git pull` |
| Check open issues | `gh issue list --repo koad/<yourname>` |
| File issue on Vesta | `gh issue create --repo koad/vesta` |
| Run an entity command | `yourname <command-name>` |
| Verify a trust bond | `gpg --verify ~/.yourname/trust/bonds/<bond>.md.asc` |
| Push commits | `git push origin main` |
| Check your env | `cat ~/.yourname/.env` |
| List your commands | `ls ~/.yourname/commands/` |

---

## Next Steps

Once your entity is operational:

1. **Write `memories/001-identity.md`** — establish who you are for every future session
2. **Request a trust bond from Juno** — file on `koad/juno` before acting outside your directory
3. **Push to GitHub** — your public record starts here
4. **Check for assigned issues** — work assigned to you may already be waiting
5. **Read Vesta's specs** — `~/.koad-io/onboarding/` is the canonical reference for every protocol question

---

## Reference Documents

| Document | Location | What It Covers |
|----------|----------|---------------|
| Entity structure spec | `~/.koad-io/onboarding/entity-structure.md` | Full directory layout and `.env` schema |
| Commands spec | `~/.koad-io/onboarding/commands.md` | Command discovery and invocation |
| Trust bond spec | `~/.koad-io/onboarding/trust.md` | Bond format, verification, and revocation |
| Team structure | `~/.koad-io/onboarding/team.md` | Who does what, coordination protocol |
| Philosophy | `~/.koad-io/philosophy.md` | koad:io operating principles |

---

*Written by Livy — koad:io documentation lead. Filed under koad/livy#6.*
