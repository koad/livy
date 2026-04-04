# Integrating with the Ecosystem

Once your kingdom is running and you have an entity, you can connect it to the broader koad:io ecosystem: other kingdoms, external services, CI/CD pipelines, and monitoring tools.

## Connecting to a Trust Ring

The primary integration path is joining a trust ring — a network of connected kingdoms.

### Get Sponsored

You need someone already in a ring to sponsor you. Give them your public key:

```bash
koad entity public-key
# ed25519:AAAA...
```

Once they've added the sponsorship on their side, you'll receive a bond notification:

```bash
koad ring status
# Pending sponsorship from: juno@koad.io
# Accept? [y/N]: y
```

After accepting:

```bash
koad ring status
# Connected to ring: koad-main
# Sponsor: juno@koad.io (basic tier)
# Peers visible: 12
```

### Sponsor Others

To add someone to your ring, get their public key and daemon hostname, then:

```bash
koad ring sponsor add <public-key> <hostname> --tier basic
```

See [Trust Rings](../guides/trust-rings.md) for full sponsorship documentation.

## REST API

koad:io exposes a local REST API for automation and integration. By default it listens on `localhost:4001`.

```bash
# Check daemon status
curl http://localhost:4001/status

# List workers
curl http://localhost:4001/workers

# Trigger a worker
curl -X POST http://localhost:4001/workers/hello-world/run
```

Full API reference: [API Reference](../api-reference/).

## Webhooks

Receive HTTP callbacks when worker state changes:

```bash
koad config set webhook_url="https://your-service.example.com/koad-events"
koad config set webhook_events="worker.start,worker.fail,worker.complete"
```

Payload format:

```json
{
  "event": "worker.complete",
  "worker": "hello-world",
  "entity": "alice",
  "timestamp": "2026-04-03T18:00:00Z",
  "duration_ms": 312,
  "exit_code": 0
}
```

## CI/CD Integration

Trigger worker runs from GitHub Actions, GitLab CI, or any CI system:

```yaml
# .github/workflows/deploy.yml
- name: Trigger koad worker
  run: |
    curl -X POST https://your-daemon-host:4000/workers/deploy/run \
      -H "Authorization: Bearer ${{ secrets.KOAD_API_KEY }}" \
      -H "Content-Type: application/json"
```

Generate an API key:

```bash
koad api-key create --name "github-actions" --scope workers:run
# koad_key_xxxxxxxx
```

## Monitoring and Observability

### Metrics Endpoint

koad:io exposes Prometheus-compatible metrics:

```
http://localhost:4001/metrics
```

Add to your `prometheus.yml`:

```yaml
scrape_configs:
  - job_name: koad
    static_configs:
      - targets: ['localhost:4001']
```

### Logs

Daemon and worker logs are written to `~/.koad/logs/`:

```bash
# Stream live logs
koad logs --follow

# Worker-specific logs
koad logs --worker hello-world

# Last 100 lines
koad logs --tail 100
```

### Health Check

Use the `/health` endpoint for load balancer or uptime checks:

```bash
curl http://localhost:4001/health
# {"status":"ok","uptime":3600,"workers":{"running":2,"idle":5,"failed":0}}
```

## Environment Variables

koad:io respects these environment variables for integration:

| Variable | Description |
|----------|-------------|
| `KOAD_API_KEY` | API key for authenticated requests |
| `KOAD_DAEMON_HOST` | Override daemon hostname for remote API calls |
| `KOAD_DAEMON_PORT` | Override daemon port (default: 4000) |
| `KOAD_LOG_LEVEL` | Log verbosity: `debug`, `info`, `warn`, `error` |
| `KOAD_ENTITY` | Override active entity for this process |

## SDK / Client Libraries

Official clients:

| Language | Package | Status |
|----------|---------|--------|
| Node.js | `@koad/client` | stable |
| Python | `koad-client` | stable |
| Go | `github.com/koad/client-go` | beta |
| Rust | `koad-client` (crates.io) | alpha |

Example (Node.js):

```javascript
const { KoadClient } = require('@koad/client');

const client = new KoadClient({
  host: 'localhost',
  port: 4001,
  apiKey: process.env.KOAD_API_KEY,
});

await client.workers.run('hello-world');
const status = await client.status();
console.log(status.workers);
```

## Next Steps

- [API Reference](../api-reference/) — Complete endpoint documentation
- [Trust Rings](../guides/trust-rings.md) — Ring management in depth
- [Your Portal](../guides/portal.md) — What the outside world sees
