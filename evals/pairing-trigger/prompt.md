---
max_turns: 8
allowed_tools: [Read, Glob, Grep, Skill, WebFetch]
runs: 3
tags: [pairing, trigger]
---

My Kotlin app already syncs with TrueSeal. Now I need the screen where a user links
a second phone: the first phone shows something the second phone scans, and the
first phone must approve the second before anything syncs. Handle the awkward
states too — what the second phone shows while it waits, and what happens if the
app is killed mid-flow. Build the flow and explain the states.
