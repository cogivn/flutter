---
name: retrofit
description: >
  Retrofit-based API integration patterns for this project. Use this skill
  whenever the user mentions API clients, HTTP interfaces, or network DTOs
  built with Retrofit. Always follow docs/packages/retrofit/retrofit.md before
  changing Retrofit code.
---

# Retrofit Skill

This skill enforces the project’s Retrofit usage as documented in
`docs/packages/retrofit/retrofit.md`.

## When to use this skill

Use this skill whenever:

- Creating or modifying **API client interfaces** using Retrofit.
- Defining or updating **network DTOs** tied to Retrofit clients.
- Wiring Retrofit services into repositories or DI.

## Key reference

- Read `docs/packages/retrofit/retrofit.md` before:
  - Adding new endpoints or clients.
  - Changing annotations or base URLs.
  - Adjusting error handling or interceptors tied to Retrofit.

## Workflow

1. Identify the API surface (endpoints, params, responses) you need.
2. Follow `retrofit.md` for:
   - Interface and annotation style.
   - Return types and error mapping.
   - Integration with Dio and the repository layer.
3. Ensure generated code and configuration match the documented patterns.

