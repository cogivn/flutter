---
title: Module Structure, Templates, and Checklists
source: /docs/architecture/ddd/ddd_guidance.md
sections:
  - Module File Structure
  - Implementation Templates
  - Domain/Application/Infrastructure/Presentation Layer Checklists
---

# Module Structure, Templates, and Checklists

This reference summarizes how to structure a module on disk and how to use the
implementation templates and checklists from `ddd_guidance.md`.

## Standard module structure

- Root folders:
  - `domain/`
  - `application/`
  - `infrastructure/`
  - `presentation/`
- Inside each folder, follow the component-specific naming and placement rules
  from the main guide (e.g. entities, repositories, DTOs, notifiers, hooks,
  widgets).

## File placement guidelines

- Place each concern in the correct layer:
  - Domain: entities, errors, repositories (interfaces), validators, request
    models, validation keys.
  - Application: notifiers, state, use-case orchestration.
  - Infrastructure: repository implementations, DTOs, data sources, mocks.
  - Presentation: pages, body widgets, form hooks, UI-only helpers.
- Avoid cross-layer shortcuts—if a file mixes concerns, refactor into multiple
  files placed in the correct layers.

## Naming conventions

- File names: `{module_name}_{component_type}.dart`.
- Class names: `{ModuleName}{ComponentType}`.
- Localization and generated files:
  - Generated: `.freezed.dart`, `.g.dart`.
  - Localization keys and usage follow the Localization section in the main
    doc.

## Implementation templates

- Use the **Quick Start Template for New Modules** to scaffold:
  - Domain contracts and entities.
  - Application notifiers and state.
  - Infrastructure repository + DTOs.
  - Presentation pages and widgets.
- For each layer, there are checklists:
  - Domain Layer Checklist.
  - Application Layer Checklist.
  - Infrastructure Layer Checklist.
  - Presentation Layer Checklist.

## Using the checklists

- After implementing or modifying a module:
  - Walk through each relevant checklist item for the layers you touched.
  - Confirm file placement, naming, and responsibilities.
  - Verify Freezed and JSON generation requirements.
  - Check localization and error-handling coverage.

For exact checklist items and full templates, read the Module File Structure
and Implementation Templates sections in
`/docs/architecture/ddd/ddd_guidance.md`.

