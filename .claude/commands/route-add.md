# /route-add — Mevcut Navigation'a Yeni Route Ekle

Mevcut go_router yapisina yeni bir typed route ekler. Sayfa adi ve path alir, `app_routes.dart`'a `GoRouteData` sinifi ekler, `build_runner` ile `app_routes.g.dart`'i yeniden uretir.

## Kullanim

```
/route-add {page_name} {path}
```

**Ornekler:**

- `/route-add Settings /settings`
- `/route-add BookingDetail /bookings/:bookingId`
- `/route-add` (arguman yoksa kullanicidan sor)

## Kaynak spesifikasyon

Oncelikle su dokumani oku ve ona uy:

- [docs/prompt/navigation_routing_prompt.md](../../docs/prompt/navigation_routing_prompt.md) — **ROUTE ADD PROMPT** bolumu

Canli referans:

- `lib/product/navigation/app_routes.dart` — mevcut route tanimlari
- `lib/product/navigation/app_routes.g.dart` — generated code
- `lib/product/navigation/guards/auth_guard.dart` — public path listesi

## Kullanicidan alinacak bilgiler

| Alan | Ornek | Zorunlu |
|------|-------|---------|
| Sayfa adi | `Settings` | Evet |
| Path | `/settings` | Evet |
| Auth gerekli mi | Evet (default) / Hayir | Evet |
| Parent route | Yok (top-level) / `FlightListRoute` | Hayir |
| Path param | `bookingId: String` | Path'te `:param` varsa |
| Extra param | `$extra: BookingModel` | Sayfa data aliyorsa |
| Sayfa widget yolu | `lib/feature/auth/settings/settings_page.dart` | Evet |

## Yapilacaklar (ozet)

1. `lib/product/navigation/app_routes.dart`:
   - Sayfa import'unu ekle
   - `@TypedGoRoute<{Name}Route>(path: '{path}')` annotation
   - `class {Name}Route extends GoRouteData with ${Name}Route` tanimla
   - Path param → `final String fieldName`
   - Extra → `final Type $extra`
   - `build()` → sayfa widget'i don

2. Auth guard (sadece PUBLIC route icin):
   - `auth_guard.dart` icindeki `_publicPaths` set'ine path ekle
   - Auth gerekliyse (default) → degisiklik yok

3. `dart run build_runner build --delete-conflicting-outputs`
   - `app_routes.g.dart` yeni route'un `$` mixin'ini icermeli

4. Kaynak sayfaya navigation cagrisi ekle:
   - `const {Name}Route().go(context)` veya `{Name}Route(param: val).go(context)`
   - `app_routes.dart` import et, direct page import kaldir

5. `flutter analyze` → 0 error

## Kisitlar

- `app_routes.g.dart` dosyasini manuel duzenleme — generated
- `Navigator.push` ile yeni route'a gitme — typed route `.go()` / `.push()` kullan
- Auth-required route'lari `_publicPaths`'e ekleme
- Build runner calistirmadan once sayfa import'unu ekle
