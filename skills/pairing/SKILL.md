---
name: pairing
description: Build the TrueSeal pairing flow — two devices exchanging a Pairing Token with explicit admission on both sides, the Pending Join state, failure and restart handling, and the membership lifecycle after pairing (add, remove, leave, Destroy Group). Use when implementing pairing UI, join-by-QR/token flows, member management, or group teardown.
---

# Pairing and the membership lifecycle

Devices sync inside a group. Pairing bootstraps it: one device opens a window and hands
over a Pairing Token; the other joins with it; the first device explicitly accepts.
The trust design is [ADR-0023](https://github.com/julianbonomini/trueseal-sync/blob/main/docs/adr/0023-pairing-trust-anchor-and-pending-join.md);
the user-facing semantics are in the Agent Docs. **Follow the links for every state
name, event and error case — never restate them from memory.**

Canonical references:

- Pairing: <https://trueseal.dev/agents/pairing>
- Membership: <https://trueseal.dev/agents/membership>
- Destroy Group: <https://trueseal.dev/agents/destroy-group>
- Errors and events: <https://trueseal.dev/agents/errors-and-events>
- Threat Model (what the token does and does not prove): <https://trueseal.dev/agents/threat-model>

## The pairing flow

1. **Device A opens the window** and gets a Pairing Token — one opaque string to show
   as a QR code or hand over out of band. Opening the window is only possible while
   the device is in a state that may admit; the SDK refuses typed otherwise.
2. **Device B joins with the token.** Its status becomes **Pending Join**: it has sent
   its join request and now waits for its first manifest. Until that manifest arrives
   it is not a member, cannot send, and drops group traffic. Pending Join is persisted
   — a crash or restart mid-flow resumes it, it is not lost.
3. **Device A receives a join-request event** and must accept **explicitly**. Show the
   requesting device to the user; the name in the request is a label, not
   authentication ([threat model](https://trueseal.dev/agents/threat-model) — there is
   no SAS in the preview; anyone holding the token while the window is open can
   request).
4. **After accept**, both devices are members and can send and receive.

Per-platform syntax lives in `references/swift.md`, `references/kotlin.md` and
`references/ts.md`.

## Pitfalls agents get wrong

- **Admission must happen on both sides of the UI.** Auto-accepting join requests in
  code defeats the entire trust anchor. The accepting device presents the request; the
  human accepts.
- **The token does not expire on a timer.** It carries a single-use secret; the window
  closes when the device cancels it or accepts a join. Do not invent countdown UI, and
  do not reuse a token after a failure — open a fresh window.
- **A failed join is typed.** A malformed or reused token fails with a specific typed
  error — surface it and offer a retry with a new token; do not retry the same token in
  a loop.
- **Drive UI off the group status, not off call success.** `join` returning means the
  request was durably queued — membership arrives asynchronously via state and events.
- **The window is closed for a Destroying or Leaving device** — pairing calls refuse
  typed while either is in progress.

## Membership after pairing

Pairing is the start of the lifecycle, not all of it:

- **Any member may admit** further devices (same flow) **or remove** a member. Removal
  propagates by manifest; the removed device wipes its group state and rotates its
  identity automatically. Concurrent membership changes converge — the ordering and
  re-application rules are in [membership](https://trueseal.dev/agents/membership).
- **A member may leave** on its own. Leaving is a persisted, crash-resumable state.
- **Destroy Group** tears the whole group down durably and is honoured from any past or
  present member — the semantics and their limits are in
  [Destroy Group](https://trueseal.dev/agents/destroy-group). After removal or destroy,
  the object stays usable with a fresh identity and can pair again.
- **Group size is capped by the protocol.** The number is a Shared Fact — read it from
  the SDK's exposed limit and link [limits](https://trueseal.dev/agents/limits); never
  hard-code it.
