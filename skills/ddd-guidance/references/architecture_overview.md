---
title: DDD Architecture Overview
source: /docs/architecture/ddd/ddd_guidance.md
sections:
  - Architecture Overview
  - Key Architectural Principles
  - Module Development Rules
---

# DDD Architecture Overview

This reference summarizes the high-level architecture rules from
`ddd_guidance.md` that apply to every module.

## Layered module structure

- All modules use a **four-layer** structure:
  - `domain/` – core business rules and entities
  - `application/` – use cases and state management
  - `infrastructure/` – technical implementations (API, persistence, DTOs)
  - `presentation/` – UI components and widgets

The module root must look like:

```text
{module_name}/
├── domain/
├── application/
├── infrastructure/
└── presentation/
```

## Key architectural principles

- **MCP-ddd-layer-isolation**  
  Each layer communicates only with the layer immediately below it.
- **MCP-ddd-dependency-rule**  
  Dependencies always point inward toward the domain layer.
- **MCP-ddd-separation**  
  UI, business logic, and infrastructure concerns must be fully separated.

## Module development rules

- **Unified structure**
  - Every module must follow the exact same four-layer structure.
- **File naming convention**
  - `{module_name}_{component_type}.dart`
  - Examples: `change_plates_number_error.dart`,
    `athlete_details_notifier.dart`.
- **Class naming convention**
  - `{ModuleName}{ComponentType}`
  - Examples: `ChangePlatesNumberError`, `AthleteDetailsNotifier`.
- **Generated files**
  - Use `.freezed.dart` for Freezed types.
  - Use `.g.dart` for JSON-serializable DTOs.
- **Dependency injection**
  - Use `@injectable` and `@LazySingleton` annotations as specified in the
    main guide.

For detailed templates and examples, refer back to the corresponding sections
in `/docs/architecture/ddd/ddd_guidance.md`.

