# /route-setup — go_router + go_router_builder Navigation Altyapısı Kur

Projeye sıfırdan go_router tabanlı typed navigation, AuthCubit (session), auth guard, 401 auto-logout interceptor ve MaterialApp.router yapısını kurar.

## Kullanım

```
/route-setup
```

Route'ları tanımlamak için mevcut sayfa listesini tarayıp kullanıcıya sorar.

## Kaynak spesifikasyon

Oncelikle su dokumani oku ve ona uy:

- [docs/prompt/navigation_routing_prompt.md](../../docs/prompt/navigation_routing_prompt.md) — **ROUTE SETUP PROMPT** bolumu

Canli referans implementasyon:

- `lib/product/navigation/` — app_router, app_routes, guards, helpers
- `lib/product/application/auth/` — AuthCubit, AuthState
- `lib/product/network/interceptor/auth_interceptor.dart`
- `lib/product/container/product_container.dart` — DI kayitlari
- `lib/feature/sub_feature/main/main_app.dart` — MaterialApp.router

## Yapilacaklar (ozet)

1. `pubspec.yaml`: `go_router` + `go_router_builder` ekle, `flutter pub get`
2. `AuthState` + `AuthCubit` olustur (`application/auth/`)
3. `GoRouterRefreshStream` adapter yaz (`navigation/helpers/`)
4. `auth_guard.dart` — saf redirect fonksiyonu (`navigation/guards/`)
5. `AuthInterceptor` — 401 auto-logout (`network/interceptor/`)
6. `IProductNetworkManager` interface'ine `registerInterceptor` ekle
7. `app_routes.dart` — tum sayfalarin `@TypedGoRoute` tanimlari
8. `app_router.dart` — `GoRouter` config wrapper
9. `ProductContainer.setup()` — AuthCubit + AppRouter + AuthInterceptor register
10. `MainApp` — `MaterialApp.router` + `BlocProvider<AuthCubit>`
11. Splash — `restoreSession` + delay → route
12. Tum `Navigator.push` cagirilari → typed route `.go(context)`
13. Tum logout kodu → `context.read<AuthCubit>().logout()`
14. `dart run build_runner build --delete-conflicting-outputs`
15. `flutter analyze` → 0 error

## Kisitlar

- Cubit icinde `Navigator`/`BuildContext` kullanma
- Auth/token logic'i sayfalara dagitma, `AuthCubit`'te merkezilestir
- `AuthInterceptor`'a `AuthCubit` dogrudan inject etme — callback closure kullan
- `handler.next(err)` atlanmasin — hatalar her zaman iletilmeli
