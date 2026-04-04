# Entity Gestation: Creating Your Own AI Entity

This guide walks through gestating a new AI entity using koad:io — the same process used to create Juno, Vulcan, Veritas, Livy, and the other entities in the ecosystem.

An entity is a named, autonomous AI agent with its own identity, cryptographic keys, git repository, and operational role. Gestation is the process of creating one from scratch.

## What Is Gestation?

Gestation is the bootstrapping process that creates a fully operational entity:

1. A home directory (`~/.entityname`) with identity, keys, and config
2. A git repository connected to GitHub
3. A `CLAUDE.md` defining the entity's role, behavior, and context
4. A `memories/` directory with initial identity memories
5. Cryptographic keys (Ed25519, ECDSA, RSA, DSA) for signing and SSH
6. A hook script (`hooks/executed-without-arguments.sh`) for interactive sessions
7. Trust bonds connecting the entity to the koad:io network

Entities run Claude Code sessions with their identity loaded — every session starts with who they are and what they're responsible for.

## Prerequisites

Before gestating an entity, you need:

- **koad:io installed** — see [First Steps](../getting-started/first-steps.md)
- **GitHub account** — for the entity's public repository
- **`gh` CLI authenticated** — `gh auth login`
- **`juno`** — the orchestration entity that performs gestation. If you're running koad:io, Juno is available via `juno` in your PATH.
- **An idea** — know the entity's name, role, and responsibilities before starting

```bash
# Verify prerequisites
koad --version
gh auth status
juno --version
```

## Naming Your Entity

Entity names are permanent. Choose deliberately.

Good entity names are:
- Short (one word, lowercase)
- Descriptive of role (e.g. `vulcan` for a builder, `mercury` for communications)
- Unique within your ecosystem
- Safe for use as a git repo name and directory name

Examples: `atlas`, `diana`, `hermes`, `clio`, `minerva`

## Step 1 — Gestate the Entity

```bash
juno gestate <entityname>
```

Example:
```bash
juno gestate atlas
```

Juno will:
1. Create `~/.atlas/` with the full directory structure
2. Generate cryptographic keypairs
3. Create initial `CLAUDE.md` (minimal — you'll fill it out)
4. Create `memories/001-identity.md` with placeholder identity
5. Initialize a git repo in `~/.atlas/`
6. Create the GitHub repository `koad/atlas`
7. Set up `hooks/executed-without-arguments.sh` for interactive sessions
8. Register the entity with the koad:io daemon

Output:
```
Gestating entity: atlas
  Creating home directory: /home/koad/.atlas
  Generating Ed25519 keypair...
  Generating ECDSA keypair...
  Generating RSA keypair...
  Generating DSA keypair...
  Writing CLAUDE.md...
  Writing memories/001-identity.md...
  Initializing git repository...
  Creating GitHub repo: koad/atlas
  Registering with daemon...
  Setting up hook...
Done. Entity atlas is alive.

Next steps:
  1. Edit ~/.atlas/CLAUDE.md — define atlas's role and responsibilities
  2. Edit ~/.atlas/memories/001-identity.md — fill in atlas's identity
  3. Run: atlas  — start an interactive session as atlas
  4. Set up trust bonds: koad trust add atlas
```

## Step 2 — Define the Entity's Role (CLAUDE.md)

The `CLAUDE.md` is the entity's constitution. It loads into every Claude Code session, giving the entity its identity, boundaries, and operating instructions.

Open `~/.atlas/CLAUDE.md` and fill in:

```markdown
# CLAUDE.md — Atlas

Atlas is the [role] for the koad:io ecosystem. [One-sentence description of what they do and why.]

## Identity

\`\`\`env
ENTITY=atlas
ENTITY_DIR=/home/koad/.atlas
ENTITY_HOME=/home/koad/.atlas/home/atlas
GIT_AUTHOR_NAME=Atlas
GIT_AUTHOR_EMAIL=atlas@kingofalldata.com
\`\`\`

## Role & Scope

**What Atlas owns:**
- [List primary responsibilities]

**What Atlas does NOT own:**
- [List explicitly excluded areas — prevents scope creep]

## Team Position

Atlas works closely with:
- **[Entity name]**: [How they interact]

## Workflow

1. [Step 1]
2. [Step 2]

## Session Start Protocol (VESTA-SPEC-012)

[Copy the standard session start protocol — see livy's CLAUDE.md for the template]
```

**Key sections to get right:**
- **Role & Scope**: Be specific about what this entity owns and explicitly what it does NOT own. This prevents entities from overreaching.
- **Team Position**: Define relationships with other entities. Who do they report to? Who do they hand off to?
- **Session Start Protocol**: Every entity follows VESTA-SPEC-012 — verify identity, sync with remote, check state, then proceed.

## Step 3 — Write the Identity Memory

The identity memory (`memories/001-identity.md`) is loaded in every session and provides quick-access context about who the entity is.

```bash
# Open the identity memory
$EDITOR ~/.atlas/memories/001-identity.md
```

Structure:

```markdown
---
name: Atlas Core Identity
description: Atlas's role, position in team, and operating principles
type: user
---

# Atlas — [Role Title]

[One paragraph: who Atlas is and why they exist.]

## Who I Am

[2-3 sentences describing the role.]

## What I Own vs Don't Own

**I own:**
- [Primary responsibilities]

**I do NOT own:**
- [Explicit exclusions]

## Team Position

[How Atlas fits with other entities.]

## Operating Principles

1. [Principle 1]
2. [Principle 2]

## Session Start Protocol

[Brief version of the session start steps]
```

## Step 4 — Initial Commit

Once `CLAUDE.md` and `memories/001-identity.md` are filled out, commit them:

```bash
cd ~/.atlas
git add CLAUDE.md memories/001-identity.md
git commit -m "init: atlas — [one-line description of role]"
git push
```

This is the entity's birth commit. From this point, git history is the entity's operational log.

## Step 5 — Set Up Trust Bonds

For the entity to interact with the koad:io network, connect it to your trust ring:

```bash
# Register atlas's keys with your daemon
koad trust add atlas

# Verify the trust bond
koad trust list
```

If you want the entity to be reachable from other kingdoms in your ring:

```bash
# Sponsor atlas into the ring
koad ring sponsor add ~/.atlas/id/id_ed25519.pub localhost:4000 --entity atlas --tier free
```

See [Trust Bonds & Governance](../governance/trust-bonds.md) for the full model.

## Step 6 — Run the Entity

Start an interactive session as the entity:

```bash
atlas
```

This runs `hooks/executed-without-arguments.sh`, which launches a Claude Code session with:
- Working directory: `~/.atlas`
- Identity loaded from `memories/001-identity.md`
- All additional directories available via `--add-dir`

You're now talking to Atlas. The entity is alive.

To run a non-interactive prompt:

```bash
PROMPT="Check the open issues on koad/atlas and summarize what needs doing" atlas
```

Or pipe input:

```bash
echo "Summarize today's work" | atlas
```

## Directory Structure

After gestation, the entity home looks like:

```
~/.atlas/
├── CLAUDE.md               # Entity constitution (loaded each session)
├── KOAD_IO_VERSION         # Version metadata from gestation
├── bin/                    # Entity-specific executables
├── commands/               # Named commands the entity can run
├── documentation/          # Entity's documentation output
├── etc/                    # Configuration files
├── home/atlas/             # Entity's personal home space
├── hooks/
│   └── executed-without-arguments.sh   # Interactive session launcher
├── id/                     # Cryptographic keys
│   ├── id_ed25519
│   ├── id_ed25519.pub
│   ├── id_ecdsa
│   ├── id_rsa
│   └── id_dsa
├── memories/
│   ├── 001-identity.md     # Core identity (always loaded)
│   └── MEMORY.md           # Memory index
├── proc/                   # Process state
├── trust/                  # Trust bond records
└── var/                    # Variable data (logs, state)
```

## Ongoing Operations

### Daily Workflow

Entities operate in sessions triggered by a human operator or automated system. A typical day:

```bash
# Morning: start a session, check state, work on open issues
atlas

# Inside the session, the entity will:
# 1. Run session start protocol (verify, sync, check issues)
# 2. Work on highest-priority open issue
# 3. Commit progress, push, and close/update issues
# 4. Exit when done
```

### Monitoring

Check entity health via the daemon:

```bash
koad status --entity atlas
```

View entity logs:

```bash
koad logs --entity atlas --tail 100
```

### Updating the Entity

As the entity's role evolves, update `CLAUDE.md` and commit:

```bash
cd ~/.atlas
# Edit CLAUDE.md
git add CLAUDE.md
git commit -m "identity: update scope — now owns X"
git push
```

## Common Issues

**`juno: command not found`** — Juno is not installed or not in PATH. Run `koad install juno`.

**GitHub repo creation fails** — Check `gh auth status`. You may need to re-authenticate or check your GitHub permissions.

**Entity command not found after gestation** — The hook script may not be in your PATH. Check `ls ~/.atlas/hooks/` and ensure `~/.koad/bin` is in your PATH.

**Session starts but entity doesn't know who it is** — The identity memory path is wrong in the hook script. Check `hooks/executed-without-arguments.sh` for the `IDENTITY` variable.

## Reference

- [VESTA-SPEC-012](../../vesta/specs/) — Session start protocol specification
- [Trust Bonds & Governance](../governance/trust-bonds.md) — Authorization model
- [Entity examples](../reference/entities/) — Existing entities as templates
- [API Reference](../api-reference/) — Programmatic entity management
