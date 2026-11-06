---
name: masterflutter-design-system-setup
description: >-
  Takes a Claude Design export (a folder of *.dc.html boards + Handoff notes) and builds the
  project's design system from it: a local module/ui_kit package (color palette, ColorScheme,
  ThemeExtension roles, type scale, spacing/radius/size tokens, UiKitTheme builder, every base
  component with all its states, widget tests, a web gallery app), the app wiring (re-export
  barrel, AppTheme with the app font), product-level domain widgets, the shared data contracts
  the screens need (NEW DATA on models + backend, app-wide cubits) and docs/design/kit_mapping.md
  — the dictionary the screen skill reads. Then it plans the screen bindings and dispatches them,
  one by one, to the masterflutter-screen-binder agent (Sonnet). Run this on Opus in the main
  session. Use when the user runs /masterflutter-design-system-setup, says "Claude Design'dan
  tasarım geldi", "design system'i kur", "tasarımı projeye bağla", "yeni tasarımı sıfırdan
  entegre et", or drops a design export folder into the repo.
---

> **Language:** these instructions are in English. Talk to the user in Turkish; code,
> identifiers and commit messages stay in English.

# Claude Design export → design system → screens

Two phases, two models, one contract between them.

| Phase | Who | Output |
|---|---|---|
| **1 · Design system** | **Opus**, main session (this skill) — decisions, architecture, cross-cutting code | `module/ui_kit`, app wiring, product widgets, data contracts, `docs/design/kit_mapping.md` |
| **2 · Screens** | **Sonnet**, [`masterflutter-screen-binder`](../../agents/masterflutter-screen-binder.md) agent running [`/masterflutter-design-screen`](../masterflutter-design-screen/SKILL.md), one screen per run, sequential | one feature folder per screen |

Why the split: Phase 1 is judgement-heavy (what is a token, what is a component, where the
package boundary is, which data the screens share). Phase 2 is repetitive and checklist-shaped —
once `kit_mapping.md` exists, binding a screen is lookup work, which Sonnet does well and
cheaply. **Never start Phase 2 before `kit_mapping.md` is written.**

## 0 · Intake

1. Locate the export (e.g. `flight_booking_design/`) and move it to `docs/design/claude_design/`.
2. Read `FLUTTER_PROMPT.md` if present, but **this repo's architecture wins**: Cubit + mixin,
   GetIt (`ProductContainer`), typed go_router, `LocaleKeys`. Ignore Riverpod / Freezed / Clean
   Architecture suggestions from the export and tell the user you did.
3. Boards are templated HTML. The values live in the `<style>` block (tokens as CSS custom
   properties on `.light` / `.dark`, component classes) and in the `<script>` block (sample
   data, state lists, the Handoff inventory). Read with CSS/script extracted, not raw.
   - `Main.dc.html` → color roles (light + dark hex), spacing, type scale, radius, sizes
   - `Components.dc.html` / `States.dc.html` → every component and state
   - `Handoff.dc.html` → per-screen component inventory, NEW DATA / NEW FEATURE, navigation map
4. Note in a short plan: token list, component list (kit vs. domain), NEW DATA / FEATURE
   decisions, shared state the screens need, screen order.

## 1 · Package: `module/ui_kit`

Shape (mirror `module/cache_manager`):

```
module/ui_kit/
  pubspec.yaml               flutter + only what widgets need (e.g. shimmer)
  analysis_options.yaml      very_good_analysis, same as cache_manager
  lib/ui_kit.dart            barrel — exports theme + widgets
  lib/src/theme/             app_colors (AppPalette light/dark, every role incl. scrim),
                             app_color_scheme, app_theme_extension (non-M3 roles +
                             context.appTheme / context.colorScheme / context.appTextTheme),
                             app_text_styles (scale with line heights, NO font family),
                             app_sizes, app_radius (small/medium/large + legacy getters),
                             app_page_padding, product_text, ui_kit_theme (ThemeData + component
                             themes: appBar, dialog, snackBar, switch, segmented, progress,
                             divider, card)
  lib/src/widget/<group>/    button · input · navigation · display · feedback · state · layout
  test/                      one test per component behaviour/state
  example/                   web gallery (`flutter create --platforms=web -e example`),
                             every component × state, light/dark toggle
```

Rules:
- **Names 1:1 with the kit page.** The board's component name is the class name.
- **The package is asset- and l10n-free.** Font family comes in through
  `UiKitTheme.light(fontFamily:)`; widgets take ready strings (labels, tooltips) as parameters.
- **Kit = generic, domain widgets stay in the app.** `AppButton`, `AppDialog`, `EmptyState` go
  into the package; `FlightCard`, `RouteVisual` go to `lib/product/widget/<domain>/`, built from
  kit parts, taking display-ready values (not feature models).
- **Keep existing token APIs compiling** (legacy getters like `AppRadius.circular12`) so
  un-migrated pages build until their screen run replaces them. Move the old theme files with
  `git mv` to keep history.
- Dialog and snackbar are **static `show` helpers** returning futures/controllers, so screens
  never touch `showDialog` / `SnackBar` directly.
- Every icon-only control requires a tooltip / semantic label parameter.

Verify: `dart analyze lib` clean · `flutter test` green · `flutter build web` in `example/`.

## 2 · App wiring

- `pubspec.yaml`: `ui_kit: path: module/ui_kit`.
- `lib/core/theme/theme.dart` becomes the single import: re-exports `package:ui_kit/ui_kit.dart`
  and the app's `AppTheme` (`UiKitTheme.light/dark(fontFamily: FontFamily.<generated>)`).
- Remove an empty template package if the kit replaces it (e.g. `module/utils`).
- `flutter analyze` must have **zero errors** before Phase 2.

## 3 · Data contracts the screens share

Decide these yourself — screens must not invent them in parallel:
- **NEW DATA**: nullable fields on the models (+ regenerate json_serializable) and, when the
  backend is ours, the backend mock/endpoint. Verify by running the backend and curling.
- **Shared state**: anything two screens read/write (cart, selection, settings) becomes an
  app-level cubit in `lib/product/application/<name>/`, registered in `ProductContainer`, with a
  unit test.
- **Fictional content**: replace real brand/airline names in seed data with the kit's fictional
  ones.

## 4 · `docs/design/kit_mapping.md`

The contract for Phase 2. Sections: (1) tokens — CSS var → `colorScheme` / `appTheme`, gap
classes → `AppSizes`, radius, sizes, typography classes → `ProductText` roles; (2) components —
board class → widget + key parameters; product widgets; (3) app contracts — shared cubits,
model fields; (4) KIT GAP rule. Use this repo's file as the template:
[docs/design/kit_mapping.md](../../../docs/design/kit_mapping.md).

## 5 · Dispatch the screens (Phase 2)

1. Stage Phase 1 (`git add`) so every screen's diff is reviewable on its own.
2. Order by dependency: entry screens first, screens that consume shared state after the ones
   that produce it (here: Splash → Login → Flights → Detail → Cart (+ confirmation) → Profile).
3. For each screen, dispatch **one** agent and wait for its report before the next:
   - `subagent_type: masterflutter-screen-binder` (if the agent type is not loaded yet in this
     session, use `general-purpose` with `model: sonnet` and tell it to read
     `.claude/agents/masterflutter-screen-binder.md` first).
   - Brief = board file, current code location, what the board wants in one paragraph, the
     NEW DATA / NEW FEATURE items **in scope**, cross-screen moves (e.g. "the update check moves
     from Flights to Splash"), what must not be touched.
4. After each report: read the diff, run `flutter analyze` + `flutter test`, fix or send the
   agent back with `SendMessage`. Collect KIT GAPs; resolve them in the kit yourself (Opus),
   update `kit_mapping.md`, then continue.
5. Finish with the `masterflutter-reviewer` agent over the whole diff.

## Done

- `module/ui_kit` analyzed, tested, gallery builds; app has zero analyzer errors.
- Every screen bound by its own run; KIT GAP list empty or explicitly deferred with the user.
- `docs/design/kit_mapping.md`, `docs/theme.md` and `todo.md` updated.
- Report to the user (Turkish): what was built per phase, decisions taken (architecture overrides,
  data contracts, deferred NEW FEATUREs), open KIT GAPs, how to run the gallery.
