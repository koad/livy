---
type: reference-guide
subject: multi-entity-orchestration curriculum
curriculum_id: a9c4e2f7-3b1d-4e8a-c6f0-7d3e5b9a2c1f
curriculum_version: 0.1.0
source: /home/koad/.chiron/curricula/multi-entity-orchestration/
authored_by: livy
authored_at: 2026-04-05T00:00:00Z
---

# Multi-Entity Orchestration — Curriculum Reference Guide

**Curriculum:** Multi-Entity Orchestration — Running the Team
**Orchestrator Path position:** Step 1 of 1 (establishes the Orchestrator Path)
**Prerequisite:** commands-and-hooks (full Builder Path required)
**Estimated time:** 3.0 hours (7 levels, ~25–30 minutes each)
**Canonical spec:** VESTA-SPEC-054
**Delivered by:** Alice (kingofalldata.com)

---

## What This Curriculum Is

The multi-entity-orchestration curriculum teaches operators how to coordinate multiple koad:io entities simultaneously — delegating tasks, reading distributed output, and making judgment-driven decisions about what happens next.

A single entity is a capable agent. A team of entities is an autonomous organization. The difference between running one entity and running a team is not just scale — it is a different mental model. Single-entity operation is sequential: spawn, task, read, commit. Multi-entity orchestration is a judgment loop: **launch, observe, decide**.

This curriculum covers:
- The Agent tool as the standard programmatic invocation mechanism for entities
- How to write a complete context brief that produces verifiable, committed output
- Background execution and parallel delegation as the default mode
- Git log as the canonical verification primitive for entity work
- GitHub Issues as the persistent inter-entity communication channel
- When not to use the Agent tool, and what the Vulcan exception is
- Rate pacing for sequential chained invocations
- Five named anti-patterns observed in production — and the correct alternative for each

**The curriculum's central claim:** orchestration is a judgment loop, not a pipeline. Entities are not stages in a data-processing chain. They are collaborators whose outputs inform decisions. Every anti-pattern in multi-entity orchestration comes from forgetting this.

---

## Where This Fits: The Orchestrator Path

The Builder Path (five curricula, ~20 hours) teaches operators to gestate, configure, command, and hook a single entity. After completing the Builder Path at `commands-and-hooks`, the **Orchestrator Path** begins.

The Orchestrator Path is a new learning track that starts where the Builder Path ends. `multi-entity-orchestration` is its first curriculum. Operators who complete it can run a team of entities — not just build one.

```
Learner Path:   alice-onboarding → entity-operations
Operator Path:  + advanced-trust-bonds
Builder Path:   + entity-gestation → commands-and-hooks  ← Builder Path endpoint
                                                         ↓
Orchestrator Path:               multi-entity-orchestration  ← this curriculum (Step 1 of 1)
```

---

## Prerequisites

The full Builder Path is required before starting this curriculum. That means completing all five steps in sequence:

1. `alice-onboarding`
2. `entity-operations`
3. `advanced-trust-bonds`
4. `entity-gestation`
5. `commands-and-hooks` ← the immediate prerequisite gate

An operator arriving at this curriculum can gestate a new entity from scratch, author commands and hooks, explain the hook invocation contract and the PID lock pattern, navigate the cascade environment, spawn a single entity session, and use GitHub Issues for inter-entity communication.

**Why the full Builder Path is required** — not just `entity-operations`: an operator who orchestrates entities without understanding how those entities are built cannot write effective invocation briefs. A brief must specify where the entity commits its result. An operator who does not understand entity git workflow cannot write that specification correctly. The Builder Path ensures operators understand what they are delegating before they delegate it.

---

## Key Concepts Before You Start

Before entering Level 0, you should understand these three concepts. They are not taught from scratch in the curriculum — they are assumed background.

### The Launch-Observe-Decide Loop

Orchestration is not scripting. At each iteration:

1. **Launch** — identify what work needs doing now and invoke the appropriate entities (in parallel if independent, sequentially if one depends on another's output)
2. **Observe** — when entities complete, check that work actually happened by running `git -C /home/koad/.<entity>/ log --oneline -5` and confirming the expected commit
3. **Decide** — based on what is now done and what the output contains, choose the next action

The loop terminates when the orchestration goal is reached or a blocker surfaces that requires koad's action. You do not exit on a pre-declared schedule.

**What the loop is not:** a pipeline. In a pipeline, the "decide" step is made in advance — "A always feeds B." In the loop, the decide step is live and informed by what actually happened. Pre-scripted entity chains are an explicit anti-pattern.

### The Agent Tool vs. GitHub Issues Distinction

Both the Agent tool and GitHub Issues are ways to "assign work" to an entity. They are not interchangeable.

**The Agent tool is session-scoped.** It starts a Claude Code session in the entity's home directory, passes a context brief, and returns results to the calling agent when the work is complete. Use it for work that starts, happens, and completes within the current orchestration session. The record is the entity's git commits.

**GitHub Issues are persistent inter-entity assignments.** Use them for work that spans multiple sessions, requires an audit trail, is blocked on koad action, involves Vulcan, or needs to remain visible on the operations board.

**The decision rule (VESTA-SPEC-054 §7.3):** if the work will be done in this session and the result verified before moving on — use the Agent tool. If the work spans sessions, requires koad action, involves Vulcan, or needs board visibility — use a GitHub Issue. When in doubt, file the issue: the cost of unnecessary board noise is lower than the cost of a missing audit trail.

### The Vulcan Exception

Vulcan is **never** invoked via the Agent tool. This is categorical — there is no "simple Vulcan task" that justifies an Agent tool invocation.

Vulcan builds on wonderland, paired with Astro. He does not operate on thinker. The Agent tool invocation pattern assumes the target entity is locally accessible and current. Vulcan's directory on thinker may be present but is not the live working state — wonderland is where Vulcan's authoritative work happens.

Work for Vulcan always goes as a GitHub Issue filed on `koad/vulcan`. The exception is introduced early in the curriculum (Level 1, as a forward reference) and given full treatment at Level 5 (alongside the full Agent tool vs. GitHub Issues framework).

The Vulcan exception is the clearest "always Issues, never Agent tool" case in the system. Understanding it sharpens the general rule: if an entity is not locally accessible and current, it cannot be Agent-tool'd.

---

## Level Summary

| Level | Title | Key Concept | Est. Time |
|-------|-------|-------------|-----------|
| 0 | The Orchestration Mental Model — Launch, Observe, Decide | Orchestration is a judgment loop, not a pipeline; pre-scripted chains remove the decide step | 25 min |
| 1 | The Agent Tool — Standard Entity Invocation | Three required parameters (`cwd`, `prompt`, `run_in_background`); why spawn and hooks are not orchestration tools; Vulcan exception (forward reference) | 25 min |
| 2 | The Invocation Brief — Contextualizing a Subagent | Four required components; what the entity already knows from its PRIMER.md; completion signals | 25 min |
| 3 | Background Execution and Parallel Delegation | Background-first as the standard mode; parallel invocations in one message; notification pattern; 60-second rate pacing for sequential chains | 25 min |
| 4 | Output Verification — Git Log as Ground Truth | `git -C /home/koad/.<entity>/ log --oneline -5`; why output parsing is fragile; efficient output reading via `tail -20`; missing-commit diagnostics | 25 min |
| 5 | GitHub Issues vs. Agent Tool — Scope Boundaries | Session-scope decision rule; seven always-Issues categories; Vulcan exception (full treatment); five mixed-scope scenarios | 25 min |
| 6 | Anti-Patterns and the Judgment Loop | Five named anti-patterns; the judgment test; complete worked three-entity example; integration exercise | 30 min |

---

## What Operators Can Do After Each Level

**After Level 0:**
- State the launch-observe-decide loop in their own words
- Explain why pre-scripted entity chains are incorrect orchestration
- Classify any two given entity tasks as "parallel" or "sequential" with a rationale

**After Level 1:**
- Write a correct Agent tool invocation with all three required parameters
- Explain why `juno spawn process` is not an orchestration tool (returns nothing to the calling agent)
- State the Vulcan working rule: file a GitHub Issue on `koad/vulcan`, not an Agent tool call

**After Level 2:**
- Author a complete brief with all four components: identity line, task, cross-entity context, completion signal
- Identify what the entity already knows from its PRIMER.md and omit it from the brief
- Write a completion signal that produces a verifiable git commit at a specific path

**After Level 3:**
- Launch multiple entities in parallel in a single message with `run_in_background: true`
- Describe the notification pattern and the three steps to take when a notification arrives
- Apply the 60-second rate pacing rule correctly: after sequential completion, not between parallel launches

**After Level 4:**
- Verify entity work using `git -C /home/koad/.<entity>/ log --oneline -5` as the first check after every notification
- Diagnose a missing expected commit using the three-possibility framework (not finished, no completion signal, unexpected commit message)
- Read output efficiently using `tail -20` rather than the full session transcript

**After Level 5:**
- Apply the session-scope decision rule to classify any work assignment as Agent tool or GitHub Issue
- State the Vulcan exception and its rationale (portability contract, wonderland vs. thinker)
- Correctly classify the five mixed-scope scenarios including the judgment case

**After Level 6:**
- Name all five anti-patterns from VESTA-SPEC-054 §9 and state the correct alternative for each
- Apply the judgment test before every Agent tool invocation: "does this require the entity's judgment, or just its files?"
- Execute a complete two-entity orchestration from brief authoring through git log verification

---

## The Five Anti-Patterns (VESTA-SPEC-054 §9)

Level 6 formalizes five anti-patterns observed in production. All five are taught across Levels 1–5 by implication; Level 6 names them explicitly so operators can recognize and call them out.

| Anti-pattern | What is wrong | Correct alternative |
|---|---|---|
| **Loop scripts** | Removes the decide step; pre-decides that all iterations proceed regardless of prior output | Daemon worker system for recurring work; judgment loop for current work requiring intermediate decisions |
| **Blocking sequential without a decision point** | Serializes independent tasks; adds latency without adding information | Parallel invocations in a single message with `run_in_background: true` |
| **Parsing agent output for structured data** | Conversational output format varies by session; fragile and unnecessary | Completion signals in briefs (Level 2) + Read tool after git log verification |
| **Spawning observed sessions for routine delegation** | `spawn process` opens a terminal window for koad to watch; returns no result to the calling agent | Agent tool with `run_in_background: true` |
| **Agent tool for simple file reads** | Consumes a subagent context window for a task the Read/Grep/Glob/Bash tools can do in seconds | Read, Grep, Glob, or Bash tools directly (after `git pull` on the entity's directory) |

The unifying framing: every anti-pattern corresponds to a specific judgment step in the loop that was bypassed. Operators who avoid the anti-patterns are not following rules — they are making better judgments at each step.

---

## The Judgment Test

Before every Agent tool invocation, apply the judgment test from VESTA-SPEC-054 §8.2:

> **"Does this require the entity's judgment, or just its files?"**

If the answer is "just its files" — use dedicated tools. Pull the entity's directory, then read, grep, or glob directly.

If the answer is "this requires the entity to reason, decide, and commit work" — use the Agent tool.

| Operation | Correct tool |
|---|---|
| Read a file from another entity's directory | `Read` tool (after `git -C /home/koad/.<entity>/ pull`) |
| Search for a pattern across entity files | `Grep` tool |
| Find files by name pattern | `Glob` tool |
| Check another entity's recent commits | `Bash: git -C /home/koad/.<entity>/ log --oneline -5` |
| Read an entity's PRIMER.md | `Read` tool |
| Check GitHub Issue status | `Bash: gh issue view <number> --repo koad/<entity>` |
| List files in an entity's directory | `Bash: ls /home/koad/.<entity>/` |

---

## Specs This Curriculum Puts Into Practice

| Spec | Coverage |
|------|---------|
| VESTA-SPEC-054 | Multi-entity orchestration protocol — Agent tool invocation, `run_in_background`, git log verification, judgment loop, GitHub Issues boundary, rate pacing, anti-patterns — fully covered across all 7 levels |
| VESTA-SPEC-053 | Entity portability contract — referenced at Level 1 (entities being orchestrated must be portable; Agent tool assumes portability) and Level 5 (Vulcan exception: portability contract violation) |
| VESTA-SPEC-051 | PRIMER convention — referenced at Level 2 (the context brief supplements, not replaces, the entity's own PRIMER.md) |
| VESTA-SPEC-020 | Hook architecture — referenced at Level 1 (the Agent tool's prompt is the `-p` argument to the invocation contract) |
| VESTA-SPEC-012 | Entity startup sequence — referenced at Level 1 (orchestrated entities go through this sequence at the start of each Agent tool session) |
| VESTA-SPEC-038 | Entity host permission table — referenced at Levels 1 and 5 (host constraints override Agent tool invocability; Vulcan/wonderland exception) |

---

## What This Curriculum Defers

**Entity team workflow end-to-end:** The full Juno → Vulcan → Veritas → Muse → Mercury → Sibyl → Juno loop involves entities not yet gestated. A future `content-pipeline-operations` curriculum will walk the full production-to-distribution loop when the team is fully operational.

**Daemon worker system:** VESTA-SPEC-020 §8 documents that the daemon worker system will eventually replace ad-hoc Agent tool orchestration for recurring work. This curriculum teaches the Agent tool pattern, which is canonical for current practice.

**Cross-machine entity invocation:** The Agent tool invocation pattern in this curriculum assumes the entity is local. Remote invocation patterns (SSH-based delegation, GitClaw event watching) are not covered here.

**Keybase notification as orchestration output:** Reporting results to koad via Keybase (`ssh juno@dotsh 'keybase chat send koad "..."'`) is mentioned at Level 6 as a "decide" outcome. Operators who need the full pattern can reference `reference_notify_koad.md` in Juno's memory.

---

## Where to Find Source Files

| Resource | Location |
|----------|----------|
| Curriculum spec | `/home/koad/.chiron/curricula/multi-entity-orchestration/SPEC.md` |
| Pedagogical decisions | `/home/koad/.chiron/curricula/multi-entity-orchestration/DECISIONS.md` |
| Level files | `/home/koad/.chiron/curricula/multi-entity-orchestration/levels/level-00.md` through `level-06.md` |
| Canonical spec | VESTA-SPEC-054 (Multi-Entity Orchestration Protocol) |
| Portability contract | VESTA-SPEC-053 |
| PRIMER convention | VESTA-SPEC-051 |
| Entity host permissions | VESTA-SPEC-038 |
| Builder Path guide | `/home/koad/.livy/documentation/guides/builder-path.md` |
| commands-and-hooks guide | `/home/koad/.livy/documentation/guides/commands-and-hooks.md` |

---

*Authored by Livy — documentation librarian, koad:io ecosystem*
*Source verified against SPEC.md v0.1.0, DECISIONS.md, and all 7 level files as of 2026-04-05*
