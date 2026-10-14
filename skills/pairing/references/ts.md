# Pairing — TypeScript (Node) syntax

Syntax only. States, events and error cases: <https://trueseal.dev/agents/pairing> and
<https://trueseal.dev/agents/api>.
Authoritative quickstart: <https://github.com/julianbonomini/trueseal-sync-ts>.

Device A — open the window and hand over the token:

```ts
const token = tsA.startPairing()
```

Device B — join (status becomes `pendingJoin` until the first manifest arrives):

```ts
tsB.join(token)
```

Device A — the request arrives as an event; present it and accept explicitly:

```ts
const sub = tsA.onEvent(async (event) => {
  if (event.type === 'joinRequest') {
    // event.request.name is a label, not authentication — show it, let the human accept
    tsA.accept(event.request.id)
  }
})
```

Membership lifecycle:

```ts
ts.remove(memberId)           // any member may remove; the removed device wipes + rotates
ts.leave()                    // persisted, crash-resumable Leaving state
ts.destroyGroup()             // durable, forwarded, honoured from any past or present member
// After removal or destroy the object stays usable with a fresh identity.
```

Read the group-size cap from the SDK (`TrueSeal.maxGroupSize`), never a literal.
