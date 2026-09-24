---
name: masterflutter-localization-add-key
description: >-
  Adds a translation key (or migrates a hard-coded UI string) to every language
  file under assets/translations, regenerates LocaleKeys, and replaces the call
  site with `LocaleKeys.<key>.translate` / `.translateArgs([...])`. Also covers
  adding a whole new language. Use when the user runs /masterflutter-localization-add-key
  or asks to translate/localize a screen or string.
---

# Add a Localization Key

## When to apply

- User invokes **`/masterflutter-localization-add-key`**, asks to localize a screen, or
  wants a new language.
- Prerequisite: `lib/product/gen/locale_keys.g.dart` and
  `lib/product/localization/` exist. If not, run
  **`/masterflutter-codegen-setup`** first.

## Key convention

`assets/translations/<code>.json`, nested exactly one level:

```json
{ "flight": { "add_to_cart": "Sepete Ekle", "duration": "Süre: {}" } }
```

→ `LocaleKeys.flight_add_to_cart`, `LocaleKeys.flight_duration`.

- Group by feature (`login`, `flight`, `profile`, `cart`), plus `general` for
  strings shared by more than one screen.
- `snake_case` keys, named after **meaning**, not the Turkish or English words.
- Dynamic values → placeholders, never string interpolation around a translated
  fragment (see below).

## Parameters — pick the right one

| JSON | Call | Use when |
|------|------|----------|
| `"Süre: {}"` | `key.translateArgs([value])` | exactly one value, position obvious |
| `"Test hesabı: {email} / {password}"` | `key.translateNamed({'email': e, 'password': p})` | two or more values, or a translator may reorder them |
| `{"one": "1 bilet var", "other": "{} bilet var"}` | `key.translatePlural(count)` | the sentence changes with a count |

```json
"added_to_cart": {
  "one":   "Bilet eklendi. Sepetinizde 1 bilet var.",
  "other": "Bilet eklendi. Sepetinizde {} bilet var."
}
```

- Plural branches are `zero` / `one` / `two` / `few` / `many` / `other`; `other`
  is mandatory, the rest are per-language. **Never** build a count sentence by
  hand (`'$count ${LocaleKeys.x.translate}'`) — the branch belongs to the
  language, not to Dart.
- Values that are **data, not language** (emails, test credentials, product
  names, IDs) belong in code and get injected as named args — not copied into
  every language file.
- With `translatePlural` the count fills `{}` by default; pass `name:` to fill a
  `{named}` slot instead.

## Where translation may happen

Read keys **inside the widget that displays them**, under `MaterialApp`'s
`Localizations`. Translating in a parent that sits above it runs before the
translation assets finish loading: `translate` logs
`Localization key [x] not found` and `translatePlural` throws a
`LateInitializationError`. This is why `MainApp` uses `onGenerateTitle:` instead
of `title:`, and why `test/product/localization/product_localization_test.dart`
builds its texts under `home:`.

## Checklist

1. **Collect the strings.** When migrating a screen, grep it for quoted literals
   first and list them; analytics/event names and API keys are **not** UI text.
2. **Add the key to every file** in `assets/translations/` — all languages, same
   nesting, same placeholder count. A missing key renders as the raw key.
3. **Regenerate**: `./scripts/generate.sh --localization`
4. **Replace the call site**:
   - plain → `LocaleKeys.flight_add_to_cart.translate`
   - with args → `LocaleKeys.flight_duration.translateArgs([flight.duration])`
   - import `product/gen/locale_keys.g.dart` +
     `product/localization/localization_extension.dart`
     (**never** `package:easy_localization`).
5. `flutter analyze` → 0 errors, then check both languages in the app
   (the app bar translate button toggles `Locales`).
6. Parametric or plural key? Add a case to
   `test/product/localization/product_localization_test.dart` — one pump per
   language (the package caches translations statically, so pumping the same
   locale twice does not reload them).

## Adding a new language

1. `assets/translations/<code>.json` — copy `en.json`, translate every value.
2. Add the entry to `enum Locales` in `lib/product/localization/locales.dart`
   (this is the only registry; the JSON file alone does nothing).
3. `./scripts/generate.sh --localization`, then verify the toggle cycles through it.

## Do not

- Import `package:easy_localization` in a feature file — go through
  `localization_extension.dart`.
- Add a key to one language only, or with mismatched `{}` counts.
- Localize log/analytics/event names or cache keys.
- Concatenate translated fragments (`'${LocaleKeys.a.translate} ${x}'`) — add a
  placeholder to the key instead.
- Bake data (emails, credentials, IDs) into translation values — inject it with
  `translateNamed`.
- Translate above `MaterialApp` (e.g. `title:`) — assets are not loaded yet.
- Hand-edit `lib/product/gen/locale_keys.g.dart`.

## Reference code in this repo

- Migrated screens: `lib/feature/unauth/login/**`,
  `lib/feature/auth/flight/flight_list_page.dart`
- Facade: `lib/product/localization/product_localization.dart`
- Language switch + persistence: `lib/product/application/application_cubit.dart`

## Invocation

- **`/masterflutter-localization-add-key {key | file_path}`** — or just describe the task; the
  description above triggers this skill automatically.
