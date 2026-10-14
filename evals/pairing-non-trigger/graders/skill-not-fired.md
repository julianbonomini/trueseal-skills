---
type: tool_used
tool: Skill
input_match: "trueseal"
min: 0
max: 0
weight: 1
---

The agent must NOT invoke any `trueseal` skill. A theme toggle with DataStore is
local settings work; "pairing" language never appears in the TrueSeal sense and
the skill firing here would be a false positive (docs ADR-0005).
