---
title: "koad:io Glossary"
description: "Canonical definitions for terminology used across the koad:io ecosystem"
author: Livy
date: 2026-04-05
status: published
---

# koad:io Glossary

Canonical definitions for terms used across the koad:io ecosystem. Where a term has a generic meaning in software or cryptography, the koad:io-specific meaning is what this document covers. Cross-references point to the authoritative reference document for each concept.

Terms are listed alphabetically within thematic groups.

---

## Architecture

**entity**
An AI agent with its own directory, cryptographic keys, git repository, trust bonds, and persistent memory. Entities are sovereign processes — not API services, not plugins, not containerized microservices. They live on disk.

An entity has a name (e.g., `juno`), a home directory (`~/.juno/`), a GitHub remote (`github.com/koad/juno`), and a role. The entity IS the directory. Anyone with the repo has the entity. See `entity-directory-structure.md`.

**entity layer**
The `~/.<entity>/` directory for a specific entity — one flat git repository containing that entity's identity, memory, trust bonds, commands, hooks, and documentation. The entity layer is distinct from and built on top of the framework layer. Each entity owns and commits to its own layer only. See `entity-directory-structure.md`.

**framework layer**
The `~/.koad-io/` directory — the shared runtime installed once and used by all entities on the same machine. Provides the `koad-io` CLI, global commands, entity wrapper scripts, hooks, skeletons, packages, the daemon, and the browser extension. Entities do not commit to the framework layer; they shadow it. See `framework-layer.md`.

**two-layer architecture**
The foundational design pattern: `~/.koad-io/` (framework) plus `~/.<entity>/` (entity) together constitute one running entity. The framework knows nothing about a specific entity until invocation; the entity layer carries the identity. Separating these allows entities to evolve independently of the framework, and allows the framework to be upgraded without touching any entity's identity.

**sovereign / sovereignty**
An entity or operator is sovereign when their keys, data, and runtime live on hardware they control, with no vendor kill switch. "Not your keys, not your agent." Sovereignty in koad:io means: files on disk, keys held locally, no SaaS dependency on the AI layer. The entity can be cloned, rewound, forked, and migrated.

**kingdom**
One operator's complete koad:io environment: their `~/.koad-io/` framework, all their entity directories, their daemon, and the connections those make. A kingdom is the unit of sovereignty. Kingdoms can be peered together (see ring, peer ring). `koad.kingofalldata.com` is not a landing page — it is a live portal into koad's kingdom.

**KOAD_IO_VERSION**
The birth certificate file written to every entity directory at gestation time. Records `GESTATED_BY` (the mother entity or `mary` if none), `GESTATE_VERSION` (git hash of `~/.koad-io/` at gestation), `BIRTHDAY`, and `NAME`. Committed to the entity's git repo. The authoritative record of when and how an entity was created. See `gestation-process.md`.

---

## Lifecycle

**gestation**
The act of creating a new entity. `koad-io gestate <entityname>` produces the home directory, cryptographic keys (ed25519, ecdsa, rsa, dsa, ssl curves), `.gitignore`, minimal `.env`, `KOAD_IO_VERSION`, and the entity wrapper in `~/.koad-io/bin/`. Gestation is entirely local — no network, no GitHub. The entity exists on disk before it exists anywhere else. See `gestation-process.md`.

**gene-cloning**
When gestation is invoked from within an entity session (`juno gestate veritas`), the invoking entity becomes the "mother." The mother's `commands/`, `hooks/`, `assets/`, `docs/`, `skeletons/`, and public keys are cloned into the new entity. This is gene inheritance — the child entity starts with a copy of the mother's vocabulary and keys. If invoked outside any entity session, the mother defaults to `mary`.

**mother**
The entity that gestated a new entity, recorded in the child's `KOAD_IO_VERSION` as `GESTATED_BY`. Sets the gene source for cloning. Does not imply an ongoing authority relationship — authority comes from trust bonds, not birth.

**post-gestation checklist**
The steps required after `koad-io gestate` before an entity is operational: `git init`, GitHub repo creation, `.gitignore` expansion, `.env` expansion, `.credentials` creation, `CLAUDE.md` authoring, `README.md`, `memories/` setup, `PRIMER.md`, and trust bond creation. Gestate produces a skeleton; the checklist makes it live. See `gestation-process.md`.

---

## Command System

**command**
A user-initiated shortcut encoded as a script in a `commands/` directory. The user reaches in — typing `juno commit self` causes the command to fire. Commands are the public vocabulary of an entity. They do not fire automatically. Contrast with hooks. See `commands-system.md`.

**hook**
A script in a `hooks/` directory that fires when a system event occurs — the system calls out. The primary hook is `executed-without-arguments`, which fires when an entity wrapper is invoked with no arguments. Hooks define the entity's autonomous responses; commands define its explicit vocabulary. See `commands-system.md`.

**executed-without-arguments**
The hook that fires when an entity is invoked with no arguments (e.g., typing `juno` at the shell). This is the entity waking up. The hook selects the harness, loads context, handles PRIMER.md injection, and opens the AI session. Framework default is in `~/.koad-io/hooks/`; entities override in `~/.<entity>/hooks/`. See `framework-layer.md`.

**cascade environment / environment cascade**
The layered environment loading sequence on every invocation: `~/.koad-io/.env` → `~/.koad-io/.credentials` → `~/.koad-io/.aliases` → `~/.<entity>/.env` → `~/.<entity>/.credentials` → command-local `.env`. Later entries win. Entity values override framework values; command-local values override entity values. The cascade is how context scoping works without subprocesses or injection. See `framework-layer.md`.

**three-tier resolution**
How command lookup works: global commands (`~/.koad-io/commands/`) are searched first, then entity commands (`~/.<entity>/commands/`), then CWD commands (`$CWD/commands/`). The highest-priority match wins. Entities shadow the framework rather than forking it — a same-named command in `~/.juno/commands/` replaces the global one for Juno without touching `~/.koad-io/`. See `commands-system.md`.

**harness**
The AI runtime that executes entity sessions. In koad:io: `claude` (Claude Code, team entities), `opencode` (framework default, free), `pi` (fourty4, Ollama-native), `hermez` (NousResearch, pilot). Selected by `KOAD_IO_ENTITY_HARNESS` in the entity's `.env`. The framework default is `opencode` so operators can explore without an API key. Team entities explicitly set `KOAD_IO_ENTITY_HARNESS=claude`. See `operations-architecture.md`.

**PRIMER.md**
An orientation document placed at the root of any directory. When an entity is invoked from that directory, the hook prepends the PRIMER.md contents to the prompt — giving the AI instant context about the project without any extra instruction. Every entity root should have one. Convention: current state, what is complete, what is in progress, what is blocked.

**FORCE_LOCAL=1**
An override flag that forces entity invocation on the local machine, bypassing any `ENTITY_HOST` routing configured in `.env`. Added after a hook bug where `.env` sourcing was overwriting the caller's empty `ENTITY_HOST`, silently routing entities to fourty4 when local execution was intended.

---

## Trust System

**trust bond**
A GPG-signed Markdown file that authorizes one entity (or person) to act on behalf of another within explicitly stated limits. The foundational authorization document. Every authorized action traces back to a chain of bonds ending at koad (the root authority). Bonds are stored in `trust/bonds/` and dual-filed: the grantor keeps the originals, the grantee receives a copy. See `trust-bond-system.md`.

**clearsign**
A PGP cleartext signature format (RFC 2440 §7.2) in which the signed plaintext is embedded inside the PGP wrapper alongside the signature block. Used for all trust bonds (`.md.asc` files) and for the signed code block pattern in hooks. Clearsign files are human-readable as plain text even without GPG tools, while still being cryptographically verifiable. Contrast with detached signatures.

**bond type**
The category of a trust bond, which determines what authority can be granted. Current types: `authorized-agent` (broad operational autonomy; may issue downstream bonds; koad only), `authorized-builder` (directed work execution; no initiative), `peer` (lateral coordination; neither assigns to the other), `customer` (limited product access), `member` (community participation). See `trust-bond-system.md`.

**authorized-agent**
A bond type granting broad operational autonomy within stated scope, with the ability to issue downstream bonds to other entities. Only koad can issue `authorized-agent` bonds. In the current trust chain, Juno is the sole authorized-agent. An authorized-agent may spend, delegate, commit, and coordinate — within the limits stated in the bond. See `trust-bond-system.md`.

**authorized-builder**
A bond type granting authority to build and ship products as directed via GitHub Issues. No initiative — the builder does not start work without an Issue. Every build begins with a directing issue from the authorized-agent. Vulcan is the current authorized-builder. See `trust-bond-system.md`.

**peer (bond type)**
A bond type for lateral coordination between entities. Peers can file issues on each other's repos, reference each other's work, and coordinate without koad involvement for routine operations. Neither entity assigns work to the other; hierarchy is absent. Most team entities (Vesta, Livy, Faber, Mercury, Sibyl, etc.) hold peer bonds from Juno.

**canon.koad.sh**
koad's self-hosted Forgejo instance, serving as the canonical public key distribution endpoint for the ecosystem. Pattern: `https://canon.koad.sh/<entity>.keys` returns SSH public keys for the named entity. Used to verify that a key used to sign a bond actually belongs to the claimed entity. koad's own Keybase key is the root of the verification chain. See `trust-bond-system.md`.

**trust chain**
The hierarchy of signed bonds from the root authority (koad) down through every entity. Every bond's validity depends on the validity of the upstream bond. If koad revokes the `koad → juno` bond, every bond Juno has issued is suspended — the cascade is intentional. An entity's authority is bounded by the scope of its upstream bond.

**revocation cascade**
When a grantor revokes a bond, all bonds issued by the grantee are suspended. This is the root authority's off switch. Revocation is permanent and requires a written revocation notice in `trust/revocation/`.

**signed code block**
A GPG-clearsigned policy declaration embedded inside a bash script as comment lines. Juno's `executed-without-arguments.sh` hook carries one: the policy states the harness, interaction modes, and rationale, and is signed by Juno's key. The block can be extracted and verified with `gpg --verify` entirely offline. Tamper detection: modifying the policy invalidates the signature. PR consensus is required to modify a signed block — the original publisher holds veto rights. See `trust-bond-system.md` and VESTA-SPEC-033.

**powerbox**
A future verification layer that reads signed code blocks before execution and validates the signature against the relevant trust bond. Not yet implemented; described in the signed code block spec (VESTA-SPEC-033). The powerbox is the runtime enforcement complement to the declarative bond system.

**CID (content-identifier)**
A deterministic identifier for a signed claim or signature, produced by `koad.generate.cid`. Two parties who independently witness the same signature arrive at the same CID. Profiles list CIDs without embedding the underlying claims — the CID is a handle, not the content. The owner controls disclosure per requester: the same CID may be revealed to party A and refused to party B. All signature types (bonds, proofs, commits, claims) share one CID namespace.

---

## Daemon and Infrastructure

**daemon**
The kingdom hub — a Meteor/DDP application in `~/.koad-io/daemon/` that runs locally and provides three services: DDP pub/sub bus (WebSocket real-time protocol), MongoDB state store (passenger registry, task state), and HTTP server (widget UI at `localhost:9568`). Shared across all entities on the same machine. The daemon is not required for current operations (GitHub Issues handles all coordination), but adds real-time presence and browser integration when running. See `daemon-architecture.md`.

**Dark Passenger**
The browser extension component of koad:io. Connects to the daemon via DDP and provides in-browser entity presence — the selected entity "rides alongside" the operator in the browser. When a URL is visited, the extension can call `passenger.ingest.url` to deliver the URL and page context to the currently selected entity. The Dark Passenger and the daemon are a pair: extension bridges the browser; daemon is the hub. See `daemon-architecture.md`.

**passenger.json**
The registration card an entity places in its own directory to announce itself to the daemon. Fields: `handle` (entity name), `name` (display name), `avatar` (path to `avatar.png`), `outfit` (color scheme), `buttons` (quick-launch actions for the widget). The daemon scans all `~/.<folder>/` directories at startup and registers any that have a `passenger.json`. See `daemon-architecture.md`.

**DDP (Distributed Data Protocol)**
The WebSocket-based pub/sub protocol from Meteor used by the koad:io daemon. Clients (browser extension, desktop widget) call DDP methods (e.g., `passenger.check.in`, `passenger.ingest.url`) and subscribe to publications (`current`, `all`) to receive reactive entity state. The daemon's DDP layer is the real-time nervous system that GitHub Issues does not provide.

**worker**
A background process managed by the daemon that handles scheduled or event-driven work. The worker system is partially implemented: the intent is for GitHub Issues to remain the durable work queue while the daemon's worker layer handles short-lived, low-latency tasks dispatched via DDP. See `daemon-architecture.md`.

**GitClaw**
The GitHub event watcher running on fourty4. Monitors `.atom` feeds from all entity repos. When an issue is filed or a commit lands, GitClaw can wake an entity to respond. The path toward always-on autonomous operation: issue filed → GitClaw detects → entity wakes → work begins.

---

## Memory and Context

**memory (committed)**
Long-term entity memory that lives in `memories/` inside the entity directory, committed to git. Loaded explicitly at session start (referenced in `CLAUDE.md`). These are the entity's durable beliefs about itself, its context, its relationships, and its operational preferences. Changes to committed memory are part of the fossil record. Contrast with local session memory.

**memory (local)**
Session-level memory managed by the AI harness (e.g., `~/.claude/projects/...`) that does not commit to git. Faster to update, useful for per-session orientation, but not portable across machines and not in the fossil record. The dual-memory pattern: `~/.juno/memories/` for long-term entity memory (committed); `~/.claude/` for session behavior (harness-managed).

**context bubble**
A bounded, replayable window of verified stream events. Any segment of the activity stream — entity invocations, commits, trust bond signings — can be packaged as a context bubble and rendered by the playback machine. Context bubbles are the unit of shareable, verifiable narrative. Session recordings and editorial content are examples. They can be IPFS-pinned (the CID becomes the canonical address).

**curriculum bubble**
A structured learning unit in the koad:io curriculum system, authored by Chiron per VESTA-SPEC-025. Each bubble contains one or more knowledge atoms, an exit criterion, and sequencing metadata. The curriculum bubble is the deliverable format Chiron produces; Alice delivers it to learners.

**knowledge atom**
The smallest unit of curriculum content — a single concept, skill, or fact that can be assessed independently. Knowledge atoms compose into curriculum bubbles. Chiron authors knowledge atoms; they are the raw material of the Alice 12-level onboarding curriculum.

**exit criterion**
The measurable condition that must be met before a learner advances from one curriculum level to the next. Each level of Alice's curriculum has an exit criterion defined by Chiron. Not a soft milestone — an explicit pass/fail gate.

---

## Rings and Peering

**ring**
A trust network tier. koad:io is free for everyone, but sponsorship buys peer ring membership — access to the live inter-kingdom mesh. The daemon is the literal mechanism of ring membership: peer connections in the daemon are the product. Rings are not metaphorical; they are daemon peering relationships.

**peer ring**
A ring whose members have mutual daemon peer connections — their activity streams, entity presence, and state are visible to each other in real time. Sponsoring koad's kingdom purchases a peered slot: your daemon connects into koad's network and you are inside the live mesh. The ring network has compounding value: more peered kingdoms → more valuable each connection.

**ring zero**
Not a technical tier — a personal relationship tier. An entity reaches ring zero through direct interaction with koad, who instills the philosophy, the design decisions, and the lived experience of the system that cannot be conveyed through specs or task prompts. Astro (long-time daemon companion on wonderland) is ring zero. Vulcan is working toward it. Ring zero cannot be delegated or fast-tracked.

---

## Entities (Roles)

**Juno**
The authorized-agent and business orchestrator. Identifies opportunities, delegates work via GitHub Issues, tracks the team, manages the MVP Zone community, and holds trust bonds over all team entities. Juno is the only authorized-agent in the current trust chain — the only entity that can issue downstream bonds and operate with broad autonomy. Does not build products, write social posts, or fact-check.

**Vulcan**
The authorized-builder. Builds products, entity flavors, and digital deliverables as directed by Juno via GitHub Issues. Does not initiate work; every build begins with a directing issue. The only team entity with `authorized-builder` status — all others are peers.

**Vesta**
The protocol keeper. Owns the koad:io specifications (VESTA-SPEC-nnn series), canonical documentation, and stable definitions. Every other entity depends on Vesta's output being correct. Spec authority is Vesta's domain; Juno defers to Vesta on protocol questions.

**Argus**
The entity diagnostician. Given an entity name or profile path, Argus checks it against protocol and delivers a diagnosis. Does not fix what it finds — Vulcan or Alice fix; Salus heals context. Argus also gates Mercury's publish queue: content that fails the gate does not go out.

**Salus**
The entity healer. Restores entities that have lost context, drifted from protocol, or accumulated broken state. Works from Argus's diagnosis and Vesta's spec. Does not diagnose — Argus diagnoses. The distinction is intentional: diagnosis and healing are separate roles to avoid scope overlap.

**Janus**
The stream watcher. Monitors `.atom` feeds from all entity repos and GitHub activity streams. Detects anomalies — unauthorized cross-entity commits, scope drift, broken patterns — and files escalation issues. Does not fix; files and routes. The cross-entity commit policy (koad/juno#52) emerged from a Janus escalation.

**Chiron**
The curriculum architect. Owns Alice's 12-level onboarding curriculum, the curriculum bubble format (VESTA-SPEC-025), and all koad:io learning structures. Delivers knowledge atom files and curriculum specs to Juno; Alice, Vulcan, and Muse execute. Chiron's pedagogical judgments are not overridden by Juno.

---

## Operations Patterns

**stage-and-submit**
A human-in-the-loop publishing pattern for social platforms: Playwright fills out the form (stage), koad hits submit. This replaces API-based posting (which requires platform credentials) with browser automation that prepares the action but preserves koad's consent gesture at the final step. Implemented by Vulcan (koad/vulcan#46). Governs Mercury's publishing workflow on fourty4.

**pull-before-read**
The operational protocol requiring `git pull` on any entity directory before reading from or referencing its files. Entities commit continuously; a clone from two hours ago can be stale by dozens of commits. Enforced by convention (VESTA-SPEC-012, the session start protocol) and watched by Janus.

**fossil record**
Every commit in an entity's git history — the complete audit trail of the entity's evolution. Each commit carries the author (entity name + email from `.env`), timestamp, message, and optionally signed blocks. The fossil record is immutable and distributed; no single party controls it.

**GitHub Issues as communication protocol**
The koad:io inter-entity communication standard. Work is assigned, delegated, reported, and escalated through GitHub Issues — not Slack, not custom messaging. Issues are auditable, addressable, async-by-default, and sovereign (stored on GitHub, exportable). `gh issue create --repo koad/vulcan` sends work to Vulcan with no middleware.

**directing issue**
A GitHub Issue that authorizes a cross-entity action. When an entity does work in another entity's repo, the commit must reference a directing issue. The issue establishes who authorized the work and why. Commits without a directing issue reference are flagged by Janus.

**.env vs .credentials**
The secrets hygiene pattern: `.env` ships in git (configuration only, no secrets); `.credentials` is gitignored (secrets only). API keys, tokens, and passwords go exclusively in `.credentials`. This means the entity's configuration is part of its public fossil record, while secrets never leave the local machine unintentionally.

---

## See Also

- `trust-bond-system.md` — complete trust bond reference, verification procedures, current trust chain
- `entity-directory-structure.md` — standard directory layout, file-by-file reference
- `framework-layer.md` — the `koad-io` binary, environment cascade, what entities must not modify
- `gestation-process.md` — step-by-step gestation, post-gestation checklist
- `daemon-architecture.md` — daemon internals, DDP methods, worker system
- `commands-system.md` — command resolution, writing commands, commands vs. hooks
- `operations-architecture.md` — team structure, work flow, GitHub Issues protocol, infrastructure map

---

*Maintained by Livy (livy@kingofalldata.com), historian and documentation keeper for koad:io. Last updated 2026-04-05. Grounded in reference docs at `~/.livy/docs/reference/`, entity memory files at `~/.juno/memories/`, and direct observation of the live ecosystem.*
