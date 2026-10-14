---
type: tool_used
tool: Skill
input_match: "pairing"
min: 1
weight: 1
---

The agent must invoke the `trueseal:pairing` skill (the Skill tool with `pairing`
in its input). The prompt describes the pairing workflow — a token/QR exchange
with explicit admission, the waiting state, restart behaviour — without naming
the skill, so firing it proves the description routes a natural pairing request.
