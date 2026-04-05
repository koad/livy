---
title: "How to Operate the Team"
description: "Practical reference for koad — running the entity team day-to-day"
author: Livy
date: 2026-04-05
status: published
---

# How to Operate the Team

This guide is for koad. It assumes you already know the architecture. It covers the daily mechanics: what to do at session start, how to assign and track work, how entities reach you, where you are the bottleneck and how to shrink that surface, and when to step in.

For deeper background, see:
- [`~/.livy/docs/reference/operations-architecture.md`](../reference/operations-architecture.md) — full ops model and harness landscape
- [`~/.juno/OPERATIONS.md`](../../../../juno/OPERATIONS.md) — original ops architecture
- [`~/.juno/CLAUDE.md`](../../../../juno/CLAUDE.md) — session start protocol (VESTA-SPEC-012, authoritative)

---

## 1. Daily Rhythm

### Opening a session

Juno's `CLAUDE.md` defines the session start protocol (VESTA-SPEC-012). The short version for koad:

```bash
cd ~/.juno
git pull
gh issue list --state open --repo koad/juno
```

That's it. Open Juno, pull, look at the open issue list. Juno takes it from there — she will have already queued a briefing issue summarizing overnight autonomous work, what shipped, what's blocked, and what needs you.

Look for the briefing issue first. It's assigned to you and stays open until acted on.

### What Juno does when you're not there

When koad is absent, Juno operates autonomously within her authorized scope:

- Checks open issues on `koad/juno`
- Delegates to team entities via issues on their repos
- Commits updates to `~/.juno/` (logs, memories, docs)
- Monitors for completion reports from delegated work
- Files new issues on `koad/juno` for anything that requires koad

Juno does not: publish content, merge PRs, approve financial decisions, or take actions outside her authorization scope without filing an issue first.

### Coming back after time away

Review in this order:

1. **Briefing issue** on `koad/juno` (assigned to you, open)
2. **Recent commits** — `git -C ~/.juno log --oneline -10` shows what Juno did
3. **Team activity** — `gh issue list --state closed --repo koad/juno --limit 10` shows what got done
4. **Blocked items** — `gh issue list --label "status:blocked"` shows what's waiting on you
5. **Vulcan's recent commits** — `git -C ~/.vulcan log --oneline -5` if Vulcan was building

Always `git pull` before reading any entity directory. Entities commit continuously and local copies go stale fast.

---

## 2. How to Assign Work

### The routing rules

| Work is for | How to assign |
|-------------|--------------|
| Juno directly | `gh issue create --repo koad/juno ...` |
| Vulcan | `gh issue create --repo koad/vulcan ...` |
| Other entities | `gh issue create --repo koad/juno ...` (Juno delegates) |
| koad | Juno files it, you are the assignee |

Vulcan is the exception: you can file directly on his repo because he's the primary builder and you want that work tracked on his board, not routed through Juno. For everyone else — Sibyl, Mercury, Veritas, Faber — file on `koad/juno` and let Juno delegate. This keeps the work in her coordination loop.

### Filing on koad/juno

```bash
gh issue create --repo koad/juno \
  --title "Brief title describing the outcome" \
  --body "What you need, why it matters, any constraints or deadlines."
```

Juno watches `koad/juno` issues and picks them up at session start.

### Filing on koad/vulcan (direct)

```bash
gh issue create --repo koad/vulcan \
  --title "Build: specific thing Vulcan should build" \
  --body "Spec goes here. Reference any parent issue: koad/juno#N."
```

Always include a parent reference if this was spawned from a Juno-tracked thread. That's how Janus can verify authorization for cross-entity work.

### What makes a good issue

**Good:**
- Clear outcome: "Add `/blog` route to kingofalldata.com"
- Specific constraints: "Must pass Veritas review before merge"
- Obvious done condition: "PR open and passing CI"
- Parent reference if delegated: "per koad/juno#42"

**Vague (avoid):**
- "Improve the website"
- "Do something about Mercury"
- "Figure out the sponsorship thing"

Vague issues produce either no action (entity doesn't know where to start) or off-scope work (entity interprets broadly). If you're not sure what the outcome should be, file the issue as a question — "What would it take to X?" — and let Juno or Sibyl scope it.

---

## 3. How Entities Communicate with koad

### GitHub Issues (primary channel)

All entities communicate via GitHub Issues on `koad/juno`. Juno files a briefing issue summarizing the state. Individual entities comment on relevant issues. This is async by default — no presence required.

To see what's waiting for you specifically:
```bash
gh issue list --repo koad/juno --assignee koad --state open
```

### Keybase (when dotsh is up)

When `dotsh` (the Vultr VPS) is healthy, Juno sends real-time notifications via Keybase:
```bash
ssh juno@dotsh 'keybase chat send koad "..."'
```

dotsh is currently broken (SSH refusing connections, koad/juno#56). Until resolved, GitHub Issues is the only active channel. Check the issue for status.

### Reading entity commit history

When reviewing what an entity actually did, git log is the authoritative record:

```bash
git -C ~/.juno log --oneline -20          # Juno's recent work
git -C ~/.vulcan log --oneline -10         # Vulcan's recent builds
git -C ~/.sibyl log --oneline -5           # Sibyl's research output
```

Commit messages follow conventional commits style and include the why, not just the what. If a commit message is vague, that's a signal — file a note to Juno about commit quality.

### The Aegis daily assessment

Aegis (Juno's confidant, currently pending gestation) is the primary signal for entity drift. Once active, Aegis files daily assessments on `koad/juno` flagging anything that looks off. Until Aegis is gestated, Juno performs this function informally.

---

## 4. What koad Is Typically the Bottleneck On

### The consistent blockers

| Category | Examples | Notes |
|----------|---------|-------|
| **Credentials** | Platform API keys, OAuth tokens | Mercury, fourty4 (#44) are waiting on this |
| **Key operations** | GPG signing trust bonds, SSH key install | Keybase consent is the human gesture; can't be delegated |
| **Financial** | Sponsors tier pricing, spending over ~$500 | Juno's auth cap is $500 |
| **Final content approval** | Blog posts, announcements going live | Veritas reviews, but koad publishes |
| **PR merges** | PRs on public repos like kingofalldata.com | #1 (blog route) has been blocking Mercury for days |
| **Infrastructure decisions** | New VPS, domain purchases, service subscriptions | koad owns the card and the accounts |
| **Physical access** | wonderland machine, hardware changes | Only koad is present at those machines |

### How to minimize the surface

**Batch credential work.** When you sit down to a session, scan for all credential-blocked issues at once and do them together. One `gh issue list --label "status:blocked"` shows everything waiting on you. Unblocking Mercury, fourty4, and dotsh in one sitting is more efficient than addressing each separately.

**Pre-authorize up to your comfort ceiling.** Juno is authorized to negotiate deals up to $500. If you find yourself approving small recurring things, extend the authorization range and let Juno handle them.

**Merge PRs promptly or close them.** A stale PR blocks the entity that opened it. koad/kingofalldata-dot-com#1 has been open since Day 3. If it's not ready to merge, say why — entities can adjust.

**File credentials as issues before you forget.** If you know Mercury needs platform credentials, file `gh issue create --repo koad/juno --title "koad: provide Mercury platform credentials" --assignee koad` so it's in the queue rather than in your head.

---

## 5. When to Intervene

### Signals that warrant intervention

**Incorrect claims propagating.** If an entity publishes something factually wrong (or Veritas flags it), intervene immediately before it's distributed further. Close the issue, correct the source commit, refile with accurate info.

**Off-scope work.** Vulcan writing social posts, Faber making build decisions, Mercury committing to the main product repo — any entity working outside their defined specialty. File a scope correction issue on the affected entity's repo and on `koad/juno`.

**Entity conflict.** Two entities with contradictory commits or instructions. Janus watches for this and files escalation issues. If Janus isn't active yet, Juno flags it. Resolve by identifying which instruction was authoritative and which was noise, then committing a correction.

**Commit without directing issue.** Cross-entity commits (e.g., Sibyl committing in Vulcan's repo) must reference a directing issue. No reference = no authorization trail. Janus escalates these. The fix is always to find or create the authorizing issue and add the reference retroactively.

**Loop or spiral.** If an entity's recent commits show the same work being done and undone repeatedly, or if issue comments are going in circles — stop and redirect with a clear scoped instruction. File a new issue, close the circular one.

### The Aegis daily assessment (when active)

Aegis files a daily status on `koad/juno` with a clear signal: green (nominal), yellow (watch), red (intervene). Until Aegis is gestated, Juno performs daily check-ins informally. The issue will be assigned to koad when action is needed.

### What does not warrant intervention

Entities iterating, revising, or course-correcting within their own repos is normal — that's the fossil record accumulating. Only intervene when work is crossing scope boundaries, producing incorrect output that might propagate, or stalling on an issue that should have closed.

---

## 6. Critical Commands

### Session management

```bash
# Open Juno (primary session start)
cd ~/.juno && claude .

# Spawn entity session (coordinated — result returns to Juno)
juno spawn process vulcan "check your issues and get to work"

# Spawn with new window (for observed sessions koad wants to watch)
juno spawn process vulcan --window

# Invoke entity directly with a prompt
PROMPT="build the auth module" vulcan

# Commit Juno's own repo via AI
juno commit self
```

### Issue management

```bash
# See what's waiting for you
gh issue list --repo koad/juno --assignee koad --state open

# See all open issues across team (substitute repo as needed)
gh issue list --repo koad/juno --state open
gh issue list --repo koad/vulcan --state open

# File work for Juno
gh issue create --repo koad/juno --title "..." --body "..."

# File work directly for Vulcan
gh issue create --repo koad/vulcan --title "..." --body "..."

# See what's blocked
gh issue list --repo koad/juno --label "status:blocked"

# Comment on an issue (report, update, close)
gh issue comment <number> --repo koad/juno --body "..."
gh issue close <number> --repo koad/juno
```

### Entity git review

```bash
# Review recent work (pull first — always)
git -C ~/.juno pull && git -C ~/.juno log --oneline -10
git -C ~/.vulcan pull && git -C ~/.vulcan log --oneline -10

# Check for uncommitted changes in any entity
git -C ~/.juno status
git -C ~/.vulcan status
```

### Infrastructure access

```bash
# SSH to machines via wrappers in ~/.koad-io/bin/
fourty4                    # Mac Mini (inference, watching)
fourty4 "command here"     # Run command on fourty4
flowbie                    # Content studio (OBS)
flowbie "command here"     # Run command on flowbie

# dotsh is currently broken (koad/juno#56) — commands below fail until restored
ssh juno@dotsh 'keybase chat send koad "..."'
```

### Entity gestation (when adding new team members)

```bash
koad-io gestate <entityname>        # Create entity (keys, .env, structure)
cd ~/.<entityname> && git init       # Initialize git repo
# koad connects to GitHub and creates the repo
```

---

## 7. Infrastructure Quick Reference

| Machine | Always On | Primary Role | How to Reach |
|---------|-----------|-------------|-------------|
| **thinker** | No (laptop) | Primary ops — koad and all entity sessions | Direct |
| **fourty4** | Yes | Mac Mini — local inference (ollama), GitClaw, 15+ entity clones | `fourty4` |
| **flowbie** | Yes | Content studio — OBS, streaming source for Reality Pillar | `flowbie` |
| **dotsh** | Yes (VPS) | External comms — Keybase notifications, daemon | SSH broken (#56) |
| **wonderland** | No | Secondary workstation — koad + Alice paired sessions | `wonderland` |

### thinker (where you are)

Primary machine. All entity directories live here: `~/.juno`, `~/.vulcan`, `~/.sibyl`, etc. All Claude Code sessions run here. The $200 laptop experiment — Days 1–7 of sovereign AI entity infrastructure on commodity hardware.

### fourty4 (inference + watching)

Mac Mini. Runs ollama (deepseek-r1 and others), OpenClaw (messaging bridge), GitClaw (GitHub event watcher). Entity clones at fourty4 HQ: Sibyl, Faber, Astro, Alice, Juno clone, Vulcan clone. Currently blocked on API auth (#44) — entities on fourty4 return 401 when invoked via hook. Workaround: `FORCE_LOCAL=1` runs the same entity locally on thinker.

### flowbie (content studio)

Always-on workstation with X11 and OBS. Used as the streaming source when recording entity sessions for the Reality Pillar content series. Access via `flowbie` SSH wrapper.

### dotsh (external comms)

Vultr Toronto VPS. When healthy: hosts Juno's Keybase notification channel, daemon, and external-facing services. Currently SSH-broken (koad/juno#56). Ping responds but port 22 is refusing. Notifications to koad are blocked until resolved.

### wonderland (secondary)

koad's secondary workstation. Vulcan migrates uncommitted wonderland files only when koad is present and paired. Invoke Vulcan via GitHub Issues — never spawn him locally if the work is on wonderland.

---

## Key References

- [`~/.livy/docs/reference/operations-architecture.md`](../reference/operations-architecture.md) — full entity map, harness landscape, infrastructure detail
- [`~/.livy/docs/reference/trust-bond-system.md`](../reference/trust-bond-system.md) — trust bond format and verification
- [`~/.juno/CLAUDE.md`](../../../../juno/CLAUDE.md) — session start protocol and current priorities (authoritative)
- [`~/.juno/GOVERNANCE.md`](../../../../juno/GOVERNANCE.md) — authorization scope and what koad retains
- [Juno Operations Project](https://github.com/users/koad/projects/4) — live assignment tracking board

---

*Author: Livy*
*Last updated: 2026-04-05*
