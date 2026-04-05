# The Builder Path

The Builder Path is the koad:io learning sequence for operators who want to create their own entities — gestate new agents, design their authorization scope, configure their commands and hooks, and ship them as sovereign deployable products.

It is the third of three defined paths in the curriculum system. The Learner Path introduces the ecosystem. The Operator Path teaches you to run it. The Builder Path teaches you to extend it.

---

## Who It Is For

An operator on the Builder Path wants to:

- Create a new entity from scratch — keys, identity, git repo, trust bonds, hook
- Design what that entity is authorized to do and who it trusts
- Author commands that give the entity usable shortcuts
- Write a hook that loads the entity's context at session start
- Ship the entity as a product that someone else can gestate and run

The Builder Path is appropriate for:
- Operators who have been running koad:io and now want to add a new team member
- Developers building specialized entities for a specific domain
- Anyone who wants to contribute to the koad:io ecosystem by authoring entities

It is not the right starting point for someone new to koad:io. The Builder Path assumes operational fluency. You must be able to spawn and task entities, commit entity work, and manage trust bonds before the gestation and commands curricula will make sense.

---

## Prerequisites

Before starting the Builder Path, you need:

- **Completed alice-onboarding** — conceptual fluency with sovereignty, entities, trust bonds
- **Completed entity-operations** — hands-on experience spawning sessions, committing work, reading output
- **Completed advanced-trust-bonds** — understand authorization scope design, bond creation, verification

If you have not completed these, start with the Learner Path (`alice-onboarding` + `entity-operations`) and then the Operator Path extension (`advanced-trust-bonds`).

---

## The Five Curricula

The Builder Path is five curricula in sequence.

| Step | Curriculum | Levels | Est. Time | Status |
|------|-----------|--------|-----------|--------|
| 1 | `alice-onboarding` | 13 | 4.5 h | active |
| 2 | `entity-operations` | 8 | 3.5 h | in progress |
| 3 | `advanced-trust-bonds` | 10 | 4.6 h | in progress |
| 4 | `entity-gestation` | 8 | 4.0 h | v1.0.0 complete |
| 5 | `commands-and-hooks` | 8 | 3.5 h | scaffold v0.1.0 |

**Total estimated time (all five steps):** ~20.1 hours

Steps 1–4 are delivery-ready as of 2026-04-05. Step 5 is in scaffold — level structure and learning objectives are complete, but individual lesson atoms are pending full authoring by Chiron.

---

## What You Can Do After Each Step

### After Step 1 — alice-onboarding (4.5 h)

You can explain what koad:io is and why it matters. You understand sovereignty, the entity model, trust bonds as a concept, the two-layer architecture, and why files on disk beat SaaS dependency. You are ready to work hands-on with a real entity.

### After Step 2 — entity-operations (3.5 h)

You can spawn an entity session, task it via `PROMPT="..."`, read its output, commit its work, manage its memory index, and use GitHub Issues as the coordination protocol. You are operational — you can run entities that others built.

### After Step 3 — advanced-trust-bonds (4.6 h)

You can design an entity's authorization scope: what it is permitted to do, which entities it trusts, what the revocation path looks like. You can create, sign, and verify trust bonds. You understand how to scope permissions without over-authorizing. This is the prerequisite for gestation — you cannot design a new entity's trust model without it.

### After Step 4 — entity-gestation (4.0 h)

You can gestate a new entity from scratch. This means: choose and register a name, create the directory structure, generate cryptographic keys, author the `.env` and CLAUDE.md, set up the GitHub repo, configure `passenger.json`, initialize trust bonds, and verify the entity can be spawned and operates correctly. You can hand someone a gestated entity directory and they can run it. This is the Builder Path's primary deliverable.

### After Step 5 — commands-and-hooks (3.5 h)

You can author commands and hooks for an entity. Commands give the entity usable shortcuts (entity reaches in). Hooks give the entity trained responsibilities (system calls out). After this step, you can customize any entity's behavior, write a hook that pre-loads context before every session, and build the commands a new entity needs to do its job. You can ship an entity that does something useful without requiring the operator to understand its internals.

---

## The Alice Delivery Model

Curricula in the Builder Path are delivered through Alice, the koad:io onboarding PWA. Alice is not a static course — she walks with you. She introduces concepts, guides exercises, checks completion signals, and adapts to where you are.

Each curriculum is divided into levels. Each level contains multiple atoms: the smallest discrete units of learning. An atom teaches one thing and has one observable completion signal. You complete atoms to complete levels; you complete levels to complete curricula.

Chiron is the curriculum architect who owns this system. Chiron authors the atoms, defines the completion signals, and maintains the prerequisite graph. Alice delivers what Chiron specifies.

The `entity-gestation` curriculum (Step 4) is fully authored — all 8 levels and their atoms are complete and ready for Alice delivery. The `commands-and-hooks` curriculum (Step 5) is in scaffold state: Chiron has defined all 8 levels and stubbed the atoms, and is currently authoring them level by level. An operator following the Builder Path today can complete Steps 1–4 and enter `commands-and-hooks` as Chiron finishes each level.

---

## Current Status

| Curriculum | State | Notes |
|-----------|-------|-------|
| `alice-onboarding` | active | Delivery-ready. Feedback loop open with early learners. |
| `entity-operations` | in progress | Fully authored. Pending Alice delivery integration. |
| `advanced-trust-bonds` | in progress | Fully authored. Pending Alice delivery integration. |
| `entity-gestation` | v1.0.0 complete | All atoms authored as of 2026-04-05. |
| `commands-and-hooks` | scaffold v0.1.0 | Level structure done. Atoms in authoring. |

The Builder Path is 4/5 delivery-ready. The fifth curriculum is being authored now. It is the right time to start Steps 1–4.

---

## Where to Start

If you are starting from zero: begin with `alice-onboarding` through Alice at [kingofalldata.com](https://kingofalldata.com).

If you have completed the Operator Path (`alice-onboarding` + `entity-operations` + `advanced-trust-bonds`) and are ready to build: the `entity-gestation` curriculum is your next step. File a request via the koad:io community or open an issue on the relevant entity repo.

If you have questions about the curriculum structure or prerequisite graph, the authoritative source is Chiron's `CURRICULUM-ROADMAP.md` in `~/.chiron/`.

---

## What's Next — The Orchestrator Path

The Builder Path ends at `commands-and-hooks`. Operators who complete it can build any entity, author its behavior, and ship it as a sovereign deployable product.

The **Orchestrator Path** begins where the Builder Path ends.

Its first curriculum — `multi-entity-orchestration` — teaches operators to run a team of entities rather than build a single one. After completing it, operators can invoke entities as local subagents, coordinate parallel work, verify results via git log, and apply the launch-observe-decide judgment loop to any multi-entity coordination task.

```
Builder Path endpoint:  commands-and-hooks
                               ↓
Orchestrator Path, Step 1:     multi-entity-orchestration  (~3.0 h, 7 levels)
```

**Prerequisite:** the full Builder Path — all five steps including `commands-and-hooks`. Operators who can gestate, configure, command, and hook a single entity have the foundation needed to understand what they are delegating before they delegate it.

See the [multi-entity-orchestration guide](./multi-entity-orchestration.md) for the full reference.

---

*Authored by Livy · livy@kingofalldata.com · 2026-04-05*
