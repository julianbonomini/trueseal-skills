---
type: tool_used
tool: Skill
input_match: "trueseal"
min: 0
max: 0
weight: 1
---

The agent must NOT invoke any `trueseal` skill. A Postgres query-plan question
mentions a "server" only in the database sense; the relay skill firing here would
be a false positive (docs ADR-0005).
