---
name: auto-route
description: >
  Reusable AutoRoute navigation skill for Flutter projects. Use when working on
  routing setup, route declarations, @RoutePage annotations, nested routes,
  deep links, guards, route arguments, navigation APIs (push/replace/navigate),
  or build_runner generation for auto_route and auto_route_generator.
---

# AutoRoute Reusable Skill

Implement and maintain navigation with `auto_route` in a way that is portable
across Flutter projects.

Primary source for this skill: `auto_route_library` official README.
Official guide link: <https://raw.githubusercontent.com/Milad-Akarie/auto_route_library/refs/heads/master/README.md>

## Execution workflow

1. Detect the navigation scope.
2. Ensure dependencies and generation mode.
3. Update route declarations and page annotations.
4. Wire app-level router config.
5. Wire navigation calls from UI/application flows.
6. Validate stack behavior, tabs, guards, deep links.
7. Add fallback and observability.

## 1) Detect the navigation scope

Classify the user request first:

- **Bootstrap**: add AutoRoute to a project from scratch.
- **Feature route**: add/edit one or more screens and route args.
- **Structure change**: nested routing, tabs, shell/router hierarchy.
- **Access control**: route guard, redirect, auth-aware flow.
- **Web/deep-linking**: path strategy, params/query, URL behavior.
- **Behavior fix**: wrong stack behavior, duplicate route, bad pop/back handling.

## 2) Ensure dependencies and generation mode

Ensure these are present in `pubspec.yaml`:

- `dependencies`: `auto_route`
- `dev_dependencies`: `auto_route_generator`, `build_runner`

Optional fast incremental generation:

- `dev_dependencies`: `lean_builder`
- one-time: `dart run lean_builder build`
- watch: `dart run lean_builder watch`

Use one root router and keep router initialization outside widget build methods.

## 3) Update route declarations and pages

### Router class (`@AutoRouterConfig`)

- Keep a single app router class extending `RootStackRouter`.
- Keep route list centralized and ordered (matching is order-sensitive).
- Use `replaceInRouteName` for consistent naming.
- Set `defaultRouteType` when project-wide transition policy is required.

### Routable pages

- Annotate pages with `@RoutePage()`.
- Prefer typed constructor params; let generated routes carry typed args.
- Use path/query annotations when URL-driven state is needed:
  - `@PathParam(...)` / `@pathParam`
  - `@QueryParam(...)` / `@queryParam`
  - `@PathParam.inherit(...)` for nested inherited segments.

### Nested routes

- Use parent `AutoRoute(..., children: [...])` for scoped router trees.
- Render nested content with `AutoRouter()` in parent shell.
- Set initial child with empty path `''`, `initial: true`, or `RedirectRoute`.
- Keep each router responsible for its own stack.

### Guards and redirects

- Use `AutoRouteGuard` for auth/role/policy checks.
- Prefer `resolver.redirectUntil(...)` for temporary redirect flows.
- Call resolver completion exactly once (`resolver.next(...)` or equivalent).
- For global policy, override `guards` in root router.

## 4) Wire app-level router config

Use `MaterialApp.router(routerConfig: appRouter.config(...))` and configure:

- `deepLinkTransformer` for URL rewriting/prefix stripping.
- `deepLinkBuilder` for validating/overriding inbound deep links.
- `reevaluateListenable` for auth/state-driven guard re-evaluation.
- `navigatorObservers: () => [FreshObserverInstance()]` (new instances).

Prefer DI-managed router singleton for navigation without context.

## 5) Run generation

After changing router/page annotations:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For active iteration:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

Fix annotation/import/type errors before rerunning generation.

## 6) Navigation API selection rules

Prefer typed generated routes (`PageRouteInfo`) over raw strings/paths.

Use API by intent:

- `push`: add a new entry on top.
- `replace`: replace current top entry.
- `navigate`: pop to existing route if present, otherwise push (web-friendly).
- `pushAll` / `replaceAll`: commit multi-route stack changes.
- `pop`, `maybePop`, `popUntil...`, `popUntilRoot`: unwind behavior.
- `back`: browser/native back integration.

Use path APIs only when URL-driven workflows are required:

- `pushPath`, `replacePath`, `navigatePath`
- named route fallback (`NamedRouteDef`, `NamedRoute`) without generation.

## 7) Nested routers, tabs, and router lookup

- Scoped router from context resolves nearest parent router.
- Access parent/root router intentionally (`router.parent<T>()`, `router.root`).
- Access inner routers from outside scope only when necessary:
  - `GlobalKey<AutoRouterState>`
  - `context.innerRouterOf<StackRouter/TabsRouter>(RouteName)`

Tab UX:

- Prefer `AutoTabsRouter` / `AutoTabsScaffold` over manual push/replace per tab.
- Use `.pageView` or `.tabBar` constructors when needed.
- Keep tab state preserved offstage (default behavior).

## 8) Deep links and path design

- Define explicit memorable paths for web/deep-link-first apps.
- Keep prefix-match order correct for hierarchical URLs.
- Handle unknown paths with wildcard (`*`) route at the end.
- Use `RedirectRoute` for deterministic path migrations.
- Ensure full hierarchy is provided for deep navigation in nested trees.

## 9) Observability and route lifecycle hooks

- Use `AutoRouterObserver` for push/replace/pop tracking.
- Use `didInitTabRoute` / `didChangeTabRoute` for tab observability.
- Use `AutoRouteAware` or `AutoRouteAwareStateMixin` for route-aware pages.
- Use `activeGuardObserver` for guard-in-progress UX states.

## 10) Customization patterns

- Use `CustomRoute` for custom transitions.
- Use `customRouteBuilder` for full page route control.
- Use `AutoRouteWrapper` to wrap route pages with providers/theme scope.
- Use `AutoLeadingButton` / `AutoBackButton.builder` for nested-aware back UI.

## 11) Builder performance and large apps

For faster generation in large codebases, tune `build.yaml`:

- narrow `generate_for` globs for page/router files.
- enable cached builds when suitable.
- configure generator options for lint-ignore output behavior.

## 6) Validation checklist

Validate these before finishing:

- Build succeeds after generation.
- Each new route is reachable from intended entry points.
- Back button behavior is correct on Android and iOS.
- Android predictive back behavior is correct if enabled.
- Guards do not trap user in redirect loops.
- Route arguments are serializable/typed as expected.
- Deep links land on the correct stack level.
- Unknown routes are handled via wildcard/fallback strategy.
- Nested router scope resolves as expected for actions.
- Navigation observers do not reuse stale singleton observer instances.

## Common pitfalls to prevent

- Router created inside `build` method (causes state/reset issues).
- Mixed raw-path navigation and typed route navigation without clear reason.
- Missing `@RoutePage()` on new screens.
- Forgot build_runner after route changes.
- Guard branches not resolving exactly once.
- Wildcard route defined before specific routes.
- Tab navigation implemented via manual stack churn instead of tabs router.
- Reusing the same observer instance across nested routers.
- Navigating without context in nested trees using incomplete hierarchy.

## Output expectations for this skill

When applying this skill, always produce:

1. Updated router/page files.
2. Generated routing artifacts.
3. A concise verification note describing:
   - What route behavior changed.
   - Which navigation API was chosen and why.
   - What was tested manually or by automation.

