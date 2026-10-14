---
max_turns: 6
allowed_tools: [Read, Glob, Grep, Skill, WebFetch]
runs: 3
tags: [pairing, non-trigger]
---

Add a dark-mode toggle to my Android settings screen. It should follow the system
theme by default, let the user override it, and persist the choice across app
restarts with DataStore. Plain local settings work — no accounts, no servers.
