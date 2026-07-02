# Building a Testable Network Layer and Three-Tier State Management in Flutter

How to wrap HTTP behind a generic, testable network manager with `sealed` results — then drive your screens with a three-tier state model: global Cubit, page Cubit, and widget-local `ValueNotifier`.

## Flutter Refactoring Masterclass — Part 3

https://github.com/VB10/flight_booking

> **PRs:** #11, #12

📺 **Video Series:** [8-Network & Service Layer](https://youtu.be/YvZtk_6mV2s) · [9-State Management with Cubit](https://youtu.be/P5hpxaFRJNw)

🤖 *Want to apply these changes to your project? See the [AI prompt](#-apply-this-to-your-project) at the end.*

---

## The Problem

In Part 2 we split the login page into View, ViewModel, and Mixin — but the ViewModel still `new`'d up a `Dio()` instance and hard-coded `http://localhost:8080` inline. Every screen that talked to the backend did the same thing: create a fresh Dio, paste the base URL, decode JSON by hand, and copy-paste the same `if (statusCode == 200) … else … catch (e)` ladder.

That pattern rots fast. A URL change means a project-wide search. A new header (auth token, API version) has to be added everywhere. Error handling drifts — one screen returns `'Server hatası'`, another swallows the exception. And nothing is testable, because the network call is welded to the widget. As the video puts it: *the person writing the code shouldn't be able to say "this only works with internet" — the network is a dependency, and dependencies must be managed.*

There's a second rot: **state**. `setState` rebuilds the whole widget on every field change. A page with a loading flag, an error string, and a list re-renders all three even when only one changed. And there's no consistent home for "where does the loading state live" — sometimes a `ValueNotifier`, sometimes a `bool`, sometimes buried in `_PageState`.

This article fixes both on the same module. PR #11 builds a **generic network + service + model layer**. PR #12 layers a **three-tier state model** on top — Cubit for business, `BlocSelector` for surgical rebuilds, `ValueNotifier` for widget-local UI.

---

## What We Changed

**Network & Service Layer (PR #11):**
- `lib/product/network/network_manager.dart` — `IProductNetworkManager` interface
- `lib/product/network/product_network_manager.dart` — Vexana-backed singleton implementation
- `lib/product/network/network_constants.dart` — base URL, timeouts, endpoint paths
- `lib/product/network/error_model.dart` — global `ProductErrorModel` + error codes
- `lib/product/service/flight_service.dart` + `impl/flight_service_impl.dart` — abstract service + implementation
- `lib/product/service/auth_service.dart` + `impl/auth_service_impl.dart` — same for auth
- `lib/feature/**/*_response_model.dart` — models migrated to `json_serializable` + `Equatable`
- `build.yaml` — scoped code generation
- `test/product/service/*_test.dart` — service integration tests

**State Management (PR #12):**
- `lib/product/container/product_container.dart` — GetIt DI container
- `lib/product/application/application_cubit.dart` + `application_state.dart` — global app Cubit (theme)
- `lib/feature/**/cubit/*_cubit.dart` + `*_state.dart` — page-level Cubits
- `lib/feature/unauth/login/login_page.dart` — `BlocProvider` + `BlocListener` wiring
- `lib/feature/unauth/login/view/widget/login_page_body.dart` — `BlocSelector` + local `ValueNotifier`s

---

# Part A — The Network & Service Layer

## 1. One Interface, Not Ten Dio Instances

Every network call funnels through a single interface. The interface is the contract; the concrete class is swappable — which is exactly what makes it testable.

**After:**
```dart
// ✅ After — lib/product/network/network_manager.dart
/// Abstract interface for network operations.
/// This allows for easy testing and mocking.
abstract interface class IProductNetworkManager {
  /// Send a network request using the sealed NetworkResult pattern.
  Future<NetworkResult<R, ProductErrorModel>> sendRequest<
      T extends INetworkModel<T>, R>(
    String path, {
    required T parseModel,
    required RequestType method,
    dynamic body,
  });

  void setAuthToken(String token);   // call once after login
  void clearAuthToken();             // call on logout
  bool get isAuthenticated;
  void addBaseHeader(MapEntry<String, String> header);
  void removeHeader(String key);
  void clearHeaders();
}
```

> **Why this matters:** The generic bounds do the heavy lifting. `T extends INetworkModel<T>` guarantees every model has `fromJson`/`toJson`, so parsing is never hand-rolled. `setAuthToken` is called **once** — the token lives on the manager, and every later request inherits it. No more pasting headers per call.

---

## 2. The Concrete Manager: A Configured Singleton

The implementation wraps [Vexana](https://pub.dev/packages/vexana) (a Dio-based strategy-pattern network layer). The key move: **the error model is set once, at construction.** Every failed request comes back already typed as `ProductErrorModel`.

**Before:**
```dart
// ❌ Before — a fresh Dio in every method
void fetchFlights() async {
  Dio dio = Dio();                          // new instance every call
  String baseUrl = 'http://localhost:8080'; // hard-coded, repeated
  Response response = await dio.get('$baseUrl/flights');
  if (response.statusCode == 200) {
    final json = jsonDecode(response.data);
    // ...manual parsing, manual status checks, manual catch
  }
}
```

**After:**
```dart
// ✅ After — lib/product/network/product_network_manager.dart
final class ProductNetworkManager implements IProductNetworkManager {
  ProductNetworkManager._({String? baseUrl})
      : _networkManager = NetworkManager<ProductErrorModel>(
          isEnableLogger: true,
          errorModel: const ProductErrorModel(), // typed errors, set once
          options: BaseOptions(
            baseUrl: baseUrl ?? NetworkConstants.baseUrl,
            connectTimeout: NetworkConstants.connectTimeout,
            receiveTimeout: NetworkConstants.receiveTimeout,
            sendTimeout: NetworkConstants.sendTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

  static ProductNetworkManager? _instance;
  static ProductNetworkManager get instance =>
      _instance ??= ProductNetworkManager._();

  /// Call in main.dart before runApp() to point at a different environment.
  static void setup({String? baseUrl}) =>
      _instance = ProductNetworkManager._(baseUrl: baseUrl);

  /// Reset for tests.
  static void reset() => _instance = null;

  @override
  void setAuthToken(String token) {
    _networkManager.addBaseHeader(
      MapEntry(HttpHeaders.authorizationHeader, 'Bearer $token'),
    );
  }
  // ...clearAuthToken, isAuthenticated, header helpers
}
```

> **Why this matters:** `setup()` swaps the base URL for staging/prod without touching a single call site. `reset()` gives tests a clean slate. And because `errorModel` is fixed at construction, the `onError` branch downstream receives a real `ProductErrorModel` — not `dynamic`, not a raw `DioException`.

---

## 3. Endpoints and Errors as Constants

No magic strings. Paths, timeouts, and error codes live in one file each.

**After:**
```dart
// ✅ After — lib/product/network/network_constants.dart
final class NetworkConstants {
  const NetworkConstants._();
  static const String baseUrl = 'http://localhost:8080';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}

final class NetworkPaths {
  const NetworkPaths._();
  static const String login = '/login';
  static const String flights = '/flights';
  static const String checkout = '/checkout';
  static const String profile = '/profile';
}
```

The global error model mirrors the backend's error shape exactly, so it deserializes in one shot:

```dart
// ✅ After — lib/product/network/error_model.dart
@JsonSerializable()
final class ProductErrorModel extends Equatable
    implements INetworkModel<ProductErrorModel> {
  const ProductErrorModel({
    this.success = false,
    this.message,
    this.errorCode,
    this.details,
  });

  factory ProductErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ProductErrorModelFromJson(json);

  @JsonKey(defaultValue: false)
  final bool success;
  final String? message;
  final String? errorCode;
  final Map<String, dynamic>? details;

  @override
  Map<String, dynamic> toJson() => _$ProductErrorModelToJson(this);
  @override
  List<Object?> get props => [success, message, errorCode, details];
}
```

> **Why this matters:** A structured backend always returns errors in one shape (`success`, `message`, `errorCode`, `details`). Model it once, and every error handler in the app reads `error.model.errorCode` with full type safety.

---

## 4. Models: Generated, Not Hand-Written

The old models had 40 lines of manual `fromJson` loops per class. `json_serializable` + `Equatable` replaces all of it. The one rule the video stresses: **every model must implement `INetworkModel`** so the network manager can trust its `toJson`/`fromJson`.

**Before:**
```dart
// ❌ Before — flights_response_model.dart (hand-rolled)
class FlightsResponseModel {
  bool success;
  List<FlightModel> data;
  String message;

  factory FlightsResponseModel.fromJson(Map<String, dynamic> json) {
    List<FlightModel> flightList = [];
    if (json['data'] != null) {
      for (var item in json['data'] as List<dynamic>) {
        flightList.add(FlightModel.fromJson(item)); // manual loop
      }
    }
    return FlightsResponseModel(
      success: json['success'] ?? false,
      data: flightList,
      message: json['message'] ?? '',
    );
  }
  // ...plus a hand-written toJson
}
```

**After:**
```dart
// ✅ After — flights_response_model.dart (generated)
@JsonSerializable()
final class FlightsResponseModel extends Equatable
    implements INetworkModel<FlightsResponseModel> {
  const FlightsResponseModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory FlightsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FlightsResponseModelFromJson(json);

  final bool success;
  final List<FlightModel> data;
  final String message;

  @override
  FlightsResponseModel fromJson(Map<String, dynamic> json) =>
      FlightsResponseModel.fromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FlightsResponseModelToJson(this);
  @override
  List<Object?> get props => [success, data, message];
}
```

Code generation is **scoped** so `build_runner` doesn't crawl the entire project:

```yaml
# ✅ After — build.yaml
targets:
  $default:
    builders:
      json_serializable:
        generate_for:
          include:
            - lib/feature/**/model/*.dart
            - lib/feature/**/*_response_model.dart
            - lib/product/network/error_model.dart
        options:
          explicit_to_json: true
          include_if_null: false
```

> **Why this matters:** `const` constructors + immutable `final` fields + `Equatable` give you free value comparison (crucial for state, next section). Scoping `generate_for` is a real performance win on large projects — the generator only touches files that match, instead of scanning everything.

---

## 5. Abstract Services with Injected Managers

Business code never talks to the network manager directly — it talks to a service. And every service is **an interface first**, so you can swap the real implementation for a fake in tests.

**After:**
```dart
// ✅ After — lib/product/service/flight_service.dart
abstract interface class IFlightService {
  Future<NetworkResult<FlightsResponseModel, ProductErrorModel>> getFlights();
  Future<NetworkResult<CheckoutResponseModel, ProductErrorModel>> checkout({
    required List<FlightModel> cartItems,
    required String userEmail,
  });
}
```

```dart
// ✅ After — lib/product/service/impl/flight_service_impl.dart
final class FlightServiceImpl implements IFlightService {
  FlightServiceImpl([IProductNetworkManager? networkManager])
      : _networkManager = networkManager ?? ProductNetworkManager.instance;

  final IProductNetworkManager _networkManager;

  @override
  Future<NetworkResult<FlightsResponseModel, ProductErrorModel>> getFlights() {
    return _networkManager
        .sendRequest<FlightsResponseModel, FlightsResponseModel>(
      NetworkPaths.flights,
      parseModel: const FlightsResponseModel(
        success: false,
        data: [],
        message: '',
      ),
      method: RequestType.GET,
    );
  }
}
```

> **Why this matters:** Note the constructor: `[IProductNetworkManager? networkManager]`. Pass a **test** manager in unit tests; pass nothing in production and it defaults to the global singleton. This is dependency injection with zero ceremony — and it's why the services stay out of the container as *concrete* types (they're registered by their interface, more on that in Part B).

---

## 6. The Call Site: `fold` Instead of try/catch

Here's the payoff. The flight page's fetch drops from a 30-line try/catch ladder to a `sealed` result you `fold` over.

**Before:**
```dart
// ❌ Before — flight_list_page.dart
void fetchFlights() async {
  setState(() { isLoading = true; errorMessage = ''; });
  Dio dio = Dio();
  String baseUrl = 'http://localhost:8080';
  try {
    Response response = await dio.get('$baseUrl/flights');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.data);
      final flightsResponse = FlightsResponseModel.fromJson(json);
      if (flightsResponse.success) {
        setState(() { flights = flightsResponse.data; isLoading = false; });
      } else {
        setState(() { isLoading = false; errorMessage = flightsResponse.message; });
      }
    } else {
      setState(() { isLoading = false; errorMessage = 'Server hatası'; });
    }
  } catch (e) {
    setState(() { isLoading = false; errorMessage = 'Bağlantı hatası: $e'; });
  }
}
```

**After:**
```dart
// ✅ After — flight_list_page.dart
final result = await FlightServiceImpl().getFlights();
result.fold(
  onSuccess: (response) {
    if (response.success) {
      setState(() { flights = response.data; isLoading = false; });
    } else {
      setState(() { isLoading = false; errorMessage = response.message; });
    }
  },
  onError: (error) {
    setState(() {
      isLoading = false;
      errorMessage = error.description ?? 'Bağlantı hatası';
    });
  },
);
```

> **Why this matters:** A `NetworkResult` is a *sealed* type — it's `onSuccess` **or** `onError`, never both, never null. The compiler forces you to handle both branches, and `onError` hands you a typed `ProductErrorModel`. This is the exact seam that makes Part B's Cubit clean.

Because services are interfaces, the integration test just points the manager at localhost and asserts on the folded result:

```dart
// ✅ After — test/product/service/flight_service_test.dart
setUpAll(() {
  ProductNetworkManager.reset();
  ProductNetworkManager.setup(baseUrl: 'http://localhost:8080');
  flightService = FlightServiceImpl();
});

test('getFlights should return flight list', () async {
  final result = await flightService.getFlights();
  result.fold(
    onSuccess: (response) {
      expect(response.success, isTrue);
      expect(response.data, isNotEmpty);
    },
    onError: (error) => fail('Expected success: ${error.description}'),
  );
});
```

---

# Part B — Three-Tier State Management

The video's core message: **state management is an approach, not a package.** Don't let the library get in front of your architecture. Whether you use Riverpod or Bloc, the discipline is what matters. This project uses `flutter_bloc`'s **Cubit** — but the three-tier model applies anywhere.

The three tiers:

- **Global** — lives across the whole app, a `Cubit` held in the DI container. Example: theme, localization, user session.
- **Page** — lives on one screen, a page `Cubit` + `State`. Example: login flow, flight list.
- **Widget-local** — lives inside one widget, a `ValueNotifier`. Example: password visibility, expand toggle.

---

## 7. The DI Container: One Box, Registered by Interface

Global objects go in a GetIt container, registered **by their interface**. This is where the "inject a fake in tests" promise from Part A is cashed in.

**After:**
```dart
// ✅ After — lib/product/container/product_container.dart
final class ProductContainer {
  ProductContainer._();
  static final ProductContainer instance = ProductContainer._();

  final GetIt _getIt = GetIt.instance;

  T get<T extends Object>() => _getIt<T>();

  void setup() {
    if (_getIt.isRegistered<IProductNetworkManager>()) return;

    _getIt
      ..registerLazySingleton<IProductNetworkManager>(
        () => ProductNetworkManager.instance,
      )
      ..registerLazySingleton<IAuthService>(
        () => AuthServiceImpl(_getIt<IProductNetworkManager>()),
      )
      ..registerLazySingleton<IFlightService>(
        () => FlightServiceImpl(_getIt<IProductNetworkManager>()),
      )
      ..registerLazySingleton<ApplicationCubit>(ApplicationCubit.new);
  }
}
```

Wired once, before `runApp`:

```dart
// ✅ After — lib/main.dart
void main() async {
  AppInitializer.run();
  await AppInitializer().prepare();
  ProductContainer.instance.setup();
  runApp(const MainApp());
}
```

> **Why this matters:** Register the *interface* → `IAuthService`, not `AuthServiceImpl`. The whole app depends on the abstraction. Change one line in the container and every consumer gets the new implementation. `registerLazySingleton` means the object is built on first use, not at startup.

---

## 8. Global State: One Cubit for the Whole App

Theme is app-wide — flip it on the login screen, every page reacts. That's a job for a global `Cubit` provided at the root and consumed with a `BlocSelector`.

**After:**
```dart
// ✅ After — lib/product/application/application_cubit.dart
final class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(const ApplicationState(themeMode: ThemeMode.light));

  void toggleTheme() {
    final next = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(state.copyWith(themeMode: next));
  }
}
```

```dart
// ✅ After — lib/feature/sub_feature/main/main_app.dart
return MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (_) => ProductContainer.instance.get<ApplicationCubit>(),
    ),
  ],
  child: BlocSelector<ApplicationCubit, ApplicationState, ThemeMode>(
    selector: (state) => state.themeMode,
    builder: (context, themeMode) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: SplashPage(),
      );
    },
  ),
);
```

> **Why this matters:** `BlocSelector<…, ThemeMode>` rebuilds `MaterialApp` **only** when `themeMode` changes — not when any other global field mutates. Provide global Cubits at the app root and every subtree can reach them with `context.read<ApplicationCubit>()`.

---

## 9. Page State: Cubit is the Business Layer

Part 2's `LoginViewModel` becomes a `LoginCubit`. The rename isn't cosmetic — the Cubit now **owns the state** and emits it, instead of returning values the widget has to juggle.

**Before:**
```dart
// ❌ Before — login_view_model.dart returns a value, widget manages state
Future<LoginResponseModel> login({required String email, required String password}) async {
  final result = await _authService.login(email: email, password: password);
  LoginResponseModel? response;
  String? errorMessage;
  result.fold(
    onSuccess: (data) { response = data; },
    onError: (error) { errorMessage = error.model?.message ?? 'Giriş başarısız'; },
  );
  if (response != null) return response!;
  throw Exception(errorMessage); // widget has to try/catch this
}
```

**After:**
```dart
// ✅ After — lib/feature/unauth/login/cubit/login_cubit.dart
final class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authService, this._networkManager) : super(const LoginState());

  final IAuthService _authService;
  final IProductNetworkManager _networkManager;

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));

    final result = await _authService.login(email: email, password: password);
    LoginResponseModel? successResponse;
    String? failureMessage;

    result.fold(
      onSuccess: (data) {
        if (data.success) {
          _networkManager.setAuthToken(data.token); // token set once, here
          successResponse = data;
        } else {
          failureMessage = data.message;
        }
      },
      onError: (error) {
        failureMessage = error.model?.message ?? error.description ?? 'Giriş başarısız';
      },
    );

    if (successResponse != null) {
      await _saveUserToCache(successResponse!);
      await _logSuccessfulLogin(successResponse!);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: failureMessage ?? 'Giriş başarısız'));
    }
  }
}
```

The state is immutable, comparable, `copyWith`-friendly:

```dart
// ✅ After — lib/feature/unauth/login/cubit/login_state.dart
@immutable
final class LoginState extends Equatable {
  const LoginState({
    this.isLoading = false,
    this.errorMessage = '',
    this.isSuccess = false,
  });

  final bool isLoading;
  final String errorMessage;
  final bool isSuccess;

  LoginState copyWith({bool? isLoading, String? errorMessage, bool? isSuccess}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, isSuccess];
}
```

> **Why this matters:** The Cubit is a **business manager** — "logging in is a business operation." It never holds view objects (no `BuildContext`, no `Navigator`). It just emits state. Notice `isSuccess` is state, not a callback — navigation reacts to it in the next section.

---

## 10. Wiring: `BlocListener` for Side Effects

The Cubit is provided at the page root. Navigation is a *side effect* of `isSuccess` flipping true — and side effects belong in a `BlocListener`, never in a `builder`.

**After:**
```dart
// ✅ After — lib/feature/unauth/login/login_page.dart
return BlocProvider(
  create: (_) => loginCubit,
  child: BlocListener<LoginCubit, LoginState>(
    listenWhen: (previous, current) => current.isSuccess && !previous.isSuccess,
    listener: (context, state) {
      if (state.isSuccess) navigateToFlightList();
    },
    child: Scaffold(
      body: _LoginPageBody(
        emailController: emailController,
        passwordController: passwordController,
        onLogin: () => onLoginPressed(context),
      ),
    ),
  ),
);
```

The mixin now just builds the Cubit (from the container) and fires the action — no more `setState`, no more manual state juggling:

```dart
// ✅ After — lib/feature/unauth/login/view/login_page_mixin.dart
mixin LoginPageMixin on State<LoginPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  late final LoginCubit loginCubit = LoginCubit(
    ProductContainer.instance.get<IAuthService>(),
    ProductContainer.instance.get<IProductNetworkManager>(),
  );

  void navigateToFlightList() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const FlightListPage()),
    );
  }

  void onLoginPressed(BuildContext context) {
    unawaited(loginCubit.login(
      email: emailController.text,
      password: passwordController.text,
    ));
  }
}
```

> **Why this matters:** `listenWhen` fires the listener **only** on the `false → true` transition, so navigation runs exactly once. Business (Cubit) and view (Navigator) stay separated: the Cubit reports "success," the listener decides "navigate."

---

## 11. Surgical Rebuilds: `BlocSelector` per Field

Here's where immutable state pays off. Instead of one `BlocBuilder` rebuilding the whole page, each widget subscribes to **only the field it cares about** with a `BlocSelector`. The error text listens to `errorMessage`; the button listens to `isLoading`. Neither rebuilds when the other changes.

**After:**
```dart
// ✅ After — login_page_body.dart — error text listens to errorMessage only
final class _LoginErrorText extends StatelessWidget {
  const _LoginErrorText();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginCubit, LoginState, String>(
      selector: (state) => state.errorMessage,
      builder: (context, errorMessage) {
        if (errorMessage.isEmpty) return const SizedBox.shrink();
        return ProductText.bodySmall(context, errorMessage,
            color: context.colorScheme.error);
      },
    );
  }
}

// ✅ Button listens to isLoading only
final class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginCubit, LoginState, bool>(
      selector: (state) => state.isLoading,
      // builder: shows spinner when true, ElevatedButton otherwise
    );
  }
}
```

> **Why this matters:** As the video says — *"as long as nobody emits a change to `isLoading`, this widget never re-renders."* Because `LoginState` is `Equatable`, the selector compares by value and skips rebuilds when the selected field is unchanged. The widget also stops needing props passed down from the parent; it reads its slice of state directly.

---

## 12. Widget-Local State: `ValueNotifier`, No `setState`

The bottom tier: purely visual toggles that no business logic and no page state should ever know about — password visibility, "show test account" expand. These get their own `ValueNotifier`, scoped to the widget.

**After:**
```dart
// ✅ After — password field owns its own obscure toggle
class _LoginPasswordFieldState extends State<_LoginPasswordField> {
  late final ValueNotifier<bool> obscureNotifier;

  @override
  void initState() {
    super.initState();
    obscureNotifier = ValueNotifier(true);
  }

  @override
  void dispose() {
    obscureNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureNotifier,
      builder: (context, obscure, _) {
        return TextField(
          controller: widget.controller,
          obscureText: obscure,
          // suffix icon toggles obscureNotifier.value
        );
      },
    );
  }
}
```

> **Why this matters:** Password visibility is *nobody's* business but this text field's. Putting it in the Cubit would pollute business state and trigger page-wide rebuilds. A local `ValueNotifier` keeps the rebuild scoped to the one widget. Tip from the video: give the notifier a descriptive name (`obscureNotifier`, `expandedNotifier`) — a bare `ValueNotifier<bool>` tells the reader nothing.

---

## Key Takeaways

1. **Network is a dependency — manage it centrally.** One `IProductNetworkManager`, one base URL, one place for auth headers. `setAuthToken` is called exactly once.

2. **`sealed` results beat try/catch.** `NetworkResult.fold(onSuccess, onError)` forces both branches and hands you a *typed* error, not a `dynamic`.

3. **Every model implements `INetworkModel` + is generated.** `json_serializable` + `Equatable` kills hand-written parsing and gives you value equality for free. Scope `build.yaml` so generation is fast.

4. **Services are interfaces; managers are injected.** `FlightServiceImpl([manager])` defaults to the singleton in prod, accepts a fake in tests. Register by interface in the container.

5. **State has three tiers.** Global (`Cubit` in DI) → Page (`Cubit` + `State`) → Widget-local (`ValueNotifier`). Match the tier to the scope of the change.

6. **Cubit is business; the View is view.** No `BuildContext` in the Cubit. Emit `isSuccess`; let a `BlocListener` handle navigation.

7. **`BlocSelector` per field, not `BlocBuilder` per page.** Immutable `Equatable` state means each widget rebuilds only when *its* slice changes.

8. **State management is an approach, not a package.** The three-tier discipline outlives whatever library you pick.

---

## What's Next

In **Part 4**, we'll wire up **navigation with `go_router`** — typed routes, auth guards that react to the session Cubit we just built, and a `GoRouterRefreshStream` that redirects on 401. The `isSuccess` flag from `LoginCubit` becomes a router redirect instead of a manual `Navigator.pushReplacement`.

---

*This article is part of the **Flutter Refactoring Masterclass** series, where we transform a messy real-world project into production-ready code, one PR at a time.*

---

## 📺 Watch the Full Series

https://youtu.be/YvZtk_6mV2s

https://youtu.be/P5hpxaFRJNw

---

## 🤖 Apply This to Your Project

Use this prompt with Claude or your AI assistant:

```
Refactor my Flutter project's networking and state management into a
layered, testable architecture.

Network layer (lib/product/network/):
1. Create IProductNetworkManager (abstract interface) with a generic
   sendRequest<T extends INetworkModel<T>, R>() returning a sealed
   NetworkResult<R, ProductErrorModel>, plus setAuthToken / clearAuthToken /
   header helpers.
2. Implement it as a singleton (Vexana or Dio) that sets the error model ONCE
   at construction. Add static setup({baseUrl}) and reset() for env + tests.
3. Create NetworkConstants (baseUrl, timeouts) and NetworkPaths (endpoints).
4. Create a global ProductErrorModel (success, message, errorCode, details)
   implementing INetworkModel.

Models:
5. Convert every response model to @JsonSerializable + Equatable +
   INetworkModel<T> with const constructor and final fields. Add a scoped
   build.yaml (generate_for include patterns, explicit_to_json: true,
   include_if_null: false).

Service layer (lib/product/service/):
6. For each domain, create an abstract interface (IFlightService) and an
   impl that takes an optional IProductNetworkManager (defaulting to the
   singleton). Call sites use result.fold(onSuccess:, onError:).

DI (lib/product/container/):
7. Create a GetIt-based ProductContainer with setup(), registering services
   and global cubits BY INTERFACE via registerLazySingleton. Call setup()
   in main() before runApp().

State management (three tiers):
8. Global: an ApplicationCubit for app-wide state (theme). Provide it at the
   app root via MultiBlocProvider; consume with BlocSelector.
9. Page: a <Feature>Cubit extends Cubit<<Feature>State>. State is @immutable
   + Equatable + copyWith. Cubit holds NO BuildContext — it emits state only.
   Provide via BlocProvider at the page root. Handle navigation/side-effects
   in a BlocListener (use listenWhen for one-shot transitions).
10. Widget-local: use a named ValueNotifier + ValueListenableBuilder for
    purely visual toggles (obscurePassword, expanded). Never setState.
11. Subscribe each widget to only its field with BlocSelector, not one
    page-wide BlocBuilder.

Show before/after for one screen and list every new file.
```

Or invoke the existing skills directly:
```
/flutter-network-generator   # scaffolds the network + service + model layer
/cubit-add lib/feature/<area>/<feature>   # adds Cubit + state + mixin + ValueListenable
```

---

## 📋 Full Series Roadmap

This is Part 3 of a 20-part series. Here's the complete roadmap:

https://gist.github.com/VB10/1e38a0b9cb95104de24b756787026357

**Completed:** v1–v5 (Project Setup), v6 (Theme & Design System), v7 (View-ViewModel-Mixin), v8 (Network & Service Layer), v9 (State Management with Cubit)

**Coming Next:** v10 Navigation with go_router (typed routes + auth guards), plus code generation, caching, and more.

---

*⭐ [github.com/VB10/flight_booking](https://github.com/VB10/flight_booking)*
