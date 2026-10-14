---
type: llm
weight: 2
---

The runbook treats the keypair as the relay's identity: it is generated on first
start (never hand-copied into the repo or printed into committed files), the
backup section centres on it, and it states plainly that losing it strands every
client and that there is no key rotation in the preview. The Relay Address for
clients comes from the documented command (key, host and both ports in ONE
`trueseal://…` string — not hand-assembled host/port instructions).
