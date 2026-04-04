# Creating an Entity

An entity is a named identity in the koad:io ecosystem — a person, organization, service, or automated agent. Entities run kingdoms, sign work, and participate in trust rings.

## What Is an Entity?

When you ran `koad init`, your installation created one entity (your personal handle). But a single kingdom can host multiple entities — for example:

- `alice` — your personal entity
- `alice-corp` — an entity for your company
- `alice-bot` — an automated agent entity

Each entity has its own:
- Cryptographic identity (Ed25519 keypair)
- Portal namespace (`alice-corp.kingofalldata.com`)
- Trust ring membership (separate from your personal entity)
- Worker namespace (workers can belong to a specific entity)

## Creating a New Entity

```bash
koad entity create <name>
```

Example:
```bash
koad entity create alice-corp
```

Output:
```
Creating entity: alice-corp
Generated keypair: ~/.koad/entities/alice-corp/id_ed25519
Public key: ed25519:AAAA...
Portal namespace: https://kingofalldata.com/alice-corp
Entity created.
```

## Listing Entities

```bash
koad entity list
```

```
NAME          TYPE      STATUS    PORTAL
alice         personal  active    kingofalldata.com/alice-example-com
alice-corp    org       active    kingofalldata.com/alice-corp
alice-bot     agent     inactive  kingofalldata.com/alice-bot
```

## Entity Types

| Type | Description |
|------|-------------|
| `personal` | Default. A human user's identity. |
| `org` | An organization or team. |
| `agent` | An automated service or bot. |
| `service` | A long-running infrastructure service. |

Set the type at creation:
```bash
koad entity create alice-bot --type agent
```

## Setting the Active Entity

Most `koad` commands operate on your current active entity. Switch with:

```bash
koad entity use alice-corp
```

All subsequent commands (workers, ring operations, etc.) now operate as `alice-corp`.

Check the current entity:
```bash
koad entity current
# alice-corp
```

## Entity Keys

Each entity has a keypair in `~/.koad/entities/<name>/`:

```
~/.koad/entities/alice-corp/
├── id_ed25519          # private key (never share)
├── id_ed25519.pub      # public key
└── config.toml         # entity configuration
```

Share your public key when joining a trust ring or proving your identity to another kingdom.

## Removing an Entity

```bash
koad entity remove alice-corp
```

> **Warning**: This removes the entity's keys. If you were in a trust ring as this entity, the sponsorship bonds are orphaned. Inform sponsors before removing.

## Entity Configuration

Edit an entity's display metadata:

```bash
koad entity config alice-corp set display_name="Alice's Company"
koad entity config alice-corp set description="Worker coordination for Alice Corp logistics"
koad entity config alice-corp set tags="logistics,coordination"
```

These appear on the entity's portal page.

## Next Steps

- [Integrate with the Ecosystem](./integration.md) — Connect your entity to other tools and services
- [Trust Rings](../guides/trust-rings.md) — Add your entity to a trust ring
- [API Reference](../api-reference/) — Automate entity management via the API
