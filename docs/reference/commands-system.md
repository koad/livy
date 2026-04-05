# Commands System Reference

This document covers everything needed to understand, use, and write commands in the koad:io ecosystem. Commands are the primary way humans and agents reach into the system to invoke behavior.

For framework internals (the `koad-io` binary itself, hooks, env cascade), see `framework-layer.md`.

---

## 1. What Commands Are

Commands are **user-initiated shortcuts** — verbs that make the system do something when a human or agent types them. The pattern is:

```
<entity> <verb> [subverb] [args]
juno commit self
juno spawn process vulcan "write the auth module"
koad-io gestate muse
```

**Commands are not hooks.** This is the most important architectural distinction:

- **Commands** — the user reaches in. You type something; the system responds.
- **Hooks** — the system calls out. An event occurs; the entity's trained response fires automatically.

The `executed-without-arguments` hook fires when `juno` is invoked with no arguments — that is the entity waking up and choosing a harness. You did not type a command; you opened a portal. Commands are what happen after the entity is running and you ask it to do something specific.

Writing a command means encoding a repeatable operation as a named shortcut. Writing a hook means defining the entity's autonomous response to system events. Use commands for things a user asks for. Use hooks for things the system triggers.

---

## 2. The Three-Tier Resolution Order

When you invoke a command, the dispatcher searches three locations in priority order:

```
1. Global commands      ~/.koad-io/commands/
2. Entity commands      ~/.<entity>/commands/
3. CWD commands         $CWD/commands/
```

**Priority goes upward** — CWD wins over entity, entity wins over global. The dispatcher walks all three in sequence, replacing any earlier match with a later one. The final value of `COMMAND_LOCATION` when execution begins is the highest-priority match found.

Concretely: `juno commit` resolves to `~/.juno/commands/commit/command.sh` if that file exists, otherwise falls back to `~/.koad-io/commands/commit/command.sh`. If you are inside a project directory that has its own `commands/commit/`, that takes precedence over both.

This is the koad:io extension model. **Entities never fork the framework — they shadow it.** Add a same-named command at a higher-priority tier and the global default is bypassed automatically. The global command stays intact and unmodified.

---

## 3. How the Dispatcher Works

The dispatcher is `~/.koad-io/bin/koad-io`. It is a linear bash script, deliberately kept human-readable. Here is the sequence of what happens on every invocation:

### Step 1: Quiet and dry-run flags

Before anything else, the dispatcher scans arguments for `--quiet` / `-q` and strips them from the argument list. `KOAD_IO_QUIET=1` is exported and propagates to every command script. Spinners and ANSI decoration are suppressed.

`--dry-run` is detected later and causes the dispatcher to print the resolved command path without executing it.

`DEBUG=1` in the environment causes verbose trace output at every resolution step.

### Step 2: No-argument hook

If `$# -eq 0` (called with no arguments), the dispatcher exits command resolution entirely and runs the `executed-without-arguments` hook in waterfall order:

```
1. ~/.$ENTITY/hooks/executed-without-arguments.sh
2. $CWD/hooks/executed-without-arguments.sh
3. ~/.koad-io/hooks/executed-without-arguments.sh
```

The first match wins; lower tiers are not called. This is how entity invocation (waking an AI) stays separate from command dispatch.

### Step 3: Environment cascade

Environments are loaded in this order (later values win):

```
~/.koad-io/.env
~/.koad-io/.credentials
~/.koad-io/.aliases
~/.$ENTITY/.env
~/.$ENTITY/.credentials
```

After command resolution, the command's own `.env` and `.credentials` are loaded if present.

### Step 4: The depth-5 subdirectory walk

The dispatcher walks the argument list against each command tier, up to five levels deep. At each depth it checks whether the next argument maps to an existing subdirectory. It keeps the deepest match.

For a call like `juno spawn process vulcan`:

- Check `$GLOBAL/$1` → `~/.koad-io/commands/spawn/` — match, `COMMAND_LOCATION` set
- Check `$GLOBAL/$1/$2` → `~/.koad-io/commands/spawn/process/` — match, `COMMAND_LOCATION` updated
- Check `$GLOBAL/$1/$2/$3` → no `~/.koad-io/commands/spawn/process/vulcan/` — no change
- Then entity tier: `~/.juno/commands/spawn/` — match
- Then: `~/.juno/commands/spawn/process/` — match, `COMMAND_LOCATION` updated to entity path
- Then CWD tier: no matches

Result: `COMMAND_LOCATION = ~/.juno/commands/spawn/process/`, `EXEC_ARGS = (vulcan)`.

The remaining positional arguments after the deepest matched subcommand become `EXEC_ARGS` and are passed to the command script.

### Step 5: File selection

Once `COMMAND_LOCATION` is resolved, the dispatcher looks for an executable in this order:

1. `$COMMAND_LOCATION/command.sh` — standard, always tried first
2. `$COMMAND_LOCATION/$NEXT_ARG.sh` — named sibling script; if found, the next argument is consumed and the remainder becomes `EXEC_ARGS`
3. `$CWD/$1.sh` — a `.sh` file of the same name in the current working directory (lowest priority, used rarely)

The `commit/staged.sh` pattern is the named sibling in action: `juno commit staged` routes to `~/.koad-io/commands/commit/staged.sh` because `staged.sh` exists alongside `command.sh` in that directory.

### Step 6: Execution

```bash
exec $EXEC_FILE $EXEC_ARGS
```

The resolved file is `exec`'d with remaining arguments. The process is replaced; no subshell overhead.

---

## 4. How to Write a New Command

### Minimal structure

```
~/.<entity>/commands/
└── <verb>/
    └── command.sh
```

A command directory must have at minimum a `command.sh`. The directory name is the verb. A `README.md` or `PRIMER.md` alongside it is conventional but not required.

### command.sh format

```bash
#!/usr/bin/env bash

# Brief description of what this command does
# Usage: <entity> <verb> [args]

# $ENTITY      — the entity name (juno, vulcan, etc.)
# $ENTITY_DIR  — ~/.<entity>/ absolute path
# $CWD         — directory from which the entity wrapper was invoked
# $EXEC_ARGS   — remaining arguments after subcommand resolution
# $KOAD_IO_QUIET — "1" if quiet mode; suppress decorative output

# your script body here
```

The shebang must be `#!/usr/bin/env bash`. The script will be `exec`'d by the dispatcher, so it replaces the dispatcher process — keep that in mind for any cleanup logic.

### Available variables

All variables loaded by the environment cascade are available:

| Variable | Source | Value |
|----------|--------|-------|
| `ENTITY` | entity wrapper | Entity name (`juno`, `vulcan`, …) |
| `ENTITY_DIR` | koad-io dispatcher | `~/.juno` etc. |
| `CWD` | koad-io dispatcher | Working directory at time of invocation |
| `COMMAND_LOCATION` | koad-io dispatcher | Absolute path to the command directory |
| `EXEC_ARGS` | koad-io dispatcher | Remaining args after subcommand resolution |
| `KOAD_IO_QUIET` | quiet flag | `"1"` if `--quiet` or `-q` was passed |
| `DRY_RUN` | dry-run flag | `"true"` if `--dry-run` was passed |
| Any var from `.env` | cascade | Entity and framework config |

### Adding subcommands

Subcommands are just subdirectories. To add `juno team status`:

```
~/.juno/commands/
└── team/
    └── status/
        └── command.sh
```

No registration needed. The dispatcher walks the directory tree automatically up to five levels.

### Adding named sibling scripts

To add a variant of an existing command as `<entity> commit staged`:

```
~/.koad-io/commands/commit/
├── command.sh    # handles: <entity> commit
└── staged.sh     # handles: <entity> commit staged
```

When the dispatcher finds `staged.sh` in `COMMAND_LOCATION`, it treats `staged` as consumed and passes the remainder as arguments.

### Command-local environment

If a command needs its own environment variables, add a `.env` file inside the command directory. It is loaded after the entity cascade, so command-local values always win. Never put secrets in committed files; use `.credentials` (which is gitignored).

---

## 5. The $ENTITY-Scoping Pattern

A single command script can behave differently based on which entity invoked it, because `$ENTITY` is always available. This allows one global command to serve every entity correctly.

Example from `~/.koad-io/commands/sign/command.sh`:

```bash
ENTITY="${ENTITY:-koad}"
# ...
echo "--- AUTHORIZED BY $(echo "$ENTITY" | tr '[:lower:]' '[:upper:]') ---"
```

When `juno sign "message"` is called, `$ENTITY` is `juno`. When `koad-io sign "message"` is called without an entity wrapper, `$ENTITY` is empty and the default `koad` is used.

The same scoping appears in `~/.koad-io/commands/gestate/command.sh`, which captures the invoking entity as the "mother":

```bash
[[ $ENTITY ]] && MOTHER=$ENTITY
ENTITY=$1
```

If Juno gestates a new entity, the new entity's keys are generated with `$ENTITY_NAME@juno` as the identity. If koad-io gestates directly, the mother is `mary` (the immaculate default).

This pattern lets global commands encode entity-aware logic without any per-entity duplication. One script handles both framework-wide invocation and entity-scoped invocation. The entity wrapper sets `ENTITY`; the command script reads it.

---

## 6. Documented Commands Inventory

### Global commands (`~/.koad-io/commands/`)

| Command | Invocation | What it does |
|---------|------------|--------------|
| `gestate` | `koad-io gestate <name>` | Creates a new entity from scratch. Generates directory structure, four cryptographic key pairs (ed25519, ecdsa, rsa, dsa), SSL curves, `.gitignore`, minimal `.env`, and entity wrapper in `~/.koad-io/bin/`. `--full` flag adds slow dhparam generation. Mother entity's genes (commands, hooks, assets, etc.) are cloned if invoked from an entity wrapper. |
| `init` | `koad-io init [entity]` | Registers an existing directory as an entity by creating the wrapper in `~/.koad-io/bin/`. Lighter than `gestate` — no key generation. Checks directory structure for entity-likeness before proceeding; use `--forceful` to override. |
| `spawn` | `koad-io spawn <skeleton>` | Deploys a project skeleton template from `~/.koad-io/skeletons/` into the current working directory. Runs `pre-install`, `install`, and `post-install` control scripts if present. Available skeletons: `bare`, `interface`, `lighthouse`. |
| `start` | `koad-io start` | Starts a koad:io application (Meteor) in the current workspace. Detects whether a built bundle or source tree is present. Built bundles start via node; source trees start via `meteor`. Waits for MongoDB if `DB_HOST`/`DB_PORT` are set. |
| `build` | `koad-io build` | Builds a koad:io Meteor application from source. Produces a timestamped build in `builds/<datetime>/` and updates the `builds/latest` symlink. `LOCAL_BUILD=true` builds as a local directory bundle; default builds a tarball. |
| `commit` | `koad-io commit` | Warns against blind bulk commits and exits non-zero. Acts as a guardrail, not a commit helper. |
| `commit staged` | `koad-io commit staged` | AI-assisted commit of staged changes using OpenCode. Prompts the model to write a meaningful commit message focused on the "why." Does not push. |
| `install starship` | `koad-io install starship` | Installs the Starship cross-shell prompt, downloads a preconfigured `starship.toml`, and appends initialization to `.bashrc`. |
| `sign` | `koad-io sign "message"` | Produces a GPG clearsign-style block with Keybase saltpack signature. Entity-scoped: output header uses `$ENTITY`. Accepts message as argument or stdin. |
| `shell` | `<entity> shell` | Opens a shell in the entity's daemon directory. If a Meteor app is present in `daemon/src/`, opens `meteor shell`; otherwise opens `$ENTITY_SHELL` or `$SHELL`. `--terminal` forces a plain shell regardless. |
| `think` | `think "prompt"` | Raw local inference via ollama on fourty4 (`http://10.10.10.11:11434`). Not identity-aware; bypasses all entity context. Options: `-m` for model, `-s` for system prompt, `-r` for raw JSON, `--no-stream`, `--list`. Not for entity work — use OpenClaw/pi for context-aware inference. |
| `test` | `koad-io test` | Minimal echo command — prints the exec file and arguments. Exists to demonstrate the dispatch and depth-walk mechanics. Subcommands `test one`, `test one two`, `test one two three` each have their own `command.sh`. |
| `assert datadir` | (sourced internally) | Validates the current workspace as a koad:io working directory. Sets `DATADIR`, detects `LOCAL_BUILD`, loads workspace `.env`. Sourced by `start` and `build` rather than invoked directly. |

### Juno commands (`~/.juno/commands/`)

| Command | Invocation | What it does |
|---------|------------|--------------|
| `commit self` | `juno commit self` | AI-powered commit of `~/.juno/` itself. Uses OpenCode with big-pickle to write a meaningful commit message. Juno's self-maintenance shortcut. Overrides the global `commit` behavior entirely for the `self` subpath. |
| `spawn process` | `juno spawn process <entity> [opts] [prompt]` | Routes an entity invocation through that entity's hook. Validates the entity directory exists. `--window` opens a new gnome-terminal/tmux window. Prompt can be passed as argument, stdin, or heredoc. Non-interactive (with prompt): passes `PROMPT=` env to the entity wrapper. Interactive (no prompt): `exec`s directly into the entity. Overrides the global `spawn` command at the `spawn/process` subpath only. |
| `status` | `juno status` | Pulls `~/.juno/`, shows last five commits, lists open GitHub issues on `koad/juno`, and prints the critical path from `CLAUDE.md`. |
| `team status` | `juno team status` | Iterates all known team entities and shows last commit and memory file count for each. Quickly surfaces which entities are gestated and active. |
| `invoke entity` | `juno invoke entity <entity> "task"` | Spawns a team entity non-interactively via Claude (`claude --dangerously-skip-permissions -p`). Sleeps 30 seconds after completion. |
| `invoke free` | `juno invoke free <entity> "task"` | Same as above but uses OpenCode with big-pickle (no API key required). Sleeps 120 seconds after completion. |
| `community status` | `juno community status` | Markdown placeholder — community status overview. Not yet implemented as a shell script. |
| `outreach send` | `juno outreach send` | Markdown placeholder — outreach send workflow. Not yet implemented as a shell script. |
| `revenue status` | `juno revenue status` | Markdown placeholder — revenue status overview. Not yet implemented as a shell script. |

---

## 7. Commands vs. Hooks — The Architectural Distinction

This distinction is load-bearing. Confusing the two leads to the wrong extension pattern.

### Commands: user reaches in

A command is invoked explicitly. Something external — a human, an agent, a script — decides to call it. The entity does not know in advance that a command will be called; it simply waits and responds when asked.

Commands live in `commands/` directories. They are verbs in a vocabulary. The user constructs the sentence.

```bash
juno status          # I want to know Juno's status
juno commit self     # I want Juno to commit herself
juno spawn process vulcan "build the API"  # I want Vulcan working on a task
```

### Hooks: system calls out

A hook fires because a system event occurred. The entity does not decide to call it; the runtime decides. The hook is the entity's trained response to that event.

Hooks live in `hooks/` directories. They are reflexes, not choices. The system constructs the trigger.

```
juno              # no args → executed-without-arguments hook fires → entity wakes
```

The `executed-without-arguments` hook is not a command. It is what the entity does when invoked without being told what to do — it selects a harness, loads context, and opens the portal.

### When to use each

| Situation | Use |
|-----------|-----|
| Encoding a repeatable operation a user asks for | Command |
| Automating the entity's response to being invoked | Hook |
| Giving an entity a named verb to expose externally | Command |
| Training the entity's autonomous behavior | Hook |
| A shortcut that appears in the help vocabulary | Command |
| Something the entity should do without being asked | Hook |

There is one further distinction worth stating: commands can be discovered and listed. They have names, directories, README files. Hooks are harder to enumerate — they are buried in `hooks/` and fire on events, not on names. Commands are the public surface. Hooks are the trained interior.

---

## Technical Constraints

- Maximum argument depth: **5 levels** (hardwired in dispatcher)
- Maximum total arguments: **8** (positions `$1` through `$8`; `$9` causes exit 68)
- Named sibling scripts (`staged.sh`) consume one argument position
- Command scripts are `exec`'d — they replace the dispatcher process
- `KOAD_IO_QUIET=1` must be respected in all commands; suppress spinners and ANSI decoration when set
- Entity commands must not be placed in `~/.koad-io/commands/` — that is the global tier, shared by all entities

## See Also

- `framework-layer.md` — the `koad-io` dispatcher, environment cascade, and what entities must not modify
- `entity-directory-structure.md` — the standard entity directory layout, including `commands/` and `hooks/`
- `daemon-architecture.md` — the background worker system that will eventually automate what commands do interactively
