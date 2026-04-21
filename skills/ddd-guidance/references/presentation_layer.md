---
title: Presentation Layer Patterns
source: /docs/architecture/ddd/ddd_guidance.md
sections:
  - Presentation Layer
  - 1. Hooks for Form Management Pattern
  - 2. Page Implementation Pattern
  - 3. Body Widget Implementation Pattern
---

# Presentation Layer Patterns

This reference summarizes how to structure the presentation layer for each
module based on `ddd_guidance.md`.

## Responsibilities

- Contain only UI concerns: widgets, layout, and interaction with notifiers.
- Use state and actions exposed by the application layer.
- Apply localization and sizing according to project-wide rules.

## Hooks for form management

- Use the form-related hooks described in the Presentation Layer section for:
  - Managing input controllers.
  - Tracking validation state.
  - Wiring form fields to notifier actions.
- Keep validation logic in domain validators and only trigger/consume results
  in the UI.

## Page implementation pattern

- Follow the recommended page structure:
  - Top-level page widget (e.g. `ChangePlatesNumberPage`).
  - Connection to the corresponding notifier/provider.
  - Clear separation between:
    - App bar / scaffold shell.
    - Body content (usually delegated to a body widget).

## Body widget implementation

- Extract complex layouts into dedicated body widgets as shown in the guide.
- Keep widgets focused on:
  - Layout.
  - Wiring to state and actions.
  - Displaying errors and loading states from the application layer.
- Use localization keys and sizing helpers consistently with:
  - `MCP-localization-usage`.
  - The project’s Flutter and sizing documentation.

For widget-level examples and more detailed patterns, see the Presentation
Layer section in `/docs/architecture/ddd/ddd_guidance.md`.

