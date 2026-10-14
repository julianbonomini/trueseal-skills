---
max_turns: 8
allowed_tools: [Read, Glob, Grep, Skill, WebFetch]
runs: 3
tags: [integrate, trigger]
---

I'm building a small macOS notes app in Swift and I want my notes to stay in sync
between my Mac and my iPhone. I don't want to run my own sync server logic or trust
a cloud database with the note contents. A friend mentioned TrueSeal is made for
exactly this. Add it to my project and wire up the smallest possible thing: when a
note changes on one device, the other device gets it. Show me the code.
