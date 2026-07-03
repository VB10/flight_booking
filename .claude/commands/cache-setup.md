# /cache-setup — Model Tabanlı Cache Mimarisini Kur

İki bağımsız store kurar: (1) **ana cache = Hive** (package'a **gömülü**, app
Hive import etmez), model-capable — `ICacheManager` primitive + `writeModel`/
`readModel`, modeller **JSON** olarak `CacheModel` contract'ıyla saklanır
(adapter/typeId YOK). (2) **fallback = strategy dışında bağımsız `IFallbackStore`**
(SharedPreferences), sadece token gibi birkaç kritik key. Ayrı `module/cache_manager`
package + ana projeye entegrasyon (ProductCache holder, keys, DI) + DTO örneği.

## Kullanım

```
/cache-setup
```

Argüman yok — mimari sabittir. Zaten kurulu ise eksik parçaları tamamlar.

## Kaynak spesifikasyon

Öncelikle şu skill'i oku ve ona uy:

- `.claude/skills/cache-setup/SKILL.md`

Canlı referans (mirror edilecek stil):

- `lib/product/network/network_manager.dart` + `product_network_manager.dart` —
  `IXxx` interface + `final class XxxImpl` + singleton + `reset()` konvansiyonu
- `lib/product/container/product_container.dart` — DI kaydı
- `lib/product/initialize/app_initializer.dart`, `lib/main.dart` — bootstrap

## Yapılacaklar (özet)

1. `module/cache_manager` package scaffold (pubspec + analysis_options).
2. Strateji (Hive, gömülü): `ICacheStrategy` (primitive + `writeObject`/
   `readObject`), `HiveCacheStrategy` — `init()` içinde `Hive.initFlutter`.
3. Manager: `CacheKey` (Equatable), `CacheModel { toJson() }`, `ICacheManager`
   (+ `writeModel<T extends CacheModel>` / `readModel(fromJson)`),
   `ProductCacheManager` (tek strateji, fallback YOK).
4. Fallback: `IFallbackStore` + `SharedPrefsFallbackStore` (strategy dışında,
   string-only, birkaç kritik key).
5. App wiring: `ProductCache` (manager + fallback, **Hive import yok**), keys,
   root pubspec path dependency, `AppInitializer` içinde `ProductCache.instance.init()`,
   `ProductContainer`'da `ICacheManager` + `IFallbackStore` kaydı (consumer'dan ÖNCE).
6. `AuthSessionCacheModel` DTO (`/cache-add-model`: json_serializable + Equatable
   + CacheModel) + AuthCubit: session → `writeModel`, token → hem model hem
   fallback; restore `readModel(fromJson)`, yoksa fallback token'dan.
7. Testler + `cd module/cache_manager && flutter test` + `flutter analyze`.

## Kısıtlar

- Fallback mantığını manager/strategy içine koyma → ayrı `IFallbackStore`.
- Object'i fallback store'a koyma (string-only) → `writeModel`.
- App'te `package:hive*` import etme → Hive package'a gömülü.
- Model için Hive adapter/`typeId` ekleme → JSON DTO (`CacheModel`).
- DI'da `ICacheManager`/`IFallbackStore`'u consumer'lardan sonra kaydetme.
