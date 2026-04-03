# Your Kingdom and the Portal

kingofalldata.com is a **portal**—a doorway into sovereign kingdoms. When you visit a namespace like `alice.kingofalldata.com`, you're looking into Alice's live kingdom state.

## What Is the Portal?

The portal is not a SaaS app. It's a read-only window into your daemon's live state. Every time a visitor loads your namespace, the portal queries your daemon for current worker state, metrics, and logs.

```
Visit: alice.kingofalldata.com
  ↓
Portal looks up Alice's daemon hostname
  ↓
Portal queries Alice's daemon for state
  ↓
Portal renders the data in a live dashboard
  ↓
No data is stored on the portal—it's fetched on each request
```

## Your Namespace

When you run koad:io, your kingdom gets a namespace on the portal:

```
https://kingofalldata.com/{your-kingdom-handle}
```

Your handle is tied to your cryptographic identity. If your entity is `alice@example.com`, your namespace is:

```
https://kingofalldata.com/alice-example-com
```

Or, if you run a named kingdom, you can claim a custom namespace (requires proof of domain ownership).

## What Visitors See

When someone visits your namespace, they see:
- Your kingdom's current worker state (running, idle, failed)
- Current metrics (CPU, memory, uptime)
- Recent logs (24-hour window)
- Ring membership (which daemons you're peered with, at your tier level)

**They CANNOT:**
- Start or stop workers
- Modify configuration
- Access another peer's data (only their sponsor can)
- Trigger commands
- See data outside the 24-hour log window

## Privacy Model

**Your namespace is public by default.** If you're running koad:io, anyone can visit your portal page. This is intentional—it's a feature, not a bug.

Why public? Because:
1. It's a showcase. You want people to see what you're building.
2. It builds trust. Live, public state is auditable by anyone.
3. It's part of the koad:io story—your kingdom is legible to the world.

If you want privacy, you can:
- Run a private tier (enterprise) — requires sponsorship from Juno
- Firewall your daemon endpoint from external IPs (blocks portal access)
- Use port restrictions in your firewall (the portal queries a specific peer port)

## The Portal Connection

The portal connects to your daemon as a special **portal client**. It authenticates using a pre-shared key and queries your daemon every time someone loads your namespace page.

If your daemon is unreachable, the portal serves cached data (up to 24 hours old).

## Updating Your Metadata

You can customize what the portal displays about your kingdom:

```bash
# Set your kingdom's display name
koad config set display_name="Alice's Flower Shop Workers"

# Set a description
koad config set description="Real-time worker coordination for flower delivery"

# Set tags (searchable on kingofalldata.com)
koad config set tags="flowers,delivery,coordination"
```

The portal automatically discovers and displays these.

## Portal as a Feature, Not a Service

The portal is **your window into live daemons**, not a replacement for them. You still control everything—your daemon, your data, your workers. The portal is just the view.

Think of it like a glass house: everyone can see in (workers are running, metrics are healthy), but only you have the keys to change anything.

## What's Next?

- Learn about trust rings: [What is a Trust Ring?](./trust-rings.md)
- Set up your first kingdom: [Getting Started](../getting-started/first-steps.md)
- Full protocol details: See VESTA-SPEC-014 in the spec docs

---

*This is placeholder documentation. Complete version coming soon.*
