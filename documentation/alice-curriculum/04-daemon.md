# Level 4: The Daemon

## Core Concept
The daemon is your kingdom's hub. It's a service running on your machine that handles communication, stores your data, and lets you act in the world.

## What You Learn

Think of the daemon like the heart of your kingdom. It's always there, always listening, always ready. Here's what it does:

- **Listens for commands** — when you (or your agents) tell it to do something, it listens
- **Holds your data** — it's the custodian of your files, your relationships, your trust bonds
- **Communicates** — it reaches out to other entities, receives messages, manages your connections
- **Executes work** — when you run a command or skill, the daemon is what actually makes it happen

The daemon runs on *your* machine. Not in some cloud. Not managed by a third party. Your machine, your daemon, your control.

You already started the daemon in Level 3. Now we're going to understand what it's doing.

## What You Do

Your daemon is already running. Let's check in on it:

```
# See daemon status
livy daemon status
```

You should see something that tells you it's running, how many entities are connected, maybe some recent activity.

Now let's explore what the daemon knows:

```
# List everything the daemon is managing
livy daemon info
```

This shows you:
- Your entity information
- What trust bonds exist (relationships you've created)
- Active connections to other entities
- Recent commands that have run

The daemon isn't hidden. You can ask it anything. Go ahead:

```
# Check logs
livy daemon logs
```

This is intentional. You should know exactly what your kingdom is doing at all times.

## What You Have at the End

- A running daemon managing your kingdom
- Clear visibility into what it's doing
- The foundation for everything that comes next
