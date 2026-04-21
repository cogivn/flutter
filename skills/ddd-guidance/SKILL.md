---
name: ddd-guidance
description: >
  Domain-Driven Design architecture guide for this Flutter project.
  Use this skill whenever the user mentions DDD, modules, domain/application/
  infrastructure/presentation layers, entities, repositories, notifiers, state,
  DTOs, or module structure, or asks to add/modify code in a module. The skill
  makes sure all changes follow /docs/architecture/ddd/ddd_guidance.md,
  including layer isolation, naming conventions, file structure, and templates.
---

# DDD Architecture Skill for Flutter Modules

This skill helps you apply the project's Domain-Driven Design (DDD) rules when
creating or modifying modules in this Flutter app. It is tightly coupled to
`references/ddd_guidance.md` (full local mirror of the DDD guide) and should
always treat that document as the single source of truth.

## When to use this skill

Trigger and follow this skill whenever:

- The user mentions **DDD**, **domain layer**, **application layer**,
  **infrastructure layer**, or **presentation layer**
- The user works on a **module** (creating a new one or extending an existing
  one)
- The task involves **entities, repositories, validators, DTOs, errors,
  notifiers, state, hooks, pages, or widgets** inside a module
- The user asks about **module file structure**, **naming conventions**,
  **Freezed patterns**, **DTOs**, or **localization usage** in DDD modules

If there is any doubt whether DDD rules apply, assume they **do** and follow
this skill.

## Key references (read order)

Do **not** re-invent DDD patterns from memory. Always prefer local docs, with
this read order:

- **Primary full guide (read first for non-trivial tasks)**:
  - `references/ddd_guidance.md`

- **Project canonical source (cross-check when needed)**:
  - `/docs/architecture/ddd/ddd_guidance.md`

- **Compact reference files (this skill’s `references/` folder)**:
  - `references/architecture_overview.md`  
    High-level architecture, principles, and module development rules.
  - `references/domain_layer.md`  
    Domain-layer responsibilities, constants, entities, errors, models,
    repositories, validators.
  - `references/application_layer.md`  
    Notifier/state pattern, state template, cancel token management.
  - `references/infrastructure_layer.md`  
    Repository implementations, mocks, DTO patterns.
  - `references/presentation_layer.md`  
    Hooks, page patterns, body widgets for UI.
  - `references/module_structure_and_templates.md`  
    Module file structure, placement guidelines, naming, templates, checklists.
  - `references/code_generation_and_quick_reference.md`  
    Quick reference for agents, code generation guidelines, Freezed + JSON
    rules.

For any non-trivial task, read `references/ddd_guidance.md` first, then use
the compact `references/*.md` files for fast section lookup.

## Core architectural rules to enforce

When this skill is active, you must enforce at least these rules from
`references/ddd_guidance.md`:

- **Layer isolation & dependencies**
  - Respect `MCP-ddd-layer-isolation`: each layer talks only to the layer
    immediately below it.
  - Respect `MCP-ddd-dependency-rule`: dependencies always point inward toward
    the domain layer.
  - Respect `MCP-ddd-separation`: keep UI, business logic, and infrastructure
    concerns fully separated.
- **Module structure**
  - Every module follows the **four-layer** structure:
    `domain/`, `application/`, `infrastructure/`, `presentation/`.
  - Do not introduce ad-hoc folders inside a module unless explicitly allowed
    by `references/ddd_guidance.md`.
- **Naming conventions**
  - File names: `{module_name}_{component_type}.dart`.
  - Class names: `{ModuleName}{ComponentType}`.
  - Generated files must use `.freezed.dart` and `.g.dart` where required.
- **Freezed & data patterns**
  - Use the Freezed patterns described under **Freezed Patterns for DDD
    Layers**.
  - Follow JSON serialization rules from **JSON Serialization Layer Rules**.
- **Localization usage**
  - Apply `MCP-localization-usage`: widgets use `context.s.keyword`,
    non-widgets use `S.current.keyword`, functions with `BuildContext`
    parameter use `context.s.keyword`.

If the local document and general best practices ever disagree, always follow
the local document.

## Standard workflow for DDD coding tasks

When handling a user task that touches a module, follow this workflow:

1. **Identify module and layer**
   - Determine which module the change belongs to.
   - Determine the main layer(s) affected: domain, application,
     infrastructure, presentation.
2. **Read relevant sections**
   - Open `references/ddd_guidance.md` first.
   - Cross-check `/docs/architecture/ddd/ddd_guidance.md` when needed.
   - Read the **Architecture Overview**, **Module Development Rules**, and the
     sections listed in *Key references* for the layer(s) you will modify.
3. **Plan files and naming**
   - Decide which file(s) need to be created or updated.
   - Confirm correct directory and file names using **Module File Structure**,
     **File Placement Guidelines**, and **Naming Conventions**.
4. **Apply layer-specific patterns**
   - For each layer you touch, follow the corresponding pattern sections
     exactly (entities, repositories, DTOs, notifiers, state, hooks, pages,
     widgets, etc.).
   - For new modules or major features, consult **Implementation Templates**
     and the four layer checklists.
5. **Generate / update code**
   - Implement code following the patterns and examples in the relevant
     sections.
   - Use the code generation guidance when working with Freezed and build
     runner.
6. **Self-check against checklists**
   - For each affected layer, verify requirements using:
     - `Domain Layer Checklist`
     - `Application Layer Checklist`
     - `Infrastructure Layer Checklist`
     - `Presentation Layer Checklist`
  - If any checklist item is unclear, re-read the corresponding pattern
    section in `references/ddd_guidance.md`.

Always keep the number of changes minimal and focused on the user’s request,
while still honoring all DDD constraints.

## Layer-specific guidance (summary)

Use this as a quick mental checklist, but always refer back to the full
document for exact patterns and code templates.

### Domain layer

- Keep this layer free of framework-specific dependencies.
- Ensure:
  - Constants exist for validation keys.
  - Entities model core domain concepts and invariants.
  - Domain error types represent meaningful failure modes.
  - Request models and repositories are defined at the domain level.
  - Validators encapsulate business rules and use static pure functions where
    appropriate.

### Application layer

- Orchestrate use cases and state management only.
- Follow the **Notifier and State Implementation Pattern**:
  - Notifier and state live together where described by the guide.
  - Use Freezed for state.
  - Follow the Riverpod-related patterns referenced by the document.

### Infrastructure layer

- Provide technical implementations for domain repositories and DTOs.
- Ensure:
  - Repositories implement domain interfaces.
  - DTOs use Freezed and correct JSON serialization rules.
  - Mock repositories follow the documented mock patterns.

### Presentation layer

- Contain only UI concerns for a module.
- Follow:
  - Hook patterns for form management.
  - Page implementation patterns.
  - Body widget implementation patterns.
- Use localization and sizing patterns consistent with the rest of the project
  and any referenced UI documentation.

## Do and don’t

- **Do**
  - Always read the relevant parts of `references/ddd_guidance.md` before
    generating or editing DDD-related code.
  - Keep changes aligned with the four-layer structure and naming rules.
  - Prefer patterns and templates from the guide over ad-hoc solutions.
- **Don’t**
  - Invent new folder structures or naming patterns without explicit support in
    the guide.
  - Mix concerns between layers (for example, UI code in the domain layer, or
    persistence logic in the application layer).
  - Ignore the layer checklists when implementing or refactoring a module.
  - Rely only on memory when `references/ddd_guidance.md` is available.

If a user request seems to conflict with these rules, first try to reinterpret
the request so it fits the DDD architecture. If that is impossible, clearly
explain the conflict and propose a DDD-compliant alternative.

