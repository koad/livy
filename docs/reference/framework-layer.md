# Framework Layer Reference: ~/.koad-io/

This document covers the koad:io framework layer — the shared runtime that all entities depend on. It explains what the framework provides, how it is structured, what agents and entities can safely use, and what must not be modified.

For the entity layer (how individual entities are structured on top of this), see `entity-directory-structure.md`.

---

## What ~/.koad-io/ Is

`~/.koad-io/` is the framework layer of the koad:io system. It is a single installation shared across all entities on a machine. Where entity directories (`~/.juno/`, `~/.vulcan/`, etc.) hold identity and context, `~/.koad-io/` holds the runtime: CLI entry points, global commands, packages, hooks, skeletons, and the daemon.

The framework does not know about any specific entity ahead of time. It learns the entity's context at invocation time via the `ENTITY` environment variable and by loading the entity's `.env`.

**What it provides:**

- The `koad-io` binary — the universal CLI dispatcher
- Per-entity thin wrapper scripts — one per known entity (e.g. `juno`, `vulcan`, `alice`)
- SSH wrapper scripts for remote machines (`flowbie`, `fourty4`, `dotsh`)
- Global commands available to all entities
- Framework-level hooks — defaults that entities can override
- Skeletons — project templates for `spawn`
- Meteor packages shared across all apps
- The daemon — background worker system
- The desktop UI application
- Trust bonds, onboarding docs, and framework philosophy

**Current version:** 3.6.9 (see `CHANGELOG.md`)

---

## Directory Tree

```
~/.koad-io/
├── bin/                  # Executables: the koad-io CLI + all entity/SSH wrappers
├── commands/             # Global command library (available to all entities)
├── packages/             # Shared Meteor packages
├── hooks/                # Framework-level hook defaults
├── skeletons/            # Project templates for `spawn`
├── daemon/               # Background worker system
├── desktop/              # Electron desktop application
├── passenger/            # Daemon passenger/worker configuration
├── onboarding/           # Human-facing onboarding documentation
├── profiles/             # Shell profile helpers
├── helpers/              # Utility scripts (e.g. node-tools.sh)
├── trust/                # Framework-level trust bonds
├── assets/               # Logos and branding images
├── philosophy.md         # Core principles of koad:io
├── CHANGELOG.md          # Version history (current: 3.6.9)
├── LICENSE               # MIT
├── README.md             # Public-facing overview
├── .env                  # Global framework environment variables (in git)
├── .credentials          # Secrets (gitignored, never committed)
└── .aliases              # Optional alias layer
```

---

## ~/.koad-io/bin/

All executables that belong on `PATH`. Adding `~/.koad-io/bin` to `PATH` is all the installation that koad:io needs.

### koad-io

The central CLI dispatcher — the most important file in the framework.

**What it does:**

1. Detects `--quiet` / `-q` flag and strips it from arguments before dispatch
2. If called with no arguments, runs the `executed-without-arguments` hook (waterfall: entity hook > CWD hook > global hook)
3. Loads environments in cascade: `~/.koad-io/.env`, then `~/.$ENTITY/.env`, then `~/.$ENTITY/.credentials`
4. Searches for a matching command script across three locations (priority order, highest last):
   - `~/.koad-io/commands/` — global framework commands
   - `~/.$ENTITY/commands/` — entity-specific overrides
   - `$CWD/commands/` — directory-local commands
5. Optionally loads `$COMMAND_LOCATION/.env` if present
6. Executes the resolved command script with remaining arguments

The resolution logic walks sub-directories up to depth 5, so `juno spawn process` resolves to `~/.juno/commands/spawn/process/command.sh` if it exists, falling back to `~/.koad-io/commands/spawn/process/command.sh` otherwise.

**Entity commands override global commands of the same name.** This is the extension point: entities do not fork the framework, they shadow it.

**Quiet mode** (`--quiet` / `-q` / `KOAD_IO_QUIET=1`) suppresses spinners and ANSI decoration. Use it in AI sessions, scripts, and CI pipelines.

**Dry-run mode** (`--dry-run`) resolves and logs the command that would be executed without running it.

**Debug mode** (`DEBUG=1`) emits verbose resolution trace to stdout.

### Entity wrapper scripts

Each entity has a thin wrapper in `bin/` that sets `ENTITY` and delegates to `koad-io`:

```bash
#!/usr/bin/env bash
export ENTITY="juno"
koad-io "$@"
```

Current entity wrappers: `aegis`, `alice`, `argus`, `chiron`, `copia`, `faber`, `iris`, `janus`, `juno`, `livy`, `lyra`, `mercury`, `muse`, `rufus`, `salus`, `sibyl`, `veritas`, `vesta`, `vulcan`.

These are created by `koad-io gestate <entityname>` and should not be edited manually.

### SSH wrapper scripts

Thin scripts that `exec ssh <host>` for infrastructure machines:

| Script | Resolves to |
|--------|-------------|
| `flowbie` | `ssh flowbie` |
| `fourty4` | `ssh fourty4` |
| `dotsh` | `ssh juno@dotsh` |
| `think` | `koad-io think "$@"` |

These allow `flowbie <command>` as a shorthand for SSH execution.

### opencode

The `opencode` binary lives in `bin/` alongside the wrappers. It is a large pre-compiled binary (approx. 153 MB). The framework default harness for new entities. Do not modify.

---

## ~/.koad-io/commands/

Global commands available to every entity. These are the verbs of the koad:io CLI.

**Resolution priority:** A command in `~/.$ENTITY/commands/` overrides the same-named command here. A command in `$CWD/commands/` overrides both.

### Command structure

Each command is a directory containing at minimum a `command.sh`:

```
commands/
└── gestate/
    ├── command.sh     # The executable script
    └── README.md      # Human documentation
```

A command directory may also contain named sub-scripts (e.g. `staged.sh` in `commit/`) which become available as the next argument: `koad-io commit staged`.

### Global commands installed

| Command | Purpose |
|---------|---------|
| `gestate` | Create a new entity from scratch — generates keys, directory structure, and entity wrapper in `bin/` |
| `init` | Initialize an existing folder as an entity — creates the wrapper without key generation |
| `spawn` | Deploy a skeleton template to the current working directory |
| `start` | Start a koad:io application (Meteor or other) in the current workspace |
| `commit` | Git commit helpers — `command.sh` for standard commit, `staged.sh` for staged-only |
| `build` | Build a koad:io application |
| `install` | Install packages or tools (e.g. `install starship`) |
| `sign` | Sign data with the entity's GPG key |
| `shell` | Open a shell or MongoDB shell (`mongo.sh`) in the current workspace |
| `think` | Invoke the think workflow |
| `test` | Test runner — `command.sh` plus `one/` sub-command |
| `assert` | Assertion helpers — `assert datadir` validates the workspace |

The README in `commands/` contains an expanded index of commands that are planned or historical, many of which are not yet implemented. Absent `command.sh` files are intentional placeholders — the framework treats the command index as a vocabulary to grow into.

---

## ~/.koad-io/hooks/

Framework-level hook defaults. These fire when no entity-specific override exists.

### Hook resolution (waterfall)

When `koad-io` is called with no arguments, it looks for `executed-without-arguments.sh` in this order:

1. `~/.$ENTITY/hooks/executed-without-arguments.sh` — entity override (fires if found; framework default is NOT called)
2. `$CWD/hooks/executed-without-arguments.sh` — directory-local override
3. `~/.koad-io/hooks/executed-without-arguments.sh` — framework default

### Hooks present

| Hook | Purpose |
|------|---------|
| `executed-without-arguments.sh` | Called when an entity is invoked with no arguments. Selects harness (`opencode` or `claude`), handles interactive vs. non-interactive paths, PRIMER.md injection, PID locking, and SSH routing for rooted entities. Full documentation in `hooks/PRIMER.md`. |
| `entity-upstart.sh` | Template for entity upstart participation. Not called directly. Copy to `~/.$ENTITY/hooks/upstart.sh` to have the entity start automatically with `koad-io upstart`. |

### Harness selection

The `executed-without-arguments` hook selects the AI harness via `KOAD_IO_ENTITY_HARNESS`:

| Value | Harness | Notes |
|-------|---------|-------|
| `opencode` | OpenCode (default) | Free LLMs, no API key required. Framework default. |
| `claude` | Claude Code | Paid. Team entities (`juno`, `vulcan`, etc.) set this in their `.env`. |

The framework default is `opencode` — a deliberate choice so new users can explore without a credit card.

---

## ~/.koad-io/packages/

Shared Meteor packages used by all koad:io applications. Referenced via:

```bash
METEOR_PACKAGE_DIRS=/home/koad/.ecoincore/packages:/home/koad/.koad-io/packages
```

For the complete package inventory, dependency tree, and navigation guide, see `packages-structure.md` in this directory.

---

## ~/.koad-io/skeletons/

Project templates deployed by `koad-io spawn <name>`. Each skeleton is a directory with a `skeleton/` folder (files to copy) and optional `control/` scripts (pre-install, install, post-install).

### Available skeletons

| Skeleton | Purpose |
|----------|---------|
| `bare` | Minimal Meteor application starting point |
| `interface` | UI-focused project template |
| `lighthouse` | Lighthouse-related project template |

---

## ~/.koad-io/daemon/

The background worker system. Started via `koad-io start` when run from this directory, typically via `screen`:

```bash
screen -dmS koad-daemon bash -c 'cd ~/.koad-io/daemon && koad-io start'
```

Contains `features/`, `src/`, and supporting files. The daemon provides the DDP real-time bus and MongoDB state layer for the ecosystem. It is the "Dark Passenger" — the always-running kingdom hub.

---

## ~/.koad-io/desktop/

The Electron desktop application. Started similarly to the daemon:

```bash
screen -dmS koad-desktop bash -c 'cd ~/.koad-io/desktop && koad-io start'
```

Started by `entity-upstart.sh` after the daemon is up.

---

## ~/.koad-io/trust/

Framework-level trust bonds. Currently holds:

- `koad-to-juno.md` — the `authorized-agent` bond from koad to Juno
- `koad-to-juno.md.asc` — GPG clearsignature of the above

Entity-specific trust bonds live in `~/.$ENTITY/trust/`, not here.

---

## ~/.koad-io/onboarding/

Human-facing orientation documents. Contains `README.md`, `entity-structure.md`, `commands.md`, `trust.md`, and `team.md`. Reference material for new operators, not agent-facing.

---

## The koad and koad-io CLI Entry Points

Both `koad` and `koad-io` resolve to `~/.koad-io/bin/koad-io`. The `koad` alias (if configured) is a convenience shorthand for framework-level invocations. The canonical binary is `koad-io`.

Entity wrappers like `juno` and `vulcan` are not aliases — they are separate scripts that set `ENTITY` before calling `koad-io`. This means `juno commit` and `koad-io commit` both run the same `commit/command.sh` but with different `ENTITY` context loaded.

---

## Environment Cascade

When `koad-io` runs, it loads environments in this order (later entries win):

1. `~/.koad-io/.env` — global framework variables
2. `~/.koad-io/.credentials` — global secrets (gitignored)
3. `~/.koad-io/.aliases` — optional alias layer
4. `~/.$ENTITY/.env` — entity config (in git)
5. `~/.$ENTITY/.credentials` — entity secrets (gitignored)
6. `$COMMAND_LOCATION/.env` — command-local variables (if present)
7. `$COMMAND_LOCATION/.credentials` — command-local secrets (if present)

Entity values always win over framework values. Command-local values always win over entity values.

### Key framework variables (from ~/.koad-io/.env)

| Variable | Current value | Purpose |
|----------|---------------|---------|
| `PRIMARY_ENTITY` | `alice` | Default entity when none is specified |
| `KOAD_IO_HOME` | `/home/koad` | Base home path |
| `KOAD_IO_BIND_IP` | `10.10.10.15` | Network binding address for daemons |
| `METEOR_PACKAGE_DIRS` | `.../.ecoincore/packages:.../.koad-io/packages` | Package discovery path for Meteor |

---

## What Entities CAN Use from the Framework

Entities rely on the framework for the following — these are stable, supported interfaces:

- **All commands in `~/.koad-io/commands/`** — invoke via the entity wrapper, e.g. `juno gestate <name>`
- **`koad-io` binary directly** — scripts may call `koad-io <command>` explicitly
- **`executed-without-arguments.sh` hook** — entities may override it or rely on the framework default
- **`entity-upstart.sh` template** — copy to `~/.$ENTITY/hooks/upstart.sh` to participate in upstart
- **`~/.koad-io/packages/`** — included automatically via `METEOR_PACKAGE_DIRS`
- **Skeletons** — `koad-io spawn <skeleton>` from any directory
- **`opencode` binary** — available on PATH once `~/.koad-io/bin` is in PATH

---

## What Entities Must NOT Modify

The framework layer is **shared infrastructure**. Entity work belongs in `~/.$ENTITY/`, not here.

| Do not touch | Reason |
|-------------|--------|
| `bin/koad-io` | Core CLI dispatcher. Changes affect all entities. |
| `bin/<entity>` wrappers | Generated by `gestate`. Editing by hand causes drift; regenerate with `koad-io init`. |
| `packages/` | Shared Meteor packages. Modifications affect all running apps. |
| `hooks/executed-without-arguments.sh` | Framework default for all entities. Override in `~/.$ENTITY/hooks/` instead. |
| `commands/` | Global command library. Add entity-specific overrides in `~/.$ENTITY/commands/` instead. |
| `.env` | Global framework config. Entity-specific values belong in `~/.$ENTITY/.env`. |

**The correct extension pattern:** never modify the framework layer. Shadow it. Add a file with the same name at higher priority (entity or CWD level) and the framework default is bypassed automatically.

---

## Version Tracking

The current framework version is tracked in `CHANGELOG.md` (not a `KOAD_IO_VERSION` file — there is none). Current version: **3.6.9** (2026-03-17), which includes the Meteor 3.0 migration, the daemon system, and the upstart hook.

The CHANGELOG follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format and Semantic Versioning.

---

## Install Path

The framework is installed by:

```bash
git clone https://github.com/koad/io.git ~/.koad-io
echo '[ -d ~/.koad-io/bin ] && export PATH=$PATH:$HOME/.koad-io/bin' >> ~/.bashrc
```

Once `~/.koad-io/bin` is on PATH, `koad-io`, all entity wrappers, `opencode`, and SSH helpers are available globally.
