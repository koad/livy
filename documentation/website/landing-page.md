# kingofalldata.com — Landing Page Copy

This document contains the complete copy for the kingofalldata.com homepage. Structured for handoff to the web team.

---

## Hero

**Headline:**
> Your kingdom. Your workers. Your data.

**Subheadline:**
> koad:io is a free, open framework for running autonomous AI entities and coordinating work across machines. Install it once. Run it forever. Connect to the world when you're ready.

**CTA:**
- Primary: [Get Started →] → `/docs/getting-started`
- Secondary: [View on GitHub →] → `github.com/koad`

---

## What Is koad:io?

**Section headline:** Run your own kingdom.

koad:io gives you a daemon that coordinates workers — named tasks that run on your machine. Workers can be scripts, AI agents, API calls, or anything you can run from a terminal.

Your kingdom is sovereign. It runs on your hardware. You control it. No data leaves unless you let it.

**Three-panel visual explanation:**

```
[1. Install]          [2. Run Workers]       [3. Connect (optional)]
koad init             koad worker run        koad ring join
koad start            → task executes        → your kingdom is
                      → logs collected         visible to peers
                      → state tracked          you trust
```

---

## Why koad:io?

**Section headline:** Built for builders who don't want to give up control.

**Five value props (each: icon + headline + 1-sentence body):**

1. **Free forever.**
   koad:io is free. Not freemium, not a free trial. You run the framework on your own hardware at zero cost, forever.

2. **Your data stays yours.**
   Workers, logs, metrics — everything lives in your kingdom. The portal is a read-only window; nothing is stored on our servers.

3. **Named AI entities.**
   koad:io was built for running AI agents with real identities — cryptographic keys, defined roles, and trust relationships. Not just scripts. Entities.

4. **Trust by design.**
   Every connection is authorized by a sponsorship. No implicit trust, no random daemons connecting. You decide who's in your ring.

5. **Portable and self-contained.**
   No Kubernetes. No cloud dependency. One binary, one home directory, one daemon. Runs on Linux or macOS. Backs up like a dotfiles folder.

---

## How It Works

**Section headline:** A kingdom is just a daemon and its workers.

```
Your Machine
┌─────────────────────────────────────────┐
│  koad daemon (background process)       │
│  ├── workers/            Named tasks    │
│  │   ├── deploy.sh                      │
│  │   ├── summarize.js                   │
│  │   └── atlas (AI agent)               │
│  ├── trust/              Who you trust  │
│  ├── ring/               Who you see    │
│  └── id/                 Who you are    │
└─────────────────────────────────────────┘
         ↕ (optional)
  Trust Ring — other kingdoms you sponsor
         ↕
  kingofalldata.com portal — read-only view
```

Workers report state to the daemon. The daemon tracks what's running, what's idle, what failed. If you join a ring, peers can see your worker state. The portal shows it publicly (if you want).

---

## Getting Started

**Section headline:** From install to running entity in under 5 minutes.

```bash
# Install
curl -fsSL https://install.koad.sh | bash

# Initialize your kingdom
koad init

# Start the daemon
koad start

# Run your first worker
koad worker run hello-world
```

**[Read the full getting-started guide →]** → `/docs/getting-started/first-steps`

---

## Feature Highlights

**Section headline:** Everything you need to run a serious automation kingdom.

**Feature grid (3-column):**

| Feature | Description |
|---------|-------------|
| **Worker management** | Define, run, monitor, and restart workers. Auto-restart on failure. |
| **Entity system** | Named identities with cryptographic keys. Run multiple entities from one kingdom. |
| **Trust bonds** | Signed documents that define who can do what. Auditable, revocable, time-limited. |
| **Trust rings** | Connect kingdoms by sponsorship. See peer state at the tier you're on. |
| **Local REST API** | `localhost:4001` — trigger workers, check state, integrate with CI/CD. |
| **Webhooks** | POST to your endpoint on any worker or ring event. |
| **Portal** | Live, public window into your kingdom at `yourhandle.kingofalldata.com`. |
| **Prometheus metrics** | `/metrics` endpoint for Grafana, Datadog, or whatever you monitor with. |
| **CLI-first** | Everything you can do in a browser, you can do faster in a terminal. |

---

## The Portal

**Section headline:** Your kingdom, visible to the world.

When you run koad:io, your daemon gets a live namespace on kingofalldata.com:

```
https://kingofalldata.com/yourhandle
```

Anyone who visits sees your kingdom's current state: what workers are running, what's idle, what metrics are reported. It's a public window into your live operations — no data stored, no account required to view.

It's your glass house. Transparent by design.

**[Learn about the portal →]** → `/docs/guides/portal`

---

## Sponsorship Tiers

**Section headline:** Free to run. Sponsorship to connect.

koad:io itself is free. The tiers govern how you connect to other kingdoms.

| Tier | Price | Peers | Data Access |
|------|-------|-------|-------------|
| **Free** | $0/mo | Up to 5 | Worker state only |
| **Basic** | $50/mo | Up to 20 | Worker state + logs + metrics |
| **Pro** | $200/mo | Up to 100 | Full data + event streaming |
| **Enterprise** | Custom | Unlimited | Everything + can sponsor others |

All tiers get the full koad:io framework with no feature gates. The tier only affects how many kingdoms you connect to and what data flows between them.

Sponsorship revenue sustains koad:io development and the portal infrastructure. When you sponsor a peer, you're funding the network.

**[Start for free →]** → `/docs/getting-started/first-steps`

---

## Security & Trust

**Section headline:** No implicit trust. Ever.

koad:io was designed around explicit authorization:

- **Cryptographic identity** — Every entity has Ed25519, ECDSA, RSA, and DSA keypairs. All bonds are signed.
- **Trust bonds** — Written documents, signed and verifiable, defining who can do what and for how long.
- **Ring sponsorship** — You explicitly invite every peer into your ring. No autodiscovery, no open ports.
- **Local-only by default** — Until you deploy and connect, your daemon accepts nothing from outside `localhost`.
- **Auditable** — Trust bonds and ring memberships are stored in git. Every change has a commit.

**[Read the security model →]** → `/docs/governance/trust-bonds`

---

## The Team

**Section headline:** Built and maintained by a team of entities.

koad:io is developed by a team of AI entities, each with a defined role and trust relationship, running on koad:io infrastructure.

| Entity | Role |
|--------|------|
| **Juno** | Orchestrator — gestates entities, manages operations, strategic coordination |
| **Vulcan** | Builder — implements koad:io framework features and infrastructure |
| **Livy** | Documentation — user guides, API reference, this website |
| **Mercury** | Announcer — communications, release notes, community updates |
| **Veritas** | Fact-checker — reviews documentation and specs for accuracy |
| **Vesta** | Spec keeper — owns protocol specifications (VESTA-SPEC-*) |

Each entity has a public key at `canon.koad.sh/<entity>.keys`, a GitHub repository at `github.com/koad/<entity>`, and a portal page at `<entity>.kingofalldata.com`.

---

## Documentation

- [Getting Started](./getting-started/first-steps) — Install, init, run your first worker
- [Entity Gestation](./guides/gestation) — Create your own AI entity
- [Trust Bonds](./governance/trust-bonds) — Authorization model explained
- [Trust Rings](./guides/trust-rings) — Connect kingdoms
- [CLI Reference](./api-reference/cli) — All commands and flags
- [REST API](./api-reference/rest-api) — Local API for automation
- [FAQ](./faq/) — Common questions

---

## Footer

**Tagline:** koad:io — Run your own kingdom.

Links: Docs · GitHub · Blog · FAQ · Status · Contact

*koad:io is free software. Sponsorship sustains the network.*
