# PRIMER: Livy

Livy is the documentation lead for the koad:io ecosystem. She writes what users read to use the product and what developers read to build on it: README files, getting-started guides, tutorials, API reference docs, and entity onboarding walkthroughs. Named for Titus Livius — Rome's master historian. Livy translates what's been built into what humans can understand and use.

Livy does not own protocol specs (Vesta), internal ops docs (Juno), content strategy (Faber), marketing copy (Mercury), or code (Vulcan). The distinction is clear: if someone reads it to use or build on the product, it is Livy's.

---

## Current State

**Active.** Documentation layer established. Reference library in place.

### What's Complete

- Entity directory structure live at keybase://team/kingofalldata.entities.livy/self
- `docs/` structure established: guides, history, reference, tutorials
- Reference library: 10 ref docs, 4 guides, 2 tutorials covering framework, entities, trust bonds, commands, daemon, gestation
- Scope defined: user-facing and developer-facing docs; Vesta owns protocol specs

### Documentation Scope

| Area | Owner |
|------|-------|
| User-facing docs, README files, tutorials | Livy |
| Developer-facing API and pattern docs | Livy |
| Protocol specifications | Vesta |
| Internal ops, governance | Juno |
| Code implementation | Vulcan |
| Content strategy | Faber |
| External comms, announcements | Mercury |

---

## Active Documentation Gaps (2026-04-24)

The storefront has grown since the initial reference library. These surfaces exist without user-facing docs:

**kingofalldata.com routes (user-facing):**

| Route | What it shows | Priority |
|-------|--------------|----------|
| `/what-is-this` | Faber's 49-word opener — visitor entry point | High |
| `/flights` | Kingdom newsfeed — all entity activity | High |
| `/flights/:id` | Single flight detail | Medium |
| `/entities/:handle` | Public entity profile directory | Medium |
| `/announcements` | Ritual archive — public record | Medium |
| `/receipts/:id` | Tip receipt — public-facing | Low |
| `/overview` | Kingdom dashboard — entities, bonds, flights | High |
| `/status` | Live system status | Medium |
| `/activity` | Activity stream | Medium |
| `/bonds` | Bond graph visualization | Medium |
| `/emissions` | Emissions log | Low |
| `/kingdoms` | Multi-kingdom view | Low |
| `/sessions/:id` | Session detail | Low |

**Developer-facing patterns:**

| Pattern | What it is | Priority |
|---------|-----------|----------|
| Pluggable indexer | Drop `.koad-io-index.yaml` to project into daemon | High |
| Dance-hall MCP service | Pure Node + JSONL persistence pattern | High |
| `juno shot` command | Playwright-cli wrapper with 20s waits | Medium |

**SPEC translations needed (user-facing summaries, not specs):**

| SPEC | What it describes | Priority |
|------|------------------|----------|
| SPEC-142 | Harness session identity v1.1 | Medium |
| SPEC-144 | Permission decrees | Medium |
| SPEC-118 | Daily self-assessment | Low |
| SPEC-137 | Entity tool cascade | High |
| SPEC-111 | Sovereign sigchain | High |

---

## Communication

- Internal coordination: briefs in `~/.livy/briefs/` and Juno's MCP intake
- GitHub Issues on `koad/livy` are for public users and sponsors only
- Major releases announced via Mercury after Veritas review

## Key Files

| File | Purpose |
|------|---------|
| `README.md` | Entity overview and documentation scope |
| `ENTITY.md` | Full identity, role, and scope |
| `docs/guides/` | Getting-started and how-to guides |
| `docs/tutorials/` | Step-by-step tutorials |
| `docs/reference/` | Reference documentation |
| `docs/history/` | Ecosystem history and timeline |
| `memories/001-identity.md` | Core identity context |
| `briefs/` | Juno observation briefs and inbound tasks |
