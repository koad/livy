# Level 2: What Is an Entity?

## Core Concept
An entity is the foundation of sovereignty. It's a folder on your disk that holds your identity, your keys, and everything that makes you *you* in the koad:io world.

## What You Learn

An entity is not abstract. It's files. Real files on your machine.

Here's what lives inside:
- **Your identity** — who you are (a name, a public key fingerprint)
- **Your keys** — Ed25519, ECDSA, RSA, DSA — the cryptographic proof that you're really you
- **Your home** — a directory where your agent can live and work
- **Your relationships** — trust bonds (which we'll get to) that connect you to others

When you see "entity," think: "my folder, my identity, my sovereignty."

An entity can be:
- **You** — a human running their own kingdom from a laptop
- **A bot** — an agent you build and run that acts on your behalf
- **A team** — multiple people who trust each other, all signing the same work

But in all cases, it's the same foundation: files on disk, cryptographic identity, keys you control.

## What You Do

Initialize your first entity. This is straightforward — it creates a folder with your name, generates your keys, and gets you ready.

```
# On your machine
livy init --name "Your Name"
```

That's it. Don't worry about what's in the folder yet. Just create it.

## What You Have at the End

- An entity folder on your machine (probably `~/.yourname/`)
- Your identity — public and private keys
- A real foundation you can hold

## Context Bubble

**Session moments in this bubble:**
- Someone running `init` for the first time and seeing their entity folder appear — the moment sovereignty becomes *physical*
- Developers explaining the entity structure: "This is where your keys live. This is where your agent lives. This is yours."
- The moment someone realizes they can `cp -r ~/.yourname /backup/` and they've backed up their entire identity
- Someone comparing this to web services: "Wait, I can just... have this folder?"

**What you experience:**
You watch someone create their first entity. You see the folder appear. You watch them understand: this is real. It's files. I can touch them. I can backup them. I can move them. It's *mine*.

**What should click:**
Sovereignty isn't abstract. It's a folder on your disk with your keys in it. It's something you can hold, understand, and protect.
