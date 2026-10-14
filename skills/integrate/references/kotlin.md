# Integrate — Kotlin syntax

Syntax only. Signatures, error cases and limits: <https://trueseal.dev/agents/api>.
Authoritative quickstart: <https://github.com/julianbonomini/trueseal-sync-kotlin>.

Install (Maven Central coordinates are the stable API; check the README for the current
interim AAR step while the Central publish lands):

```kotlin
// app/build.gradle.kts
dependencies {
    implementation("dev.trueseal:trueseal-sync:<latest release>")
}
```

Open (`open` is suspend — call from a coroutine; `Storage.android` puts Session State
under the backup-excluded directory):

```kotlin
import dev.trueseal.sync.Storage
import dev.trueseal.sync.TrueSeal

val ts = TrueSeal.open(
    relay = "trueseal://<relay public key hex>@relay.example.com",
    storage = Storage.android(applicationContext),
)
// State is StateFlows: ts.status, ts.me, ts.members, ts.connection
```

Receive (one awaited suspend handler; registering starts receiving; the ack goes out
when the handler returns — throw to retry):

```kotlin
val sub = ts.onMessage { message ->
    // message.body, message.from, message.id (stable — the library deduplicates)
    withContext(Dispatchers.Main) { /* UI work */ }
}
```

Send (returns the Message ID once durably queued; fails typed when not a member or over
the protocol size limit — read `TrueSeal.maxPayloadBytes`, never a literal):

```kotlin
val messageId = ts.send("hello".encodeToByteArray())
```

Close when done (`ts.close()`); every later call fails with the typed closed error.
