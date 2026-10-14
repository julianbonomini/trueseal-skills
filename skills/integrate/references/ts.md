# Integrate — TypeScript (Node) syntax

Syntax only. Signatures, error cases and limits: <https://trueseal.dev/agents/api>.
Authoritative quickstart: <https://github.com/julianbonomini/trueseal-sync-ts>.

Install (per-platform native packages resolve automatically; check the README for the
current from-source step while the registry publish lands):

```bash
npm install @trueseal/sync
```

Open (scope `storageDir` to YOUR app — two apps sharing a path share one group
identity):

```ts
import { TrueSeal } from '@trueseal/sync'

const ts = await TrueSeal.open(
  'trueseal://<relay public key hex>@relay.example.com',
  { storageDir: '/path/to/your-app/trueseal' },
)
// State: ts.status, ts.me, ts.members, ts.connection
```

Receive (one awaited handler; registering starts receiving; the ack goes out when the
handler resolves — throw to retry):

```ts
const sub = ts.onMessage(async (message) => {
  // message.body (Uint8Array), message.from, message.id (stable — the library
  // deduplicates)
})
```

Send (synchronous — returns the Message ID once durably queued; throws typed when not
a member or over the protocol size limit — read `TrueSeal.maxPayloadBytes`, never a
literal):

```ts
const messageId = ts.send(Buffer.from('hello'))
```

Close when done (`ts.close()`); every later call throws the typed closed error.
