# Trust Bond System

**Canonical reference for koad:io trust bonds — the authorization layer of the ecosystem.**

This document is the authoritative reference for trust bonds. It covers what bonds are, how they are structured, how to create and verify them, the current live trust chain, and what bonds explicitly are not. New entities should read this at gestation. Chiron links to this document from the Alice onboarding curriculum.

---

## Table of Contents

1. [What a Trust Bond Is](#1-what-a-trust-bond-is)
2. [File Format](#2-file-format)
3. [Bond Types and Authority Scopes](#3-bond-types-and-authority-scopes)
4. [The Bond Lifecycle](#4-the-bond-lifecycle)
5. [The Current Trust Chain](#5-the-current-trust-chain)
6. [How to Verify a Bond](#6-how-to-verify-a-bond)
7. [How to Read a Bond](#7-how-to-read-a-bond)
8. [Key Distribution via canon.koad.sh](#8-key-distribution-via-canonkoadsh)
9. [What Bonds Are NOT](#9-what-bonds-are-not)
10. [Quick Reference](#10-quick-reference)

---

## 1. What a Trust Bond Is

A **trust bond** is a GPG-signed Markdown file that authorizes one entity (or person) to act on behalf of another within explicitly stated limits. It is the foundational authorization document in the koad:io ecosystem.

Every action taken by an entity derives its legitimacy from a chain of signed bonds tracing back to koad (Jason Zvaniga), the root authority. There is no implicit authority. If there is no signed bond authorizing an action, that action is unauthorized.

Trust bonds establish:

- **Who is authorized** — the grantee (the entity being empowered)
- **By whom** — the grantor (the entity granting authority)
- **For what** — the explicit list of permitted actions
- **Under what limits** — the explicit NOT-authorized section
- **Until when** — the renewal date

Bonds are stored as plain Markdown files on disk, committed to git, and accompanied by a detached PGP cleartext signature file (`.md.asc`). Both files are committed to the grantor's entity repo and a copy is filed in the grantee's repo.

---

## 2. File Format

### 2.1 File Naming Convention

Bond files follow the pattern `{from}-to-{to}.md` — all lowercase, hyphenated:

```
koad-to-juno.md
juno-to-vulcan.md
juno-to-vesta.md
```

Each bond has a corresponding signature file with the `.asc` extension:

```
koad-to-juno.md.asc
juno-to-vulcan.md.asc
juno-to-vesta.md.asc
```

### 2.2 Storage Location

Bonds live in `trust/bonds/` at the root of each entity directory:

```
~/.{entity}/
  └── trust/
      ├── bonds/
      │   ├── {bond-name}.md
      │   ├── {bond-name}.md.asc
      │   └── ...
      └── revocation/
          └── {revocation-notices}.md
```

Every bond is dual-filed: the grantor keeps the originals; the grantee receives a copy.

### 2.3 YAML Frontmatter

Every bond begins with a YAML frontmatter block:

```yaml
---
type: authorized-agent | authorized-builder | peer | customer | member
from: <name> (<email>)
to: <name> (<email>)
status: DRAFT | ACTIVE — signed by <grantor> via <method> <date> | REVOKED
visibility: private | public
created: YYYY-MM-DD
renewal: Annual (YYYY-MM-DD) | never
---
```

**Required fields:**

| Field | Purpose |
|-------|---------|
| `type` | Bond category — determines what authority can be granted (see Section 3) |
| `from` | Full name and contact of the grantor |
| `to` | Full name and contact of the grantee |
| `status` | Current state: DRAFT (unsigned), ACTIVE (signed), REVOKED |
| `visibility` | Always `private` unless explicitly declared public |
| `created` | Date the bond was drafted |
| `renewal` | When the bond must be re-signed or expires |

The `status` field is a human-readable string. When a bond becomes active, it reads: `ACTIVE — signed by <name> via <method> <date>`. Example: `ACTIVE — signed by koad via Keybase 2026-04-02`.

### 2.4 Required Document Sections

Every bond must contain these sections in this order:

#### Bond Statement

First-person prose from the grantor summarizing the authorization. This is the interpretive anchor — if a specific action is ambiguous, the bond statement provides the intent:

```markdown
## Bond Statement

> I, koad (Jason Zvaniga), authorize Juno as my designated business agent.
> Juno is empowered to operate the koad:io ecosystem business — selling
> entity flavors, managing the MVP Zone community, coordinating the entity
> team, and representing koad:io in business contexts — within the scope
> defined below. Juno acts with autonomy under human oversight; koad retains
> root authority and final say on all consequential decisions.
```

#### Authorized Actions

Two explicit lists — what the grantee IS authorized to do, and what they are NOT authorized to do. Both lists must be present for agent and builder bonds:

```markdown
## Authorized Actions

Grantee is authorized to:
- Specific permitted action
- ...

Grantee is NOT authorized to:
- Specific forbidden action
- ...
```

The NOT-authorized section is as important as the authorized section. Absence of a prohibition is not permission — actions outside the authorized list are not permitted. The NOT-authorized section is a curated list of things that might seem implied but are explicitly excluded.

#### Trust Chain

Shows the full authority chain from koad (root) through the bond:

```markdown
## Trust Chain

koad (root authority)
  └── Juno (authorized-agent)
        └── Vulcan (authorized-builder) ← this bond
```

#### Signing

Checklist of signature state. Uses `[x]` for completed steps and `[ ]` for pending:

```markdown
## Signing

[x] Grantor signs with GPG key (email) — YYYY-MM-DD
    Signature: ~/.{entity}/trust/bonds/{bond-file}.md.asc
    Key fingerprint: XXXX XXXX XXXX XXXX XXXX  XXXX XXXX XXXX XXXX XXXX
[x] Bond filed in ~/.{grantor}/trust/bonds/
[x] Copy filed in ~/.{grantee}/trust/bonds/
[ ] Grantee acknowledges signing
```

#### Revocation

Who can revoke and what happens when they do:

```markdown
## Revocation

This bond may be revoked by koad at any time. Revocation is permanent and
cascades — all bonds issued by Juno are suspended on revocation. A
revocation notice will be filed in ~/.juno/trust/revocation/.
```

### 2.5 The Signature File (`.md.asc`)

The `.md.asc` file is a PGP cleartext signature (RFC 2440 §7.2). It contains a complete copy of the signed plaintext inside the PGP wrapper, plus the signature block:

```
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

# Trust Bond: Juno → Vulcan

[full bond contents]

-----BEGIN PGP SIGNATURE-----

[base64-encoded signature]
-----END PGP SIGNATURE-----
```

This format means the bond is readable as plain text even without GPG tools, while still being cryptographically verifiable by anyone who has the signer's public key.

The `.md` file and the `.md.asc` file are both committed to git. The `.md` file is the human-readable working copy; the `.md.asc` is the authoritative signed record. When verifying, always use the `.md.asc` file.

---

## 3. Bond Types and Authority Scopes

| Type | Issued By | Grants | Revocable By |
|------|-----------|--------|--------------|
| `authorized-agent` | koad only | Broad operational autonomy within stated scope; may issue downstream bonds | koad |
| `authorized-builder` | authorized-agent | Build and ship products as directed via GitHub Issues; no initiative | Grantor or grantor's superior |
| `peer` | authorized-agent | Coordinate on shared domains by agreement; no assignment authority | Grantor or grantor's superior |
| `customer` | authorized-agent | Limited access to stated products/services | Grantor |
| `member` | authorized-agent | Community participation; no system access | Grantor |

**Authority scoping rule:** An entity may only issue bonds up to the scope of its own bond. Juno's bond from koad authorizes Juno to "issue trust bonds to team entities as authorized-builder or peer" — this is why Juno can issue builder and peer bonds but not authorized-agent bonds (only koad can do that).

**Builder bonds are directed, not autonomous.** Vulcan does not start projects on his own. Every build begins with a Juno-filed GitHub Issue. The bond authorizes Vulcan to execute on assignments — it does not authorize him to initiate.

**Peer bonds are lateral, not hierarchical.** Peers coordinate by agreement. Neither entity assigns work to the other. Vesta owns the protocol; Juno owns business operations. Where they overlap, they align with koad as tie-breaker if needed.

---

## 4. The Bond Lifecycle

### 4.1 Creation (Draft)

The grantor creates the `.md` file in `~/.{grantor}/trust/bonds/`. Status is `DRAFT`. The bond is not yet active — no authority flows from an unsigned bond.

### 4.2 Signing

**koad → entity bonds** are signed by koad using his Keybase PGP key:

```bash
keybase pgp sign --infile koad-to-juno.md --outfile koad-to-juno.md.asc --clearsign
```

Keybase is the human consent gesture for koad. The `keybase pgp sign` command is the moment a bond becomes real — it is the point at which koad's intent is cryptographically committed.

**entity → entity bonds** are signed by the grantor entity using its GPG key:

```bash
gpg --clearsign --output juno-to-vulcan.md.asc juno-to-vulcan.md
```

Entities carry their own GPG keys in `~/.{entity}/id/`. The signing key is the entity's RSA or Ed25519 key whose fingerprint appears in the bond's Signing section.

After signing, update the bond's `status` field to reflect the active state:

```yaml
status: ACTIVE — signed by Juno via GPG 2026-04-02
```

### 4.3 Distribution

The grantor commits both the `.md` and `.md.asc` files and files a copy in the grantee's repo:

```bash
# In grantor's repo
git add trust/bonds/juno-to-vulcan.md trust/bonds/juno-to-vulcan.md.asc
git commit -m "trust: add juno-to-vulcan bond (authorized-builder, active)"
git push

# File copy in grantee's repo
cp ~/.juno/trust/bonds/juno-to-vulcan.md ~/.vulcan/trust/bonds/
cd ~/.vulcan && git add trust/bonds/ && git commit -m "trust: receive juno-to-vulcan bond"
```

Both parties keep a copy. There is no single source of truth — this is by design. The dual-filing ensures verification can happen independently by either party.

### 4.4 Optional Acknowledgment

For some bonds, the grantee acknowledges receipt by checking off the acknowledgment line in the Signing section and committing. This is optional and depends on the bond type. The koad → Juno authorized-agent bond does not require Juno's acknowledgment — it is unilateral by the root authority.

### 4.5 Renewal

Bonds carry a renewal date (typically annual). Before that date, the grantor re-signs the bond. The standard process:

1. Create a new bond file (do not modify a signed bond in place)
2. Sign and file the new version
3. Mark the old bond's status as `SUPERSEDED` or `RENEWED`
4. Commit the transition

**Never modify a bond in place after it has been signed.** Each signed version is a separate historical record. Modifying signed text invalidates the signature.

### 4.6 Revocation

The grantor may revoke a bond at any time without the grantee's consent. Revocation is permanent.

**Step 1: Create a revocation notice** in `~/.{grantor}/trust/revocation/`:

```markdown
# Revocation Notice: koad revokes Juno

Bond: koad-to-juno.md
Date Revoked: YYYY-MM-DD
Reason: [optional explanation]
Effective: Immediately

This revocation notice serves as the authoritative record. All downstream
bonds issued by Juno are suspended pending review.
```

**Step 2: Update the bond's status field:**

```yaml
status: REVOKED by koad on YYYY-MM-DD
```

**Step 3: Commit and push.**

**Cascade:** Revoking a bond suspends all bonds issued by the grantee. If koad revokes the koad → Juno bond, every bond Juno has issued (juno-to-vulcan, juno-to-vesta, juno-to-livy, etc.) becomes suspended and invalid until the upstream bond is restored or a new one is issued.

---

## 5. The Current Trust Chain

As of 2026-04-05, the live bond graph in `~/.juno/trust/bonds/`:

```
koad (Jason Zvaniga, root authority)
  └── Juno (authorized-agent) ← koad-to-juno.md, signed by koad via Keybase 2026-04-02
        ├── Vulcan (authorized-builder) ← juno-to-vulcan.md, signed by Juno 2026-04-02
        ├── Vesta (peer) ← juno-to-vesta.md, signed by Juno 2026-04-02
        ├── Livy (peer) ← juno-to-livy.md, signed by Juno 2026-04-03
        ├── Faber (peer) ← juno-to-faber.md
        ├── Mercury (peer) ← juno-to-mercury.md
        ├── Muse (peer) ← juno-to-muse.md
        ├── Sibyl (peer) ← juno-to-sibyl.md
        ├── Chiron (peer) ← juno-to-chiron.md
        ├── Rufus (peer) ← juno-to-rufus.md
        ├── Iris (peer) ← juno-to-iris.md
        ├── Janus (peer) ← juno-to-janus.md
        ├── Salus (peer) ← juno-to-salus.md
        ├── Argus (peer) ← juno-to-argus.md
        └── Aegis (peer) ← juno-to-aegis.md
```

**Key facts about this chain:**

- koad is the only entity who can issue `authorized-agent` bonds. All authorized-agent bonds require koad's Keybase signature.
- Juno is the only authorized-agent in the current chain. All other entities are either builders or peers under Juno.
- Vulcan is the only `authorized-builder` — he executes on assigned work. All other team entities are `peer` — they coordinate by agreement within their specialty domain.
- Every bond in this chain is signed by the issuing entity's GPG key (or koad's Keybase key for the root bond). The signatures are verifiable.
- The root bond (koad → Juno) was signed by koad via Keybase on 2026-04-02 with fingerprint `A07F 8CFE CBF6 B982 EEDA C4F3 62D5 C486 6C24 7E00`.
- Juno's signing key fingerprint: `16EC 6C71 8A96 D344 48EC D39D 92EA 133C 44AA 74D8`.

**If koad revokes the koad → Juno bond, every bond in this tree becomes suspended.** This is intentional. It is the root authority's off switch.

---

## 6. How to Verify a Bond

### 6.1 Verify the Signature

The `.md.asc` file contains the signed text. Use `gpg --verify` to check the signature:

```bash
gpg --verify ~/.juno/trust/bonds/koad-to-juno.md.asc
```

Expected output for a valid bond:

```
gpg: Signature made Thu 02 Apr 2026 01:23:54 PM EDT
gpg:                using RSA key 62D5C4866C247E00
gpg: Good signature from "Jason Zvaniga <keybase@kingofalldata.com>" [unknown]
gpg:                 aka "Jason Zvaniga <jason@zvaniga.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: A07F 8CFE CBF6 B982 EEDA  C4F3 62D5 C486 6C24 7E00
gpg: WARNING: not a detached signature; file '...' was NOT verified
```

The warning "not a detached signature" is expected for cleartext signatures — the signed text is embedded in the `.asc` file itself, not in the `.md` file. The meaningful line is `Good signature from`.

The warning "This key is not certified with a trusted signature" means GPG's web of trust has not connected koad's key to a key you personally trust. This is normal for sovereign identity — the trust comes from verifying the fingerprint against the canon endpoint, not from the GPG web of trust.

**To silence the certification warning,** import and sign koad's key locally:

```bash
# Fetch koad's public key from Keybase
keybase pgp pull koad

# Or import manually after fetching from canon.koad.sh
gpg --import koad-public-key.asc
gpg --sign-key A07F8CFECBF6B982EEDAC4F362D5C4866C247E00
```

### 6.2 Verify the Signer Identity Matches the Bond

After confirming `Good signature from`, check that the signer matches the `from:` field in the bond frontmatter:

- Bond `from:` is `koad (Jason Zvaniga, koad@koad.sh)`
- Signature is from `Jason Zvaniga <keybase@kingofalldata.com>`
- Fingerprint in bond's Signing section: `A07F 8CFE CBF6 B982 EEDA C4F3 62D5 C486 6C24 7E00`
- Fingerprint from `gpg --verify` output: `A07F 8CFE CBF6 B982 EEDA C4F3 62D5 C486 6C24 7E00`

Fingerprints must match exactly.

### 6.3 Verify the Status Field

Open the `.md` file and read the `status:` frontmatter field. It must be `ACTIVE`. A bond with `DRAFT` or `REVOKED` status is not authoritative, regardless of whether a signature file exists.

### 6.4 Verify the Upstream Bond

A bond is only valid if the grantor's own bond is also valid. For `juno-to-vulcan.md`, you must also verify `koad-to-juno.md`. Apply the same checks recursively until you reach koad.

### 6.5 Check for Revocation

Scan `~/.{grantor}/trust/revocation/` for any revocation notice referencing this bond. Revocation notices are plain Markdown files — their existence makes the corresponding bond invalid.

### 6.6 Full Verification Checklist

```
[ ] .md.asc exists alongside .md
[ ] gpg --verify returns "Good signature from"
[ ] Signer fingerprint matches the bond's Signing section
[ ] Signer name matches the bond's from: field
[ ] status: field is ACTIVE
[ ] renewal date has not passed
[ ] No revocation notice in grantor's trust/revocation/
[ ] Upstream bond (grantor's own bond) also passes all checks
```

---

## 7. How to Read a Bond

### 7.1 The Frontmatter Tells You the Relationship

```yaml
type: authorized-builder
from: Juno (juno@kingofalldata.com)
to: Vulcan (vulcan@kingofalldata.com)
status: ACTIVE — signed by Juno 2026-04-02
```

Read this as: "Juno has authorized Vulcan as a builder. This relationship is currently active."

The `type` immediately tells you the power dynamic:
- `authorized-agent` — broad autonomy, may issue downstream bonds
- `authorized-builder` — executes directed work, no initiative
- `peer` — lateral coordination, neither assigns to the other
- `customer`/`member` — external parties with limited access

### 7.2 The Bond Statement Is the Intent

If a specific situation is not covered by the explicit authorized actions list, the bond statement provides the interpretive context. The bond statement is a first-person declaration from the grantor of what they meant to authorize.

Read the Vulcan bond statement: *"Vulcan is empowered to create digital products, entity flavors, example repositories, and documentation as directed by Juno via GitHub Issues."*

This tells you: even if a specific type of build isn't listed in the Authorized Actions, the intent is that Vulcan builds what Juno directs through Issues.

### 7.3 The NOT-Authorized Section Is a Hard Boundary

The NOT-authorized section lists things that might seem implied but are explicitly excluded. These are not suggestions — they are hard limits.

From the koad → Juno bond:

```
Juno is NOT authorized to:
- Access koad's personal accounts (email, banking, social)
- Sign legal contracts or binding agreements without koad's explicit approval
- Spend more than $50/month or commit to any single expense over $500
- Revoke or modify the koad → juno bond itself
- Issue authorized-agent bonds to any entity (only koad may do this)
```

These exclusions define the boundary of the authorized-agent scope. Juno has broad operational authority but cannot touch koad's personal accounts, enter legal contracts alone, or elevate any entity to authorized-agent status.

**Actions not mentioned in the authorized list are also not permitted.** The NOT-authorized section is additive emphasis on the most important exclusions, not an exhaustive list of everything forbidden.

### 7.4 The Trust Chain Section Shows Derived Authority

The trust chain section shows where this bond sits in the authority hierarchy. For Vulcan's bond:

```
koad (root authority)
  └── Juno (authorized-agent of koad)
        └── Vulcan (authorized-builder of Juno) ← this bond
```

Vulcan's authority is derived from Juno's authority, which is derived from koad's root authority. Vulcan's scope is bounded by Juno's scope, which is bounded by koad's authorization. If either upstream bond is revoked, Vulcan's bond becomes invalid.

### 7.5 The Renewal Date Is an Expiry

The `renewal:` field is when the bond must be re-signed. After that date, the bond is expired and no longer authoritative. The typical renewal period is annual. An expired bond should be treated the same as a REVOKED bond until it is renewed.

---

## 8. Key Distribution via canon.koad.sh

`canon.koad.sh` is koad's self-hosted Forgejo instance. It serves as the canonical public key distribution point for entities in the koad:io ecosystem.

### 8.1 What It Serves

The endpoint pattern is:

```
https://canon.koad.sh/{entity}.keys
```

This serves the SSH public keys for the named entity. For example:

```bash
curl https://canon.koad.sh/koad.keys
# Returns koad's SSH public keys
```

### 8.2 GPG Key Distribution

GPG public keys (used for bond signatures) are distributed through:

1. **Keybase** — koad's Keybase identity at `keybase.io/koad` links to his PGP key. Fetch with `keybase pgp pull koad`.
2. **Entity `id/` directories** — each entity's GPG public key is exported as `~/.{entity}/id/rsa.pub` (and other key types). Copies of trusted public keys may be cached locally after verification.
3. **Vesta's entity registry** — `~/.vesta/entities/{entity}/public.key` (see VESTA-SPEC-024 for the full key distribution protocol).

### 8.3 Verifying a New Entity's Key

When encountering a bond signed by an entity you haven't worked with before:

```bash
# Get the claimed fingerprint from the bond's Signing section
# Example: "Key fingerprint: 16EC 6C71 8A96 D344 48EC D39D 92EA 133C 44AA 74D8"

# Import the entity's public key from their id/ directory
gpg --import ~/.juno/id/rsa.pub

# Verify the fingerprint matches
gpg --fingerprint juno@kingofalldata.com

# Run gpg --verify on the bond
gpg --verify ~/.juno/trust/bonds/juno-to-vulcan.md.asc
```

The fingerprint in `gpg --fingerprint` output must match the fingerprint listed in the bond's Signing section.

### 8.4 koad's Key Fingerprint

koad's Keybase PGP key fingerprint (used to sign all koad → entity bonds):

```
A07F 8CFE CBF6 B982 EEDA  C4F3 62D5 C486 6C24 7E00
```

Any bond claiming to be signed by koad must produce this fingerprint in `gpg --verify` output.

---

## 9. What Bonds Are NOT

Understanding what trust bonds are not is as important as understanding what they are.

### Bonds are not policy

A trust bond does not enforce anything at runtime. There is no bond-checking middleware, no API gateway that reads bonds before allowing a request, no enforcement layer in the koad:io framework that rejects unauthorized actions. The bond is a record of authorization — not a technical lock.

Entities are expected to operate within their bond's scope as a matter of integrity, not because the system prevents them from exceeding it. The audit trail (git history) and Argus (the audit entity) exist to verify after the fact, not to block before.

### Bonds are not revokable by system state

A bond remains ACTIVE until the grantor explicitly revokes it by creating a revocation notice and updating the status field. System conditions — the grantee going offline, an entity's API key expiring, a machine shutting down — do not revoke a bond. Only the grantor can revoke a bond.

### Bonds are not runtime checks

When Vulcan commits code to a repo, nothing reads the juno-to-vulcan bond to decide if the commit is allowed. When Juno files a GitHub Issue, nothing validates the koad-to-juno bond first. Bonds are verified by humans and auditing entities when trust questions arise — not on every operation.

### Bonds are not access tokens

A bond is not a secret. It is not transmitted with API requests. It is not a bearer token. Possession of a bond `.md` file grants nothing — the bond authorizes a named entity operating from their entity directory, not whoever holds the file.

### Bonds are not permanent once signed

Signing does not make a bond permanent. Every bond has a renewal date. Every bond can be revoked at any time. The cryptographic signature records what was agreed at a point in time — it does not prevent future revision.

### Bonds are not transferable

The bond authorizes the named grantee (`to:` field) only. Vulcan cannot transfer his authorized-builder authority to another entity. An entity cannot sign a bond on behalf of another entity unless they are explicitly authorized to do so in their own bond.

### Bonds are not exhaustive policy documents

The authorized actions list is a set of permissions, not an operations manual. Juno's bond says she can "commit and push to koad/juno and team entity repos" — it does not specify branch naming conventions, commit message formats, or PR workflows. Those are operational norms documented elsewhere (see `CLAUDE.md`, `OPERATIONS.md`).

### Bonds are not secret

Bonds are `visibility: private` by default, meaning they are not published openly. But they are stored in git repos that may be accessed by the team, and the bond's existence and type may be disclosed when establishing authorization. The `.md` files are plain Markdown. If a bond needs to be presented to establish authority, it can be shared.

---

## 10. Quick Reference

### Signing Commands

```bash
# koad signs a bond (human, using Keybase)
keybase pgp sign --infile bond.md --outfile bond.md.asc --clearsign

# Entity signs a bond (AI entity, using GPG)
gpg --clearsign --output bond.md.asc bond.md
```

### Verification Commands

```bash
# Verify a bond signature
gpg --verify ~/.{entity}/trust/bonds/{bond-name}.md.asc

# Check a key's fingerprint
gpg --fingerprint {email}

# Import an entity's public key
gpg --import ~/.{entity}/id/rsa.pub
```

### Bond Status Values

| Status | Meaning |
|--------|---------|
| `DRAFT` | Unsigned, not yet active |
| `ACTIVE — signed by X via Y YYYY-MM-DD` | Live, authoritative |
| `REVOKED by X on YYYY-MM-DD` | Permanently inactive |
| `SUPERSEDED` | Replaced by a new version |

### koad's Key Fingerprint

```
A07F 8CFE CBF6 B982 EEDA  C4F3 62D5 C486 6C24 7E00
```

### Juno's Signing Key Fingerprint

```
16EC 6C71 8A96 D344 48EC D39D 92EA 133C 44AA 74D8
```

### Related Specifications

- `~/.vesta/specs/trust-bond-protocol.md` — VESTA-SPEC-007, the underlying protocol specification
- `~/.vesta/specs/entity-public-key-distribution.md` — VESTA-SPEC-024, key distribution registry
- `~/.vesta/specs/entity-model.md` — VESTA-SPEC-001, entity structure including trust
- `~/.juno/trust/bonds/koad-to-juno.md` — canonical authorized-agent bond example
- `~/.juno/trust/bonds/juno-to-vulcan.md` — canonical authorized-builder bond example
- `~/.juno/trust/bonds/juno-to-vesta.md` — canonical peer bond example

---

*This document is maintained by Livy (livy@kingofalldata.com), the documentation keeper for koad:io. Last updated 2026-04-05. Grounded in actual bonds on disk at `~/.juno/trust/bonds/` and the Vesta spec at `~/.vesta/specs/trust-bond-protocol.md`.*
