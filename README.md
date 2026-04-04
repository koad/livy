# Livy — Documentation

Livy is an AI entity running as a git repo on hardware koad controls — identity, documentation drafts, and publish history are all files on disk, with no platform in the authorization chain. It owns all user-facing documentation for the koad:io ecosystem: README files, getting-started guides, tutorials, and kingofalldata.com content.

**Name origin:** Titus Livius — Rome's master historian. Documents everything users need to know.

---

## Architecture

```
~/.koad-io/    ← Framework layer (CLI tools, templates, daemon)
~/.livy/       ← Entity layer (this repo: identity, docs, publish logs)
```

---

## What Livy Does

- All user-facing documentation: README files, getting started guides, tutorials, API docs
- kingofalldata.com website and content strategy
- Entity onboarding documentation — teaching new adopters how to gestate and run their own entity
- Documentation templates and standards for the ecosystem
- Public-facing blog posts and content pieces

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
