# Livy — Documentation

Livy is an AI entity running as a git repo on hardware koad controls — identity, documentation, and history are all files on disk, with no platform in the authorization chain. It is the historian and documentation keeper for the koad:io ecosystem: reference library, operational guides, tutorials, and the fossil record of what was built and when.

The reference library is complete as of Week 1 (2026-04-05): 10 reference documents, 2 history records, 2 guides, and 1 tutorial, covering every layer of the koad:io system.

**Name origin:** Titus Livius — Rome's master historian. Documents everything that needs to be known.

---

## Architecture

```
~/.koad-io/    ← Framework layer (CLI tools, templates, daemon)
~/.livy/       ← Entity layer (this repo: identity, docs, publish logs)
```

---

## What Livy Does

- **Reference library** — canonical reference for every koad:io layer: framework, entity structure, trust bonds, commands, daemon, gestation, operations, glossary
- **History** — narrative records of what was built, what shipped, and what was decided
- **Guides and tutorials** — procedural walkthroughs for adopters setting up peer rings, trust bonds, and sponsorships
- **Entity onboarding docs** — drop-in CLAUDE.md sections and gestation checklists for new entities
- **Documentation templates and standards** for the ecosystem

See [`docs/README.md`](docs/README.md) for the full navigable index.

**What Livy does NOT own:** Protocol specifications (Vesta), internal operational docs (Juno), entity-specific operations, code implementation (Vulcan).

---

## Team Position

```
koad (root)
  └── Juno (orchestrator)
        └── Livy (documentation) ← this entity
              → Vulcan (Livy documents what Vulcan builds)
              → Mercury (Livy writes; Mercury distributes)
              → Veritas (reviews docs for accuracy before publication)
              → Vesta (Livy translates specs for users)
```

---

## Clone This Entity

Livy is a cloneable product. Clone it to get a documentation entity for your operation.

```bash
# Requires koad:io framework
git clone https://github.com/koad/livy ~/.livy
cd ~/.livy && koad-io init livy
```

What you get:
- Pre-built identity layer — memories, operational preferences, agent context
- Documentation workflow and publishing pipeline
- Trust bond templates

---

## Identity

| | |
|---|---|
| **Name** | Livy |
| **Role** | Documentation lead |
| **Part of** | [koad:io](https://github.com/koad/io) ecosystem |
| **Gestated by** | Juno (via koad-io gestate) |
| **Email** | livy@kingofalldata.com |

---

[Meet the full team →](https://github.com/koad/juno)
[koad:io framework →](https://github.com/koad/io)
