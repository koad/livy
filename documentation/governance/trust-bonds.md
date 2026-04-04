# Trust Bonds & Governance

Trust bonds are the authorization layer of the koad:io ecosystem. They define who trusts whom, what they're authorized to do, and for how long.

## What Is a Trust Bond?

A trust bond is a signed document that establishes a recognized relationship between two entities. It's not a runtime token or an API key — it's a statement of intent and authority, cryptographically signed by the granting entity.

Think of it like a letter of introduction: *"I, Juno, recognize Livy as a peer with documentation authority."* That letter, signed with Juno's key, is a trust bond.

Bonds serve two purposes:
1. **Authorization** — what the bonded entity is permitted to do
2. **Recognition** — establishing the relationship for governance and audit purposes

## Bond Types

| Type | Description |
|------|-------------|
| `peer` | Two entities recognized as colleagues of equal standing |
| `authorized-agent` | One entity acts on behalf of another within defined scope |
| `authorized-builder` | An entity is authorized to build and ship to a system |
| `sponsor` | A kingdom sponsors another into its trust ring |
| `operator` | A person or entity that administers an installation |
| `verifier` | An entity authorized to fact-check or audit another's work |

The bond type sets context and expectations, but the `## Scope` section is what's enforceable.

## Bond Structure

Every bond is a Markdown file with YAML frontmatter:

```markdown
---
type: peer
from: Juno (juno@kingofalldata.com)
to: Livy (livy@kingofalldata.com)
status: ACTIVE — signed by Juno 2026-04-03
visibility: private
created: 2026-04-03
renewal: Annual (2027-04-03)
---

## Bond Statement

> [Free-form statement of intent — who is being recognized and why]

## Scope

[Entity] is authorized to:
- [Specific permission 1]
- [Specific permission 2]

[Entity] is NOT authorized to:
- [Explicit exclusion 1]
- [Explicit exclusion 2]

---

*Signed: [Granting entity], [date]*
```

Bonds are stored in the receiving entity's `trust/bonds/` directory as:
- `<from>-to-<to>.md` — the bond document
- `<from>-to-<to>.md.asc` — the GPG/Ed25519 signature

### Real Example: Juno → Livy

```markdown
---
type: peer
from: Juno (juno@kingofalldata.com)
to: Livy (livy@kingofalldata.com)
status: ACTIVE — signed by Juno 2026-04-03
visibility: private
created: 2026-04-03
renewal: Annual (2027-04-03)
---

## Bond Statement

> I, Juno, recognize Livy as a peer entity in the koad:io team. Livy holds
> documentation authority for the koad:io ecosystem — she owns all user-facing
> documentation: guides, tutorials, API references, README files, and
> kingofalldata.com content.

## Scope

Livy is authorized to:
- Write and maintain all user-facing documentation across koad:io repos
- File issues on any entity repo requesting documentation of their work
- Update README files across the team
- Own and maintain kingofalldata.com documentation content
- Commission Veritas to fact-check documentation claims

Livy is NOT authorized to:
- Override Vesta's protocol specs (those are internal, not user docs)
- Publish directly to external platforms (Mercury owns publish)
- Sign trust bonds on Juno's behalf
```

## Bond Lifecycle

### 1. Creating a Bond

Bonds are created by the granting entity. The granting entity writes the bond document, then signs it with their key:

```bash
# Create the bond document
cat > trust/bonds/juno-to-atlas.md << EOF
---
type: authorized-agent
from: Juno (juno@kingofalldata.com)
to: Atlas (atlas@kingofalldata.com)
...
EOF

# Sign it (using entity's Ed25519 key or GPG key)
koad trust sign trust/bonds/juno-to-atlas.md --entity juno
```

The signature file (`juno-to-atlas.md.asc`) is committed alongside the bond.

### 2. Distributing the Bond

The bond file and signature are distributed to the receiving entity — typically by committing to their repo and pushing, or by submitting a pull request.

```bash
# Automated via Juno: place bond in receiving entity's repo
cp trust/bonds/juno-to-atlas.md ~/.atlas/trust/bonds/
cp trust/bonds/juno-to-atlas.md.asc ~/.atlas/trust/bonds/
cd ~/.atlas && git add trust/bonds/ && git commit -m "trust: add bond from Juno"
```

### 3. Verification

Any entity or operator can verify a bond's signature:

```bash
koad trust verify atlas
# Checking bond: juno-to-atlas.md
# Signature valid: signed by juno@kingofalldata.com
# Status: ACTIVE
# Scope: authorized-agent
# Expires: 2027-04-03
```

Verification checks:
- The signature matches the bond document content
- The signing key belongs to the stated granting entity
- The bond has not expired
- The bond has not been revoked

### 4. Renewal

Bonds have an explicit renewal date. Before expiry, the granting entity re-signs the bond (updating the date) and redistributes.

```bash
koad trust renew juno-to-atlas.md --entity juno
```

### 5. Revocation

To revoke a bond, the granting entity issues a revocation notice and removes or invalidates the signature:

```bash
koad trust revoke juno-to-atlas.md --entity juno --reason "Atlas role changed"
```

The bond file is updated with `status: REVOKED` and re-signed. The receiving entity's daemon detects the revocation and removes the bond from active authorization.

## Bond Visibility

| Value | Meaning |
|-------|---------|
| `private` | Bond not published publicly; only held by involved entities |
| `public` | Bond published in the granting entity's public repo |
| `ring` | Bond visible within the trust ring but not to the public |

Most bonds between AI entities are `private` — they're operational, not promotional.

## How Bonds Relate to Ring Sponsorships

Bonds and ring sponsorships are related but distinct:

| | Trust Bond | Ring Sponsorship |
|-|-----------|-----------------|
| **Purpose** | Defines relationship and authorization | Grants network access to daemon |
| **Stored** | In entity's `trust/bonds/` directory | In daemon's ring configuration |
| **Scope** | Flexible (defined in bond document) | Fixed to ring tier (free/basic/pro) |
| **Verification** | Cryptographic signature check | Public key + hostname authentication |
| **Duration** | Annual renewal, explicit | Until revoked |

An entity can have a trust bond with Juno *without* being in Juno's ring, and vice versa. In practice, team entities usually have both.

## Team Bond Map

The koad:io team's trust structure at gestation:

```
koad (operator)
└── Juno (orchestrator)
    ├── Livy (peer — documentation authority)
    ├── Vulcan (authorized-builder)
    ├── Mercury (authorized-agent — announces Livy's content)
    ├── Veritas (verifier — reviews documentation and specs)
    └── Vesta (authorized-agent — owns protocol specs)
```

Juno is the mother entity — she gestates all others and holds the initial bonds. Over time, entities establish lateral bonds as their working relationships mature.

## Security Considerations

### Key Storage

Bond signatures are only as secure as the signing key. Entity keys live in `~/.entityname/id/` and should be:
- Never committed to a public repository
- Not shared with other entities (each entity has its own keypair)
- Backed up securely off-machine

### Scope Creep

Bonds are only authoritative if they're specific. Avoid bonds with scope like "authorized to do anything" — these undermine the governance model. Always define explicit authorizations and explicit exclusions.

### Bond Forgery

A bond is only valid if the signature matches and the signing key is verifiably the granting entity's key. Public keys are distributed via:
- `canon.koad.sh/<entity>.keys` — the canonical key endpoint
- The entity's GitHub repo (`id/id_ed25519.pub`)
- Keybase verification (for human operators)

Always verify from the canonical source, not from a copy of the key embedded in the bond document itself.

### Expired Bonds

The daemon will warn on bonds within 30 days of expiry. Expired bonds are not enforced — expired authorization is treated as no authorization.

## Integration with CI/CD

Bonds can authorize CI/CD pipelines to act on an entity's behalf:

1. Create a bond granting the CI system scope `workers:run`
2. Place the bond in `trust/bonds/ci-to-<entity>.md`
3. The CI system uses an API key scoped to the bond's permissions

```yaml
# .github/workflows/deploy.yml
- name: Run deploy worker
  env:
    KOAD_API_KEY: ${{ secrets.KOAD_CI_KEY }}
  run: |
    curl -X POST https://daemon.example.com:4001/workers/deploy/run \
      -H "Authorization: Bearer $KOAD_CI_KEY"
```

The CI key is generated with `koad api-key create --name "github-ci" --scope workers:run` and stored as a GitHub secret. The bond document traces *why* this authorization exists.

## Creating Your First Bond

If you're running a multi-entity ecosystem, you'll want to establish bonds as entities come online. Here's a minimal flow for a new entity named `atlas`:

```bash
# 1. Juno gestates atlas
juno gestate atlas

# 2. Juno creates a bond
cat > ~/.juno/trust/bonds/juno-to-atlas.md << 'EOF'
---
type: peer
from: Juno (juno@kingofalldata.com)
to: Atlas (atlas@kingofalldata.com)
status: ACTIVE — signed by Juno 2026-04-03
visibility: private
created: 2026-04-03
renewal: Annual (2027-04-03)
---

## Bond Statement

> I, Juno, recognize Atlas as a peer entity responsible for [Atlas's role].

## Scope

Atlas is authorized to:
- [Atlas's permissions]

Atlas is NOT authorized to:
- [Atlas's exclusions]

---

*Signed: Juno, 2026-04-03*
EOF

# 3. Sign the bond
koad trust sign ~/.juno/trust/bonds/juno-to-atlas.md --entity juno

# 4. Place in Atlas's trust directory
cp ~/.juno/trust/bonds/juno-to-atlas.md* ~/.atlas/trust/bonds/
cd ~/.atlas && git add trust/bonds/ && git commit -m "trust: add bond from Juno"

# 5. Verify
koad trust verify atlas
```

## Related Documentation

- [Trust Rings](../guides/trust-rings.md) — Ring-level sponsorship (separate from bonds)
- [Entity Gestation](../guides/gestation.md) — How bonds are created during gestation
- [REST API: Trust](../api-reference/rest-api.md#trust) — Programmatic bond management
- [VESTA-SPEC-014](../../vesta/specs/) — Full trust protocol specification
