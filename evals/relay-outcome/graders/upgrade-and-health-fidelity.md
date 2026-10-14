---
type: llm
weight: 1
---

The runbook's health and upgrade sections match the real relay: health is checked
through the documented `/healthz` behaviour (including that it fails when the
store is down), and the upgrade story covers the store version — a newer store is
refused, a Store Reset release requires the operator's explicit reset flag, and
queued messages survive ordinary upgrades. Invented endpoints, flags or an
"upgrade wipes nothing ever" claim fail this criterion.
