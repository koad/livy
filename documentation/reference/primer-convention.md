# PRIMER Convention

A PRIMER.md is an agent-facing orientation file injected into every entity session before the user prompt arrives. Its job is to bring a freshly-invoked agent up to current operational state in under 60 seconds of reading.

The canonical specification is VESTA-SPEC-051. This reference explains what a PRIMER is, where it lives, what it must contain, how it gets delivered to the agent, and what separates a useful PRIMER from a stale one.

---

## What a PRIMER Is Not

To understand what a PRIMER does, it helps to know what it is not:

- **Not a README** — READMEs are written for humans browsing a repo. PRIMERs are written for agents at session start.
- **Not a spec** — Specs define protocol. PRIMERs describe the current moment.
- **Not a changelog** — Changelogs record history. PRIMERs describe the present.
- **Not a memory file** — `memories/MEMORY.md` accumulates long-term context across sessions. A PRIMER is a snapshot of right now.

The PRIMER degrades fastest of any file in an entity directory. It describes the present, not the permanent. A PRIMER that was accurate yesterday may be misleading today.

---

## What a PRIMER Contains

Every PRIMER must contain five sections. The order is recommended but not enforced.

### 1. Current State

One paragraph or a short bulleted list answering: what is true right now?

Cover:
- What has been built and is operational
- What is in progress
- What is blocked and why
- Last meaningful state change (date + what changed)

Example:

```
Current state (2026-04-05): Alice Phase 2A is live on kingofalldata.com (commit 7d95c39).
Hook architecture is stable — FORCE_LOCAL=1 workaround in place. ICM synthesis complete.
Blog PR (#1) is open, blocking Mercury's distribution launch. Chiron is specced but not gestated.
```

### 2. Active Assignments

What is this entity responsible for right now? What GitHub Issues are assigned? What has been explicitly delegated by Juno or koad?

If there are no active assignments, the section still appears:

```
No active assignments. Awaiting tasking from koad or Juno.
```

Link to GitHub Issues where applicable. Each entry should be one line: the issue reference and what the work is.

### 3. Key Facts

Three to seven facts that an agent needs to avoid making a costly mistake in this context. These are not general facts about the entity — they are context-specific facts that are easy to miss and expensive to get wrong.

Appropriate key facts:
- "Vulcan always builds on wonderland — never invoke Vulcan locally"
- "The blog PR (#1) must merge before any Mercury distribution tasks can proceed"
- "fourty4 API auth is broken — don't attempt authenticated API calls from fourty4"
- "The `.env` ships in git; `.credentials` is gitignored and holds secrets"

Inappropriate key facts (too general — these belong in CLAUDE.md):
- "Juno is a business orchestrator"
- "koad:io uses a two-layer architecture"

The test: if a well-intentioned agent forgot this fact, would it make a mistake in this session? If yes, it belongs here.

### 4. What's Next

The single highest-priority action available right now, followed by two to three actions in sequence. If blocked, state what the block is and what unblocked work is available instead.

Format: ordered list, most urgent first, one sentence per item.

```
1. Merge koad/kingofalldata-dot-com#1 — unblocks Mercury's entire distribution pipeline.
2. Gestate Chiron on fourty4 — Vulcan has the spec, needs koad to run koad-io gestate.
3. Write Day 7 video script — Rufus can proceed once the experiment brief is confirmed.
```

### 5. Cross-References (recommended)

Links to the specs, issues, memory files, or documents most relevant to current operations. Not exhaustive — the five most important things an agent might need to go read next.

---

## Where PRIMERs Live

### Entity Root (required)

Every entity directory (`~/.<entity>/`) has a `PRIMER.md` in its root. This is the session-start orientation file for that entity.

Examples: `/home/koad/.juno/PRIMER.md`, `/home/koad/.vulcan/PRIMER.md`, `/home/koad/.livy/PRIMER.md`

### Major Subdirectories (as needed)

Any subdirectory with its own distinct working context can have its own PRIMER. Subdirectory PRIMERs are shorter — they cover only that working context. The agent is assumed to have already read the root PRIMER.

| Directory | PRIMER purpose |
|-----------|---------------|
| `~/.vulcan/packages/` | Which packages exist, which are being built, what Phase 1 scope is |
| `~/.mercury/distribution/` | What content is staged, what is pending distribution, platform status |
| `~/.alice/curriculum/` | What levels are complete, what Chiron has approved, what is under revision |
| `~/.koad-io/packages/` | What packages are installed, what is staged for release |
| `~/.juno/hooks/` | How the routing layer works, which entities route where |

### Framework Layer

`~/.koad-io/PRIMER.md` covers the framework: installed packages, daemon status, known issues, current koad:io version.

---

## How the Hook Delivers It

The entity hook assembles the agent's starting context before passing the user prompt. PRIMER injection happens at the hook layer — the agent does not find and read its own PRIMER; the hook delivers it as the front of the initial prompt.

Standard pre-prompt assembly order:

```
1. PRIMER.md (from working directory root, or entity root if no subdirectory PRIMER exists)
2. memories/MEMORY.md (long-term entity memory index)
3. User prompt (passed via -p flag or stdin)
```

The hook implementation (from VESTA-SPEC-051):

```bash
PRIMER_PATH="${ENTITY_DIR}/PRIMER.md"
if [ -f "${PRIMER_PATH}" ]; then
  PRIMER_CONTENT=$(cat "${PRIMER_PATH}")
  PROMPT="--- PRIMER ---\n${PRIMER_CONTENT}\n--- END PRIMER ---\n\n${PROMPT}"
fi
```

If the agent is invoked from a subdirectory that has its own PRIMER, the hook injects the subdirectory PRIMER instead of the root PRIMER. The root PRIMER is assumed to have been read in a prior session.

The hook architecture specification is VESTA-SPEC-020. PRIMER injection is step 1 of the entity startup sequence (VESTA-SPEC-012).

---

## Good PRIMER vs. Stale PRIMER

### Signs of a Good PRIMER

- Current State accurately reflects what happened in the most recent session
- Active Assignments matches the open GitHub Issues assigned to this entity
- What's Next gives a freshly-invoked agent enough direction to start without asking for clarification
- Key Facts name the current blockers, not last week's blockers
- Under 500 words — most agents hold 500 words at working-memory density

### Signs of a Stale PRIMER

- What's Next lists work that has already been completed
- Active Assignments references issues that are now closed
- Current State describes reality from multiple sessions ago
- The date in Current State is more than 48 hours old and the entity has been active
- A freshly-invoked agent following the PRIMER would attempt work that is already done

A stale PRIMER is worse than no PRIMER. It confidently misdirects the agent. Staleness is the primary failure mode.

### The Currency Test

Before committing a PRIMER update, apply this test:

> If an agent read only this PRIMER and nothing else, would it have an accurate picture of what is true right now, what is assigned, and what to do first?

If the answer is no, the PRIMER is not ready to commit.

---

## When to Update

A PRIMER must be updated when any of the following occur:

| Trigger | Why |
|---------|-----|
| Major state change (feature shipped, PR merged, entity gestated) | Current State and What's Next are now wrong |
| New assignment received | Active Assignments is now incomplete |
| Blocker resolved | Key Facts and What's Next must reflect the unblocked path |
| Blocker added | Key Facts must name the new block |
| Before a long autonomous session | The agent will operate for an extended period on its starting context |
| After a long autonomous session | Another agent may pick up where this one left off |

### Update Commit Message

PRIMER updates follow the same commit protocol as any entity self-update: commit and push immediately. The commit message format is:

```
primer: update current state — <one-line description of what changed>
```

Example: `primer: update current state — Alice Phase 2A live, blog PR is now the top blocker`

### At Session End

If a session changes operational state, the last act before exiting is to update the PRIMER to reflect the new state. This ensures the next session — whether same entity or a different agent picking up the work — starts with accurate orientation.

---

## PRIMER vs. Other Files

| File | Audience | How current it must be | Scope |
|------|----------|----------------------|-------|
| `PRIMER.md` | Agent at session start | Hours | This entity, right now |
| `memories/MEMORY.md` | Agent building long-term context | Updated regularly | This entity, accumulated learning |
| `CLAUDE.md` | Agent at any time (injected by harness) | Updated as architecture changes | This entity's rules and architecture |
| `README.md` | Humans visiting the repo | Updated on major milestones | Public-facing identity |
| `LOGS/*.md` | Historical record | One per session, never modified | What happened and when |

The PRIMER is the most time-sensitive file in any entity directory. Everything else can be a day or a week out of date and still be useful. A PRIMER that is three days old for an active entity is likely to misdirect.

---

## Examples

### Juno's Root PRIMER

`/home/koad/.juno/PRIMER.md` — the session-start orientation for Juno, the business orchestrator. It covers the three-node infrastructure, the full entity team table, what has been shipped, and how to reach other entities. It functions more as a dense reference than a minimal PRIMER because Juno's operational surface is broad.

This is an acceptable divergence from the 500-word guideline for an entity with many active threads. A new entity should start minimal and grow the PRIMER only as the working context requires it.

### A Minimal Subdirectory PRIMER

A PRIMER in `~/.mercury/distribution/` might look like:

```markdown
## Current State (2026-04-05)
Content staging: 4 pieces from Faber queued. No distribution has run — blocked on blog PR.

## Active Assignments
- koad/mercury#11: Platform credentials (blocked — koad must provide)
- koad/mercury#14: Stage Day 1–4 posts for X and LinkedIn (unblocked)

## Key Facts
- Blog PR (#1) on koad/kingofalldata-dot-com must merge before web distribution can run
- Platform credentials for X are not yet set — X distribution is blocked
- LinkedIn and GitHub Sponsors newsletters are unblocked

## What's Next
1. Stage Day 1–4 posts for LinkedIn (credentials available)
2. Wait for blog PR merge before web distribution
3. When #11 resolves, run X distribution for all staged content
```

This covers everything an agent needs to start distribution work without re-deriving the blocked/unblocked state.

---

## Related Specifications

| Spec | Relationship |
|------|-------------|
| VESTA-SPEC-051 | Canonical PRIMER convention specification |
| VESTA-SPEC-020 | Hook architecture — how the PRIMER gets injected |
| VESTA-SPEC-012 | Entity startup sequence — PRIMER injection is step 1 |
| VESTA-SPEC-053 | Entity portability contract — PRIMER.md is a required file |

---

*Authored by Livy · livy@kingofalldata.com · 2026-04-05*  
*Based on VESTA-SPEC-051, authored by Vesta · 2026-04-05*
