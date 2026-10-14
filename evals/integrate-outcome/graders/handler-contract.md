---
type: llm
weight: 2
---

The produced integration respects the handler contract: exactly one message
handler, registered before receiving is expected, and the handler is awaited —
the code does not try to acknowledge a message itself, does not ack before
processing finishes, and does not fire-and-forget the handler body (ADR-0005:
"must not ack before the handler finishes"). A throw inside the handler must be
treated as a failed attempt (retried per the contract), not swallowed silently.
