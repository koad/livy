---
title: "Connecting Multiple Kingdoms: A Tutorial"
description: "Step-by-step walkthrough of connecting your first peer daemon ring"
author: Livy
date: 2026-04-03
status: published
---

# Connecting Multiple Kingdoms: A Tutorial

In this tutorial, we'll walk through connecting two kingdoms: **Koad's kingdom** (the sponsor, running on machine "thinker") and **Alice's kingdom** (the peer, running on machine "alice-laptop"). By the end, Alice's worker state will be flowing to Koad's daemon in real-time.

## Overview

Here's what we're building:
```
Koad (sponsor)
  └── Alice (peer, basic tier)
      ├── Worker 1 (running)
      ├── Worker 2 (running)
      └── Worker 3 (idle)
```

The flow: Alice's daemon → Koad's daemon (TLS) → Koad's dashboard shows Alice's workers.

## Prerequisites

- Koad's daemon running on `thinker.koad.sh` with entity name `koad`
- Alice's daemon running on `alice.koad.sh` with entity name `alice`
- Both machines reachable via their hostnames
- Both have Keybase identities (koad@keybase and alice@keybase)

## Step 1: Exchange and Verify Certificate Fingerprints

### Alice's Side

Alice generates her daemon's peer certificate fingerprint and publishes it.

Alice's daemon already has a peer certificate at:
```
~/.alice/id/peer/certificate.pem
```

Alice computes the SHA256 fingerprint:
```bash
alice@alice-laptop:~$ openssl x509 -noout -fingerprint -sha256 \
  -in ~/.alice/id/peer/certificate.pem | sed 's/.*=//;s/://g'
a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0
```

Alice commits this fingerprint to her public entity repository:
```bash
alice@alice-laptop:~$ cd ~/.alice
alice@alice-laptop:~/.alice$ echo "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0" > id/peer/certificate.fingerprint
alice@alice-laptop:~/.alice$ git add id/peer/certificate.fingerprint
alice@alice-laptop:~/.alice$ git commit -m "id: publish peer certificate fingerprint"
alice@alice-laptop:~/.alice$ git push
```

Alice sends Koad a message on Keybase:
> "I've published my peer cert fingerprint at https://github.com/alice/alice/blob/main/id/peer/certificate.fingerprint"

### Koad's Side

Koad retrieves and verifies Alice's fingerprint:
```bash
koad@thinker:~$ ALICE_CERT_HASH=$(curl -sf https://raw.githubusercontent.com/alice/alice/main/id/peer/certificate.fingerprint)
koad@thinker:~$ echo "Alice's fingerprint: $ALICE_CERT_HASH"
Alice's fingerprint: a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0
```

Koad verifies with Alice over Keybase:
> "I have your fingerprint: a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0 — is that correct?"

Alice confirms it's correct.

## Step 2: Create the Sponsorship Document

Koad creates a sponsorship document in her trust directory:

```bash
koad@thinker:~$ mkdir -p ~/.koad/trust/bonds/peer-sponsors
koad@thinker:~$ cat > ~/.koad/trust/bonds/peer-sponsors/alice.sponsorship.yaml << 'EOF'
---
type: sponsor
from: koad (koad@kingofalldata.com)
to: alice (alice@example.com)
status: ACTIVE
visibility: private
created: 2026-04-03
renewal: Annual (2027-04-03)
tier: basic
endpoints:
  - hostname: alice.koad.sh
    port: 6480
    tls_cert_sha256: a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0
limits:
  max_data_per_day_mb: 100
  max_peers: 20
---
EOF
```

Koad verifies the file:
```bash
koad@thinker:~$ cat ~/.koad/trust/bonds/peer-sponsors/alice.sponsorship.yaml
---
type: sponsor
from: koad (koad@kingofalldata.com)
to: alice (alice@example.com)
status: ACTIVE
visibility: private
created: 2026-04-03
renewal: Annual (2027-04-03)
tier: basic
endpoints:
  - hostname: alice.koad.sh
    port: 6480
    tls_cert_sha256: a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0
limits:
  max_data_per_day_mb: 100
  max_peers: 20
---
```

## Step 3: Sign the Sponsorship

Koad signs the document with her Keybase key:
```bash
koad@thinker:~$ keybase sign -i ~/.koad/trust/bonds/peer-sponsors/alice.sponsorship.yaml \
  -o ~/.koad/trust/bonds/peer-sponsors/alice.sponsorship.yaml.sig

# Verify the signature exists
koad@thinker:~$ ls -la ~/.koad/trust/bonds/peer-sponsors/alice.sponsorship.*
-rw-r--r-- 1 koad koad 500 Apr  3 12:00 ~/.koad/trust/bonds/peer-sponsors/alice.sponsorship.yaml
-rw-r--r-- 1 koad koad 750 Apr  3 12:01 ~/.koad/trust/bonds/peer-sponsors/alice.sponsorship.yaml.sig
```

## Step 4: Commit and Push (Koad's Side)

Koad commits the sponsorship to her repository:
```bash
koad@thinker:~$ cd ~/.koad
koad@thinker:~/.koad$ git add trust/bonds/peer-sponsors/alice.sponsorship.yaml*
koad@thinker:~/.koad$ git commit -m "sponsorship: add alice at basic tier"
[main abc1234] sponsorship: add alice at basic tier
 2 files changed, 14 insertions(+)
koad@thinker:~/.koad$ git push
```

## Step 5: Alice Commits the Sponsorship (Peer's Side)

Koad sends Alice the sponsorship files via email or Keybase.

Alice commits them to her repository:
```bash
alice@alice-laptop:~$ mkdir -p ~/.alice/trust/bonds/peer-sponsors
alice@alice-laptop:~$ # Save the files Koad sent
alice@alice-laptop:~$ cp ~/Downloads/alice.sponsorship.yaml* ~/.alice/trust/bonds/peer-sponsors/
alice@alice-laptop:~$ cd ~/.alice
alice@alice-laptop:~/.alice$ git add trust/bonds/peer-sponsors/alice.sponsorship.yaml*
alice@alice-laptop:~/.alice$ git commit -m "sponsorship: receive koad sponsorship at basic tier"
[main def5678] sponsorship: receive koad sponsorship at basic tier
 2 files changed, 14 insertions(+)
alice@alice-laptop:~/.alice$ git push
```

## Step 6: Restart Both Daemons

Now both daemons need to reload their sponsorship configurations.

### Koad Restarts:
```bash
koad@thinker:~$ systemctl restart koad-daemon
# or: sudo systemctl restart koad-daemon
# (depending on how the daemon is managed)
```

### Alice Restarts:
```bash
alice@alice-laptop:~$ systemctl restart koad-daemon
```

## Step 7: Verify Connection

Let's check that the daemons have discovered each other.

### Check Koad's Peer List

Koad checks her `peers.json` to see if Alice is connected:
```bash
koad@thinker:~$ cat ~/.koad/peers.json | jq '.peers[]'
{
  "hostname": "alice.koad.sh",
  "port": 6480,
  "tier": "basic",
  "sponsor": "koad",
  "tls_cert_sha256": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0",
  "status": "connected",
  "last_connected": "2026-04-03T12:30:00Z"
}
```

**Great!** Alice is connected. The `status: connected` means:
- Koad's daemon successfully initiated a TLS connection to Alice's daemon on `alice.koad.sh:6480`
- Koad verified Alice's certificate hash matches the pinned value
- Alice's daemon authenticated Koad with a signed auth message
- Both daemons exchanged capability info

### Check Alice's Peer List

Alice can also verify the sponsorship from her side:
```bash
alice@alice-laptop:~$ cat ~/.alice/peers.json | jq '.sponsors[]'
{
  "entity": "koad",
  "hostname": "thinker.koad.sh",
  "port": 6480,
  "tls_cert_sha256": "xyz789..."
}
```

Alice's daemon shows that Koad is her sponsor, which matches the sponsorship document.

## Step 8: Watch Data Flow

Now worker state flows from Alice's daemon to Koad's daemon. Let's verify.

### Koad Sees Alice's Data

Koad's daemon buffers Alice's data for 24 hours in:
```bash
koad@thinker:~$ ls ~/.koad/.peers/alice.koad.sh/
events.jsonl
logs.jsonl.gz
metrics.jsonl
worker-state.jsonl
```

Let's check worker state:
```bash
koad@thinker:~$ head -3 ~/.koad/.peers/alice.koad.sh/worker-state.jsonl
{"worker_id":"w-alice-1","status":"running","uptime_seconds":7200,"memory_mb":256,"cpu_percent":15.2,"last_heartbeat":"2026-04-03T12:30:00Z"}
{"worker_id":"w-alice-2","status":"running","uptime_seconds":3600,"memory_mb":512,"cpu_percent":8.5,"last_heartbeat":"2026-04-03T12:30:01Z"}
{"worker_id":"w-alice-3","status":"idle","uptime_seconds":0,"memory_mb":128,"cpu_percent":0.0,"last_heartbeat":"2026-04-03T12:29:59Z"}
```

Perfect! Koad can see:
- Worker 1: running, 2 hours uptime, 256 MB, 15.2% CPU
- Worker 2: running, 1 hour uptime, 512 MB, 8.5% CPU
- Worker 3: idle (not currently processing)

### Metrics Are Flowing

Metrics also stream to Koad:
```bash
koad@thinker:~$ tail -1 ~/.koad/.peers/alice.koad.sh/metrics.jsonl
{"cpu_percent":23.4,"memory_mb":1024,"disk_free_gb":45.2,"network_in_mbps":2.1,"network_out_mbps":1.8,"worker_count":3,"timestamp":"2026-04-03T12:30:00Z"}
```

Alice's daemon is using 23.4% CPU, 1 GB of RAM, has 3 workers running, and is using ~2 Mbps inbound / 1.8 Mbps outbound.

### Logs Flow (Basic Tier)

Since we chose `basic` tier, logs also flow:
```bash
koad@thinker:~$ zcat ~/.koad/.peers/alice.koad.sh/logs.jsonl.gz | head -2
{"level":"INFO","message":"Worker w-alice-1 started","timestamp":"2026-04-03T12:00:00Z"}
{"level":"INFO","message":"Worker w-alice-2 started","timestamp":"2026-04-03T12:01:00Z"}
```

## Step 9: View in Portal

Once connected, the data also appears in the kingofalldata.com dashboard:

```
https://kingofalldata.com/koad/dashboard
```

Koad logs in and sees:
- **Connected Peers**: Alice (basic tier, connected)
- **Real-time Workers**: All 3 workers from Alice's daemon
- **Metrics**: CPU, memory, disk usage from Alice's machine
- **Logs**: Recent log entries from Alice's daemon

The portal is **read-only**: Koad can see everything Alice is doing, but cannot:
- Invoke commands on Alice's machines
- Modify Alice's configuration
- Start or stop workers

## Step 10 (Optional): Upgrade to Pro Tier

Let's say after a week, Koad wants to give Alice access to event streams. She upgrades the tier.

Koad edits the sponsorship:
```bash
koad@thinker:~$ sed -i 's/tier: basic/tier: pro/' ~/.koad/trust/bonds/peer-sponsors/alice.sponsorship.yaml
```

She re-signs:
```bash
koad@thinker:~$ keybase sign -i ~/.koad/trust/bonds/peer-sponsors/alice.sponsorship.yaml \
  -o ~/.koad/trust/bonds/peer-sponsors/alice.sponsorship.yaml.sig
```

And commits:
```bash
koad@thinker:~$ cd ~/.koad
koad@thinker:~/.koad$ git add trust/bonds/peer-sponsors/alice.sponsorship.yaml*
koad@thinker:~/.koad$ git commit -m "sponsorship: upgrade alice to pro tier"
koad@thinker:~/.koad$ git push
```

On the next sync (within 1 hour), Alice's daemon receives the upgrade and starts sending event data:
```bash
koad@thinker:~$ head -1 ~/.koad/.peers/alice.koad.sh/events.jsonl
{"event":"worker_started","worker_id":"w-alice-4","timestamp":"2026-04-03T13:00:00Z"}
```

## Summary: What Happened

1. **Fingerprint exchange**: Koad verified Alice's certificate before creating sponsorship
2. **Sponsorship created**: Koad created a YAML document describing the trust relationship
3. **Signed & committed**: Both stored the signed sponsorship in their repositories
4. **Daemons discovered**: On restart, both daemons read the sponsorship and initiated TLS connection
5. **Data flows**: Alice's daemon streams worker state, logs, and metrics to Koad
6. **Portal connected**: Kingofalldata.com now shows Alice's data in Koad's dashboard
7. **Tier upgrade**: Koad upgraded to pro tier without any downtime — just edited + re-signed + committed

The entire process is **cryptographically verified**: Every sponsorship is signed, every peer connection is TLS-pinned, and every daemon authentication is signature-verified.

## Next Steps

- **Add more peers**: Repeat steps 1-7 for other kingdoms
- **Monitor health**: Use `~/.koad/peers.json` to check peer connection status
- **Renew annually**: Before the `renewal` date, update and re-sign the sponsorship
- **Revoke if needed**: Change `status: REVOKED` and re-sign to immediately cut off peer access
