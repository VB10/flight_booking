---
name: masterflutter-cache-add-model
description: >-
  Adds a new model to the cache as a pure DTO — a freezed class in module/gen
  that implements CacheModel (toJson) and provides a fromJson factory. No
  Hive annotations, no typeId, no adapters (Hive is encapsulated in the
  cache_manager package and stores models as JSON). Store/read via
  ICacheManager.writeModel / readModel(fromJson). Use when the user runs
  /masterflutter-cache-add-model or asks to store/cache a new model.
---

# Add a Model to the Cache (JSON DTO, no Hive adapters)

## When to apply

- User invokes **`/masterflutter-cache-add-model`** or asks to persist/cache a new model.
- The cache architecture exists (`module/cache_manager/`, `lib/product/cache/`).
  If not, run **`/masterflutter-cache-setup`** first.

## Key rules

- Models are stored as **JSON** via the `CacheModel` contract — **no Hive
  types in the app**. No `@HiveType`, no `typeId`, no adapters, no registrar.
  Hive is fully encapsulated inside the `cache_manager` package.
- `ICacheManager.writeModel<T extends CacheModel>` forces `toJson`. `fromJson`
  is a factory (can't be forced by an interface), so **pass it to `readModel`**.
- Cache models are **DTOs**: keep the app's domain/state (e.g. AuthState) free of
  persistence concerns; map DTO ↔ domain at the call site.
- Every data model is a **freezed** class (immutable + value equality) living in
  the `module/gen` package. Cubit/page states are not models: they stay next to
  their cubit with Equatable + `copyWith`.

## Required information

| Field | Example | Required |
|-------|---------|----------|
| Model name | `SearchHistory` | Yes |
| Fields | `query: String`, `at: int` | Yes |

## Implementation checklist

### 1. Create the DTO

`module/gen/lib/src/model/cache/<snake_name>.dart`:
```dart
import 'package:cache_manager/cache_manager.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_history.freezed.dart';
part 'search_history.g.dart';

@freezed
abstract class SearchHistory with _$SearchHistory implements CacheModel {
  const factory SearchHistory({
    required String query,
    required int at,
  }) = _SearchHistory;

  factory SearchHistory.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryFromJson(json);
}
```
- `implements CacheModel` (the `toJson` contract; freezed generates `toJson`).
- No Equatable, no `@JsonSerializable`. Fields are `required` in the `const factory`.
- Nested models must themselves be JSON-encodable (`explicit_to_json: true` is
  set in `module/gen/build.yaml`).
- Export it from `module/gen/lib/gen.dart`; the app imports it via
  `package:gen/gen.dart`.

### 2. Codegen (freezed + json_serializable)

`module/gen/build.yaml` already includes `lib/src/model/**.dart`. Run from the
repo root:
```bash
./scripts/generate.sh --models
```
Generates `<snake_name>.freezed.dart` and `<snake_name>.g.dart`. No Hive
registrar step. Add a round-trip test in `module/gen/test/`:
```dart
test('SearchHistory round-trips through JSON', () {
  const model = SearchHistory(query: 'IST', at: 1);
  expect(SearchHistory.fromJson(model.toJson()), model);
});
```

### 3. Add a key

`ProductCacheKeys`:
```dart
static const CacheKey searchHistory = CacheKey('search_history');
```

### 4. Store / read

```dart
await cache.writeModel(ProductCacheKeys.searchHistory, history);

final history = cache.readModel<SearchHistory>(
  ProductCacheKeys.searchHistory,
  fromJson: SearchHistory.fromJson,
);
```

### 5. Verify

```bash
flutter analyze lib/product/cache
```

## Do not

- Add `@HiveType` / `typeId` / a Hive adapter — models are JSON DTOs; Hive stays
  in the package.
- Import `package:hive*` anywhere in the app.
- Store a model in `IFallbackStore` (string-only). Critical *primitives* (token)
  go there; models go through `writeModel`.
- Forget `fromJson` on `readModel` — it's required.
- Edit `*.g.dart` or `*.freezed.dart` by hand — regenerate with `./scripts/generate.sh --models`.
- Put a model under `lib/product/cache/model/` — data models live in `module/gen`.

## Reference code in this repo

- Working example: `module/gen/lib/src/model/cache/auth_session_cache_model.dart`
- Contract: `CacheModel` (from `package:cache_manager/cache_manager.dart`)
- Manager API: `ICacheManager.writeModel` / `readModel`
- Cache holder: `lib/product/cache/product_cache.dart`

## Invocation

- **`/masterflutter-cache-add-model {ModelName}`** — or just describe the task; the
  description above triggers this skill automatically.
