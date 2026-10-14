---
max_turns: 15
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, WebFetch]
runs: 3
tags: [relay, outcome]
---

Set me up to run a TrueSeal relay on a small Ubuntu VPS with Docker for my app's
beta. I need: the exact bring-up (compose-based, pinned, ready to paste), how I get
the connection string my app's SDKs take, how I check it's healthy, what I must
back up and what happens if I lose it, and how upgrades work without me
accidentally wiping my users' queued messages. Write the runbook as files I can
keep in my ops repo.
