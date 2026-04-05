# Daemon Architecture — Canonical Reference

This document describes the koad:io daemon: what it is, how it is structured, how entities register and interact with it, and what changes when it is running versus not. Written for agents arriving cold at the daemon layer.

---

## What the Daemon Is

The koad:io daemon (`~/.koad-io/daemon/`) is the kingdom hub — a Meteor/DDP application that runs locally and provides three services simultaneously:

1. **DDP pub/sub bus** — a WebSocket-based real-time protocol for entity presence and state streaming
2. **MongoDB state store** — persistent local database for passenger registry, task state, and entity metadata
3. **HTTP server** — serves the Electron desktop widget UI and administration PWA at `localhost:9568`

The daemon is a framework-layer component. It lives in `~/.koad-io/daemon/`, not in any entity directory. All entities on the same machine share one daemon instance.

The browser extension (Dark Passenger) connects to the daemon via DDP to receive context from the currently selected entity. The daemon is the bridge between entities and the browsing environment.

---

## The Dark Passenger

The Dark Passenger is the browser extension component of koad:io. It connects to the daemon via DDP and provides in-browser entity presence — the selected entity rides alongside the user in the browser.

When a URL is visited, the extension can call `passenger.ingest.url` to deliver the URL and page context to the currently selected entity. This is the primary real-time data pipe from the browser into the entity layer.

The Dark Passenger and the daemon are a pair: one is the bridge, the other is the hub.

---

## Directory Structure

```
~/.koad-io/daemon/
├── README.md                        — Project overview
├── features/                        — Feature specification documents
│   ├── 001-entity-management.md
│   ├── 002-distributed-network.md
│   ├── 003-zerotier-integration.md
│   ├── 004-process-management.md
│   ├── 005-mongodb-management.md
│   ├── 006-ui-serving.md
│   └── 007-passenger-registry.md
└── src/                             — Meteor application source
    ├── package.json                 — Node.js dependencies (node >=22)
    ├── package-lock.json
    ├── server/                      — Server-only code
    │   ├── clicker.js               — Browser launch methods (chrome, brave, pwa)
    │   ├── passenger-api.js         — HTTP REST endpoint (/passenger/post)
    │   └── passenger-methods.js     — Passenger registry, DDP methods, publications
    ├── client/                      — Client-only code (widget UI)
    │   ├── application-logic.js     — Template logic, DDP subscriptions, widget UX
    │   ├── styles.css               — Widget styling
    │   └── templates.html           — Blaze templates for the widget
    └── public/                      — Static assets
        ├── assets/
        ├── icons/
        └── logo.png
```

MongoDB data is stored in `~/.koad-io/daemon/data/` when the daemon auto-spawns its own MongoDB instance. If `MONGO_URL` is set in the environment, the daemon connects to that instance instead.

---

## passenger.json — Entity Registration

`passenger.json` is the file an entity places in its own directory to announce itself to the daemon. It is the entity's registration card.

**Discovery mechanism:** At startup, the daemon scans every `~/.<folder>` directory in the home directory. For each folder whose `.env` contains `KOAD_IO_` variables, the daemon checks for a `passenger.json` file. If found, the entity is registered as a passenger.

**passenger.json fields:**

| Field | Type | Purpose |
|---|---|---|
| `handle` | string | Unique identifier (matches entity name, e.g. `"juno"`) |
| `name` | string | Display name (e.g. `"Juno"`) |
| `avatar` | string | Path to `avatar.png` — embedded as base64 on load |
| `outfit` | object | Color scheme `{ hue, saturation, brightness }` (auto-generated if absent) |
| `buttons` | array | Quick-launch actions shown in the widget (each has `action` and `target`) |

**Registration flow:**

```
daemon startup
  → scan ~/.* for folders with KOAD_IO_ in .env
  → for each qualifying entity, read passenger.json
  → embed avatar.png as base64 data URL
  → if handle not already in Passengers collection, insert
  → log count of registered passengers
```

The `passenger.reload` DDP method triggers a full re-scan: clears the collection and re-runs `registerPassengers()`. This is the current mechanism for picking up newly gestated entities without restarting the daemon.

**No liveness signal exists yet.** Once registered, a passenger remains in the collection indefinitely. There is no heartbeat and no automatic eviction of offline entities. This is a known gap (see Hardening section below).

---

## DDP Methods

These are the RPC calls clients (browser extension, widget) make to the daemon:

| Method | Arguments | Effect |
|---|---|---|
| `passenger.check.in` | `passengerName: String` | Sets the named passenger as `selected`; deselects all others |
| `passenger.ingest.url` | `{ url, title, timestamp, domain, favicon? }` | Delivers URL context to currently selected passenger (logged; full processing TBD) |
| `passenger.resolve.identity` | `{ domain, url? }` | Identity resolution stub for selected passenger (not yet implemented) |
| `passenger.check.url` | `{ domain, url? }` | URL safety check for selected passenger (not yet implemented) |
| `passenger.reload` | — | Clears Passengers collection and re-scans filesystem |
| `open.pwa` | `appId: String` | Launches Chrome PWA by app ID |
| `open.chrome` | — | Opens Chrome with default profile |
| `open.brave` | — | Opens Brave with default profile |
| `open.with.default.app` | `url: String` | Opens URL with system default app |
| `open.with.chrome` | `url: String` | Opens URL in Chrome |
| `open.with.brave` | `url: String` | Opens URL in Brave |
| `open.pwa.with.brave` | `appId: String` | Launches Brave PWA by app ID |

The `open.*` methods execute shell commands directly via Node.js `child_process.exec`. They are the daemon's mechanism for reaching into the desktop environment.

There is also an HTTP endpoint at `POST /passenger/post` (implemented in `passenger-api.js`) that accepts JSON bodies. Currently it logs the payload and returns `{ status: "success" }`. Full processing is not yet wired.

---

## DDP Publications

Clients subscribe to these to receive reactive data from the Passengers collection:

| Publication | Filter | Purpose |
|---|---|---|
| `current` | `{ selected: { $exists: true } }` | Currently active passenger (the one "riding") |
| `all` | `Passengers.find()` | Full passenger roster |

The widget client subscribes to `current` to render the active entity in the browser overlay. The `all` publication is available for admin UIs and the future Stream PWA (Vulcan#3).

**Scaling note:** `all` returns the entire Passengers collection with no filter. At current scale (15–20 entities) this is fine. Before the entity count reaches dozens, this publication should be scoped — for example, filtered to entities with a recent `lastHeartbeat`. See Sibyl's research brief `2026-04-05-daemon-architecture-patterns.md` for full scaling analysis.

---

## MongoDB Collections

| Collection | Contents | Notes |
|---|---|---|
| `Passengers` | Registered entity records (handle, name, avatar, outfit, buttons, selected) | In-process collection (`{connection: null}` on server, standard on client) |

No other collections are in use in the current implementation. The daemon is designed to support additional collections as the worker and task dispatch systems are built out.

---

## Current Status

**npm unblocked.** The Electron dependency that previously blocked `npm install` has been removed. The daemon's Node.js dependencies install cleanly on Node >=22.

**dotsh ready to start.** The dotsh server (Vultr Toronto) is provisioned and ready to run the daemon as a persistent background service. The daemon has not yet been started there as a production service.

**What is implemented:**
- Passenger discovery and registration via `passenger.json`
- Avatar embedding as base64
- DDP pub/sub for passenger state (`current`, `all` publications)
- Full DDP method set for browser integration
- HTTP REST endpoint at `/passenger/post`
- Desktop browser launch methods

**What is not yet implemented:**
- Heartbeat / liveness tracking (entities don't signal they are alive)
- Task persistence (no `tasks` collection — work dispatched via DDP methods is ephemeral)
- `passenger.ingest.url` processing beyond logging
- `passenger.resolve.identity` and `passenger.check.url` (stubs only)
- Oplog tailing configuration (required for production load; prevents polling fallback)

---

## Hardening Recommendations

Based on Sibyl's architecture research (`2026-04-05-daemon-architecture-patterns.md`), three hardening items before the daemon carries real coordination load:

**1. Heartbeat tracking**

Each entity should call `passenger.heartbeat(handle)` every 30 seconds. The daemon records `lastHeartbeat` on the Passengers document. Entities not seen within 90 seconds are considered offline. This prevents stale entries from accumulating and allows the `all` publication to filter to live entities only.

**2. Task persistence before dispatch**

Before dispatching any work to an entity via DDP method, write it to a `tasks` MongoDB collection with `status: pending`. Mark it `acknowledged` when the entity confirms receipt. A background sweep re-dispatches tasks that remain `pending` past a timeout. This prevents work loss if the daemon restarts mid-dispatch.

**3. Oplog tailing**

Set `MONGO_OPLOG_URL=mongodb://localhost/local` before running under production load. Without oplog tailing, Meteor falls back to polling each collection — expensive at any meaningful query rate.

---

## The Worker System (Current vs. Future)

### Current: GitHub Issues as the durable work queue

The daemon does not currently function as a task queue. All durable work assignment flows through GitHub Issues:

```
koad files issue on koad/juno    → Juno picks up on session start
Juno files issue on koad/vulcan  → Vulcan builds
Vulcan comments on Juno's issue  → Juno verifies, closes
```

GitHub Issues is a reliable work queue because issues are durable (GitHub stores them), entities can reconnect after any downtime and recover their assignments, and there is a full audit trail. Entities check `gh issue list --state open` at session start.

### Future: DDP as real-time state layer

The daemon's intended medium-term role is not to replace GitHub Issues but to complement it:

- **GitHub Issues** — durable task assignment (what work must be done; survives restarts and offline periods)
- **DDP** — real-time state streaming (current presence, live status, low-latency coordination)

The recommended hybrid reconnection protocol, once the daemon is a persistent service:

1. `git pull` on entity directory — reconcile all durable state
2. `gh issue list --state open` — recover any assigned tasks
3. Connect to daemon, re-establish DDP subscriptions — get current live state
4. Request any tasks with `status: pending` since last session

This pattern is described in detail in Sibyl's research: `2026-04-05-daemon-architecture-patterns.md`, Research Question 4.

---

## What Changes When the Daemon Is Running

| Dimension | Daemon not running | Daemon running |
|---|---|---|
| Entity coordination | GitHub Issues (minutes latency, fully durable) | GitHub Issues + DDP (sub-second presence layer) |
| Browser integration | None | Dark Passenger rides alongside; URLs delivered to selected entity |
| Widget / desktop overlay | No UI | Electron widget displays current entity, quick-launch buttons |
| Admin PWA | Not available | Available at `localhost:9568` |
| Entity presence | Not tracked | Passengers collection reflects registered entities |
| Work dispatch | Manual (issue filing) | DDP methods can dispatch directly to live entities |
| Stream PWA (Vulcan#3) | Not possible | Live activity wall across all entities subscribes to daemon |

The daemon is not required for current operations. All coordination continues via GitHub Issues when the daemon is offline. The daemon adds real-time capability on top of the existing durable layer — it does not replace it.

---

## Environment Variables

| Variable | Default | Purpose |
|---|---|---|
| `MONGO_URL` | (none) | External MongoDB connection string; if unset, daemon spawns local instance |
| `MONGO_OPLOG_URL` | (none) | MongoDB oplog connection for change detection; required for production |
| `MONGO_PORT` | 3001 | Port for daemon-spawned MongoDB instance |
| `MONGO_DB_PATH` | `./data` | Data directory for daemon-spawned MongoDB |
| `KOAD_IO_PORT` | 9568 | HTTP port for daemon server |
| `KOAD_IO_BIND_IP` | 127.0.0.1 | IP binding for daemon server |
| `KOAD_IO_AUTO_SPAWN_MONGO` | true | Whether to auto-spawn MongoDB if `MONGO_URL` is not set |
| `ZEROTIER_NETWORK_ID` | (none) | ZeroTier network ID for entity network isolation |
| `ZEROTIER_API_TOKEN` | (none) | ZeroTier API token for network management (optional) |

---

## Related Documents

- `~/.koad-io/daemon/features/` — Feature specification documents (source of truth for intended behavior)
- `~/.sibyl/research/2026-04-05-daemon-architecture-patterns.md` — DDP scaling limits, worker queue patterns, reconnection strategies (Sibyl, 2026-04-05)
- `~/.livy/docs/reference/operations-architecture.md` — How entities coordinate via GitHub Issues today
- `~/.livy/docs/reference/entity-directory-structure.md` — What `passenger.json` lives alongside in an entity directory
- Vulcan#3 — Stream PWA (depends on daemon running as persistent service)
