---
title: Domain Layer Patterns
source: /docs/architecture/ddd/ddd_guidance.md
sections:
  - Domain Layer
  - 1. Constants - Validation Keys Pattern
  - 2. Entities - Domain Entity Pattern
  - 3. Errors - Domain Error Types Pattern
  - 4. Models - Request Model Pattern
  - 5. Repositories - Repository Interface Pattern
  - 6. Validators - Validation Rules Pattern
---

# Domain Layer Patterns

This reference summarizes how to design the domain layer for each module,
based on `ddd_guidance.md`.

## Responsibilities

- Contain core business logic and rules.
- Remain independent of Flutter, Riverpod, and infrastructure details.
- Define clear contracts for the rest of the system.

## Constants – validation keys

- File name template: `{module_name}_validation_keys.dart`.
- Use a class with:
  - Private constructor.
  - `static const` string keys for each validation error field.
- Purpose:
  - Centralize validation keys.
  - Support consistent error handling and localization mapping.

## Entities – domain entities

- File name template: `{module_name}.dart`.
- Use `abstract interface class` for core entities.
- Expose only the properties required by the domain.
- Avoid framework-specific types here.

## Errors – domain error types

- File name template: `{module_name}_error.dart`.
- Use **Freezed** sealed classes for domain error hierarchies.
- Follow rules:
  - Use `@freezed`.
  - Include `.freezed.dart` and `.g.dart` parts where specified.
  - Provide constructors for each domain-specific failure case.
- Respect:
  - `MCP-ddd-domain-layer`
  - `MCP-ddd-error-handling`

## Models – request models

- Represent input data required by domain operations.
- Use Freezed where the guide shows it.
- Keep them in the domain layer (not infrastructure) when they are part of the
  business contract.

## Repositories – repository interfaces

- File name template: `{module_name}_repository.dart` (or similar as shown).
- Define **interfaces only** in the domain layer.
- Repository contracts:
  - Expose domain-level operations in terms of domain entities / models.
  - Hide persistence, API, and other technical details.

## Validators – validation rules

- Centralize business validation.
- Use static methods for pure validation functions.
- Use validation key constants for error mapping.
- Ensure validators do not depend on UI or infrastructure.

For detailed code templates and examples, see the full domain layer section in
`/docs/architecture/ddd/ddd_guidance.md`.

