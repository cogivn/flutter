---
name: sizing
description: >
  Responsive sizing patterns for this project. Use this skill whenever the
  user mentions widget sizes, padding, margin, font sizes, or layout spacing
  in Flutter UI. Always follow docs/packages/sizing/sizing.md before writing
  or refactoring sizing-related code.
---

# Sizing Skill

This skill ensures all UI sizing follows the project’s responsive rules from
`docs/packages/sizing/sizing.md`.

## When to use this skill

Use this skill whenever:

- Creating or adjusting **width, height, padding, margin, radius, or font
  sizes**.
- Implementing new widgets or refactoring existing layouts.
- Working on any presentation-layer code that uses hard-coded numeric sizes.

## Key reference

- Read `docs/packages/sizing/sizing.md` before:
  - Adding new dimensions or typography.
  - Refactoring UI to be responsive.
  - Choosing between `.ss`, `.sw`, `.sh`, `.fs`, `.fss`, etc.

## Workflow

1. Identify all hard-coded sizes in the area you are changing.
2. Use the sizing extensions from `sizing.md` to convert them to responsive
   values.
3. Keep usage consistent with documented examples for spacing and typography.

