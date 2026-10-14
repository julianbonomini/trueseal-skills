---
type: llm
weight: 2
---

The implementation has EXPLICIT ADMISSION ON BOTH SIDES (ADR-0005: "Pairing must
implement admission on both sides"): device A opens a pairing window and surfaces
the Pairing Token; device B joins with the token; device A receives a join-request
event and a human confirm action accepts it (auto-accepting without user
confirmation fails this criterion). Both typed failure paths (window refused in
the wrong state, join refused) are handled.
