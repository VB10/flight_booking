# Navigation & Routing Prompt (go_router + go_router_builder)

Bu prompt'u kullanarak projeye go_router tabanlı typed navigation, auth guard ve 401 auto-logout yapısı ekleyebilirsin.

---

## ROUTE SETUP PROMPT

```
Projeme go_router + go_router_builder ile navigation altyapısı kur.

Hedef yapı:
lib/product/
├── navigation/
│   ├── app_router.dart                # GoRouter config (refreshListenable, redirect, routes)
│   ├── app_routes.dart                # @TypedGoRoute tanımları
│   ├── app_routes.g.dart              # generated (build_runner)
│   ├── guards/
│   │   └── auth_guard.dart            # redirect logic (saf fonksiyon)
│   └── helpers/
│       └── go_router_refresh_stream.dart   # Stream → Listenable adapter
├── network/
│   └── interceptor/
│       └── auth_interceptor.dart      # 401 → auto logout
└── application/
    └── auth/
        ├── auth_cubit.dart            # restoreSession, setSession, logout
        └── auth_state.dart            # Equatable + copyWith

Gereksinimler:

1. pubspec.yaml:
   dependencies:
     go_router: ^14.6.2+
   dev_dependencies:
     go_router_builder: ^4.3.0+
   (build_runner zaten mevcut)

2. AuthState + AuthCubit:
   - AuthState: isLoggedIn, token?, email?, name?, userId? + Equatable + copyWith
   - AuthState.unauthenticated() named constructor
   - AuthCubit(IProductNetworkManager):
     - restoreSession(): SharedPreferences'tan oku, token varsa setAuthToken + emit
     - setSession({token, email, name, userId}): prefs yaz + setAuthToken + emit
     - logout(): prefs sil + clearAuthToken + emit unauthenticated (idempotent)
   - Hard-coded prefs key'leri: 'user_token', 'user_email', 'user_name', 'user_id'

3. GoRouterRefreshStream:
   - ChangeNotifier — Stream subscribe → notifyListeners
   - dispose'da subscription cancel

4. Auth Guard:
   - Saf fonksiyon: String? authGuard(GoRouterState state, AuthState authState)
   - /splash ve /login public; diğerleri auth required
   - !isLoggedIn ve hedef korumalı → /login
   - isLoggedIn ve hedef /login → /flights (veya ana sayfa)
   - Aksi halde null

5. AuthInterceptor:
   - Dio Interceptor: onError'da 401 → onUnauthorized callback
   - ProductContainer.setup() içinde:
     networkManager.registerInterceptor(
       AuthInterceptor(onUnauthorized: () => getIt<AuthCubit>().logout()),
     );

6. IProductNetworkManager interface'ine registerInterceptor(Interceptor) ekle

7. AppRouter:
   - GoRouter(initialLocation, refreshListenable, redirect, routes: $appRoutes)
   - ProductContainer'a lazySingleton olarak register

8. MainApp:
   - MultiBlocProvider: AuthCubit eklenir
   - MaterialApp → MaterialApp.router(routerConfig: appRouter.config)

9. Typed Route tanımları (@TypedGoRoute):
   - Her sayfa için GoRouteData extend eden route sınıfı
   - Path parametreleri: final String fieldName
   - Extra parametreler: $extra field (URL'ye yazılmaz)
   - build() metodu sayfa widget'ını döner

10. Tüm Navigator.push/pushReplacement/pushAndRemoveUntil çağrıları:
    - const SomeRoute().go(context) veya SomeRoute(param: val).go(context)
    - Logout: context.read<AuthCubit>().logout() — manuel navigation yok

11. Splash:
    - await Future.wait([delay, authCubit.restoreSession()])
    - Sonra state'e göre route

12. Build & verify:
    - flutter pub get
    - dart run build_runner build --delete-conflicting-outputs
    - flutter analyze → 0 error
```

---

## ROUTE ADD PROMPT

```
Mevcut go_router yapısına yeni route ekle:
- Sayfa adı: {PAGE_NAME}
- Path: {PATH}          (örn: /settings, /booking/:bookingId)
- Auth gerekli mi: {YES/NO}
- Path parametreleri: {PARAMS}   (örn: bookingId: String)
- Extra parametreler: {EXTRAS}   (örn: $extra: BookingModel)

Adımlar:
1. lib/product/navigation/app_routes.dart dosyasına:
   - @TypedGoRoute<{PageName}Route>(path: '{PATH}') ekle
   - class {PageName}Route extends GoRouteData with ${PageName}Route tanımla
   - Path parametreleri: final String fieldName
   - Extra: final Type $extra (nullable olabilir deep-link desteği için)
   - build() → {PageName}Page(...)

2. dart run build_runner build --delete-conflicting-outputs

3. Auth gerekli ve guard'da exempt değilse → auth_guard.dart'a eklemeye gerek yok (default korumalı).
   Auth GEREKLİ DEĞİLSE → auth_guard.dart içindeki _publicPaths set'ine path'i ekle.

4. İlgili sayfadan bu route'a navigation çağrısı ekle:
   const {PageName}Route().go(context)
   veya {PageName}Route(param: value, $extra: data).go(context)

5. flutter analyze çalıştır.
```

---

## Typed Route Şablonu

### Basit route (parametre yok)

```dart
@TypedGoRoute<ProfileRoute>(path: '/profile')
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfilePage();
}
```

### Path parametreli route

```dart
@TypedGoRoute<FlightDetailRoute>(path: ':flightId')
class FlightDetailRoute extends GoRouteData with $FlightDetailRoute {
  const FlightDetailRoute({required this.flightId, required this.$extra});

  final String flightId;
  final Map<String, dynamic> $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      FlightDetailPage(flight: $extra);
}
```

### Nested route (parent/child)

```dart
@TypedGoRoute<FlightListRoute>(
  path: '/flights',
  routes: [TypedGoRoute<FlightDetailRoute>(path: ':flightId')],
)
class FlightListRoute extends GoRouteData with $FlightListRoute {
  const FlightListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FlightListPage();
}
```

---

## Auth Guard Şablonu

```dart
String? authGuard(GoRouterState state, AuthState authState) {
  final isLoggedIn = authState.isLoggedIn;
  final location = state.matchedLocation;

  const publicPaths = {'/splash', '/login'};
  final isPublic = publicPaths.contains(location);

  if (!isLoggedIn && !isPublic) return const LoginRoute().location;
  if (isLoggedIn && location == '/login') return const FlightListRoute().location;
  return null;
}
```

---

## AuthCubit Şablonu

```dart
final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._network) : super(const AuthState.unauthenticated());

  final IProductNetworkManager _network;

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    if (token != null && token.isNotEmpty) {
      _network.setAuthToken(token);
      emit(AuthState(
        isLoggedIn: true,
        token: token,
        email: prefs.getString('user_email'),
        name: prefs.getString('user_name'),
        userId: prefs.getInt('user_id'),
      ));
    }
  }

  Future<void> setSession({
    required String token,
    required String email,
    required String name,
    required int userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString('user_token', token),
      prefs.setString('user_email', email),
      prefs.setString('user_name', name),
      prefs.setInt('user_id', userId),
    ]);
    _network.setAuthToken(token);
    emit(AuthState(isLoggedIn: true, token: token, email: email, name: name, userId: userId));
  }

  Future<void> logout() async {
    if (!state.isLoggedIn) return; // idempotent
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove('user_token'),
      prefs.remove('user_email'),
      prefs.remove('user_name'),
      prefs.remove('user_id'),
    ]);
    _network.clearAuthToken();
    emit(const AuthState.unauthenticated());
  }
}
```

---

## AuthInterceptor Şablonu

```dart
final class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.onUnauthorized});
  final void Function() onUnauthorized;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      onUnauthorized();
    }
    handler.next(err);
  }
}
```

---

## ProductContainer Kayıt Sırası

```dart
_getIt
  ..registerLazySingleton<IProductNetworkManager>(...)
  ..registerLazySingleton<IAuthService>(...)
  ..registerLazySingleton<IFlightService>(...)
  ..registerLazySingleton<ApplicationCubit>(...)
  ..registerLazySingleton<AuthCubit>(
    () => AuthCubit(_getIt<IProductNetworkManager>()),
  )
  ..registerLazySingleton<AppRouter>(
    () => AppRouter(_getIt<AuthCubit>()),
  );

// Interceptor bağlama (register sonrası)
_getIt<IProductNetworkManager>().registerInterceptor(
  AuthInterceptor(onUnauthorized: () => _getIt<AuthCubit>().logout()),
);
```

---

## Navigation Kullanım Örnekleri

```dart
// Basit go (replace)
const FlightListRoute().go(context);
const ProfileRoute().go(context);
const LoginRoute().go(context);

// Parametreli go
FlightDetailRoute(flightId: '123', $extra: flightMap).go(context);
CartRoute($extra: cartItems).go(context);

// Push (stack'e ekle, geri dönülebilir)
const ProfileRoute().push(context);

// Logout (manual navigation YOK)
context.read<AuthCubit>().logout();
// → guard otomatik /login'e yönlendirir
```

---

## Akış Diyagramı

```
App Start → /splash → restoreSession + delay
  ├─ token var → /flights (guard izin verir)
  └─ token yok → /login

Login Success → AuthCubit.setSession → refreshListenable → guard → /flights

Logout (manual) → AuthCubit.logout → refreshListenable → guard → /login

401 Response → AuthInterceptor → AuthCubit.logout → guard → /login
```

---

## CHECKLIST

- [ ] pubspec.yaml: go_router + go_router_builder
- [ ] AuthState + AuthCubit oluşturuldu
- [ ] GoRouterRefreshStream adapter yazıldı
- [ ] auth_guard.dart yazıldı
- [ ] AuthInterceptor yazıldı
- [ ] IProductNetworkManager: registerInterceptor eklendi
- [ ] app_routes.dart: tüm @TypedGoRoute tanımları
- [ ] app_router.dart: GoRouter config
- [ ] ProductContainer: AuthCubit + AppRouter + AuthInterceptor register
- [ ] MainApp: MaterialApp.router + AuthCubit BlocProvider
- [ ] Splash: restoreSession + delay → route
- [ ] Login: AuthCubit.setSession (manual nav yok)
- [ ] Tüm Navigator.push çağrıları typed route'a çevrildi
- [ ] Tüm logout çağrıları AuthCubit.logout() (manual nav yok)
- [ ] build_runner çalıştırıldı → app_routes.g.dart üretildi
- [ ] flutter analyze → 0 error

---

## İlgili dosyalar (bu repo)

- Navigation: `lib/product/navigation/` (app_router, app_routes, guards, helpers)
- Auth: `lib/product/application/auth/` (auth_cubit, auth_state)
- Interceptor: `lib/product/network/interceptor/auth_interceptor.dart`
- DI: `lib/product/container/product_container.dart`
- MainApp: `lib/feature/sub_feature/main/main_app.dart`

---

## Diger prompt'larla ilişki

- **Network layer**: `docs/prompt/network_layer_prompt.md` — service + model + vexana
- **Cubit pattern**: `docs/prompt/flutter_cubit_feature_prompt.md` — feature state management
- **Navigation**: bu dosya — go_router + guard + typed routes
