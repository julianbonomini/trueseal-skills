---
type: llm
weight: 2
---

The produced integration deduplicates by the message's Message ID (it keeps the id
returned by `send` / delivered with the message and ignores a second delivery of
the same id), or it explicitly relies on the library's dedupe AND says so
correctly. Code that applies every delivery blindly — appending the same todo list
twice on redelivery — fails this criterion. This is the ADR-0005 outcome bar:
"Integrate dedupes by Message ID".
