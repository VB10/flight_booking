---
name: cache-add-model
description: >-
  Adds a new model to the cache as a pure DTO — a json_serializable + Equatable
  class that implements CacheModel (toJson) and provides a fromJson factory. No
  Hive annotations, no typeId, no adapters (Hive is encapsulated in the
  cache_manager package and stores models as JSON). Store/read via
  ICacheManager.writeModel / readModel(fromJson). Use when the user runs
  /cache-add-model or asks to store/cache a new model.
---

# Add a Model to the Cache (JSON DTO, no Hive adapters)

## When to apply

- User invokes **`/cache-add-model`** or asks to persist/cache a new model.
- The cache architecture exists (`module/cache_manager/`, `lib/product/cache/`).
  If not, run **`/cache-setup`** first.

## Key rules

- Models are stored as **JSON** via the `CacheModel` contract — **no Hive
  types in the app**. No `@HiveType`, no `typeId`, no adapters, no registrar.
  Hive is fully encapsulated inside the `cache_manager` package.
- `ICacheManager.writeModel<T extends CacheModel>` forces `toJson`. `fromJson`
  is a factory (can't be forced by an interface), so **pass it to `readModel`**.
- Cache models are **DTOs**: keep the app's domain/state (e.g. AuthState) free of
  persistence concerns; map DTO ↔ domain at the call site.
- Every model must be **Equatable + immutable** (project convention).

## Required information

| Field | Example | Required |
|-------|---------|----------|
| Model name | `SearchHistory` | Yes |
| Fields | `query: String`, `at: int` | Yes |

## Implementation checklist

### 1. Create the DTO

`lib/product/cache/model/<snake_name>.dart`:
```dart
import 'package:cache_manager/cache_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_history.g.dart';

@JsonSerializable()
final class SearchHistory extends Equatable implements CacheModel {
  const SearchHistory({required this.query, required this.at});

  factory SearchHistory.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryFromJson(json);

  final String query;
  final int at;

  @override
  Map<String, dynamic> toJson() => _$SearchHistoryToJson(this);

  @override
  List<Object?> get props => [query, at];
}
```
- `implements CacheModel` (the `toJson` contract).
- `extends Equatable`, all fields `final`, `const` constructor.
- Nested models must themselves be JSON-encodable (`explicit_to_json: true` is
  set in `build.yaml`).

### 2. Codegen (json_serializable)

`build.yaml` already includes `lib/product/cache/model/*.dart`. Run:
```bash
./scripts/generate_models.sh      # or: flutter pub run build_runner build --delete-conflicting-outputs
```
Generates `<snake_name>.g.dart`. No Hive registrar step.

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
- Edit `*.g.dart` by hand — regenerate with build_runner.

## Reference code in this repo

- Working example: `lib/product/cache/model/auth_session_cache_model.dart`
- Contract: `CacheModel` (from `package:cache_manager/cache_manager.dart`)
- Manager API: `ICacheManager.writeModel` / `readModel`
- Cache holder: `lib/product/cache/product_cache.dart`

## Slash command

- `.claude/commands/cache-add-model.md` → **`/cache-add-model {ModelName}`**
