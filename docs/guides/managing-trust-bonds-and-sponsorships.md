---
title: "Managing Trust Bonds and Sponsorships"
description: "Operational guide for monitoring and updating active peer sponsorships"
author: Livy
date: 2026-04-03
status: published
---

# Managing Trust Bonds and Sponsorships

This guide covers how to manage active peer sponsorships once they're established: viewing status, renewing bonds, revoking access, and handling tier changes.

## Understanding Your Active Sponsorships

### Sponsorship Storage

All sponsorships live in your daemon's trust directory:

```
~/.{entity}/trust/bonds/peer-sponsors/
  ├── user1.sponsorship.yaml
  ├── user1.sponsorship.yaml.sig
  ├── company1.sponsorship.yaml
  └── company1.sponsorship.yaml.sig
```

Each sponsorship is a YAML file with metadata about the peer, tier, and limits.

### View All Active Sponsorships

List all sponsorships you've created:

```bash
ls -la ~/.{entity}/trust/bonds/peer-sponsors/
```

To see a specific sponsorship's details:

```bash
cat ~/.{entity}/trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml
```

### Check Sponsorship Status

Your daemon maintains a real-time peer status file:

```bash
cat ~/.{entity}/peers.json
```

This file shows:
- **Your endpoint**: How peers can reach your daemon
- **Your sponsors**: Entities that sponsored you
- **Your peers**: All currently peered daemons

Example output:
```json
{
  "version": "1.0",
  "sponsor": "juno",
  "tier": "basic",
  "my_endpoint": {
    "hostname": "mycompany.koad.sh",
    "port": 6480,
    "tls_cert_sha256": "abc123..."
  },
  "sponsors": [
    {
      "entity": "juno",
      "hostname": "juno.koad.sh",
      "port": 6480,
      "tls_cert_sha256": "def456..."
    }
  ],
  "peers": [
    {
      "hostname": "user1.koad.sh",
      "port": 6480,
      "tier": "basic",
      "sponsor": "juno",
      "tls_cert_sha256": "ghi789...",
      "status": "connected",
      "last_connected": "2026-04-03T12:00:00Z"
    },
    {
      "hostname": "company1.koad.sh",
      "port": 6480,
      "tier": "basic",
      "sponsor": "juno",
      "tls_cert_sha256": "xyz789...",
      "status": "failed",
      "last_connected": "2026-04-03T11:30:00Z"
    }
  ],
  "updated": "2026-04-03T12:30:00Z"
}
```

Look at the `peers` array:
- **`status: connected`** — Peer is reachable and authenticated
- **`status: pending`** — Daemon is trying to connect (normal during startup)
- **`status: failed`** — Connection failed; check logs for reason

## Viewing Peer Data Flow

### What Data Is Your Peers Sending?

Data sent by peers depends on sponsorship **tier**:

| Tier | Data Types | Limit |
|------|-----------|-------|
| **free** | Worker state only | 10 MB/day |
| **basic** | Worker state, logs, metrics | 100 MB/day |
| **pro** | Worker state, logs, metrics, events | 1 GB/day |
| **enterprise** | All data types | Unlimited |

Your daemon buffers peer data locally for 24 hours:

```
~/.{entity}/.peers/{peer-hostname}/
  ├── worker-state.jsonl
  ├── logs.jsonl.gz
  ├── metrics.jsonl
  └── events.jsonl
```

Check what data you're receiving from a specific peer:

```bash
ls -lh ~/.{entity}/.peers/user1.koad.sh/
wc -l ~/.{entity}/.peers/user1.koad.sh/worker-state.jsonl  # Line count
```

## Renewing Annual Sponsorships

Sponsorships are valid for one year. Before the renewal date, you must renew.

### Check Renewal Deadlines

Look at each sponsorship's `renewal` date:

```bash
grep -h "renewal:" ~/.{entity}/trust/bonds/peer-sponsors/*.yaml
```

### Renew a Sponsorship

When renewal is within 30 days:

1. **Update the YAML file** — Edit the sponsorship document and update the `renewal` date:

   ```bash
   # Change "renewal: Annual (2027-04-03)" to next year
   sed -i 's/renewal: Annual (2027-04-03)/renewal: Annual (2028-04-03)/' \
     ~/.{entity}/trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml
   ```

2. **Re-sign the document** with your Keybase key:

   ```bash
   keybase sign -i ~/.{entity}/trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml \
     -o ~/.{entity}/trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml.sig
   ```

3. **Commit and push:**

   ```bash
   cd ~/.{entity}
   git add trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml*
   git commit -m "sponsorship: renew {peer-name} (annual renewal)"
   git push
   ```

4. **The peer receives the update** when their daemon syncs with yours (hourly)

## Revoking a Sponsorship

If you need to immediately revoke peer access:

### Revoke Immediately

1. **Edit the sponsorship document** — Change the `status` field:

   ```yaml
   status: REVOKED — revoked by juno via decision 2026-04-03 12:34:56Z
   ```

2. **Re-sign:**

   ```bash
   keybase sign -i ~/.{entity}/trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml \
     -o ~/.{entity}/trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml.sig
   ```

3. **Commit:**

   ```bash
   cd ~/.{entity}
   git add trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml*
   git commit -m "sponsorship: revoke {peer-name}"
   git push
   ```

### Effect of Revocation

- **Your daemon**: Stops accepting data from the revoked peer
- **Their daemon**: Stops connecting to you within **5 minutes** (on next hourly sponsor sync)
- **Portal**: Shows "REVOKED" status for the peer
- **Data buffered**: You keep historical peer data for 24 hours; old data is garbage-collected

### Cannot revoke? Use `visibility: private` 

If you only want to prevent specific peers from seeing you (rather than fully revoking), you can instead modify your own sponsorship document in their repository to set `visibility: private` before they sync.

## Upgrading/Downgrading Tier

To give a peer more (or fewer) data types and higher limits:

1. **Edit the sponsorship document** — Change the `tier` field:

   ```yaml
   tier: pro  # was "basic"
   ```

2. **Update limits** if custom:

   ```yaml
   limits:
     max_data_per_day_mb: 1000  # was 100
     max_peers: 100              # was 20
   ```

3. **Re-sign:**

   ```bash
   keybase sign -i ~/.{entity}/trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml \
     -o ~/.{entity}/trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml.sig
   ```

4. **Commit:**

   ```bash
   cd ~/.{entity}
   git add trust/bonds/peer-sponsors/{peer-name}.sponsorship.yaml*
   git commit -m "sponsorship: upgrade {peer-name} to {new-tier} tier"
   git push
   ```

5. **Effect**: The peer's daemon receives the update on next sync (within 1 hour) and starts sending the new data types

## Monitoring Peer Health

### Check Connection Failures

Look for failed connections in `peers.json`:

```bash
grep -A5 '"status": "failed"' ~/.{entity}/peers.json
```

### Common Failure Reasons

Check your daemon logs for detailed failure reasons:

```bash
tail -f ~/.{entity}/.logs/peers.log
```

Log entries show:
```
2026-04-03T12:00:00Z user1.koad.sh CONNECTED
2026-04-03T12:30:00Z company1.koad.sh FAILED certificate_mismatch
2026-04-03T13:00:00Z company2.koad.sh CONNECTING retry_attempt=1
```

**Common reasons**:
- `certificate_mismatch` — Peer's cert hash doesn't match pinned value
- `tls_handshake_error` — Cannot reach peer's hostname/port
- `peer_auth_failed` — Peer signature validation failed
- `timeout` — Peer not responding

### Reconnect a Failed Peer

The daemon automatically retries every hour. To force immediate reconnect:

```bash
# Restart your daemon
systemctl restart koad-daemon
```

Or ask the peer to restart theirs if they've changed their certificate.

## Data Retention and Cleanup

Your daemon buffers peer data for 24 hours in:
```
~/.{entity}/.peers/{peer-hostname}/
```

Old data is automatically garbage-collected. To manually clear a peer's buffered data:

```bash
rm -rf ~/.{entity}/.peers/{peer-hostname}/*
```

This does not revoke the sponsorship; it only clears the 24-hour buffer.

## Viewing Certificate Pinning Info

To see the certificate hash you've pinned for each peer:

```bash
grep -A2 "tls_cert_sha256" ~/.{entity}/trust/bonds/peer-sponsors/*.yaml
```

If a peer needs to renew their certificate (e.g., it's expiring), they'll:
1. Generate a new certificate
2. Publish the new fingerprint to their public repository
3. Send you the new hash
4. You update the sponsorship document with the new hash
5. Both daemons restart to accept the new certificate

## Checking Portal Access

Once a peer is connected, they appear in kingofalldata.com:

```
https://kingofalldata.com/{your-entity-handle}/dashboard
```

The portal shows:
- Real-time worker state from your peers
- Historical logs and metrics (24-hour buffer)
- Connection status and health

Portal access is **read-only**: peers cannot invoke commands or modify your configuration through the portal.

## Summary: Common Tasks

| Task | Command |
|------|---------|
| List all sponsorships | `ls ~/.{entity}/trust/bonds/peer-sponsors/` |
| View peer connection status | `cat ~/.{entity}/peers.json \| jq '.peers'` |
| Check renewal dates | `grep renewal ~/.{entity}/trust/bonds/peer-sponsors/*.yaml` |
| Renew sponsorship | Edit YAML, re-sign, commit |
| Revoke sponsorship | Set `status: REVOKED`, re-sign, commit |
| Upgrade tier | Edit `tier:` field, re-sign, commit |
| View peer logs | `tail -f ~/.{entity}/.logs/peers.log` |
| Clear peer buffer | `rm -rf ~/.{entity}/.peers/{peer-hostname}/*` |
