---
type: llm
weight: 1
---

The produced code is true to the canonical TrueSeal API shape: the Relay Address
is passed as ONE string (never split into host/port arguments), `send` returns a
MessageId, errors are the typed error cases (not string matching), and no numeric
limits (payload size, group size, versions) are hard-coded from memory — the code
or the prose either reads them from the SDK or links the Agent Docs. Invented
method names or made-up limits fail this criterion.
