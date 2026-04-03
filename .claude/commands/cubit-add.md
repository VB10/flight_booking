# /cubit-add — Feature ekranına Cubit + mixin + ValueListenable ekle

Yeni veya mevcut bir Flutter feature sayfasını projedeki standart desene göre uygular: **Cubit + Equatable state**, **StatefulWidget + PageMixin**, **BlocBuilder / BlocListener**, **ValueListenableBuilder** (yerel UI), **ProductContainer** ile servis çözümü.

## Kullanım

```
/cubit-add {feature_path}
```

**Örnekler:**

- `/cubit-add lib/feature/unauth/splash/splash_page.dart`
- `/cubit-add lib/feature/auth/profile` (klasör — sayfa dosyasını tespit et veya oluştur)

Argüman yoksa kullanıcıdan feature yolunu veya sayfa adını sor.

## Kaynak spesifikasyon

Önce şu dokümanı oku ve ona uy:

- [docs/prompt/flutter_cubit_feature_prompt.md](../../docs/prompt/flutter_cubit_feature_prompt.md)

Canlı referans implementasyonlar:

- `lib/feature/unauth/login/` — mixin + Cubit + copyWith state + iki ValueNotifier (şifre + test bilgisi)
- `lib/feature/auth/flight/` — `FlightListCubit` + `FlightListState` (copyWith)

## Yapılacaklar (özet)

1. `cubit/{feature}_state.dart` — Equatable + `copyWith` tek state (sealed class kullanma).
2. `cubit/{feature}_cubit.dart` — `Cubit`, servisleri constructor’dan al; `ProductContainer.instance.get<...>()` mixin’de verilir.
3. `view/{feature}_page_mixin.dart` — `part of` ana sayfa; controller + `ValueNotifier` lifecycle; Cubit’e `context.read<Cubit>()` ile erişim.
4. `{feature}_page.dart` — `BlocProvider(create:)` + `BlocListener` (navigasyon / tek seferlik yan etkiler) + `Scaffold` + body.
5. `view/widget/{feature}_page_body.dart` — `BlocBuilder` ana durum için; basit UI için `ValueListenableBuilder`; `setState` kullanma.
6. Gerekirse `lib/product/container/product_container.dart` içine `I*` servis kaydı ekle.
7. `dart analyze` ilgili `lib/feature/...` yolunda çalıştır.

## Kısıtlar

- Cubit içinde `BuildContext` / `Navigator` kullanma; `BlocListener` kullan.
- Uzun ömürlü global Cubit’ler (ör. tema) için ayrı pattern: `ApplicationCubit` + `MainApp` — bu komut feature-odaklıdır.
