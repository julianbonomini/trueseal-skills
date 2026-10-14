# Pairing — Kotlin syntax

Syntax only. States, events and error cases: <https://trueseal.dev/agents/pairing> and
<https://trueseal.dev/agents/api>.
Authoritative quickstart: <https://github.com/julianbonomini/trueseal-sync-kotlin>.

Device A — open the window and hand over the token (QR, share sheet, …):

```kotlin
val token = tsA.startPairing()
```

Device B — join (status becomes `pendingJoin` until the first manifest arrives):

```kotlin
tsB.join(token)
```

Device A — the request arrives as an event; present it and accept explicitly:

```kotlin
val sub = tsA.onEvent { event ->
    if (event is TrueSealEvent.JoinRequestReceived) {
        // event.request.name is a label, not authentication — show it, let the human accept
        tsA.accept(requestId = event.request.id)
    }
}
```

Membership lifecycle:

```kotlin
ts.remove(memberId)         // any member may remove; the removed device wipes + rotates
ts.leave()                  // persisted, crash-resumable Leaving state
ts.destroyGroup()           // durable, forwarded, honoured from any past or present member
// After removal or destroy the object stays usable with a fresh identity.
```

Read the group-size cap from the SDK (`TrueSeal.maxGroupSize`), never a literal.
