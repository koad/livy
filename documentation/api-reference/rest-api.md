# REST API Reference

koad:io exposes a local REST API at `http://localhost:4001` (configurable via `koad config set api_port`).

All requests must include an `Authorization` header with a valid API key:

```
Authorization: Bearer <api-key>
```

Generate a key with `koad api-key create`. The daemon also accepts a special `localhost` key for development — configure with `koad config set allow_localhost_no_auth=true` (disabled by default).

---

## Authentication

### Request format

```http
GET /status HTTP/1.1
Host: localhost:4001
Authorization: Bearer koad_key_xxxxxxxx
Accept: application/json
```

### Error responses

| Code | Meaning |
|------|---------|
| `401` | Missing or invalid API key |
| `403` | Key lacks required scope |
| `404` | Resource not found |
| `409` | Conflict (e.g., worker already running) |
| `500` | Internal daemon error |

Error body:
```json
{
  "error": "forbidden",
  "message": "API key lacks scope 'workers:run'",
  "code": 403
}
```

---

## Daemon

### GET /status

Returns current daemon state.

**Response:**
```json
{
  "status": "running",
  "pid": 12345,
  "uptime_seconds": 3600,
  "version": "1.0.0",
  "workers": {
    "running": 2,
    "idle": 5,
    "failed": 1
  },
  "ring": {
    "connected": true,
    "name": "koad-main",
    "peers": 12,
    "sponsor": "juno@koad.io",
    "tier": "basic"
  },
  "portal": "https://kingofalldata.com/alice-example-com"
}
```

### GET /health

Lightweight health check for load balancers and uptime monitors.

**Response:**
```json
{
  "status": "ok"
}
```

Returns `503` if the daemon is degraded.

### GET /metrics

Prometheus-compatible metrics endpoint.

**Response:** text/plain in Prometheus exposition format.

---

## Workers

### GET /workers

List all workers.

**Query parameters:**

| Param | Values | Description |
|-------|--------|-------------|
| `status` | `running`, `idle`, `failed`, `all` | Filter by status (default: `all`) |
| `entity` | entity name | Filter by entity |

**Response:**
```json
{
  "workers": [
    {
      "name": "hello-world",
      "entity": "alice",
      "status": "idle",
      "command": "node workers/hello-world.js",
      "description": "Hello world example",
      "last_run": "2026-04-03T18:00:00Z",
      "last_exit_code": 0,
      "last_duration_ms": 312,
      "enabled": true
    }
  ]
}
```

### GET /workers/:name

Get a single worker's state.

### POST /workers/:name/run

Trigger a worker run.

**Request body (optional):**
```json
{
  "env": {
    "MY_VAR": "value"
  },
  "args": ["--flag"]
}
```

**Response:**
```json
{
  "run_id": "run_abc123",
  "worker": "hello-world",
  "started_at": "2026-04-03T18:00:00Z",
  "status": "running"
}
```

### POST /workers/:name/stop

Stop a running worker.

**Request body (optional):**
```json
{
  "force": false
}
```

### GET /workers/:name/logs

Retrieve worker logs.

**Query parameters:**

| Param | Description |
|-------|-------------|
| `tail` | Number of lines from end (default: 100) |
| `since` | ISO timestamp — only logs after this time |
| `level` | Filter: `debug`, `info`, `warn`, `error` |
| `follow` | `true` for streaming (use SSE endpoint instead) |

### GET /workers/:name/logs/stream

Server-Sent Events stream of live worker output. Useful for tailing logs in real time.

```javascript
const source = new EventSource('/workers/deploy/logs/stream', {
  headers: { Authorization: `Bearer ${apiKey}` }
});
source.onmessage = (e) => console.log(JSON.parse(e.data));
```

---

## Entities

### GET /entities

List all entities in the kingdom.

**Response:**
```json
{
  "entities": [
    {
      "name": "alice",
      "type": "personal",
      "active": true,
      "display_name": "Alice",
      "email": "alice@example.com",
      "portal": "https://kingofalldata.com/alice-example-com",
      "public_key": "ed25519:AAAA..."
    }
  ]
}
```

### GET /entities/:name

Get a single entity.

### POST /entities

Create a new entity.

**Request body:**
```json
{
  "name": "atlas",
  "type": "agent",
  "email": "atlas@example.com",
  "display_name": "Atlas"
}
```

### DELETE /entities/:name

Remove an entity. Returns `409` if the entity has active trust bonds.

---

## Trust

### GET /trust

List all trust bonds.

**Response:**
```json
{
  "bonds": [
    {
      "entity": "vulcan",
      "scope": "workers:run",
      "granted_at": "2026-04-03T14:00:00Z",
      "granted_by": "alice",
      "verified": true
    }
  ]
}
```

### POST /trust

Create a trust bond.

**Request body:**
```json
{
  "entity": "vulcan",
  "scope": "workers:run"
}
```

### DELETE /trust/:entity

Revoke a trust bond.

---

## Ring

### GET /ring/status

Current ring membership status.

### GET /ring/peers

List all peers in the ring.

### POST /ring/sponsor

Sponsor a peer into your ring.

**Request body:**
```json
{
  "public_key": "ed25519:AAAA...",
  "hostname": "vulcan.example.com",
  "tier": "basic"
}
```

### DELETE /ring/sponsor/:public-key

Remove a sponsorship.

---

## Events (Webhooks)

koad:io posts JSON to your configured `webhook_url` on these events:

| Event | Trigger |
|-------|---------|
| `worker.start` | Worker run begins |
| `worker.complete` | Worker exits with code 0 |
| `worker.fail` | Worker exits with non-zero code |
| `worker.timeout` | Worker killed for exceeding timeout |
| `ring.peer.joined` | New peer joins your ring |
| `ring.peer.left` | Peer leaves or is removed |
| `trust.bond.created` | New trust bond created |
| `trust.bond.revoked` | Trust bond revoked |
| `daemon.restart` | Daemon restarted |

**Payload envelope:**
```json
{
  "event": "worker.fail",
  "entity": "alice",
  "timestamp": "2026-04-03T18:00:00Z",
  "payload": { ... }
}
```

Configure: `koad config set webhook_url=... webhook_events=worker.fail,ring.peer.joined`
