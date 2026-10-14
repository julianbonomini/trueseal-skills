# Relay — pointing the Swift SDK at your relay

The relay prints one Relay Address string (`trueseal-relay address --host <host>` —
see <https://trueseal.dev/agents/relay-address-and-keypair>). Pass it to `open` as-is;
custom ports in the address are honoured:

```swift
let ts = try await TrueSeal.open(
    relay: "trueseal://<relay public key hex>@<your relay host>",
    storage: /* your app's storage directory */
)
```

Against a local dev relay, use the host your app can actually reach (the simulator and
a device are different machines from your Mac). The macOS/iOS network-client
entitlement is required — see
<https://github.com/julianbonomini/trueseal-sync-swift>.

Everything else (health, limits, keypair, backups) is platform-independent — follow
the links in the skill.
