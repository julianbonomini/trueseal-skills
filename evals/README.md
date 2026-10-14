# Skill evals (gate G14)

Nine behavioural eval cases for the `trueseal` plugin — a **trigger**, a
**non-trigger** and an **outcome** case per skill, per
[docs ADR-0005](https://github.com/julianbonomini/trueseal-docs/blob/main/adr/0005-trueseal-skills.md):

| Skill | Trigger | Non-trigger | Outcome |
|---|---|---|---|
| `trueseal:integrate` | [integrate-trigger](integrate-trigger/) | [integrate-non-trigger](integrate-non-trigger/) | [integrate-outcome](integrate-outcome/) |
| `trueseal:pairing` | [pairing-trigger](pairing-trigger/) | [pairing-non-trigger](pairing-non-trigger/) | [pairing-outcome](pairing-outcome/) |
| `trueseal:relay` | [relay-trigger](relay-trigger/) | [relay-non-trigger](relay-non-trigger/) | [relay-outcome](relay-outcome/) |

Each case is a `prompt.md` plus `graders/`. Trigger and non-trigger graders are
deterministic (`tool_used: Skill` — free). Outcome graders are LLM-scored
criteria the ADR names (Integrate dedupes by Message ID and never acks before the
handler finishes; Pairing implements explicit admission on both sides; Relay pins
an exact image and treats the keypair as identity) and run against a no-plugin
baseline arm.

**The skills are tested on Claude Code only.** Other agents that read the
standard Agent Skills layout (`npx skills add`) get the same files, but their
behaviour is untested — public copy must say that (docs ADR-0003/0005).

## When they run

In the **manual pre-release gate G14** — not in CI, because every run is paid
model-API spend ([docs ADR-0003](https://github.com/julianbonomini/trueseal-docs/blob/main/adr/0003-separate-agent-docs.md)).
The maintainer runs them once per TrueSeal Release candidate, on the candidate's
tag, and attaches the result to the release as evidence.

## How to run (the G14 procedure)

From a checkout of this repo at the release tag:

```bash
# Full suite: 9 cases × 3 runs × 2 arms (with plugin / no-plugin baseline).
# --allow-tools grants the gated tools the outcome cases need (they write code
# and follow the Agent Docs links). --max-cost-usd is a hard ceiling — the run
# aborts with partial results rather than overrunning.
claude plugin eval . \
  --trust-plugin \
  --allow-tools Write Edit WebFetch \
  --max-cost-usd 25 \
  --json evals/results/g14-<version>.json \
  --report evals/results/g14-<version>.html
```

Results land in `evals/results/` (gitignored — evidence is attached to the
release, not committed). Run one skill while iterating:

```bash
claude plugin eval . --trust-plugin --allow-tools Write Edit WebFetch --case 'pairing-*'
```

## Pass rule (ADR-0005)

For each skill:

- **Trigger:** the skill fires in at least 2 of 3 runs (the trigger case's
  `tool_used` grader scores ≥ 2/3).
- **Non-trigger:** the skill never fires (0 of 3).
- **Outcome:** the with-plugin arm beats the no-plugin baseline arm on the
  case's weighted criteria (the runner reports the score delta under the default
  `--ablation with-without`).

A failing case blocks the release like any red gate: fix the skill (usually its
`description:` for trigger cases, or the workflow steps for outcome cases),
re-run, and attach the passing result.

## Release evidence

Attach to the GitHub Release, next to the Release Conductor's evidence bundle:

1. `g14-<version>.json` — the full scored result (prompts, graders, per-run
   scores, baseline deltas);
2. `g14-<version>.html` — the human-readable report;
3. one line in the release notes: "G14 skill evals run on Claude Code
   `<cli version>` against tag `v<version>`: 9/9 cases pass" (or the honest
   count and the follow-up).

## Real-relay variant (optional, closer to the issue's spirit)

The outcome cases grade produced code and runbooks, so they need no live relay.
To grade an integration that actually sends through a relay, start one locally
(the `trueseal:relay` skill's compose quickstart) and re-run with Bash granted:

```bash
claude plugin eval . --trust-plugin --allow-tools Write Edit WebFetch Bash --case '*-outcome'
```

The prompts leave the Relay Address to the runner; a live relay makes the agent
fill it with the real one. This variant is informative, not part of the pass
rule — the ADR's bar is the graded criteria above.
