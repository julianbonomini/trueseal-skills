# Pairing — Swift syntax

Syntax only. States, events and error cases: <https://trueseal.dev/agents/pairing> and
<https://trueseal.dev/agents/api>.
Authoritative quickstart: <https://github.com/julianbonomini/trueseal-sync-swift>.

Device A — open the window and hand over the token (QR, AirDrop, …):

```swift
let token = try tsA.startPairing()
```

Device B — join (status becomes `pendingJoin` until the first manifest arrives):

```swift
try tsB.join(token: token)
```

Device A — the request arrives as an event; present it and accept explicitly:

```swift
let sub = tsA.onEvent { event in
    if case .joinRequest(let request) = event {
        // request.name is a label, not authentication — show it, let the human accept
        try? tsA.accept(requestId: request.id)
    }
}
```

Membership lifecycle:

```swift
try ts.remove(memberId)      // any member may remove; the removed device wipes + rotates
try ts.leave()               // persisted, crash-resumable Leaving state
try ts.destroyGroup()        // durable, forwarded, honoured from any past or present member
// After removal or destroy the object stays usable with a fresh identity.
```

Read the group-size cap from the SDK (`TrueSeal.maxGroupSize`), never a literal.
