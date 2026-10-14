# Integrate — Swift syntax

Syntax only. Signatures, error cases and limits: <https://trueseal.dev/agents/api>.
Authoritative quickstart: <https://github.com/julianbonomini/trueseal-sync-swift>.

Install (SwiftPM binary target, no Rust toolchain):

```swift
// Package.swift
.package(url: "https://github.com/julianbonomini/trueseal-sync-swift", from: "<latest release>")
```

Open (macOS/iOS need the `com.apple.security.network.client` entitlement — without it
the relay connection silently fails):

```swift
import TruesealSync

let ts = try await TrueSeal.open(
    relay: "trueseal://<relay public key hex>@relay.example.com",
    storage: try FileManager.default.url(
        for: .applicationSupportDirectory, in: .userDomainMask,
        appropriateFor: nil, create: true)
)
// State is @Observable: ts.status, ts.me, ts.members, ts.connection
```

Receive (one awaited handler; registering starts receiving; the ack goes out when the
closure returns — throw to retry):

```swift
let sub = ts.onMessage { message in
    // message.body, message.from, message.id (stable — the library deduplicates)
    await MainActor.run { /* UI work */ }
}
```

Send (returns the Message ID once durably queued; fails typed when not a member or over
the protocol size limit — read `TrueSeal.maxPayloadBytes`, never a literal):

```swift
let messageId = try ts.send(Data("hello".utf8))
```

Close when done (`ts.close()`); every later call fails with the typed closed error.
