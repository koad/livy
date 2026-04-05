---
type: reference-guide
subject: commands-and-hooks curriculum
curriculum_id: f3a7d2b1-8c4e-4f1a-b3d6-0e2c9f5a8b4d
curriculum_version: 0.1.0
source: /home/koad/.chiron/curricula/commands-and-hooks/
authored_by: livy
authored_at: 2026-04-05T00:00:00Z
---

# Commands and Hooks — Curriculum Reference Guide

**Curriculum:** Commands and Hooks — Teaching an Entity to Act
**Builder Path position:** Step 5 of 5 (final step)
**Prerequisite:** entity-gestation
**Estimated time:** 3.5 hours (8 levels, ~25–30 minutes each)
**Delivered by:** Alice (kingofalldata.com)

---

## What This Curriculum Is

The commands-and-hooks curriculum teaches operators how to extend an entity's capabilities by authoring the two mechanisms that define entity behavior: the commands system and the hook architecture.

A freshly gestated entity already has an identity, keys, trust bonds, and a directory structure. What it does not have is the ability to perform custom work — either when an operator explicitly asks (commands) or when the framework invokes it automatically (hooks). This curriculum closes that gap.

**Who it is for:** Operators who have completed entity-gestation and can create a new entity from scratch, configure its `.env`, navigate its directory structure, and explain trust bonds. They have run commands and seen hooks fire, but have never written one. They are ready to become builders, not just operators.

**What it is not:** This curriculum does not cover advanced hook types, global framework commands, daemon worker architecture, or GPG-signing policy blocks in depth. Each of those topics is deferred to a subsequent curriculum or a named spec.

---

## The Pedagogical Arc

The curriculum teaches commands first, then hooks, then integrates both into a single working skill.

This ordering is deliberate. Commands are operator-initiated — the operator already knows how to invoke them. Hooks are system-initiated — they fire when the framework detects an event, not when the operator asks. Teaching hooks before commands would require explaining a complex invocation contract (interactive path, non-interactive path, PID lock, base64) before the operator has any experience writing shell scripts in the koad:io context.

Commands establish the pattern — `command.sh`, cascade variables, `set -euo pipefail` — in a low-stakes context. Hooks extend that pattern rather than introducing it simultaneously with complex protocols.

The arc in brief:

- **Levels 0–3 (Commands):** From the mental model, through the directory structure, to a working command that knows its entity and reads from the cascade environment.
- **Levels 4–6 (Hooks):** From the invocation lifecycle, through the basic hook skeleton, to a production-safe hook with PID lock, base64 encoding, and PATH initialization.
- **Level 7 (Integration):** A complete entity skill combining a command, a hook, and shared library logic — tested across all three invocation scenarios.

---

## Level Summary

| Level | Title | Key Concept | Prerequisite |
|-------|-------|-------------|--------------|
| 0 | Commands vs Hooks — The Conceptual Distinction | Pull vs push: operators reach in (command), system calls out (hook) | entity-gestation |
| 1 | The commands/ Directory — Structure, Naming, Execution | Three-layer discovery order; deepest-path wins; exit 127 | Level 0 |
| 2 | Your First Command — Writing a Working Shell Command | Minimal command.sh: shebang, set -euo pipefail, chmod +x, exit codes | Level 1 |
| 3 | Commands That Know Their Entity — $ENTITY, .env, Cascade Variables | Cascade variable contract; conformance rule: use $ENTITY_DIR, never reconstruct it | Level 2 |
| 4 | The hooks/ Directory — When Hooks Fire, Hook Types | Hook invocation lifecycle; the two-path requirement (interactive and non-interactive) | Level 3 |
| 5 | Writing a Hook — Inject Context, Guard, Log | Prompt detection; interactive path (exec); non-interactive path (claude -p); PRIMER.md injection; invocation logging | Level 4 |
| 6 | Hook Internals — Ordering, PID Lock, Base64, PATH Init | PID lock (five steps); base64 encoding for shell quoting; NVM_INIT for non-interactive SSH; replacement semantics | Level 5 |
| 7 | Command + Hook Together — A Complete Entity Skill | Three-question skill design; lib/ library pattern; prompt routing; Builder Path completion | Level 6 |

---

## What Operators Can Build After Each Level

These are the concrete capabilities an operator has at the end of each level — not abstract understanding, but things they can do.

**After Level 0:**
- Classify any described entity capability as "command" or "hook" by asking who initiates it.
- Identify the correct destination directory (`commands/` vs `hooks/`) for a new capability without ambiguity.

**After Level 1:**
- Trace the three-layer resolution path for any `<entity> <subcommand>` invocation and name the exact file that will execute.
- Predict which `command.sh` wins when the same command exists at multiple layers (entity, local, framework).
- Diagnose a "command not found" exit 127 using the three-layer diagnostic sequence.

**After Level 2:**
- Create a working `command.sh` from scratch: correct shebang, `set -euo pipefail`, `chmod +x`, and a working body.
- Handle a missing required argument with a usage message to stderr and exit code 64.
- Write a README.md for a command following the standard format.

**After Level 3:**
- Write a command that reads `$ENTITY`, `$ENTITY_DIR`, and other cascade variables without reconstructing them from `$HOME`.
- Identify the conformance violation when a script contains `ENTITY_DIR="$HOME/.$ENTITY"` and correct it.
- Determine whether a variable belongs in the entity `.env`, a command-level `.env`, or neither.

**After Level 4:**
- Trace the full invocation lifecycle from entity wrapper through the dispatcher to the hook, naming every step.
- Explain why `practice status` does not fire the hook but `practice` (bare) does.
- Identify the five structural sections in a production hook by reading Juno's `executed-without-arguments.sh`.

**After Level 5:**
- Write a working `executed-without-arguments.sh` that detects invocation mode, branches correctly to interactive (`exec claude`) or non-interactive (`claude -p --output-format=json`), injects PRIMER.md context, and logs every invocation to `var/hooks/invocations.log`.

**After Level 6:**
- Implement the full PID lock (check, read, kill-0 test, fail-fast or write PID, register trap) from memory.
- Apply the base64 encode/decode pattern with the Linux/macOS portability fallback (`-w0` flag).
- Add `NVM_INIT` for non-interactive SSH and explain why the non-interactive shell cannot find `claude` without it.
- Deliver a production-safe hook that passes the five-scenario test sequence.

**After Level 7:**
- Design a complete entity skill using the three-question framework: what does the operator invoke? What does automation invoke? What is shared?
- Extract shared logic into `lib/<skill>.sh` and source it from both the command and the hook.
- Add prompt routing to the hook's non-interactive path so deterministic operations run without invoking the AI.
- Test all three invocation scenarios (operator command, automated prompt, interactive session) and verify they produce correct output.

---

## Hands-On Approach

Exercises throughout the curriculum are performed in a dedicated practice entity gestated at the start of Level 2 with `koad-io gestate practice`. Production entities (Juno, Vulcan, and any entity the operator relies on) are not used for exercises. This isolates the risk of mistakes in an environment where mistakes are free.

The practice entity is kept through Level 7. By the end, it contains:

- `commands/hello/command.sh` — minimal command from Level 2
- `commands/greet/command.sh` — command with argument handling and exit 64 from Level 2
- `commands/whois/command.sh` — entity-aware command reading `KOAD_IO_VERSION` from Level 3
- `commands/brief/command.sh` — complete skill command from Level 7
- `hooks/executed-without-arguments.sh` — production-safe hook with all Level 6 safeguards
- `lib/brief.sh` — shared library sourced by command and hook
- `var/hooks/invocations.log` — invocation log (gitignored)

The practice entity's git history is the artifact of curriculum completion. Level 7 ends with a commit of all curriculum work.

---

## Specs This Curriculum Puts Into Practice

| Spec | Coverage |
|------|---------|
| VESTA-SPEC-006 | Commands system: three-layer discovery, resolution, execution environment, naming, subcommand patterns. Fully covered across Levels 1–3. |
| VESTA-SPEC-020 | Hook architecture: invocation contract, non-interactive path, interactive path, PID lock (five steps), base64 encoding, PATH initialization via NVM_INIT. Fully covered across Levels 4–6. |
| VESTA-SPEC-009 | Hooks catalog: other hook event types beyond `executed-without-arguments`. Introduced at Level 4 as awareness; operators learn the pattern, not the full catalog. |
| VESTA-SPEC-025 | Curriculum bubble format and progressive disclosure rules. This is the loading contract that Alice follows to deliver this curriculum. Operators do not interact with this spec directly. |
| VESTA-SPEC-033 | Signed code blocks: GPG-clearsigned policy blocks in hook files. Introduced as awareness at Level 7 (Atom 7.5). Authoring signed blocks is covered in the advanced-trust-bonds curriculum. |

---

## What This Curriculum Defers

**Multiple hook types:** The curriculum covers only `executed-without-arguments.sh`. Other event types in VESTA-SPEC-009 (`spawned.sh`, `message-received.sh`, etc.) are named but not taught. Those belong in a future `advanced-hooks` curriculum.

**Global framework commands:** Writing a command in `~/.koad-io/commands/` that works across all entities is a framework-contributor operation, not an entity-operator operation. The curriculum teaches the entity layer in depth and introduces the framework layer conceptually.

**Command composition:** Commands that invoke other commands via the koad:io dispatcher introduce recursion concerns and discovery-order subtleties. Deferred.

**Daemon worker system:** VESTA-SPEC-020 Section 8 documents a daemon worker system that will eventually replace the hook invocation model. The curriculum teaches the current hook architecture, which remains canonical. Level 4 surfaces a one-sentence note: the hook skills taught here transfer to the daemon model when it arrives.

**Signed policy blocks (authoring):** Level 7 explains what signed policy blocks are and shows the verification command. Writing and signing a policy block requires entity key familiarity and GPG clearsigning, covered in the `advanced-trust-bonds` curriculum.

---

## Connection to Related Documentation

**PRIMER convention:** The PRIMER.md injection pattern taught at Level 5 is a direct application of the PRIMER convention — short orientation documents placed in project directories for agents arriving from elsewhere. Operators who complete Level 5 understand why PRIMER.md files are useful and can create them. Every entity directory and major project directory in the koad:io ecosystem can have a PRIMER.md; agents will read and incorporate it automatically.

**Entity portability:** The conformance rule from Level 3 — use `$ENTITY_DIR` as provided by the cascade, never reconstruct it from `$HOME` — is what makes entity commands portable. A command written with `$ENTITY_DIR` works correctly whether the entity is cloned to thinker, fourty4, flowbie, or any other machine. A command that reconstructs the path with `"$HOME/.$ENTITY"` assumes the `~/.<entity>` naming convention and fails if that assumption breaks. Portability is a conformance requirement, not a style preference.

**Gene inheritance:** Commands in `commands/` can be inherited by child entities gestated from a parent. A child entity inherits the parent's command tree. README.md files in command directories are what the inheriting entity's operator reads when exploring what capabilities they received. Commands without README files are opaque after inheritance.

**Trust bonds and the non-interactive path:** Juno's hook rejects non-interactive invocations. This is a policy decision implemented in the hook and asserted in the signed policy block. The hook is where an entity's authorization scope becomes executable behavior. Operators who understand hook authoring can read another entity's hook and determine exactly what that entity will and will not accept.

---

## Where to Find Source Files

| Resource | Location |
|----------|----------|
| Curriculum spec | `/home/koad/.chiron/curricula/commands-and-hooks/SPEC.md` |
| Pedagogical decisions | `/home/koad/.chiron/curricula/commands-and-hooks/DECISIONS.md` |
| Level files | `/home/koad/.chiron/curricula/commands-and-hooks/levels/level-00.md` through `level-07.md` |
| Reference hook | `~/.juno/hooks/executed-without-arguments.sh` |
| Reference commands | `~/.juno/commands/commit/self/command.sh`, `~/.juno/commands/spawn/process/command.sh` |
| Hook architecture spec | VESTA-SPEC-020 |
| Commands spec | VESTA-SPEC-006 |
| Hooks catalog | VESTA-SPEC-009 |
| Signed code blocks | VESTA-SPEC-033 |

---

*Authored by Livy — documentation librarian, koad:io ecosystem*
*Source verified against SPEC.md v0.1.0, DECISIONS.md, and all 8 level files as of 2026-04-05*
