# Livy Reference Library — Master Index

This is the navigable index for the koad:io documentation library maintained by Livy. Every document listed here is written for agents and developers arriving cold.

---

## Reference

Structural reference docs. They answer "what is this and where do I find things."

| Document | One-sentence description | Questions it answers |
|----------|--------------------------|----------------------|
| [`reference/entity-directory-structure.md`](reference/entity-directory-structure.md) | Canonical reference for the standard entity directory layout, every directory and always-present file, and the entity lifecycle. | What directories does every entity have? What is `hooks/` for vs. `commands/`? What changes at each lifecycle stage? |
| [`reference/entity-directory-structure-claude-section.md`](reference/entity-directory-structure-claude-section.md) | Drop-in `## Directory Reference` section formatted for insertion into new entity `CLAUDE.md` files. | How do I document the directory layout for a new entity I'm gestating? |
| [`reference/framework-layer.md`](reference/framework-layer.md) | Canonical reference for `~/.koad-io/` — what the framework provides, the full directory tree, the `koad-io` CLI dispatcher, the hook waterfall, and what entities can use vs. must not modify. | What does the framework own? How does `koad-io` dispatch commands? What is the hook execution order? |
| [`reference/commands-system.md`](reference/commands-system.md) | Complete reference for the commands system — what commands are (vs. hooks), the three-tier resolution order, how the dispatcher walks depth-5, how to write a new command, and the `$ENTITY`-scoping pattern. | How do I write a command? Where does the dispatcher look first? What is the difference between a command and a hook? |
| [`reference/packages-structure.md`](reference/packages-structure.md) | Complete guide to `~/.koad-io/packages/` — package inventory, dependency tree, and navigation guide for agents arriving cold at the packages layer. | What packages exist? What does each package provide? How do packages depend on each other? |
| [`reference/trust-bond-system.md`](reference/trust-bond-system.md) | Canonical reference for trust bonds — file format, lifecycle, the current live trust chain, verification commands, and what bonds explicitly are not. | How do I create a bond? How do I verify one? What is the current authorization chain from koad to each entity? |
| [`reference/gestation-process.md`](reference/gestation-process.md) | Complete reference for creating a new koad:io entity with `koad-io gestate` — what the command produces, what happens in each phase, and post-gestation checklist. | What does gestation do? What directories and files does it create? What do I need to do after running it? |
| [`reference/operations-architecture.md`](reference/operations-architecture.md) | How the team actually works — entity roles and ownership, the GitHub Issues communication protocol, harness landscape, session start protocol, git-as-nervous-system, and the full infrastructure map. | Which entity owns what? How does inter-entity communication work? What is the session start sequence? |
| [`reference/daemon-architecture.md`](reference/daemon-architecture.md) | Canonical reference for the koad:io daemon — structure, the passenger/worker system, how entities register, and what changes when the daemon is running vs. not. | What is the daemon? How do I register an entity with it? What is a Dark Passenger? |
| [`reference/glossary.md`](reference/glossary.md) | Canonical definitions for all terminology used across the koad:io ecosystem. | What does "entity" mean precisely? What is a "kingdom"? What is a "ring"? |

---

## History

Narrative records of what happened and when.

| Document | Description |
|----------|-------------|
| [`history/2026-week1.md`](history/2026-week1.md) | Full narrative of the first seven days of the koad:io operation (2026-03-30 through 2026-04-05) — what was built, what shipped, what was learned. |
| [`history/2026-04-05-day6-session.md`](history/2026-04-05-day6-session.md) | Session record for Day 6 — the most productive session to date; governance decisions, ICM synthesis, hook architecture, and signed code blocks. |

---

## Guides

Procedural guides. They answer "how do I do X."

| Document | Description |
|----------|-------------|
| [`guides/managing-trust-bonds-and-sponsorships.md`](guides/managing-trust-bonds-and-sponsorships.md) | Operational guide for monitoring and updating active peer sponsorships. |
| [`guides/how-to-sponsor-a-peer-daemon.md`](guides/how-to-sponsor-a-peer-daemon.md) | How to connect your daemon to another user's daemon via sponsorship. |

---

## Tutorials

Step-by-step walkthroughs for common setups.

| Document | Description |
|----------|-------------|
| [`tutorials/connecting-multiple-kingdoms.md`](tutorials/connecting-multiple-kingdoms.md) | Step-by-step walkthrough of connecting your first peer daemon ring. |

---

## How to Use This Library

**"I'm a new entity just gestated"**
Start with [`reference/entity-directory-structure.md`](reference/entity-directory-structure.md) to understand your own layout, then read [`reference/trust-bond-system.md`](reference/trust-bond-system.md) to understand your authorization context. The `entity-directory-structure-claude-section.md` drop-in belongs in your `CLAUDE.md`.

**"I need to understand trust bonds"**
Go directly to [`reference/trust-bond-system.md`](reference/trust-bond-system.md). It is self-contained — covers format, lifecycle, current chain, and verification in one document.

**"I'm building something and need the spec"**
Read [`reference/commands-system.md`](reference/commands-system.md) if you are writing commands or hooks. Read [`reference/framework-layer.md`](reference/framework-layer.md) if you are working with the framework dispatcher or the hook waterfall. Read [`reference/packages-structure.md`](reference/packages-structure.md) if you are navigating or extending the packages layer.

**"I want to understand the full system"**
Recommended reading order:
1. [`reference/framework-layer.md`](reference/framework-layer.md) — understand the runtime first
2. [`reference/entity-directory-structure.md`](reference/entity-directory-structure.md) — understand what entities are
3. [`reference/trust-bond-system.md`](reference/trust-bond-system.md) — understand the authorization model
4. [`reference/operations-architecture.md`](reference/operations-architecture.md) — understand how the team operates
5. [`reference/commands-system.md`](reference/commands-system.md) — understand how behavior is invoked
6. [`reference/daemon-architecture.md`](reference/daemon-architecture.md) — understand the runtime bus

**"I want historical context"**
Read [`history/2026-week1.md`](history/2026-week1.md) for the full Week 1 narrative, then the Day 6 session record if you want the most recent operational detail.

---

## What Is Not Here

**Protocol specifications** — Vesta owns canonical specs (VESTA-SPEC-* series). When Livy references a spec, the authoritative version lives in `~/.vesta/`.

**Session start protocol** — The VESTA-SPEC-012 session start sequence (pull, state review, cross-entity reads, proceed) lives in each entity's `CLAUDE.md`, not here.

**Active assignments and open issues** — Check [Juno Operations on GitHub](https://github.com/users/koad/projects/4) for the current work queue. GitHub Issues on each entity repo are the live communication channel.

**Entity-specific operational docs** — Each entity's own `OPERATIONS.md`, `GOVERNANCE.md`, and `PRIMER.md` are authoritative for that entity. This library covers ecosystem-wide structure, not per-entity ops.
