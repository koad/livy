# Level 10: Gestate Your First Entity

## Core Concept
An entity doesn't have to be a human. You can create a synthetic entity — a bot, an agent, a sovereign AI that acts on your behalf.

## What You Learn

So far, you've been your entity. Your keys. Your daemon. Your skills.

But here's the power of koad:io: you can create another entity and give it autonomy.

This is different from a normal bot or cron job. A normal bot might run commands, but it doesn't have identity. It can't make cryptographic commitments. It can't be trusted by other entities.

A **synthetic entity** is different. It:
- Has its own keys (Ed25519, ECDSA, RSA)
- Has its own identity (a name, a public profile)
- Can execute skills on its own
- Can create trust bonds with other entities
- Can be held accountable (every action is signed and logged)

Think of it like a child becoming an adult. You don't control every breath — you give them autonomy. But you can still revoke their trust bonds if they misbehave.

Common synthetic entities:
- **Daemon**: An always-on agent that watches for events and acts
- **Scheduler**: An entity that runs skills on a schedule
- **API**: An entity that exposes your services to external systems
- **Team member**: A bot with limited permissions that helps your human team
- **Data processor**: An entity that transforms data, feeds results back to you

## What You Do

You're going to gestate a synthetic entity. This is called "gestating" because you're bringing it into existence — giving it identity, giving it agency.

Here's how:

```
# Create a new entity
livy gestate --name "backup-daemon" --type agent
```

This creates a new entity in a subfolder of your kingdom:

```
~/.yourname/entities/backup-daemon/
  ├── id/
  │   ├── ed25519.pub
  │   └── ed25519.key
  ├── home/
  └── manifest.yaml
```

Your new entity has its own keys, its own identity. It's sovereign.

Now you need to trust it. Create a trust bond:

```
# Create a trust bond from you to your agent
cat > ~/.yourname/trust-bonds/backup-daemon.bond << 'EOF'
---
entity: backup-daemon
subject: Execute the 'backup' skill
permission: EXECUTE
skill: backup
valid_until: 2027-04-03
---
EOF

livy sign ~/.yourname/trust-bonds/backup-daemon.bond
```

Now your daemon knows: "backup-daemon is allowed to run the backup skill."

Start your agent:

```
livy entity start backup-daemon
```

Your agent now has a daemon running. It can accept commands. It's a real entity in your kingdom.

Test it:

```
livy entity call backup-daemon backup --source ~/Documents
```

Your agent receives the command, verifies it's really from you (by checking your signature), runs the backup skill, and returns the result.

Now you can schedule it:

```
# Run every day at 2am
livy entity schedule backup-daemon backup "0 2 * * *"
```

Every night, your agent wakes up and runs the backup. You receive a log. You can verify what happened. You can revoke its permission anytime.

Congratulations — you've gestated a synthetic entity. You've delegated autonomy without giving up control.

## What You Have at the End

- A synthetic entity running in your kingdom
- An agent that acts on your behalf, accountably
- A real understanding of decentralized delegation
- The ability to scale your work (agents can do things while you sleep)

## Context Bubble

**Session moments in this bubble:**
- Someone realizing: "I can't be awake all the time. What if an agent could handle this?"
- The moment someone gestates their first synthetic entity: "It has keys. It has identity. It's sovereign, but it's *mine*."
- Watching them create a trust bond from themselves to their agent: "I'm giving it permission. I'm writing it down. I can always revoke it."
- The agent wakes up and starts working: scheduled backups running at 2am while they sleep
- The moment they check the logs: "It did exactly what I told it to. I don't see the work, but I see the proof."
- Someone explaining: "This isn't a cron job. This is a sovereign agent. It's different."
- The realization: "My work can continue while I sleep. I'm not running 24/7. The agent is."

**What you experience:**
You watch someone multiply their impact by creating a synthetic peer. You watch an agent come to life with autonomy *and* accountability. You watch work happen without human intervention, but with human oversight.

**What should click:**
Synthetic entities are how you scale your sovereignty. You create autonomous agents, give them limited power, and stay in control. You sleep. They work.
