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

(Verified against `skills` CLI 1.7.2: the tool finds all three skills from this repo's
layout.)

Claude Code, as a plugin marketplace:

```
/plugin marketplace add julianbonomini/trueseal-skills
/plugin install trueseal@trueseal-skills
```

The marketplace manifest is [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json)
and the plugin it serves is this same repo.

The docs site also publishes `/.well-known/agent-skills/index.json`, pinned to a release
tag (built by the docs site — see trueseal-docs).

## Versioning and releases

This repo joins the **TrueSeal Release** lockstep
([docs ADR-0005](https://github.com/julianbonomini/trueseal-docs/blob/main/adr/0005-trueseal-skills.md),
[sync ADR-0030](https://github.com/julianbonomini/trueseal-sync/blob/main/docs/adr/0030-distribution-channels-and-lockstep-versions.md)):

- Every TrueSeal Release tags this repo `vX.Y.Z` — **even when nothing changed** — so
  "same version, same guidance" holds: an agent working with SDK `0.6.x` gets the
  `0.6.x` skills, and plugin auto-update moves with SDK upgrades.
- `.claude-plugin/plugin.json` (and the marketplace entry) carry exactly that version;
  `scripts/check-version.sh` enforces the match in CI on every PR and on every tag push.
- Release flow mirrors the other lockstep repos
  ([e2e ADR-0002](https://github.com/julianbonomini/trueseal-e2e/blob/main/docs/adr/0002-release-conductor-orchestration.md)):
  the `candidate` workflow validates a version at a main commit and stages a draft
  release; the `promote` workflow (normally driven by the Release Conductor) verifies
  the draft and publishes the immutable tag. A red gate burns no version; a fix is a
  new patch version.
- The tag is part of the Release Manifest the Conductor assembles at release time.

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
.claude-plugin/plugin.json        # the trueseal plugin manifest
.claude-plugin/marketplace.json   # the Claude Code marketplace manifest (serves the same repo)
scripts/check-version.sh          # version/layout consistency gate (CI + release flows)
.github/workflows/{ci,candidate,promote}.yml
skills/
  integrate/SKILL.md           # + references/{swift,kotlin,ts}.md
  pairing/SKILL.md             # + references/{swift,kotlin,ts}.md
  relay/SKILL.md               # + references/{swift,kotlin,ts}.md
evals/                          # the nine G14 eval cases + runbook (see evals/README.md)
```

## Evals and testing

The skills are **tested on Claude Code only**. Other agents that read the
standard Agent Skills layout get the same files, but their behaviour is
untested, and public copy says so
([docs ADR-0003](https://github.com/julianbonomini/trueseal-docs/blob/main/adr/0003-separate-agent-docs.md)).

Two gates cover the skills:

- **G11 — reference existence (CI, every PR).** The `reference-check` job in
  `ci.yml` runs the trueseal-docs checker over `skills/`: every link and API
  name must exist in the built Agent Docs, and the job fails on a dangling one.
  Pre-release the nested docs checkout tracks `trueseal-docs@main`; the release
  flow flips both checkouts to the release tag.
- **G14 — behavioural evals (manual, pre-release).** Nine cases in `evals/` —
  trigger, non-trigger and outcome per skill — run with `claude plugin eval`
  on the release candidate, by the maintainer, never in CI (model-API spend).
  The pass rule: each skill triggers in at least 2 of 3 runs and its outcome
  case beats the no-plugin baseline. The full procedure and the evidence that
  attaches to the release are in [evals/README.md](evals/README.md).

## Contributing

Keep skill files free of numeric limits, error-case lists and version literals — the
reference-existence check (trueseal-docs, gate G11) covers every link and API name in
this repo and fails CI on a dangling one (the `reference-check` job runs it on every
PR). The behavioural evals for the three skills live in `evals/` and run manually
before each release (gate G14 — see [evals/README.md](evals/README.md)).

Security reports: see [SECURITY.md](SECURITY.md).
