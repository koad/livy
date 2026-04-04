---
title: "How to Sponsor a Peer Daemon"
description: "Connect your daemon to another user's daemon via sponsorship"
author: Livy
date: 2026-04-03
status: published
---

# How to Sponsor a Peer Daemon

This guide shows you how to sponsor another user's daemon, enabling live state sharing between your kingdom and theirs.

## What Peer Connectivity Means

When you sponsor a peer, you establish a **trust bond** that allows:
- **Live state flow**: Their daemon streams worker state, logs, and metrics to yours in real-time
- **Centralized visibility**: You can see all their activity through your dashboard
- **Tier-gated access**: What data flows depends on the sponsorship tier (free, basic, pro, enterprise)

Your daemon becomes the **sponsor** (the hub), and their daemon becomes the **peer**. Think of it as granting them access to your network while maintaining control over what data they can send you.

## Prerequisites

Before you begin:
1. **Both daemons must be running** on their respective machines
2. **You have the peer's entity name or domain** (e.g., `user1@example.com` or `company1.koad.sh`)
3. **You have access to commit to both git repositories**
4. **You have a Keybase identity** to sign the sponsorship document

## Step 1: Exchange Certificate Fingerprints

Each daemon has a **peer certificate** used for TLS authentication. Before creating a sponsorship, you must exchange and verify these certificates.

### What the peer needs to do

The peer (the one being sponsored) should:
1. Find their daemon's peer certificate fingerprint in `id/peer/certificate.fingerprint`
2. If this file doesn't exist, generate the fingerprint:
   ```bash
   openssl x509 -noout -fingerprint -sha256 -in ~/.{entity}/id/peer/certificate.pem | sed 's/.*=//;s/://g'
   ```
3. **Commit this fingerprint to their public entity repository** at `id/peer/certificate.fingerprint` (one hash value per file)
4. Send you the repository URL or hostname

### What you need to do

You (the sponsor) should:
1. Retrieve the peer's fingerprint from their public entity repository:
   ```bash
   PEER_CERT_HASH=$(curl -sf https://github.com/<peer-entity>/raw/main/id/peer/certificate.fingerprint)
   echo "Peer fingerprint: $PEER_CERT_HASH"
   ```

2. **Verify this fingerprint matches what they tell you** via a separate channel (Keybase, email, in-person, etc.)
3. **Save this fingerprint** — you'll use it in Step 3

**Why this matters**: The fingerprint exchange is your moment of human consent. You're verifying that the certificate you'll pin belongs to the peer you actually intend to sponsor. This cannot be automated.

## Step 2: Create the Sponsorship Document

Create a sponsorship document in your daemon's trust bonds directory:

```bash
mkdir -p ~/.{entity}/trust/bonds/peer-sponsors
```

Create the file `~/.{entity}/trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml`:

```yaml
---
type: sponsor
from: {your-entity-name} ({your-email})
to: {peer-entity-name} ({peer-domain-or-email})
status: ACTIVE
visibility: private
created: 2026-04-03
renewal: Annual (2027-04-03)
tier: basic
endpoints:
  - hostname: {peer-daemon-hostname}
    port: 6480
    tls_cert_sha256: {PEER_CERT_HASH}
limits:
  max_data_per_day_mb: 100
  max_peers: 10
---
```

Replace:
- `{your-entity-name}`: Your entity name (e.g., `juno`)
- `{your-email}`: Your email (e.g., `juno@kingofalldata.com`)
- `{peer-entity-name}`: The peer's entity name
- `{peer-domain-or-email}`: The peer's domain or email
- `{peer-daemon-hostname}`: The hostname or IP where their daemon is reachable (e.g., `company1.koad.sh`)
- `{PEER_CERT_HASH}`: The certificate fingerprint you exchanged in Step 1
- `tier`: Choose one: `free` (5 peers, 10 MB/day), `basic` (20 peers, 100 MB/day), `pro` (100 peers, 1 GB/day), `enterprise` (unlimited)

Example:
```yaml
---
type: sponsor
from: juno (juno@kingofalldata.com)
to: user1 (user1@example.com)
status: ACTIVE
visibility: private
created: 2026-04-03
renewal: Annual (2027-04-03)
tier: basic
endpoints:
  - hostname: user1.koad.sh
    port: 6480
    tls_cert_sha256: abc123def456789...
limits:
  max_data_per_day_mb: 100
  max_peers: 20
---
```

## Step 3: Sign the Sponsorship Document

Sign the file with your Keybase key to prove you authorized this sponsorship:

```bash
keybase sign -i ~/.{entity}/trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml \
  -o ~/.{entity}/trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml.sig
```

This creates a detached signature that proves you (the sponsor) created this document.

## Step 4: Share the Sponsorship with the Peer

The sponsorship needs to exist in **both repositories**:

1. **Commit to your repository:**
   ```bash
   cd ~/.{entity}
   git add trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml*
   git commit -m "sponsorship: add {peer-name} at {tier} tier"
   git push
   ```

2. **Share with the peer**: Send them the sponsorship file and signature (via email, Keybase, etc.)

3. **Peer commits to their repository:**
   They should place it at `~/.{entity}/trust/bonds/peer-sponsors/{your-name}.sponsorship.yaml` and commit it

## Step 5: Both Daemons Restart and Discover Each Other

Once both sponsorship documents are in place:

1. **Restart your daemon:**
   ```bash
   systemctl restart koad-daemon
   # or however your daemon is managed
   ```

2. **Peer restarts their daemon** (they'll do this when they see the sponsorship)

3. **Daemon discovery happens automatically:**
   - Your daemon reads the sponsorship document
   - It extracts the peer's endpoint (hostname, port)
   - It initiates a TLS connection using the pinned certificate hash
   - Both daemons exchange authentication messages
   - Your daemon starts receiving live state from the peer

4. **Check connection status:**
   ```bash
   cat ~/.{entity}/peers.json
   ```
   
   Look for the peer in the `peers` array with `"status": "connected"`.

## Troubleshooting

### "Connection failed: certificate mismatch"
- The peer's actual certificate hash doesn't match what you pinned
- **Fix**: Exchange certificates again and ensure you have the correct hash

### "Connection failed: TLS handshake error"
- The daemon hostname is unreachable or not responding on port 6480
- **Fix**: Verify the hostname is correct and that the peer daemon is running

### "Connection failed: peer auth failed"
- The peer's signature verification failed
- **Fix**: Ensure both sponsorship documents are present and signed correctly

### Peer doesn't see the sponsorship
- They may not have restarted their daemon yet
- **Fix**: Confirm they've received and committed the sponsorship file, then restart

## Next Steps

Once your peer is connected:
- **View their data** in your daemon's dashboard (tier-dependent)
- **Monitor health** via the `peers.json` status field
- **Update limits** by editing the sponsorship document and restarting
- **Renew annually** by updating the `renewal` date before it expires
