---
max_turns: 15
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, WebFetch]
runs: 3
tags: [integrate, outcome]
---

I have a small TypeScript CLI (Node 20) that manages a todo list as JSON on disk.
I want two of my machines to share the same list over TrueSeal. I already run a
relay and have its Relay Address string.

Write the integration: a module that opens a session, sends an updated list when it
changes, and applies incoming lists from the other machine. It must be correct
under the delivery contract — messages can be delivered more than once and can
arrive while the other machine is offline. Write the actual code, and keep it small.
