# What is a Trust Ring?

A trust ring is a network of connected kingdoms linked by sponsorship relationships. It's the foundation of how koad:io scales beyond a single machine.

## The Core Idea

koad:io is free. You run it for free, forever. But to connect your kingdom to others—to see their data, coordinate work, or form multi-machine networks—you need a **sponsorship**.

When you sponsor a kingdom into a trust ring, you create a trust bond. That bond grants:
- Peer connectivity (daemon-to-daemon connections)
- Data access (the sponsor can see the peer's worker state, logs, metrics)
- Network visibility (the peer appears in your ring)

## How Trust Rings Work

**Sponsorship is the permission model.** 

Think of it like inviting someone into your circle. When you sponsor a daemon:
1. You're vouching for it
2. You get visibility into its state
3. It stays in your ring as long as you sponsor it
4. You can revoke the sponsorship anytime

## Tier Model

Sponsorships come in tiers. Each tier determines what data flows and how many peers you can have:

| Tier | Max Peers | Data Access | Cost |
|------|-----------|-------------|------|
| **free** | 5 | Worker state only | $0 |
| **basic** | 20 | Worker state + logs + metrics | $50/mo |
| **pro** | 100 | Full data + events | $200/mo |
| **enterprise** | Unlimited | Everything + can sponsor others | Custom |

**Free is the default.** When you first run koad:io, you're in the free tier. You can sponsor up to 5 peers into your ring and see their worker state.

## A Practical Example

```
Koad Organization
├── Your Kingdom (free tier, sponsored by koad)
│   └── You can sponsor 5 peers
│       ├── Alice's daemon (worker state visible to you)
│       ├── Bob's daemon (worker state visible to you)
│       └── Carol's daemon (worker state visible to you)
│
└── Juno (sponsors basic and pro daemons)
    ├── Company A daemon (basic tier)
    ├── Company B daemon (basic tier)
    └── Company C daemon (pro tier)
```

You can't see Company A or B directly—they're Juno's ring. But if you upgrade to **basic**, Juno can see your daemon, and you both get visibility into each other's activity.

## Why Sponsorship?

The sponsorship model prevents:
- **No implicit trust**: You can't just connect to random daemons. Someone has to vouch for you.
- **Clear authority**: The sponsor always controls the relationship. If something goes wrong, they can revoke access in seconds.
- **Incentive alignment**: Higher tiers unlock more data and peer connections. That's how koad.io sustains as a platform.

## Connecting to a Ring

To join an existing ring:

1. Run koad:io in your kingdom
2. Get someone in the ring to **sponsor** you
3. They create a sponsorship bond for you
4. Your daemon receives the sponsorship and connects to the ring
5. You're in.

To sponsor others into your ring, you need their daemon's public key and hostname.

## What's Next?

- Learn how to sponsor a peer: [Sponsoring Peers](../getting-started/first-steps.md)
- Understand your portal namespace: [Your Kingdom and the Portal](./portal.md)
- Full protocol details: See VESTA-SPEC-014 in the spec docs

---

*This is placeholder documentation. Complete version coming soon.*
