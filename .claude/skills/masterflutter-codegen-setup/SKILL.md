---
name: masterflutter-codegen-setup
description: >-
  Sets up the project's code generation layer from scratch: flutter_gen for
  type-safe assets/fonts (`Assets.icon.svg.icAircraft`, `FontFamily.roboto`),
  easy_localization behind a `ProductLocalization` facade so pages never import
  the package (LocaleKeys + `.translate`), locale persistence through the v11
  `ICacheManager`, and one `scripts/generate.sh` entry point that drives every
  generator. Use when the user runs /masterflutter-codegen-setup or asks to add
  asset generation, localization, or a build_runner automation setup.
---

# Codegen Setup (flutter_gen + easy_localization facade + one script)

## When to apply

- User invokes **`/masterflutter-codegen-setup`** or asks for asset generation,
  localization/localization, or a build_runner script.
- Symptoms this fixes: hard-coded `'assets/...'` paths (silently broken at
  runtime), hard-coded UI strings, several overlapping codegen scripts.

## Architecture (what this builds)

Three pillars, same philosophy as the v11 cache layer — **the package is an
implementation detail behind a product-owned facade**:

1. **Assets & fonts are generated**, never typed by hand. `flutter_gen_runner`
   reads `pubspec.yaml` and writes `lib/product/gen/`. A missing file becomes a
   compile error instead of a blank screen.
2. **Localization sits behind `ProductLocalization`.** `easy_localization` is
   imported in exactly one folder (`lib/product/localization/`). Pages use
   `LocaleKeys.x.translate`; `MaterialApp` uses context extensions. Swapping the
   package later touches that folder only.
3. **One generation entry point.** `./scripts/generate.sh` runs the
   easy_localization CLI *and* build_runner; `build.yaml` documents which
   builder owns what.

```
lib/product/gen/                    # generated, never edited by hand
  assets.gen.dart                   # Assets.icon.svg.icAircraft
  fonts.gen.dart                    # FontFamily.roboto
  locale_keys.g.dart                # LocaleKeys.login_submit
lib/product/localization/
  locales.dart                      # enum Locales(tr, en) — the only language list
  product_localization.dart         # EasyLocalization wrapper + init/updateLanguage
  localization_extension.dart       # String.translate / .translateArgs + context.*
assets/translations/{tr,en}.json    # one file per Locales entry
scripts/generate.sh                 # the only codegen command anyone runs
```

## Implementation checklist

### 1. Dependencies

```bash
flutter pub add easy_localization
flutter pub add dev:flutter_gen_runner
```
`flutter_gen_core` pulls `image` → `archive ^4`. **Old `lottie 2.x` pins
`archive ^3` and blocks resolution** → bump `lottie: ^3.3.1` first.

### 2. pubspec.yaml

- Top-level `flutter_gen:` block (sibling of `flutter:`, not nested):
  `output: lib/product/gen/`, `integrations: { flutter_svg: true, lottie: true }`,
  `assets.outputs.class_name: Assets`, `style: dot-delimiter`,
  `fonts.outputs.class_name: FontFamily`.
- Register `assets/translations/` under `flutter: assets:`.
- Complete the font family — declare **every** weight/style present in
  `assets/fonts/` (`weight:` + `style: italic`), otherwise those files ship
  unused and `FontFamily` lies about what is available.

### 3. Translation files

`assets/translations/<code>.json` per `Locales` entry, nested one level
(`general`, `login`, `flight`, …) → `LocaleKeys.general_retry`. Positional
placeholders are `{}` → `.translateArgs([value])`.

### 4. Localization facade (`lib/product/localization/`)

- `locales.dart` — `enum Locales { tr(Locale('tr','TR')), en(Locale('en','US')) }`
  with `code`, `fromCodeOrNull(String?)`, `next` (for a toggle button).
- `product_localization.dart` — `final class ProductLocalization extends
  StatelessWidget`: wraps `EasyLocalization` with `path: 'assets/translations'`,
  `useOnlyLangCode: true`, `fallbackLocale: Locales.en.locale`,
  `startLocale: startLocale?.locale`, and **`saveLocale: false`** — the app owns
  persistence. Statics: `init()` → `EasyLocalization.ensureInitialized()`,
  `updateLanguage({context, value})` → `context.setLocale(...)`. `init()` also
  silences the package's DEBUG/INFO chatter, keeping the levels that carry
  signal:
  ```dart
  EasyLocalization.logger.enableLevels = <LevelMessages>[
    LevelMessages.error, LevelMessages.warning,
  ];
  ```
  (`LevelMessages` comes from `easy_logger` — declare it in `pubspec.yaml`,
  don't lean on the transitive dependency.)
- `localization_extension.dart` — `extension LocalizationExtension on String`
  with the full parametric set: `translate` → `tr(this)`, `translateArgs(args)`
  (positional `{}`), `translateNamed(map)` (`{named}` slots) and
  `translatePlural(count, {name})` (`one`/`other`/… branches) — and
  `extension LocalizationContextExtension on BuildContext`
  (`productDelegates`, `productSupportedLocales`, `productLocale`, `appLocale`).
  Use the top-level `tr(...)` function, not `this.tr()` — `unnecessary_this`.

### 5. App wiring

- `AppInitializer.prepare()` → add `ProductLocalization.init()` to `Future.wait`.
- `main.dart` → after `AppInitializer().prepare()`, read the cached code
  (`ProductCache.instance.manager.readString(ProductCacheKeys.locale)`), map it
  with `Locales.fromCodeOrNull`, and wrap `MainApp` in
  `ProductLocalization(startLocale: ...)`.
- `MaterialApp.router` → `localizationsDelegates: context.productDelegates`,
  `supportedLocales: context.productSupportedLocales`,
  `locale: context.productLocale`, and
  **`onGenerateTitle: (context) => LocaleKeys.general_app_name.translate`** —
  not `title:`, which is evaluated on the first build before the translation
  assets load (the package then logs `key not found`).
- `ProductCacheKeys.locale` (`CacheKey('app_locale')`) + `ApplicationCubit`
  (inject `ICacheManager`): `locale` in state, `changeLocale({context, value})`
  → facade + `writeString` + `emit`, plus `toggleLocale(context)`.

### 6. Generation entry point

- `build.yaml` → keep `json_serializable` / `go_router_builder` `generate_for`
  blocks, add `flutter_gen_runner: { enabled: true }`, and note that LocaleKeys
  is a **CLI**, not a builder.
- `scripts/generate.sh` (chmod +x) with `--watch`, `--clean`, `--localization`,
  `--assets`; LocaleKeys first, then `dart run build_runner build`. Delete older
  overlapping scripts (`build_runner.sh`, `generate_models.sh`).
- `.vscode/tasks.json` → "Codegen: all / watch / localization only / clean".

### 7. Migrate call sites + verify

Replace every `'assets/...'` string with the generated accessor
(`SvgPicture.asset(path)` → `Assets.icon.svg.icX.svg()`, `Lottie.asset(path)` →
`Assets.animation.lottie.x.lottie()`) and drop the now-unused
`flutter_svg` / `lottie` imports. Replace UI strings with `LocaleKeys`.

```bash
./scripts/generate.sh
flutter analyze   # 0 errors
flutter test
```

## Do not

- Import `package:easy_localization` outside `lib/product/localization/` — that
  is the whole point of the facade.
- Hand-edit anything in `lib/product/gen/` — regenerate instead.
- Let the package persist the locale (`saveLocale: true`) while the app also
  caches it — one owner, and it is `ICacheManager`.
- Add a language by only dropping a JSON file — it must exist in `Locales`.
- Read a key above `MaterialApp`'s `Localizations` — assets are not loaded yet;
  `plural` throws a `LateInitializationError` there.
- Keep a second codegen script "just in case" — one entry point.

## Reference code in this repo

- Facade pattern precedent: `module/cache_manager` + `/masterflutter-cache-setup`
- Bootstrap: `lib/product/initialize/app_initializer.dart`, `lib/main.dart`
- Migrated screens: `lib/feature/unauth/login/**`, `lib/feature/auth/flight/flight_list_page.dart`
- Follow-ups: **`/masterflutter-asset-add`**, **`/masterflutter-localization-add-key`**

## Invocation

- **`/masterflutter-codegen-setup`** — or just describe the task; the
  description above triggers this skill automatically.
