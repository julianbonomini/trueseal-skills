---
type: tool_used
tool: Skill
input_match: "trueseal"
min: 0
max: 0
weight: 1
---

The agent must NOT invoke any `trueseal` skill. This is a non-trigger case: a
local-only CSV/chart task has nothing to do with TrueSeal sync, pairing or relay
operation, and the skill firing here would be a false positive that dilutes
triggering (docs ADR-0005).
