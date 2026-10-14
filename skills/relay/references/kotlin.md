# Relay — pointing the Kotlin SDK at your relay

The relay prints one Relay Address string (`trueseal-relay address --host <host>` —
see <https://trueseal.dev/agents/relay-address-and-keypair>). Pass it to `open` as-is;
custom ports in the address are honoured:

```kotlin
val ts = TrueSeal.open(
    relay = "trueseal://<relay public key hex>@<your relay host>",
    storage = Storage.android(applicationContext),
)
```

Against a local dev relay, remember the Android emulator reaches your host machine at
its own loopback alias, not `localhost` — use the host form the emulator can route to.
See <https://github.com/julianbonomini/trueseal-sync-kotlin>.

Everything else (health, limits, keypair, backups) is platform-independent — follow
the links in the skill.
