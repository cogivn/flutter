---
title: Application Layer Patterns
source: /docs/architecture/ddd/ddd_guidance.md
sections:
  - Application Layer
  - 1. Notifier and State Implementation Pattern
  - State Implementation Template
  - Cancel Token Management Pattern
---

# Application Layer Patterns

This reference summarizes how to structure the application layer for each
module, based on `ddd_guidance.md`.

## Responsibilities

- Coordinate use cases and state transitions.
- Orchestrate domain operations and expose state to the presentation layer.
- Contain no UI widgets or infrastructure details.

## Notifier and state pattern

- Keep **notifier** and **state** closely paired as shown in the guide.
- Use **Freezed** for immutable state classes.
- Use the documented Riverpod patterns (for example, `Notifier` /
  `NotifierProvider.autoDispose`) from the main document.
- State class:
  - Holds all UI-relevant data.
  - Encodes loading/error/success states using union types where appropriate.
- Notifier:
  - Exposes intent methods (e.g. `fetchData`, `submitForm`).
  - Updates state immutably.

## State implementation template

- Follow the template in `ddd_guidance.md` for:
  - Import layout.
  - `@freezed` usage and generated part names.
  - Initial state factory.
  - Copy-like transitions (e.g. `copyWith` or pattern-matching helpers).

## Cancel token and resource cleanup

- Follow the **Cancel Token Management Pattern** and `ref.onDispose`
  guidance in the Application Layer section.
- Ensure any subscriptions, controllers, or cancel tokens are released in
  `onDispose` to avoid leaks.

For complete examples and Riverpod-specific details, refer back to the
Application Layer section in `/docs/architecture/ddd/ddd_guidance.md`.

