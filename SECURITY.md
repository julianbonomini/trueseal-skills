# Security Policy

TrueSeal is a **developer preview**. Everything here is `0.x`, published and installable,
and openly allowed to break. This policy is the same across every `trueseal-*` repository.

## Reporting a vulnerability

**Please report security issues privately through
[GitHub Security Advisories](../../security/advisories/new) (private vulnerability
reporting) — never in a public issue, discussion, or pull request.**

Include what you can: the affected skill or file, the scenario, and which property you
believe is broken.

If private vulnerability reporting is unavailable for some reason, open a public issue
describing only that you have something to report privately, and we will arrange a channel.

## What to expect

- **Best effort, no SLA.** We will acknowledge and investigate as time allows. There is no
  response-time commitment.
- **No bounty.** There is no paid program.
- **Fixes land only in the next 0.x release.** Nothing is backported to earlier versions.
  There is no notice period, and every breaking release carries Upgrade Notes.
- **Disclosure.** Confirmed findings are published as GitHub Security Advisories, crediting
  the reporter unless you ask otherwise. We ask that you give us a reasonable window to
  ship a fix before public disclosure.

## Scope: what is a security finding in this repo

This repo contains agent workflow skills — documentation for coding agents, no executable
protocol code. In scope for a report:

- Guidance that would lead an agent to **weaken a security property** of an integrating
  app — for example instructions that bypass explicit admission in pairing, disable
  deduplication, ack before the handler finishes, or leak key material.
- A link or reference that resolves to attacker-controlled content.

Protocol, SDK and relay findings belong to their owning repos
([trueseal-sync](https://github.com/julianbonomini/trueseal-sync),
[trueseal-relay](https://github.com/julianbonomini/trueseal-relay), the SDK repos) —
their SECURITY.md files name the same reporting channel. The documented limitations of
the preview (no forward secrecy, relay-visible metadata, no SAS, and the rest) are listed
in the [Threat Model](https://trueseal.dev/agents/threat-model) and are not findings.
