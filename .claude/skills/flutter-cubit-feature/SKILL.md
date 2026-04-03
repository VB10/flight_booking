---
name: flutter-cubit-feature
description: >-
  Adds or refactors a Flutter feature screen using Cubit (flutter_bloc), Equatable
  states with copyWith, BlocSelector for single-field listening, BlocBuilder/BlocListener,
  StatefulWidget + PageMixin for shared controllers, and ValueListenableBuilder
  for widget-local UI without setState. Registers services via ProductContainer (get_it).
  Use when the user runs /cubit-add, asks for Cubit + mixin + ValueListenable pattern,
  or points to docs/prompt/flutter_cubit_feature_prompt.md.
---

# Flutter Cubit + View + Mixin + ValueListenable

## When to apply

- User invokes **`/cubit-add`** or asks to add Cubit to a feature page.
- User wants the same structure as **login** or **flight list** in this repo.

## Authoritative spec

Read and follow:

- [docs/prompt/flutter_cubit_feature_prompt.md](../../../docs/prompt/flutter_cubit_feature_prompt.md)

## Implementation checklist

1. **State** (`cubit/*_state.dart`): `Equatable` + `copyWith`; always use a single immutable class with flat fields (`isLoading`, `errorMessage`, `isSuccess`, etc.) — do NOT use sealed classes.
2. **Cubit** (`cubit/*_cubit.dart`): business logic and `emit`; inject services via constructor (wired in mixin from `ProductContainer.instance.get<T>()`).
3. **Mixin** (`view/*_page_mixin.dart`): `part of` the page; only **shared** controllers here (e.g. `TextEditingController` used by multiple widgets). Widget-local `ValueNotifier`s belong in the widget's own `State`, not in the mixin.
4. **Page** (`*_page.dart`): `StatefulWidget` + `State` with mixin; `BlocProvider(create: (_) => cubit)`; `BlocListener` for navigation / one-shot side effects; pass shared controllers and callbacks into body.
5. **Body** (`view/widget/*_page_body.dart`):
   - `BlocSelector` for widgets that listen to a **single state field** (e.g. `isLoading`, `errorMessage`) — prevents unnecessary rebuilds.
   - `BlocBuilder` (with optional `buildWhen`) when a widget needs **multiple state fields**.
   - `ValueListenableBuilder` for widget-local UI state (password visibility, expand/collapse panels, etc.) — no `setState`.
6. **ValueNotifier naming**: always end with `Notifier` suffix — `obscureNotifier`, `expandedNotifier`, `selectedTabNotifier`.
7. **DI**: extend [lib/product/container/product_container.dart](../../../lib/product/container/product_container.dart) if a new service interface is required.
8. Run **`dart analyze`** on the touched feature path.

## Do not

- Put `Navigator` or `ScaffoldMessenger` inside the Cubit (use `BlocListener`).
- Use `setState` for state that belongs in Cubit or in a `ValueNotifier`.
- Pass a `ValueNotifier` from mixin to a widget if only that widget uses it — let the widget own it.
- Use `BlocBuilder` when only one field is needed — use `BlocSelector` instead.

## Reference code in this repo

- Login: `lib/feature/unauth/login/`
- Flight list: `lib/feature/auth/flight/cubit/`, `flight_list_page.dart`
- App container: `lib/product/container/product_container.dart`

## Slash command

Users can trigger the same workflow with:

- `.claude/commands/cubit-add.md` → **`/cubit-add {path}`**

Copy this `.claude/skills/flutter-cubit-feature/` folder into another project's `.claude/skills/` and keep or adapt `docs/prompt/flutter_cubit_feature_prompt.md` for portability.
