---
name: talker
description: >
  Talker logging patterns for this project. Use this skill whenever the user
  mentions logging, Talker, or log handling. Always follow
  docs/packages/talker/talker.md before changing logging code.
---

# Talker Skill

This skill describes how to use Talker for logging according to
`docs/packages/talker/talker.md`.

## When to use this skill

Use this skill whenever:

- Adding or modifying **log statements**.
- Configuring Talker loggers, filters, or observers.
- Handling errors and exceptions via Talker.

## Key reference

- Read `docs/packages/talker/talker.md` before:
  - Introducing new log categories or tags.
  - Changing log formatting or destinations.
  - Integrating Talker into new modules.

## Workflow

1. Identify what needs to be logged and at which level.
2. Follow `talker.md` for:
   - Logger APIs and configuration.
   - Log level and message patterns.
   - Error/exception logging conventions.

