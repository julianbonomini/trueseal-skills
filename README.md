# trueseal-skills

> **Developer Preview.** TrueSeal is `0.x` and openly allowed to break. These skills
> teach workflows that survive that: they link to the canonical references instead of
> copying facts that would drift.

The `trueseal` plugin for coding agents — three workflow skills for
[TrueSeal](https://trueseal.dev), the end-to-end encrypted, local-first sync primitive:

| Skill | Workflow |
|---|---|
| `trueseal:integrate` | Add TrueSeal to an app: install the SDK, open a session, register the handler, send and receive — without acking early, skipping dedupe, or hard-coding limits. |
| `trueseal:pairing` | Build the two-device pairing flow with explicit admission on both sides, the Pending Join state, failure and restart handling, and the membership lifecycle after pairing. |
| `trueseal:relay` | Run a relay for local development or a single self-hosted Docker node: keypair, Relay Address, health, limits, logging modes, backups, upgrades. |

## Install

Any agent that supports the standard Agent Skills layout:

```bash
npx skills add julianbonomini/trueseal-skills
```

Claude Code marketplace support and the `/.well-known/agent-skills` index ship with
SKILLS-2 (tracked in this repo's issues).

## Design rules

- **Link, don't copy.** Every API signature, limit, error case and version lives in the
  [Agent Docs](https://trueseal.dev/agents/) — the skills link to them and copy none.
  That is what keeps the guidance true across preview releases
  ([docs ADR-0003](https://github.com/julianbonomini/trueseal-docs/blob/main/adr/0003-separate-agent-docs.md),
  [ADR-0005](https://github.com/julianbonomini/trueseal-docs/blob/main/adr/0005-trueseal-skills.md)).
- **One skill per workflow, not per SDK.** The three SDKs share one API shape; each
  skill carries `references/swift.md`, `references/kotlin.md` and `references/ts.md`
  for syntax only.
- **Lockstep versioning.** This repo is tagged with every TrueSeal Release, even when
  nothing in it changed; `plugin.json` carries that version.

## Layout

```
.claude-plugin/plugin.json     # the trueseal plugin manifest
skills/
  integrate/SKILL.md           # + references/{swift,kotlin,ts}.md
  pairing/SKILL.md             # + references/{swift,kotlin,ts}.md
  relay/SKILL.md               # + references/{swift,kotlin,ts}.md
```

## Contributing

Keep skill files free of numeric limits, error-case lists and version literals — the
reference-existence check (trueseal-docs, gate G11) covers every link and API name in
this repo and fails the release on a dangling one. Behavioural evals for the three
skills land with SKILLS-3.

Security reports: see [SECURITY.md](SECURITY.md).
