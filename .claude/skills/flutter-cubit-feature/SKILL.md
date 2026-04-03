---
name: flutter-cubit-feature
description: >-
  Adds or refactors a Flutter feature screen using Cubit (flutter_bloc), Equatable
  states, StatefulWidget + PageMixin for lifecycle and actions, BlocProvider.value,
  BlocListener/BlocBuilder, and ValueListenableBuilder for local UI without setState.
  Registers services via ProductContainer (get_it) when needed. Use when the user
  runs /cubit-add, asks for Cubit + mixin + ValueListenable pattern, or points to
  docs/prompt/flutter_cubit_feature_prompt.md.
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
2. **Cubit** (`cubit/*_cubit.dart`): business logic and `emit`; inject `IAuthService`, `IFlightService`, `IProductNetworkManager`, etc. via constructor (wired in mixin from `ProductContainer.instance.get<T>()`).
3. **Mixin** (`view/*_page_mixin.dart`): `part of` the page; `late final` controllers, `ValueNotifier`s; dispose notifiers/controllers in `dispose`; access cubit via `context.read<Cubit>()` — BlocProvider manages cubit lifecycle.
4. **Page** (`*_page.dart`): `StatefulWidget` + `State` with mixin; `BlocProvider(create: (_) => Cubit(...))`; `BlocListener` for navigation / one-shot side effects; pass mixin fields and callbacks into body.
5. **Body** (`view/widget/*_page_body.dart`): `BlocBuilder` for cubit-driven UI; `ValueListenableBuilder` for password visibility, expand/collapse panels, etc.; no `setState` for those.
6. **DI**: extend [lib/product/container/product_container.dart](../../../lib/product/container/product_container.dart) if a new service interface is required.
7. Run **`dart analyze`** on the touched feature path.

## Do not

- Put `Navigator` or `ScaffoldMessenger` inside the Cubit (use `BlocListener`).
- Use `setState` for state that belongs in Cubit or in a `ValueNotifier`.
- Register every page Cubit in GetIt unless the team explicitly wants a global singleton (default: create in mixin, provide with `BlocProvider.value`).

## Reference code in this repo

- Login: `lib/feature/unauth/login/`
- Flight list: `lib/feature/auth/flight/cubit/`, `flight_list_page.dart`
- App container: `lib/product/container/product_container.dart`

## Slash command

Users can trigger the same workflow with:

- `.claude/commands/cubit-add.md` → **`/cubit-add {path}`**

Copy this `.claude/skills/flutter-cubit-feature/` folder into another project’s `.claude/skills/` and keep or adapt `docs/prompt/flutter_cubit_feature_prompt.md` for portability.
