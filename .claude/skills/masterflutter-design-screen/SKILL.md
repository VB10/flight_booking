---
name: masterflutter-design-screen
description: >-
  Binds ONE screen from a Claude Design export (docs/design/claude_design/design/<Screen>.dc.html)
  to this repo's architecture: kit widgets from module/ui_kit (via docs/design/kit_mapping.md),
  Cubit + Equatable state + page mixin + part/part-of views, typed go_router routes, LocaleKeys
  in EN + TR, services through ProductContainer. Every state on the board (loading, empty, error,
  content, dialogs, snackbars) becomes real code; anything the kit cannot express is reported as
  KIT GAP instead of invented. Use when the user runs /masterflutter-design-screen, asks to
  "ekranı tasarıma bağla", "bu board'u koda çevir", "yeni ekran tasarımdan geldi", or adds a new
  screen to an existing design. Built to run on Sonnet (masterflutter-screen-binder agent), one
  screen per run. Requires the design system to exist — if module/ui_kit or
  docs/design/kit_mapping.md is missing, run /masterflutter-design-system-setup first.
---

> **Language:** these instructions are in English. Talk to the user in Turkish; code,
> identifiers and commit messages stay in English.

# Design screen → Flutter (one screen per run)

You turn one design board into one working feature. You do **not** design, restyle or extend
the kit. The design system is fixed; your job is a faithful, architecture-correct binding.

## Model

This skill is written to be executed by **Sonnet** (cheap, fast, follows checklists well). The
orchestrating session (Opus) owns the design system and dispatches one screen at a time to the
[`masterflutter-screen-binder`](../../agents/masterflutter-screen-binder.md) agent. Run screens
**sequentially**, never in parallel: every screen writes to the same translation files, routes
and generated code.

## Inputs (read in this order, nothing else up front)

1. **Caller's brief** — screen name, board file, scope of NEW DATA / NEW FEATURE items to build,
   anything explicitly out of scope.
2. [docs/design/kit_mapping.md](../../../docs/design/kit_mapping.md) — the only dictionary from
   board classes / tokens to widgets / APIs. Read it fully.
3. The board: `docs/design/claude_design/design/<Screen>.dc.html`. Read it **as text without
   CSS**: the `<style>` block is the kit's own CSS (already implemented), the `<script>` block holds
   the board's sample data and state list. Useful one-liner:
   `python3 -I -c "import re,html,sys;s=open(sys.argv[1]).read();print(html.unescape(re.sub(r'<style.*?</style>','',s,flags=re.S)))" <file>`
4. `Handoff.dc.html` — the rows for this screen (component · variant · states · tokens), the
   NEW DATA / NEW FEATURE list and the navigation map. Only the rows for your screen matter.
5. The current implementation of the screen (if any) under `lib/feature/**` and the reference
   feature [lib/feature/unauth/login/](../../../lib/feature/unauth/login/) for structure.

## Feature shape (mandatory)

```
lib/feature/<auth|unauth>/<name>/
  <name>_page.dart                 StatefulWidget + State with <Name>PageMixin; BlocProvider;
                                   BlocListener for navigation / snackbars / dialogs; `part` lines
  cubit/<name>_cubit.dart          business logic + emit, services via constructor
  cubit/<name>_state.dart          Equatable + copyWith, one flat class, enum status if useful
  view/<name>_page_mixin.dart      part of page — creates the cubit from ProductContainer,
                                   owns shared controllers, action methods
  view/widget/<name>_page_body.dart  part of page — layout; BlocSelector / BlocBuilder
  view/widget/_<piece>.dart        part of page — private pieces of this screen only
```

Rules carried over from `/masterflutter-cubit-add` (read it if unsure):
- No `Navigator`, `ScaffoldMessenger`, `AppSnackbar` or `AppDialog` inside a Cubit. One-shot
  effects go through state (e.g. a `status` enum or an event field) and a `BlocListener`.
- `BlocSelector` when a widget needs one field, `BlocBuilder` (+ `buildWhen`) for several.
- Widget-local UI state uses `ValueNotifier` named `…Notifier` inside that widget's `State`;
  no `setState` for state the Cubit owns.
- Navigation only through typed routes in
  [lib/product/navigation/app_routes.dart](../../../lib/product/navigation/app_routes.dart).
  A new screen/route → follow `/masterflutter-route-add` (then
  `dart run build_runner build --delete-conflicting-outputs` or `./scripts/generate.sh --assets`).
- App-wide state comes from `ProductContainer` (see kit_mapping §3): `CartCubit`,
  `ApplicationCubit`, `AuthCubit`. Provide them with `BlocProvider.value` when the view must
  rebuild on them.

## Binding rules

1. **Kit only.** Every visual piece maps through kit_mapping.md. Forbidden in screen code:
   `ElevatedButton`, `OutlinedButton`, raw `TextField`/`TextFormField`, `AlertDialog`,
   `showDialog`, `SnackBar`/`showSnackBar`, `Card`, `Shimmer`, `CircularProgressIndicator` as a
   page loader, `AppBar` (use `AppTopBar`).
2. **Tokens only.** No `Color(0x…)`, no `Colors.*` (except `Colors.transparent`), no raw
   `TextStyle(fontSize: …)`. Spacing from `AppSizes` / `AppPagePadding`, radius from `AppRadius`.
   Literal `2` / `4` px micro gaps are allowed only where the board has them.
3. **Every state on the board is built.** Loading → `LoadingState`, empty → `EmptyState`,
   error → `ErrorState` with retry, plus the content state, dialogs and snackbars the board
   shows. The `<script>` data of the board lists them — tick them off one by one.
4. **Strings.** Every user-visible string is a `LocaleKeys` entry in **both**
   `assets/translations/en.json` and `tr.json` (follow `/masterflutter-localization-add-key`;
   regenerate with `./scripts/generate.sh --localization`). Reuse existing keys; group new ones
   under the screen's namespace. Counts use `translatePlural`, values use `translateArgs` /
   `translateNamed` — never glue a number to a translated fragment. Turkish must be real Turkish.
5. **Data.** Only use fields that exist on the models. NEW DATA fields are nullable — render the
   row/tile only when the value is non-null. A NEW FEATURE is built **only if the caller's brief
   puts it in scope**; otherwise leave it out and list it in the report.
6. **Semantics.** Every icon-only control has a tooltip / semantic label (localized).
7. **Remove the old page code** you replaced. Do not leave the legacy single-file page behind;
   delete widgets, helpers and imports that became unused.
8. **Do not touch** `module/ui_kit/**`, `docs/design/**`, other features' files, or the backend
   unless the brief says so. Need something from them → KIT GAP / report.
9. **Never change git state.** No `git stash`, `checkout`, `reset`, `restore`, `add`, `commit`.
   The working tree holds the orchestrator's uncommitted work too, and the orchestrator stages
   each screen to review it on its own. If a tool (e.g. `dart format`) touches a file outside your
   scope, undo it by editing the file back, and mention it in the report.

## Steps

1. Read the inputs. Write a short plan for yourself: states list, components list (board class →
   widget), new keys, route changes, cubit fields.
2. State + Cubit.
3. Page + mixin (cubit creation, controllers, listeners for one-shot effects).
4. Body + private pieces, state by state.
5. Translations (EN + TR) → `./scripts/generate.sh --localization`.
6. Routes (if changed) → regenerate.
7. Verify — all must pass before you report:
   - `flutter analyze lib/feature/<area>/<name> lib/product` → **no new issues**
   - `flutter analyze` (whole app) has **no errors**
   - `flutter test` — tests that ran green before still run green (the auth service integration
     tests need the backend; ignore their connection errors)
   - Grep your feature for the forbidden widgets/tokens of rules 1–2 → zero hits.

## Report (fixed format, in Turkish)

```
## <Screen> — bağlandı
Dosyalar: <created / changed / deleted, one line each>
Durumlar: loading ✓ · empty ✓ · error ✓ · content ✓ · <dialogs/snackbars> ✓
Kit bileşenleri: <list>
Ekrana özel widget'lar: <view/widget pieces and why>
Yeni çeviri key'leri: <keys>
Route değişikliği: <none | what>
NEW DATA / FEATURE: yapılan: <…> · kapsam dışı bırakılan: <…>
KIT GAP: <none | item — why — suggestion>
Doğrulama: analyze <result> · test <result> · yasaklı widget grep <result>
```
