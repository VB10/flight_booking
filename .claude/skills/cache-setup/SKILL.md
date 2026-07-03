---
name: cache-setup
description: >-
  Sets up the model-capable cache architecture from scratch: a local
  `module/cache_manager` package with ICacheManager + ICacheStrategy backed by
  Hive (fully encapsulated — the app imports no Hive). Models are stored as JSON
  via a CacheModel contract (toJson) + a fromJson factory, so no Hive
  adapters/typeId. A SEPARATE standalone IFallbackStore (SharedPreferences) lives
  outside the strategy and holds only a few critical keys (auth token). Includes
  app wiring (ProductCache holder, keys, DI) and an AuthSessionCacheModel DTO
  example. Use when the user runs /cache-setup or asks to add a cache manager /
  storage abstraction to the project.
---

# Cache Manager Setup (Hive model cache + standalone critical-key fallback)

## When to apply

- User invokes **`/cache-setup`** or asks to add a cache/storage layer, Hive, or
  a persistence abstraction.
- Project has scattered/direct `SharedPreferences` usage to consolidate.

## Architecture (what this builds)

Three design pillars:

1. **Main cache = Hive, model-capable** (`ICacheManager`), but Hive is **fully
   encapsulated in the package** — the app imports no Hive. Models are stored as
   **JSON** via the `CacheModel` contract (no adapters/typeId). Strategy pattern
   behind it for testability/swappability.
2. **Fallback = standalone `IFallbackStore`** (SharedPreferences), **outside the
   strategy**. Holds only a few critical string keys (auth token) as a safety
   net if Hive is unavailable/cleared/corrupted. Intentionally dumb, string-only.
3. **DTO pattern**: cache models are pure Dart (Equatable + immutable +
   json_serializable) implementing `CacheModel`; the app's domain/state
   (AuthState) stays decoupled from storage.

```
module/cache_manager/lib/
  cache_manager.dart                  # barrel
  src/
    i_cache_manager.dart              # ICacheManager (primitives + writeModel/readModel)
    product_cache_manager.dart        # wraps ONE ICacheStrategy (no fallback logic)
    model/cache_key.dart              # CacheKey(name) — Equatable
    model/cache_model.dart            # CacheModel { toJson() } contract
    strategy/
      i_cache_strategy.dart           # primitives + writeObject/readObject
      hive_cache_strategy.dart        # HiveCacheStrategy — init() runs Hive.initFlutter
    fallback/
      i_fallback_store.dart           # IFallbackStore (string-only, standalone)
      shared_prefs_fallback_store.dart

lib/product/cache/
  product_cache.dart                  # holds manager + fallback (NO hive import)
  product_cache_keys.dart             # ProductCacheKeys (cache) + FallbackKeys (token)
  model/auth_session_cache_model.dart # DTO: json_serializable + Equatable + CacheModel
```

## Implementation checklist

### 1. Local package

`module/cache_manager/pubspec.yaml` (name: `cache_manager`, `publish_to: none`):
```yaml
dependencies:
  flutter: { sdk: flutter }
  hive_ce: ^2.19.3
  hive_ce_flutter: ^2.3.4
  shared_preferences: ^2.2.2
dev_dependencies:
  flutter_test: { sdk: flutter }
  very_good_analysis: ^10.0.0
```
`analysis_options.yaml`: include `very_good_analysis`; disable
`avoid_positional_boolean_parameters` (strategy's `writeBool(key, value)`).

### 2. Strategy layer (Hive, encapsulated)

- `ICacheStrategy`: `init`, `writeString/Int/Bool`, **`writeObject(key, Object)`**,
  `readString/Int/Bool`, **`readObject<T>(key)`**, `remove`, `clear`.
- `HiveCacheStrategy implements ICacheStrategy`: wraps one `Box<dynamic>`.
  **`init()` runs `Hive.initFlutter()` then opens the box** — Hive is fully
  encapsulated here so the app never imports Hive. `writeObject`/`readObject` use
  `box.put`/`box.get` with an `is T` check (JSON maps, no adapters). Inject an
  already-open `box` in tests so `init()` skips `initFlutter`; throws
  `StateError` before `init`.

### 3. Manager layer

- `CacheKey(this.name)` — plain named slot, `extends Equatable`.
- `CacheModel` — `abstract interface class CacheModel { Map<String,dynamic> toJson(); }`.
- `ICacheManager`: primitive verbs keyed by `CacheKey`, plus
  `writeModel<T extends CacheModel>(key, value)` and
  `readModel<T>(key, {required T Function(Map<String,dynamic>) fromJson})`,
  `init`, `clear`.
- `ProductCacheManager({required ICacheStrategy strategy})`: thin delegation.
  `writeModel` → `strategy.writeObject(key, value.toJson())`; `readModel` →
  read the map, `Map<String,dynamic>.from(raw)`, call `fromJson`. **No fallback
  logic here.**

### 4. Fallback store (standalone, outside the strategy)

- `IFallbackStore`: `init`, `write(String,String)`, `read(String)`, `remove`,
  `clear`. String-only.
- `SharedPrefsFallbackStore implements IFallbackStore`: SharedPreferences wrapper.

### 5. App wiring

- `lib/product/cache/product_cache.dart` — `ProductCache` singleton holding
  `ICacheManager` (`ProductCacheManager(strategy: HiveCacheStrategy())`) and
  `IFallbackStore` (`SharedPrefsFallbackStore()`). `init()`: `manager.init()`
  (Hive set up inside) → `fallback.init()`. **No Hive import.** Exposes `manager`
  and `fallback`.
- `lib/product/cache/product_cache_keys.dart` — `ProductCacheKeys` (CacheKeys,
  e.g. `session`) and `FallbackKeys` (raw strings, e.g. `token`).
- Root **pubspec.yaml**: `cache_manager: { path: module/cache_manager }`.
- **AppInitializer.prepare()**: add `ProductCache.instance.init()` to `Future.wait`.
- **ProductContainer.setup()**: register `ICacheManager` **and** `IFallbackStore`
  before consumers; inject both into `AuthCubit(_network, _cache, _fallback)`.

### 6. Auth session as a DTO (uses `/cache-add-model`)

- Create `AuthSessionCacheModel` — `@JsonSerializable`, `extends Equatable
  implements CacheModel`, `part 'auth_session_cache_model.g.dart';`, fields
  token/email/name/userId, `fromJson` factory + `toJson`. **No Hive.** Add
  `lib/product/cache/model/*.dart` to json_serializable's `build.yaml` includes;
  run build_runner.
- `AuthCubit`:
  - `setSession` → `writeModel(session, AuthSessionCacheModel(...))` **and**
    `fallback.write(FallbackKeys.token, token)`.
  - `restoreSession` → `readModel(session, fromJson: AuthSessionCacheModel.fromJson)`;
    if missing, fall back to the token from `IFallbackStore` (token-only session,
    refresh profile later).
  - `logout` → `remove(session)` + `fallback.remove(token)`.
- Replace direct `SharedPreferences` reads (e.g. `profile_page.dart`) with
  `readModel<AuthSessionCacheModel>(...)`.

### 7. Tests (`module/cache_manager/test/`) + verify

Hand-rolled fakes (no mock lib):
- `hive_cache_strategy_test.dart` → `Hive.init(tempDir)` + inject an open box;
  primitives + object round-trip (a `Map` needs no adapter).
- `shared_prefs_fallback_store_test.dart` → `setMockInitialValues`.
- `product_cache_manager_test.dart` → `FakeCacheStrategy` + a `_Session`
  implementing `CacheModel`; model round-trip via `writeModel`/`readModel(fromJson)`.
```bash
cd module/cache_manager && flutter test
cd - && flutter pub get && flutter analyze lib/product/cache
```

## Do not

- Put fallback logic inside the manager/strategy — the fallback is a **separate**
  `IFallbackStore` the caller reaches for a few keys.
- Store objects in the fallback store — string-only. Objects → `writeModel`.
- Import `package:hive*` in the app — Hive is encapsulated in the package.
- Add Hive adapters/`typeId` for models — they're JSON DTOs (`CacheModel`).
- Register `ICacheManager`/`IFallbackStore` after their consumers in DI.

## Reference code in this repo

- Interface+impl style: `lib/product/network/network_manager.dart` (+ impl)
- DI: `lib/product/container/product_container.dart`
- Bootstrap: `lib/product/initialize/app_initializer.dart`, `lib/main.dart`
- Model codegen: **`/cache-add-model`**

## Slash command

- `.claude/commands/cache-setup.md` → **`/cache-setup`**
