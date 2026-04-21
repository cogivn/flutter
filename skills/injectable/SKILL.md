---
name: injectable
description: >
  Injectable-based dependency injection patterns. Use this skill whenever the
  user mentions dependency injection, @injectable, @LazySingleton, or DI
  configuration. Always follow docs/packages/injectable/injectable.md before
  changing DI setup.
---

# Injectable Skill

This skill captures the project’s dependency injection patterns using
Injectable, as documented in `docs/packages/injectable/injectable.md`.

## When to use this skill

Use this skill whenever:

- Registering or refactoring **services, repositories, or use cases** in DI.
- Adding annotations like `@injectable`, `@LazySingleton`, `@Singleton`, etc.
- Modifying DI configuration or module files.

## Key reference

- Read `docs/packages/injectable/injectable.md` before:
  - Adding new injectable types.
  - Changing scopes or lifecycles.
  - Regenerating DI configuration.

## Workflow

1. Identify which class or interface should be managed by DI.
2. Follow `injectable.md` for:
   - Proper annotation choice and placement.
   - Module organization.
   - Integration with DDD layers and the app entry point.

