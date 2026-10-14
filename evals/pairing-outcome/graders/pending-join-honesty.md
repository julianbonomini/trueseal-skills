---
type: llm
weight: 2
---

The joining device is modelled honestly through its Pending Join state: after
joining it cannot send yet and the UI shows a waiting state until the first
manifest arrives; the state is treated as durable (a kill/restart mid-flow
resumes the pending join rather than restarting from scratch or stranding the
device); a cancel path exists. Code that treats join() as instantly completing
membership fails this criterion.
