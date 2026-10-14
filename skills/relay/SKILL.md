---
name: relay
description: Run a TrueSeal relay — local development or a single self-hosted Docker node. Covers first-start keypair generation, printing the Relay Address for clients, health checks, operator limits, logging modes, upgrades and backups. Use when a developer needs a relay to develop against, wants to self-host one, or is debugging relay connectivity, refusals or upgrades.
---

# Run a TrueSeal relay

The relay routes sealed blobs between devices. It cannot read or forge message content;
what it does see is documented in the
[threat model](https://trueseal.dev/agents/threat-model). One binary, one container,
one SQLite store. **Every command, endpoint and limit below is linked to the Agent
Docs — follow the links for exact flags and numbers, never restate them.**

Canonical references:

- Running a relay (local dev and single Docker node): <https://trueseal.dev/agents/running-a-relay>
- Relay Address and keypair: <https://trueseal.dev/agents/relay-address-and-keypair>
- Limits and quotas (operator-tunable, only downward): <https://trueseal.dev/agents/relay-limits-and-quotas>
- Backups: <https://trueseal.dev/agents/relay-backups>
- Upgrades (store versions, the reset flag): <https://trueseal.dev/agents/upgrades>
- The relay repo and its README (operator quickstart): <https://github.com/julianbonomini/trueseal-relay>

## Workflow

1. **Start it.** For local development and for a single self-hosted node, the shipped
   compose file is the supported path — see
   [running a relay](https://trueseal.dev/agents/running-a-relay). Always run an exact
   release image tag, never a floating one.

2. **The keypair handles itself — protect it.** On first start the relay generates its
   keypair atomically and refuses to overwrite an existing one. The public key is
   printable at any time with the `pubkey` command. The keypair *is* the relay's
   identity: losing it strands every client, and there is no key rotation in the
   preview — [Relay Address and keypair](https://trueseal.dev/agents/relay-address-and-keypair).

3. **Hand clients the Relay Address.** The `address` command prints the one
   `trueseal://…` string clients paste into their SDK — key, host and both ports in a
   single value. How each SDK consumes it is in `references/swift.md`,
   `references/kotlin.md` and `references/ts.md`.

4. **Check health and limits.** `/healthz` reports store health and the relay's
   Transport Version. Operator limits (size, TTL, quotas) may only be *lowered* below
   the protocol ceilings — the relay refuses to start above them; the ceilings and the
   refusal behaviour are in
   [limits and quotas](https://trueseal.dev/agents/relay-limits-and-quotas).

5. **Plan backups around the keypair.** What to back up, what is disposable, and
   restore order: [backups](https://trueseal.dev/agents/relay-backups).

## Pitfalls agents get wrong

- **Never regenerate or "fix" the keypair** to resolve client connection errors — that
  changes the relay's identity and breaks every client configuration. Diagnose
  connectivity first (health, ports, the address string).
- **Logs are private by design.** Normal mode logs no client metadata at all; dev mode
  (a flag or env var, never the config file) adds key prefixes and sizes but never
  addresses. Do not add per-client logging or a public log viewer.
- **Refusals are typed and deliberate.** A client rejected for version, size or quota
  is the protocol working — check
  [relay limits and quotas](https://trueseal.dev/agents/relay-limits-and-quotas) before
  loosening anything.
- **Upgrades are versioned.** Pin an exact image tag; the store carries a version and a
  newer store is refused rather than downgraded — the reset path and its operator flag
  are in [upgrades](https://trueseal.dev/agents/upgrades). Do not wipe the store to
  resolve an upgrade refusal.
- **A relay that is "up" but unroutable is usually the address** — host or ports in the
  printed Relay Address not matching how clients actually reach the machine.
