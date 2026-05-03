---
name: route-setup
description: >-
  Sets up go_router + go_router_builder navigation infrastructure from scratch.
  Creates AuthCubit (session management), AuthInterceptor (401 auto-logout),
  GoRouterRefreshStream, auth guard, typed route definitions, and AppRouter.
  Wires everything into ProductContainer and converts MaterialApp to
  MaterialApp.router. Use when user runs /route-setup or asks to add
  go_router navigation to the project.
---

# Navigation & Routing Setup (go_router + go_router_builder)

## When to apply

- User invokes **`/route-setup`** or asks to set up navigation/routing for the project.
- Project has no go_router dependency yet and needs typed routing with auth guard.

## Authoritative spec

Read and follow:

- [docs/prompt/navigation_routing_prompt.md](../../../docs/prompt/navigation_routing_prompt.md) — **ROUTE SETUP PROMPT** section

## Implementation checklist

1. **pubspec.yaml**: Add `go_router` (dependencies) and `go_router_builder` (dev_dependencies). Run `flutter pub get`.
2. **AuthState** (`application/auth/auth_state.dart`): `Equatable` + `copyWith`; fields: `isLoggedIn`, `token?`, `email?`, `name?`, `userId?`. Named constructor `AuthState.unauthenticated()`.
3. **AuthCubit** (`application/auth/auth_cubit.dart`): inject `IProductNetworkManager`; methods: `restoreSession()`, `setSession(...)`, `logout()`. All SharedPreferences + network token + state emit in one place. `logout()` must be **idempotent** (no-op if already unauthenticated).
4. **GoRouterRefreshStream** (`navigation/helpers/`): `ChangeNotifier` that subscribes to a `Stream` and calls `notifyListeners` on each event.
5. **Auth guard** (`navigation/guards/auth_guard.dart`): pure function `String? authGuard(GoRouterState, AuthState)`. Public paths (`/splash`, `/login`) exempt. All others require `isLoggedIn`. Logged-in user on `/login` → redirect to main page.
6. **AuthInterceptor** (`network/interceptor/auth_interceptor.dart`): Dio `Interceptor`; `onError` checks `statusCode == 401` → calls `onUnauthorized` callback. Callback wired to `AuthCubit.logout()` via closure in `ProductContainer.setup()`.
7. **IProductNetworkManager**: add `void registerInterceptor(Interceptor interceptor)` to interface + implementation (`_networkManager.dioInterceptors.add(...)`).
8. **Typed routes** (`navigation/app_routes.dart`): `@TypedGoRoute` for each page. `GoRouteData` subclasses with `build()` returning the page widget. Path params as `final String fieldName`, extras as `final Type $extra`.
9. **AppRouter** (`navigation/app_router.dart`): wraps `GoRouter` with `initialLocation`, `refreshListenable: GoRouterRefreshStream(authCubit.stream)`, `redirect: authGuard`, `routes: $appRoutes`.
10. **ProductContainer**: register `AuthCubit` (lazySingleton), `AppRouter` (lazySingleton), then `AuthInterceptor` binding.
11. **MainApp**: add `BlocProvider<AuthCubit>` to `MultiBlocProvider`, change `MaterialApp` to `MaterialApp.router(routerConfig: ...)`, remove `home:`.
12. **Splash**: remove SharedPreferences logic; `await Future.wait([delay, authCubit.restoreSession()])` then `go()` based on state.
13. **All pages**: replace `Navigator.push/pushReplacement/pushAndRemoveUntil` with typed route `.go(context)` or `.push(context)`. Replace all logout code with `context.read<AuthCubit>().logout()`.
14. **Build**: `dart run build_runner build --delete-conflicting-outputs` → generates `app_routes.g.dart`.
15. **Verify**: `flutter analyze` → 0 errors.

## Do not

- Use `Navigator` directly anywhere after setup — all navigation through typed routes.
- Put auth/token logic in individual pages — centralize in `AuthCubit`.
- Skip `handler.next(err)` in `AuthInterceptor` — always forward the error.
- Inject `AuthCubit` directly into `AuthInterceptor` — use callback closure to avoid circular deps.

## Reference code in this repo

- Navigation: `lib/product/navigation/` (app_router, app_routes, guards, helpers)
- Auth: `lib/product/application/auth/` (auth_cubit, auth_state)
- Interceptor: `lib/product/network/interceptor/auth_interceptor.dart`
- DI: `lib/product/container/product_container.dart`
- MainApp: `lib/feature/sub_feature/main/main_app.dart`

## Slash command

Users can trigger this workflow with:

- `.claude/commands/route-setup.md` → **`/route-setup`**
