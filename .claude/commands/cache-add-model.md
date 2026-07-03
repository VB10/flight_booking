# /cache-add-model — Cache'e Yeni Model Ekle (JSON DTO)

Cache'e yeni bir model ekler: **json_serializable + Equatable** olan, `CacheModel`
contract'ını (`toJson`) implement eden ve `fromJson` factory'si olan **saf bir
DTO** oluşturur. **Hive annotation / typeId / adapter YOK** — Hive
`cache_manager` package'ının içine gömülü, modeller JSON olarak saklanır.
`ICacheManager.writeModel` / `readModel(fromJson)` ile kullanılır.

## Kullanım

```
/cache-add-model {ModelName}
```

**Örnekler:**

- `/cache-add-model SearchHistory`
- `/cache-add-model` (argüman yoksa kullanıcıdan sor)

## Kaynak spesifikasyon

Öncelikle şu skill'i oku ve ona uy:

- `.claude/skills/cache-add-model/SKILL.md`

Canlı referans (çalışan örnek):

- `lib/product/cache/model/auth_session_cache_model.dart` (+ `.g.dart`)
- `CacheModel` contract → `package:cache_manager/cache_manager.dart`

## Kurallar

- Modeller **Equatable + immutable + json_serializable** (proje konvansiyonu).
- `implements CacheModel` → `toJson` zorunlu; `fromJson` factory olduğu için
  `readModel`'e **parametre** olarak geçilir.
- DTO mantığı: app'in domain/state'i (AuthState) persistence'tan bağımsız kalır.
- App'te **hiçbir yerde `package:hive*` import edilmez**.

## Yapılacaklar (özet)

1. `lib/product/cache/model/{snake}.dart` → `@JsonSerializable`, `final class ...
   extends Equatable implements CacheModel`, `part '{snake}.g.dart';`,
   `fromJson` factory + `toJson` (`_$...`), `props`.
2. `./scripts/generate_models.sh` (json_serializable) → `{snake}.g.dart`.
   (`build.yaml` zaten `lib/product/cache/model/*.dart`'ı içeriyor.)
3. `ProductCacheKeys`'e `CacheKey` ekle.
4. `cache.writeModel(key, model)` / `cache.readModel<T>(key, fromJson: T.fromJson)`.
5. `flutter analyze lib/product/cache`.

## Kısıtlar

- `@HiveType` / `typeId` / adapter ekleme → modeller JSON DTO.
- App'te `package:hive*` import etme.
- Model'i `IFallbackStore`'a koyma (string-only) → kritik *primitive* (token)
  oraya, modeller `writeModel`'e.
- `readModel`'de `fromJson`'ı unutma.
- `*.g.dart` elle düzenleme → build_runner.
