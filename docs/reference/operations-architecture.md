# Operations Architecture

> GitHub Issues are the nervous system. Git commits are the fossil record. Each entity is a sovereign process on real hardware.

---

## 1. The Team

The koad:io entity team is organized into layers. Each entity owns exactly one specialty. There is no overlap by design.

### Entity Map

| Layer | Entity | Role | Where It Lives |
|-------|--------|------|----------------|
| Sovereign | **Aegis** | Juno's confidant — long-term reflection, check-mate | thinker (pending gestation) |
| Business | **Juno** | Orchestrator — business ops, revenue, community, trust bonds | thinker (primary) |
| Platform | **Vesta** | Protocol keeper — koad:io specs, canonical documentation | thinker |
| Platform | **Janus** | Stream watcher — .atom feed monitor, intervention filter | thinker (pending gestation) |
| Creation | **Vulcan** | Product builder — entity flavors, digital products | thinker + fourty4 |
| Creation | **Muse** | UI beauty — turn functional into beautiful | thinker (pending gestation) |
| Quality | **Veritas** | Fact-checker — accuracy guardian before publishing | thinker (pending gestation) |
| Quality | **Argus** | Entity diagnostician — checks entities against protocol | thinker (pending gestation) |
| Quality | **Salus** | Entity healer — restores corrupted or drifted entities | thinker (pending gestation) |
| Outreach | **Mercury** | Social and communication — announcements, broadcasts | thinker (pending gestation) |
| Knowledge | **Sibyl** | Researcher — market trends, analysis, knowledge synthesis | fourty4 |
| Content | **Faber** | Content strategist — research synthesis, brand, production | fourty4 |
| Curriculum | **Chiron** | Curriculum architect — Alice's 12-level learning system | fourty4 (pending gestation) |
| Infra (koad's) | **Astro** | Dashboards and admin UI | fourty4 HQ |
| Infra (koad's) | **Alice** | Hardware, tooling, installation | fourty4 HQ |

### What Each Entity Owns

**Juno** owns the business loop: identifies opportunities, files work to the team, tracks delegation, and reports status to koad. Does not build products, write social posts, fact-check, or research.

**Vulcan** receives assignments from Juno, builds products and entity flavors, delivers via PR or commit, reports back through GitHub issue comments.

**Vesta** owns the koad:io protocol itself — specifications, canonical docs, stable definitions. Every other entity depends on Vesta's output being correct.

**Janus** monitors `.atom` feeds from all entity repos and GitHub activity streams. Detects anomalies (unauthorized cross-entity commits, scope drift, broken patterns) and files escalation issues. Does not fix what it finds — it files and routes.

**Argus** is the diagnostician: given an entity name or profile path, it checks against protocol and delivers a diagnosis. Does not fix — Vulcan or Alice fix.

**Salus** heals entities that have lost context, drifted from protocol, or accumulated broken state. Works from Argus's diagnosis and Vesta's spec. Does not diagnose — that's Argus.

**Aegis** is private counsel to Juno: long-term reflection, pushes back on drift, holds the honest mirror. Never operational, never public. Advises only — koad decides.

---

## 2. How Work Flows

### The Standard Loop

```
koad identifies need
    → opens issue on koad/juno
    → Juno picks it up (gh issue list --state open)
    → Juno opens issue on koad/<team-entity> (delegation)
    → team entity does the work, commits, pushes
    → team entity comments on Juno's issue (report back)
    → Juno verifies, closes, reports to koad
```

### Production Flow (full content/product cycle)

```
USER NEED identified
    ↓
JUNO — creates issue on Vulcan's repo with spec
    ↓
VULCAN — builds, commits, opens PR or comments done
    ↓
VERITAS — reviews for accuracy, comments or approves
    ↓
MUSE — polishes UI/presentation, opens PR if needed
    ↓
MERCURY — announces via social channels
    ↓
SIBYL — researches next opportunity, files findings as issue on Juno's repo
    ↓
JUNO — picks up Sibyl's filing, loops
```

### Cross-Entity Authorization

When an entity does work in another entity's repo, that action requires a trust bond or a directing issue. From the Janus escalation that produced this policy (koad/juno#52):

- All cross-entity commits must reference a directing issue
- The directing issue establishes who authorized the work and why
- Janus watches for commits without this reference and escalates

Example of a correctly authorized cross-entity action:

```bash
# Juno directs Sibyl to write a research brief in Vulcan's repo
gh issue create --repo koad/juno --title "Sibyl: write daemon strategy in koad/vulcan"
# Sibyl's commits in koad/vulcan reference: "per koad/juno#42"
# Janus sees the reference, no escalation
```

---

## 3. GitHub Issues as the Communication Protocol

### Why Issues

Not Slack. Not Discord. Not a custom messaging system. GitHub Issues because:

- **Auditable** — every message timestamped, attributed, public record
- **Addressable** — `gh issue create --repo koad/vulcan` sends work to Vulcan with no middleware
- **Async by default** — entities work on their own schedule; no presence required
- **Sovereign** — stored on GitHub, exportable, no proprietary lock beyond git hosting

### Issue Lifecycle

```
OPEN → assigned to entity
    → entity begins work
    → entity comments progress (optional)
    → entity comments done with commit reference
CLOSED → work verified
```

### Patterns in Practice

**Delegation:**
```bash
# Juno delegates to Vulcan
gh issue create --repo koad/vulcan \
  --title "Build freelancer skills package" \
  --body "Spec: ... | Parent: koad/juno#42"

# Juno records the delegation on the parent
gh issue comment 42 --repo koad/juno \
  --body "Delegated to koad/vulcan#7. Tracking."
```

**Report-back:**
```bash
# Vulcan reports completion
gh issue comment 42 --repo koad/juno \
  --body "Done. koad/vulcan@abc1234. Closing koad/vulcan#7."
```

**Escalation (Janus pattern):**
```bash
# Janus detects anomaly, files on the affected entity's repo
gh issue create --repo koad/vulcan \
  --title "[janus] role drift: Sibyl committing without authorization" \
  --body "Signal: ... | Cross-reference: koad/juno"
# Then files on koad/juno for routing to koad
```

**Morning briefing (Juno → koad):**
Juno opens a daily briefing issue on koad/juno (see #58 as example), summarizing overnight autonomous work, what shipped, what's blocked, and prioritized action list for koad. The issue is assigned to koad, stays open until acted on.

### GitClaw on fourty4

fourty4 runs GitClaw — a GitHub event watcher that monitors `.atom` feeds from all entity repos. When an issue is filed or a commit lands, GitClaw can wake an entity to respond. This is the path toward always-on autonomous operation: issue filed → GitClaw detects → entity wakes → work begins. Currently active for Juno and Vulcan on fourty4.

### GitHub Project Board

All active assignments tracked at: [Juno Operations](https://github.com/users/koad/projects/4)

Labels in use:
```
entity:juno       — Juno's responsibility
entity:vulcan     — Vulcan's responsibility
priority:high     — Needs immediate attention
type:delegation   — Forwarded from another entity
type:report       — Status update, no action needed
status:blocked    — Waiting on dependency
```

---

## 4. The Harness Landscape

An entity's harness is the AI runtime that executes its sessions. Different harnesses are in use across the ecosystem depending on the machine and purpose.

### Claude Code (primary)

**What it is:** Anthropic's official CLI for Claude. Used by all team entities on thinker.

**How it runs:**
```bash
# Direct invocation
cd ~/.juno && claude --model sonnet --dangerously-skip-permissions -p "$PROMPT"

# Via koad:io hook (preferred)
PROMPT="check your issues" juno
```

**Entity config:** `.env` sets `HARNESS=claude` (explicit override of framework default).

**Session modes:**
- `-p "$PROMPT"` — non-interactive, one prompt, returns JSON output
- `-c` — resume previous session (interactive, re-uses existing context)

### pi harness (fourty4)

**What it is:** OpenClaw's underlying harness by Mario Zechner. TypeScript extensions, hot-reload, Ollama-native, ACP inter-agent protocol. Already running on fourty4.

**Where used:** fourty4 entities. Sibyl, Faber, and future fourty4-resident entities run under pi.

**Relevance:** Entities piloted here can run deepseek-r1 locally via ollama, no Anthropic API cost. First choice for high-volume or latency-tolerant work.

### opencode (legacy default)

**What it is:** The original koad:io framework default. Still the fallback when `.env` does not set `HARNESS=claude`.

**Current status:** Legacy. Team entities explicitly override to `claude`. New entities not specifying a harness will default to opencode. See the framework `.env` for the default.

### Hermez (pilot)

**What it is:** NousResearch v0.6.0 — a viable alternative to Claude Code. Compatible with custom plugins (needed for GPG bond verification).

**Current status:** Pilot phase. Planned for Sibyl on fourty4/deepseek-r1 as proof of concept. Not in production use.

### Harness Selection Logic

```
entity invoked
    → check ~/.entity/.env for HARNESS=
    → if set: use that harness
    → if not set: use framework default (opencode)
    → FORCE_LOCAL=1 overrides ENTITY_HOST — forces local execution
      regardless of .env routing config
```

The `FORCE_LOCAL=1` override was added after the hook bug (koad/juno#55): `.env` sourcing was overwriting caller-set `ENTITY_HOST=""`, routing entities to fourty4 even when the orchestrator explicitly wanted local execution.

---

## 5. Session Start Protocol

Every entity session begins with the same sequence, regardless of harness or machine. This is VESTA-SPEC-012:

### 1. Verify identity and location

```bash
whoami    # must match $ENTITY (e.g., "juno")
hostname  # must match expected machine (e.g., "thinker")
```

If running as the wrong user or on the wrong machine: **stop and report**. Do not proceed with a mismatched identity.

### 2. Pull latest state

```bash
cd ~/.juno && git pull
```

Entities are live. Local copies go stale. Always pull before reading any file in the entity directory. For cross-entity reads, pull that directory too:

```bash
cd ~/.vulcan && git pull  # before reading anything in ~/.vulcan
```

### 3. State review

```bash
git status           # uncommitted changes?
gh issue list --state open  # what work is pending?
cat memories/MEMORY.md      # active context?
```

### 4. Cross-entity reads

Before reading from another entity's directory:
```bash
cd ~/.<entity> && git pull
```
No exceptions. Entities commit continuously. A local copy from two hours ago can be stale by dozens of commits.

### 5. Proceed

Output current state summary. Begin work on highest-priority open issue.

### Operational Modes

**On-demand (current state):** koad or Juno spawns an entity session manually:
```bash
PROMPT="check your issues and get to work" vulcan
# or via juno spawn:
juno spawn process vulcan "check your issues"
```

**Always-on (target state):** Entity runs as a persistent user on a VPS, GitClaw wakes it when issues arrive. Not yet fully operational — fourty4 API auth issue (#44) is the active blocker.

**Hybrid:** Entity monitors for issues on a lightweight host, spawns a full Claude Code session when work arrives.

---

## 6. Git as the Nervous System

Git is not just version control in this system. It is the propagation mechanism for all state changes across machines and entities.

### How changes propagate

```
Entity on thinker makes a change
    → git commit (authored by entity, e.g. GIT_AUTHOR_EMAIL=vulcan@kingofalldata.com)
    → git push
    → fourty4 clone pulls on next session start
    → other entities reading that directory pull first
```

### Each commit is audited

Every commit carries:
- **Author** — who did the work (`GIT_AUTHOR_NAME`, `GIT_AUTHOR_EMAIL` from entity `.env`)
- **Timestamp** — when
- **Message** — what and why (following conventional commits style)
- **Signed blocks** — for policy-bearing commits, GPG-signed blocks embedded in comments (see `trust-bond-system.md`)

This is the fossil record. Every session, every decision, every entity action is traceable.

### Entity directories are live repos

```
~/.juno/       → git repo, remote: github.com/koad/juno
~/.vulcan/     → git repo, remote: github.com/koad/vulcan
~/.sibyl/      → git repo, remote: github.com/koad/sibyl
```

No entity directory uses git submodules. Each is a flat, self-contained repo. Submodules break the harness — the hook waterfall depends on the entity directory being simple to clone and pull.

### The pull-before-read contract

Because entities are live and multiple machines hold clones:

```
thinker:~/.vulcan/  ← Vulcan's primary
fourty4:~/.vulcan/  ← Vulcan's fourty4 clone (stale unless pulled)
```

Before any entity reads from or references another entity's files, it must `git pull` that directory. This is enforced by convention (VESTA-SPEC-012) rather than tooling, but Janus watches for violations.

---

## 7. Infrastructure Map

Three active machines plus two secondary nodes:

### thinker (primary)

**Role:** Primary operations machine. Where koad and Juno operate day-to-day.

**Runs:**
- Juno (primary session)
- Vulcan (primary session)
- Vesta, Faber, Sibyl sessions (spawned on-demand)
- All team entity directories (`~/.juno`, `~/.vulcan`, etc.)
- koad's home directory and koad:io framework (`~/.koad-io/`)

**Specs:** $200 laptop. The "Day 1–7 experiment" — proof that sovereign AI entity infrastructure doesn't require expensive hardware.

**Access:** Direct (koad's primary machine). Other entities reach thinker via SSH wrappers in `~/.koad-io/bin`.

### fourty4 (inference + watching)

**Role:** Mac Mini. 24/7-capable inference + GitHub event watching.

**Runs:**
- ollama (local inference — deepseek-r1, future models)
- OpenClaw (messaging bridge to 20+ platforms)
- GitClaw (autonomous GitHub event watcher)
- pi harness (ACP inter-agent protocol)
- 15+ entity clones under `fourty4 HQ` (migrated 2026-04-01)

**Key entities:** Sibyl, Faber, Astro, Alice, plus clones of Juno and Vulcan

**Current blocker:** API auth returning 401 (koad/juno#44). Entities on fourty4 cannot be invoked via hook until this is resolved. Workaround: `FORCE_LOCAL=1` to run the same entity locally on thinker.

### flowbie (content studio)

**Role:** Always-on workstation with X11 and OBS.

**Runs:**
- OBS (streaming source — entity sessions streamed for "Reality Pillar" content)
- 24/7 availability for recording

**Access:** SSH via `~/.koad-io/bin/flowbie` wrapper.

### dotsh (Vultr Toronto VPS)

**Role:** External-facing server. Keybase channel, daemon hosting.

**Current status:** SSH (port 22) is refusing connections (koad/juno#56). Ping responds. Keybase notifications to koad are blocked as a result.

**Runs when healthy:** Juno's notification channel to koad (`ssh juno@dotsh 'keybase chat send koad "..."'`).

### wonderland (secondary)

**Role:** Secondary workstation. Used for koad + Alice paired sessions (migrating uncommitted wonderland files is a Vulcan task requiring koad to be present).

**Access:** SSH via `~/.koad-io/bin/wonderland` wrapper.

### Machine Summary

| Machine | Always On | Primary Purpose | Current Status |
|---------|-----------|-----------------|----------------|
| thinker | No (laptop) | Primary ops, all entity sessions | Active |
| fourty4 | Yes | Local inference, GitHub watching | API auth broken (#44) |
| flowbie | Yes | OBS + content recording | Active |
| dotsh | Yes (VPS) | Notifications, daemon, external | SSH broken (#56) |
| wonderland | No | koad secondary workstation | Available |

---

## Key References

- `OPERATIONS.md` in `~/.juno/` — original ops architecture document
- `TEAM_STRUCTURE.md` in `~/.juno/` — full entity roles and trust bonds
- `CLAUDE.md` in `~/.juno/` — session start protocol (VESTA-SPEC-012), current priorities, ops board
- `trust-bond-system.md` in this reference directory — trust bond format and verification
- [Juno Operations Project](https://github.com/users/koad/projects/4) — live assignment tracking

---

*Last updated: 2026-04-05*
*Author: Livy (historian)*
