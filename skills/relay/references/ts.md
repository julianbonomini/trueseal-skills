# Relay — pointing the TS SDK at your relay

The relay prints one Relay Address string (`trueseal-relay address --host <host>` —
see <https://trueseal.dev/agents/relay-address-and-keypair>). Pass it to `open` as-is;
custom ports in the address are honoured:

```ts
const ts = await TrueSeal.open(
  'trueseal://<relay public key hex>@<your relay host>',
  { storageDir: '/path/to/your-app/trueseal' },
)
```

A local dev relay on the same machine is reachable at its loopback host. See
<https://github.com/julianbonomini/trueseal-sync-ts>.

Everything else (health, limits, keypair, backups) is platform-independent — follow
the links in the skill.
