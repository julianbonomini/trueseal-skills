---
name: integrate
description: Add TrueSeal end-to-end encrypted sync to an app — pick and install the Swift, Kotlin or TS SDK, open a session against a relay, register the message handler, and send and receive. Use when a developer wants to add device-to-device sync, E2EE sync, or "TrueSeal" to a project, or when debugging why messages are not arriving after an integration.
---

# Integrate TrueSeal into an app

TrueSeal syncs opaque bytes between the devices of one group, end-to-end encrypted,
through a relay that cannot read or forge them. One API shape covers all three SDKs
([ADR-0028](https://github.com/julianbonomini/trueseal-sync/blob/main/docs/adr/0028-canonical-sdk-api-shape.md));
this skill teaches the workflow and the pitfalls. **Every API signature, error case,
limit and version lives in the Agent Docs — follow the links, never guess from memory.**

Canonical references:

- SDK API reference (all three SDKs): <https://trueseal.dev/agents/api>
- Sending and receiving: <https://trueseal.dev/agents/sending-and-receiving>
- Errors and events: <https://trueseal.dev/agents/errors-and-events>
- Limits (payload size, group size): <https://trueseal.dev/agents/limits>
- Delivery issues (troubleshooting): <https://trueseal.dev/agents/delivery-issues>

## Workflow

1. **Pick the SDK and install.** Per-platform install and syntax live in
   `references/swift.md`, `references/kotlin.md` and `references/ts.md`. The SDK READMEs
   are the authoritative quickstarts:
   [Swift](https://github.com/julianbonomini/trueseal-sync-swift),
   [Kotlin](https://github.com/julianbonomini/trueseal-sync-kotlin),
   [TS (Node)](https://github.com/julianbonomini/trueseal-sync-ts).

2. **Get a Relay Address.** One string carries the relay's public key, host and ports.
   A developer needs a relay they run (see the `trueseal:relay` skill or
   [running a relay](https://trueseal.dev/agents/running-a-relay)); the relay CLI prints
   the address. The format is specified in
   [versions and the Relay Address](https://trueseal.dev/agents/versions-and-relay-address).
   Pitfall: never split the address into host/port arguments in code — pass the one
   string; the SDK parses and validates it.

3. **Open the session.** `open` takes the Relay Address and a storage location and
   returns before the network is up — sends queue in the outbox and replay when the
   relay is reachable. Pitfalls:
   - Scope storage to the app. Two apps sharing a storage path share one group identity.
   - A disconnected connection state at startup is normal, not an error to surface.
   - Keep the object alive for the app's lifetime; it outlives group membership changes.

4. **Register the message handler before expecting anything.** Receiving starts when
   the handler is registered. There is exactly one handler per object, it is awaited,
   and registering it replaces any previous one. See
   [sending and receiving](https://trueseal.dev/agents/sending-and-receiving).

5. **Send.** `send` returns the Message ID once the message is **durably queued**, not
   delivered. Delivery is asynchronous and at least once, in per-sender order. The
   delivery contract ([ADR-0026](https://github.com/julianbonomini/trueseal-sync/blob/main/docs/adr/0026-delivery-contract.md))
   is what the app can rely on; the user-facing semantics are in
   [sending and receiving](https://trueseal.dev/agents/sending-and-receiving).

## Pitfalls agents get wrong

- **Never ack manually, and never ack early.** The library sends the acknowledgement
  only *after* the app's handler completes. Throwing (or returning an error) from the
  handler means "retry"; it is the mechanism, not a bug. Do not catch-and-swallow inside
  the handler to look stable — that turns real failures into silent message loss.
- **Do not build your own dedupe.** The library deduplicates by Message ID and the ID is
  stable across retransmissions. If the app also needs idempotent processing, key on the
  same Message ID.
- **Return promptly from handlers and listeners.** A handler that hangs stalls delivery;
  an event listener parked too long tears the session down around it. Hop to the UI
  thread explicitly; do heavy work after returning.
- **Handle the typed errors, not string matches.** Errors are a fixed, typed set shared
  across SDKs — enumerate them from
  [errors and events](https://trueseal.dev/agents/errors-and-events), never by parsing
  messages. A send that fails typed while the device is not a member (yet) is expected
  during onboarding.
- **Payload size has a hard protocol ceiling**, checked synchronously at send time. The
  number and its boundary semantics live in [limits](https://trueseal.dev/agents/limits);
  do not hard-code it — read it from the SDK's exposed limit.

## When delivery misbehaves

Retry classes, the outbox, backoff, expiry and every delivery-issue case are documented
in [delivery issues](https://trueseal.dev/agents/delivery-issues). Check the connection
state and the delivery-issue stream before touching the sending code.
