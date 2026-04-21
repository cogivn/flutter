---
title: Code Generation and Quick Reference
source: /docs/architecture/ddd/ddd_guidance.md
sections:
  - Quick Reference for AI Agents
  - Code Generation Guidelines
  - Freezed Patterns for DDD Layers
  - JSON Serialization Layer Rules
---

# Code Generation and Quick Reference

This reference extracts the parts of `ddd_guidance.md` that are most relevant
for automated code generation and fast lookup by agents.

## Quick reference for AI agents

- Use the **Common Patterns by Purpose** mapping to jump to the right section:
  - Form validation → Validators Pattern.
  - Error handling → Error Types Pattern.
  - State management → Notifier Pattern.
  - API integration → Repository Implementation Pattern.
  - UI forms → Hooks Pattern.
  - New module setup → Quick Start Template.
  - Localization usage → Localization Requirements.
- Use the **File Templates by Layer** mapping to locate concrete templates for:
  - Domain: constants, entities, errors, models, repositories, validators.
  - Application: notifier and state.
  - Infrastructure: repository impl, repository mock, DTOs.
  - Presentation: hooks, pages, widgets.

## Code generation guidelines

When generating or updating code, follow these rules:

- Use **Freezed and build_runner** exactly as described in the Code Generation
  Guidelines section.
- Respect:
  - Required dependencies.
  - File generation rules (which files should have `.freezed.dart` and
    `.g.dart`).
  - Naming convention summary for generated parts.
- Do not guess part file names—derive them using the patterns in the main
  document.

## Freezed patterns for DDD layers

- Domain, application, and infrastructure layers use Freezed with:
  - Annotated classes (`@freezed`).
  - Proper `part` directives.
  - Union types for error hierarchies and state variants where described.
- Ensure compatibility with the project’s Dart and Freezed versions by
  following the examples in `ddd_guidance.md`.

## JSON serialization layer rules

- DTOs and other JSON-enabled types must:
  - Use the correct `@JsonSerializable` (or equivalent) configuration from the
    document.
  - Include `.g.dart` parts and generated code.
  - Map precisely between API payloads and domain types, preserving field
    names and nullability rules as specified.

For exact annotations, field-level options, and examples, consult the Code
Generation Guidelines and JSON Serialization sections in
`/docs/architecture/ddd/ddd_guidance.md`.

## Best practices and common patterns

- The **Best Practices and Common Patterns** section in the main guide collects
  cross-cutting advice (naming, error handling, validation, layering).
- When designing something non-trivial or choosing between multiple patterns,
  skim that section in `ddd_guidance.md` after using this quick reference to
  align with established project conventions.


