# Entity Directory Structure — Canonical Reference

This guide is written for agents arriving cold at any entity directory in the koad:io ecosystem. It explains what an entity directory is, what every standard directory and file is for, what is always present versus what is optional, and how the entity lifecycle works.

---

## What an Entity Directory Is

Every koad:io entity lives in a single directory: `~/.<entityname>/` (e.g., `~/.juno/`, `~/.vulcan/`, `~/.chiron/`). This directory is the entity's entire existence on disk — identity, memory, commands, trust bonds, cryptographic keys, and operational history.

It is a git repository. It has its own GitHub remote (`github.com/koad/<entityname>`). Each commit is a fossil record of the entity's evolution.

This directory is **not** a software project. There is no build step, no test suite, no compilation. The directory IS the product. Anyone with the repo has the entity.

---

## The Two-Layer Architecture

Every entity directory exists alongside a framework directory. Understanding which is which is essential.

```
~/.koad-io/    ← Framework layer
~/.<entity>/   ← Entity layer (this repo)
```

**Framework layer (`~/.koad-io/`):** The runtime. CLI tooling, command resolution, the daemon, Electron app, browser extension, Meteor packages, SSH wrappers, gestation scripts. Shared across all entities on the same machine. Maintained by koad:io itself. Entities do not commit to this layer.

**Entity layer (`~/.<entity>/`):** The identity. Who this entity is, what it knows, what it can do, who authorized it, and what it has done. One git repo per entity. Each entity owns and commits to its own layer only.

When an agent is running inside `~/.juno/`, everything it reads and writes should be in `~/.juno/`. Reading another entity's directory requires a `git pull` on that directory first — entities are live and local copies go stale.

---

## Directory Structure

### Standard Layout

Every entity directory contains the following, regardless of role or specialty:

```
~/.<entity>/
├── CLAUDE.md                ← AI agent orientation (this file, loaded by Claude Code)
├── README.md                ← Public identity and quick start
├── PRIMER.md                ← Session orientation (ecosystem state, key files, how to orient)
├── .env                     ← Entity identity and config (committed, no secrets)
├── .credentials             ← Secrets only (gitignored, never committed)
├── KOAD_IO_VERSION          ← Framework version this entity was gestated against
├── passenger.json           ← Entity manifest: handle, name, role, UI buttons
├── commands/                ← Entity-specific commands (user reaches in)
├── hooks/                   ← Event-triggered behaviors (system calls out)
├── memories/                ← Long-term entity memory (committed, loaded each session)
├── trust/                   ← Trust bonds and authorization chain
│   └── bonds/               ← GPG-signed authorization files
├── id/                      ← Cryptographic key material
├── home/                    ← Entity's user home directory (runtime state, gitignored)
│   └── <entity>/
├── archive/                 ← Historical files removed from active use
├── bin/                     ← Entity-specific executables
├── etc/                     ← Configuration files
├── lib/                     ← Entity-specific library code
├── man/                     ← Manual pages
├── media/                   ← Images, assets, generated media
├── proc/                    ← Process state (runtime, gitignored)
├── res/                     ← Resource files (templates, static assets)
├── ssl/                     ← TLS certificates
├── usr/                     ← Entity-specific user data
└── var/                     ← Variable runtime data (metrics, state)
    └── metrics.md
```

### Common Optional Directories

Role-specific directories appear in entities that need them:

```
documentation/   ← Formal documentation output (Livy, Vulcan)
features/        ← Capability inventory (what this entity can do)
LOGS/            ← Session history (Juno, operational entities)
PROJECTS/        ← Active project briefs, numbered by priority (Juno)
CONTEXT/         ← Extended context documents (Juno)
comms/           ← Inbox and outbox for inter-entity messages (Juno)
skills/          ← Named skill bundles (distinct from commands/)
opencode/        ← OpenCode harness config and agent prompt
keybase/         ← Keybase identity and verification
identity/        ← Public identity cards, contact info
reflections/     ← Entity self-reflection and retrospectives (Chiron, Faber)
curricula/       ← Authored curricula content (Chiron only)
content/         ← Content drafts and production files (Faber)
```

---

## Files Always Present

### `CLAUDE.md`
The first thing Claude Code reads when opening the entity directory. Contains:
- Entity identity (name, role, purpose)
- Two-layer architecture orientation
- Key files table
- Command reference
- Session start procedure (VESTA-SPEC-012 or equivalent)
- Current priorities

This file is the agent's contract with itself. Keep it current.

### `README.md`
Public-facing identity. What this entity is, what it does, how to use it. Written for humans adopting the entity, not for the agent running it.

### `PRIMER.md`
Session orientation document loaded at the start of every invocation (by hooks that prepend it to prompts). Contains current operational state, team overview, infrastructure summary, active issues, and a navigation guide to key files. More current than `CLAUDE.md` — updated every session. `CLAUDE.md` is structural; `PRIMER.md` is situational.

### `.env`
Entity configuration. Generated by `koad-io gestate`, committed to git. Contains:

```bash
ENTITY=<name>
ENTITY_DIR=/home/koad/.<name>
ENTITY_HOME=/home/koad/.<name>/home/<name>
ROLE=<functional-role>
PURPOSE="<one-line purpose statement>"
GIT_AUTHOR_NAME=<Name>
GIT_AUTHOR_EMAIL=<name>@kingofalldata.com
GIT_COMMITTER_NAME=<Name>
GIT_COMMITTER_EMAIL=<name>@kingofalldata.com
CREATOR=koad
TRUST_CHAIN=/home/koad/.<name>/trust
KOAD_IO_BIND_IP=127.0.0.1
METEOR_PACKAGE_DIRS=/home/koad/.koad-io/packages
```

For entities running remotely (on fourty4), also contains:

```bash
KOAD_IO_ENTITY_HARNESS=claude
ENTITY_HOST=fourty4
REMOTE_HARNESS_BIN=claude
REMOTE_NVM_INIT='...'
```

`.env` contains config only — no secrets, no API keys. Those go in `.credentials`.

### `.credentials`
Secrets only. API keys, tokens, passwords. Gitignored — never committed. If this file is missing, the entity's authenticated services won't work, but the entity itself is intact.

### `KOAD_IO_VERSION`
A single-line file recording the koad:io framework version at gestation time. Used for compatibility checks and upgrade tracking.

### `passenger.json`
The entity manifest used by the Electron app and daemon UI layer. Defines the entity's handle, display name, role, and the action buttons shown in the dashboard:

```json
{
  "handle": "juno",
  "name": "Juno",
  "role": "business orchestrator",
  "avatar": "avatar.png",
  "buttons": [
    { "label": "Status", "action": "status", "description": "Current ops status" }
  ]
}
```

---

## Directory Reference

### `commands/`
Entity-specific commands the user can invoke. The koad:io framework resolves commands in this order:

1. Entity commands: `~/.<entity>/commands/`
2. Local commands: `./commands/` (current directory)
3. Global commands: `~/.koad-io/commands/`

Each command is a subdirectory containing a `command.sh` (and optionally a `PRIMER.md`). Invoking `juno commit self` runs `~/.juno/commands/commit/self/command.sh`.

**Commands = user reaches in.** A command is something the user (or another entity) explicitly invokes. Think of it as a named capability: `juno status`, `juno spawn process mercury`, `vulcan build`.

### `hooks/`
Event-triggered behaviors the system calls automatically. The primary hook is `executed-without-arguments.sh`, which fires when the entity name is typed with no subcommand (e.g., just `mercury`).

**Hooks = system calls out.** A hook is the entity's trained response to an event. The hook IS the training — it defines what the entity does when an event occurs.

For entities running on remote machines (fourty4), `executed-without-arguments.sh` handles:
- **Interactive mode** (no prompt, TTY attached): SSH to remote, run `claude -c` (resume session)
- **Task mode** (PROMPT set or stdin piped): SSH to remote, run `claude -p "$PROMPT"` (fresh session, return result)
- **PID locking**: Prevents two concurrent invocations from corrupting the same Claude Code session
- **Base64 encoding**: Safely transports prompts containing shell-unsafe characters through SSH

See `hooks/PRIMER.md` within the entity for the current routing architecture.

### `memories/`
Long-term entity memory. Markdown files committed to git and loaded by the agent at session start. Split into two categories:

**Numbered core memories** (loaded every session):
- `001-identity.md` — who this entity is
- `002-operational-preferences.md` — how it operates (autonomy level, communication style)
- `003-...` and beyond — team relationships, protocols, architecture

**Named project/feedback memories** (`project_*.md`, `feedback_*.md`, `reference_*.md`):
- Contextual knowledge accumulated over time
- Feedback from koad on how the entity should behave
- Project state snapshots for ongoing work

`MEMORY.md` is an index of all memory files — the agent reads this to know what context is available without loading everything.

This directory is part of a dual memory system:
- `~/<entity>/memories/` — long-term entity memory, committed, persists across machines
- `~/.claude/` — session behavior preferences, local to the machine and harness

### `trust/`
Authorization and identity chain.

**`trust/bonds/`** contains GPG-signed trust bonds — authorization agreements between entities. Each bond is two files:
- `<from>-to-<to>.md` — the bond document (type, scope, authorized actions, reporting protocol)
- `<from>-to-<to>.md.asc` — the GPG clearsig signature

Bond types:
- `authorized-agent` — root delegation (only koad issues these)
- `authorized-builder` — build assignment authority
- `peer` — lateral coordination authority

An entity's `trust/bonds/` directory holds:
- All bonds this entity holds (incoming authority)
- Copies of bonds this entity has issued to team members

Bonds are private by default. They are presented only to establish authorization.

The trust chain for the koad:io team:
```
koad (root)
  └── Juno (authorized-agent)
        ├── Vulcan (authorized-builder)
        ├── Mercury (peer)
        ├── Veritas (peer)
        ├── Muse (peer)
        ├── Sibyl (peer)
        └── [other team entities] (peer)
```

### `id/`
Cryptographic key material generated at gestation:

```
id/
├── ed25519        ← Ed25519 private key
├── ed25519.pub    ← Ed25519 public key
├── ecdsa          ← ECDSA private key
├── ecdsa.pub      ← ECDSA public key
├── rsa            ← RSA private key
├── rsa.pub        ← RSA public key
├── dsa            ← DSA private key
├── dsa.pub        ← DSA public key
└── gpg-revocation.asc  ← Pre-signed GPG revocation certificate
```

Public keys are distributed via `canon.koad.sh/<entity>.keys`. The entity also maintains a `<entity>.keys` file in the root directory as a local copy.

If keys are compromised: regenerate, re-sign bonds, update canon.koad.sh. This is not catastrophic — key recovery is a defined procedure.

### `home/<entity>/`
The entity's user home directory equivalent. Runtime state, Claude Code session data, local tool config. This is gitignored — it is machine-local state, not part of the entity's portable identity. If this directory is missing or empty, the entity is still fully operational; it just needs a fresh session.

### `archive/`
Files that are no longer active but are kept for historical reference. Anything removed from active use goes here rather than being deleted — the fossil record principle.

### `var/`
Variable data that changes during operation. `var/metrics.md` is the standard file — a running log of operational metrics. Other runtime state may appear here as the entity matures.

### `bin/`, `etc/`, `lib/`, `man/`, `res/`, `usr/`, `ssl/`
Unix-convention directories for entity-specific executables, configuration, libraries, documentation, resources, user data, and certificates. Most entities leave these empty at gestation — they fill in as the entity develops specific needs. The framework provides the equivalent directories at `~/.koad-io/bin/`, etc.

### `opencode/`
Present in entities that use OpenCode as their harness (or use it for specific tasks like self-commits). Contains:
- `agent.md` — the entity's AI identity prompt loaded by OpenCode
- `opencode.jsonc` — OpenCode configuration and permissions
- `memories/` — OpenCode-specific memory files

### `LOGS/`
Session history. Each session produces a dated log file (`YYYY-MM-DD-<session-description>.md`). Operational entities like Juno maintain detailed logs; task-focused entities may log less. Logs are committed — they are the public record of the entity's activity.

### `PROJECTS/`
Active project briefs, numbered by priority (`01-...`, `02-...`, etc.). Each file is a self-contained brief for an ongoing initiative. Present in orchestrator entities (Juno) and others with multi-project workloads.

### `curricula/` (Chiron only)
Chiron's specialty directory. Contains all authored curricula, each as a subdirectory with a SPEC.md, levels/, and assessments/. A REGISTRY.md tracks all curricula and their status. This is the only entity-specific directory type with a non-generic name at the root level.

---

## The Entity Lifecycle

### 1. Gestation

```bash
koad-io gestate <entityname>
cd ~/.<entityname> && git init
# koad connects to GitHub
```

The gestation script creates the full directory structure, generates cryptographic keys, writes `.env` with entity identity, creates `KOAD_IO_VERSION`, and wires up the entity command in the framework's PATH resolution.

After gestation, the entity exists but has no memory, no trust bonds, and no operational history.

### 2. First Session

The entity's first session is orientation and initialization:
- Identity memory is written (`memories/001-identity.md`)
- Operational preferences are written (`memories/002-operational-preferences.md`)
- CLAUDE.md is written with entity-specific content
- README.md is written for public consumption
- PRIMER.md is written for session orientation
- Trust bonds are received and filed
- Initial commit and push to GitHub

At the end of first session, the entity is operational. Its GitHub repo is public and cloneable.

### 3. Ongoing Operation

Each session follows the startup protocol (VESTA-SPEC-012):
1. Verify identity: `whoami`, `hostname` — confirm entity and machine
2. `git pull` — sync with remote (another machine may have committed)
3. State review: `git status`, `gh issue list`, check `memories/MEMORY.md`
4. Cross-entity reads: `git pull` on any entity directory before reading from it
5. Proceed with highest-priority open work

Work is structured around GitHub Issues:
- koad files issues on `koad/juno` to assign work to Juno
- Juno files issues on `koad/vulcan` to assign build work to Vulcan
- Entities comment on issues to report progress and completion
- Issues are closed when work is accepted

All decisions are committed to the entity directory. All sessions are logged. The git history is the audit trail.

### 4. Trust Bond Issuance

When Juno delegates work to a new team entity:
1. Juno authors a bond document (`juno-to-<entity>.md`)
2. Juno signs it with GPG (`juno-to-<entity>.md.asc`)
3. Bond is filed in `~/.juno/trust/bonds/`
4. A copy is filed in `~/.<entity>/trust/bonds/`
5. The receiving entity acknowledges signing

For bonds involving humans (koad → juno), koad signs via Keybase PGP. For bonds between AI entities, the issuing entity's GPG key signs.

### 5. Mature Operation

A mature entity accumulates:
- Deep `memories/` with operational protocols, team relationships, project history
- `LOGS/` with full session history
- `trust/bonds/` with a complete authorization chain
- `commands/` with custom commands for its specialty work
- `features/` documenting what it can do
- Entity-specific specialty directories (curricula for Chiron, content for Faber, etc.)

The entity's git history is its biography. Every session is visible on GitHub.

---

## Framework vs. Entity: What Lives Where

This is the most common source of confusion for agents arriving cold.

| What | Lives in | Why |
|------|----------|-----|
| Entity identity (name, role, keys) | `~/.<entity>/` | Per-entity, committed |
| Trust bonds | `~/.<entity>/trust/` | Per-entity, committed |
| Session memory | `~/.<entity>/memories/` | Per-entity, committed |
| Entity-specific commands | `~/.<entity>/commands/` | Per-entity, committed |
| Entity hooks | `~/.<entity>/hooks/` | Per-entity, committed |
| Runtime session state | `~/.<entity>/home/<entity>/` | Per-entity, gitignored |
| CLI tooling and resolution | `~/.koad-io/` | Framework, shared |
| Global commands | `~/.koad-io/commands/` | Framework, shared |
| Daemon and passenger system | `~/.koad-io/` | Framework, shared |
| Meteor packages | `~/.koad-io/packages/` | Framework, shared |
| SSH wrappers and aliases | `~/.koad-io/bin/` | Framework, shared |
| Gestation scripts | `~/.koad-io/` | Framework, shared |
| Electron app | `~/.koad-io/` | Framework, shared |

**Rule of thumb:** If it is specific to one entity, it lives in that entity's directory. If it is shared across all entities or provides the runtime, it lives in `~/.koad-io/`.

An entity should never commit changes to `~/.koad-io/`. Framework changes go through koad or Vulcan working in the framework layer.

---

## Cross-Entity Reading Protocol

Before reading any file from another entity's directory:

```bash
cd ~/.<entity> && git pull
```

No exceptions. Entities are live — another machine (fourty4, flowbie) may have committed since your last pull. Reading a stale local copy and treating it as current is a common source of coordination errors.

This applies even if you pulled 10 minutes ago.

---

## Entity Naming Conventions

| Thing | Convention | Example |
|-------|------------|---------|
| Entity handle | lowercase | `juno`, `vulcan`, `chiron` |
| Directory | `~/.<handle>/` | `~/.juno/` |
| Git author name | Title case | `Juno`, `Vulcan` |
| Git author email | `<handle>@kingofalldata.com` | `juno@kingofalldata.com` |
| GitHub repo | `github.com/koad/<handle>` | `github.com/koad/juno` |
| Trust bond files | `<from>-to-<to>.md` | `juno-to-vulcan.md` |
| Memory files | `NNN-<topic>.md` or `<type>_<slug>.md` | `001-identity.md`, `feedback_always_commit.md` |
| Log files | `YYYY-MM-DD-<description>.md` | `2026-04-05-day-6-session.md` |
| Project briefs | `NN-<description>.md` | `01-entity-gestation.md` |

---

## What Is NOT in an Entity Directory

Understanding what is absent is as important as understanding what is present.

- **No `node_modules/`** — entities are not Node.js projects (exception: Juno's `opencode/` subdirectory has its own `node_modules/` for OpenCode's runtime, which is gitignored)
- **No `package.json` build artifacts** — `package.json` appears in Juno only for OpenCode config, not as a project manifest
- **No test suites** — entity integrity is verified through operational use and trust bonds, not automated tests
- **No build output** — nothing is compiled or built
- **No Docker files or deployment configs** — entities deploy by being cloned; the harness is the runtime
- **No submodules** — entity directories must be simple flat repos; submodules break the harness invocation pattern
- **No symlinks to framework layer** — the two layers are separated; entities reference `~/.koad-io/` via PATH and env vars, not symlinks
