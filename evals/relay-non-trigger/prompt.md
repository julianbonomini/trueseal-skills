---
max_turns: 6
allowed_tools: [Read, Glob, Grep, Skill, WebFetch]
runs: 3
tags: [relay, non-trigger]
---

This Postgres query is slow — it joins orders to customers and filters on
order_date, and the planner insists on a sequential scan even though there's an
index on order_date. Table sizes are in the millions. Explain why the index is
ignored and rewrite the query (or suggest the missing index) so it uses it.
