---
title: Infrastructure Layer Patterns
source: /docs/architecture/ddd/ddd_guidance.md
sections:
  - Infrastructure Layer
  - 1. Repository Implementation Pattern
  - 2. Repository Mock Implementation Pattern
  - 3. DTO Implementation Pattern
---

# Infrastructure Layer Patterns

This reference summarizes how to implement the infrastructure layer based on
`ddd_guidance.md`.

## Responsibilities

- Implement domain repository interfaces.
- Handle API calls, persistence, and data transport details.
- Map between DTOs and domain entities / models.

## Repository implementation

- Implement interfaces defined in the **domain** layer.
- Use dependency injection (`@injectable`, `@LazySingleton`) as documented.
- Keep method signatures expressed in domain types where possible.
- Handle:
  - Networking / HTTP errors.
  - Mapping to domain error types.
  - Retrying or caching according to project conventions.

## Mock repositories

- Provide mock implementations for testing and development.
- Follow the patterns in `ddd_guidance.md` for:
  - In-memory data.
  - Deterministic responses for tests.
  - Error scenarios that match domain error hierarchies.

## DTOs and serialization

- Use **Freezed** for DTO structures where specified.
- Include `.freezed.dart` and `.g.dart` parts for JSON-enabled DTOs.
- Respect the **JSON Serialization Layer Rules** from the Code Generation
  Guidelines section.
- Keep mapping responsibilities clear:
  - DTOs ↔ JSON.
  - DTOs ↔ domain entities / models.

For concrete code templates and field-level examples, see the Infrastructure
Layer section in `/docs/architecture/ddd/ddd_guidance.md`.

