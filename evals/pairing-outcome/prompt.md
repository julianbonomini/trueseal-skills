---
max_turns: 15
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, WebFetch]
runs: 3
tags: [pairing, outcome]
---

Implement the device-linking flow for my Swift app that syncs with TrueSeal. Two
devices, no accounts: device A shows a code (I'll render it as a QR myself), device
B enters or scans it, and device A must approve B before B can participate. The UI
must show B's waiting state honestly, survive either app being killed and
restarted at any point, and handle B being refused or the group being torn down
later. Write the view-model layer code and the state machine it drives.
