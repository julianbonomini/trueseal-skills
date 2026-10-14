---
type: llm
weight: 2
---

The produced runbook pins an EXACT release image tag for the relay (never
`:latest` or a floating tag), and says why (a relay upgrade is deliberate, and the
store version may force a decision). A runbook that pulls a floating tag — or
silences the version question — fails this criterion.
