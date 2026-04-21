---
name: hooks
description: >
  Project-specific flutter_hooks usage. Use this skill whenever the user
  mentions HookWidget, HookConsumerWidget, custom hooks, or code that uses
  flutter_hooks. Always follow docs/packages/hooks/hooks.md before implementing
  or refactoring hooks.
---

# Hooks Skill

This skill captures the project’s best practices for flutter_hooks as described
in `docs/packages/hooks/hooks.md`.

## When to use this skill

Use this skill whenever:

- Creating or modifying **HookWidget / HookConsumerWidget** implementations.
- Writing or updating **custom hooks**.
- Refactoring stateful widgets to use hooks.

## Key reference

- Read `docs/packages/hooks/hooks.md` before:
  - Adding new hooks.
  - Changing hook order or dependencies.
  - Mixing hooks with Riverpod or other state management.

## Workflow

1. Identify widget(s) or logic that will use hooks.
2. Follow `hooks.md` for:
   - Correct hook usage and ordering.
   - Patterns for common scenarios in this project.
   - Integration with other packages (e.g. Riverpod).
3. Ensure the final widget follows all documented constraints to avoid
   inconsistent state or hot-reload issues.

