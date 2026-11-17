---
name: masterflutter-network-generator
description: >-
  Generates this project's network layer from JSON: vexana-based
  ProductNetworkManager setup, freezed request/response models in the local
  `module/gen` package, service interface + impl pairs wired into
  ProductContainer (with Idempotency-Key for side-effect POSTs), and new
  endpoints on an existing service. Use when the user runs /masterflutter-network-generator or
  asks to add a service, an endpoint, or a model from an API response.
---

# /masterflutter-network-generator - Network Layer & Service Generator

Generates network layer, models, services, and tests from JSON responses.
Uses vexana package with static singleton pattern. Models are NOT written in
the app: they live in the local package `module/gen` (freezed 3 +
json_serializable) and are imported with `package:gen/gen.dart`.
Cubit states are not models; they stay next to their cubits.

## Usage
```
/masterflutter-network-generator <action> <arguments>
```

**Actions:**
- `setup` - Initialize network layer for the project
- `model <json>` - Generate model from JSON response
- `service <name>` - Generate service with interface
- `endpoint <service> <method> <path>` - Add endpoint to existing service

**Examples:**
- `/masterflutter-network-generator setup`
- `/masterflutter-network-generator model {"success": true, "data": {...}}`
- `/masterflutter-network-generator service auth`
- `/masterflutter-network-generator endpoint auth login /login POST`

---

## Step 1: Determine Action

Parse the action from arguments:
- If `setup`: Initialize full network layer
- If `model`: Generate model from provided JSON
- If `service`: Generate service interface and implementation
- If `endpoint`: Add endpoint to existing service

---

## Action: SETUP

Initialize the network layer infrastructure.

### 1.1 Check Prerequisites
```bash
# Check if vexana already exists
grep -q "vexana:" pubspec.yaml
```

### 1.2 Update pubspec.yaml
Add if not exists (the app has no json_serializable / equatable for models):
```yaml
dependencies:
  vexana: ^5.0.3
  gen:
    path: module/gen
```
`module/gen/pubspec.yaml` owns the model dependencies: `freezed_annotation`,
`json_annotation`, `vexana` (for `INetworkModel`), and dev `build_runner`,
`freezed`, `json_serializable`.

### 1.3 Create Network Constants
File: `lib/product/network/network_constants.dart`

```dart
/// Network configuration constants
final class NetworkConstants {
  const NetworkConstants._();

  static const String baseUrl = 'http://localhost:8080';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Header that makes a checkout retry safe (server replays the first order).
  static const String idempotencyKeyHeader = 'Idempotency-Key';
}

/// API endpoint paths
final class NetworkPaths {
  const NetworkPaths._();

  static const String login = '/login';
  static const String flights = '/flights';
  static const String checkout = '/checkout';
  // Add endpoints here
}
```

### 1.4 Create Network Manager Interface
File: `lib/product/network/network_manager.dart`

```dart
import 'package:gen/gen.dart';
import 'package:vexana/vexana.dart';

abstract interface class IProductNetworkManager {
  /// [headers] are sent with THIS request only (never the shared base
  /// headers, which would race with other requests on the singleton).
  Future<NetworkResult<R, ProductErrorModel>>
  sendRequest<T extends INetworkModel<T>, R>(
    String path, {
    required T parseModel,
    required RequestType method,
    dynamic body,
    Map<String, String>? headers,
  });

  void setAuthToken(String token);
  void clearAuthToken();
  bool get isAuthenticated;
  void addBaseHeader(MapEntry<String, String> header);
  void removeHeader(String key);
  void clearHeaders();

  /// Register a Dio interceptor (e.g. AuthInterceptor for 401 handling)
  void registerInterceptor(Interceptor interceptor);
}
```

### 1.5 Create Network Manager Implementation
File: `lib/product/network/product_network_manager.dart`

```dart
import 'dart:io';

import 'package:flight_booking/product/network/network_constants.dart';
import 'package:flight_booking/product/network/network_manager.dart';
import 'package:gen/gen.dart';
import 'package:vexana/vexana.dart';

final class ProductNetworkManager implements IProductNetworkManager {
  ProductNetworkManager._({String? baseUrl})
    : _networkManager = NetworkManager<ProductErrorModel>(
        isEnableLogger: true,
        errorModel: const ProductErrorModel(),
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

  static ProductNetworkManager get instance {
    _instance ??= ProductNetworkManager._();
    return _instance!;
  }

  static void setup({String? baseUrl}) {
    _instance = ProductNetworkManager._(baseUrl: baseUrl);
  }

  static void reset() {
    _instance = null;
  }

  final INetworkManager<ProductErrorModel> _networkManager;

  @override
  Future<NetworkResult<R, ProductErrorModel>>
  sendRequest<T extends INetworkModel<T>, R>(
    String path, {
    required T parseModel,
    required RequestType method,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    return _networkManager.sendRequest<T, R>(
      path,
      parseModel: parseModel,
      method: method,
      data: body,
      options: headers == null ? null : Options(headers: headers),
    );
  }

  @override
  void setAuthToken(String token) {
    _networkManager.addBaseHeader(
      MapEntry(HttpHeaders.authorizationHeader, 'Bearer $token'),
    );
  }

  @override
  void clearAuthToken() {
    _networkManager.removeHeader(HttpHeaders.authorizationHeader);
  }

  @override
  bool get isAuthenticated {
    final headers = _networkManager.allHeaders;
    return headers.containsKey(HttpHeaders.authorizationHeader);
  }

  @override
  void addBaseHeader(MapEntry<String, String> header) {
    _networkManager.addBaseHeader(header);
  }

  @override
  void removeHeader(String key) {
    _networkManager.removeHeader(key);
  }

  @override
  void clearHeaders() {
    _networkManager.clearHeader();
  }

  @override
  void registerInterceptor(Interceptor interceptor) {
    _networkManager.dioInterceptors.add(interceptor);
  }
}
```

### 1.6 Create the `module/gen` package and the Error Model
The error model is a model like any other, so it lives in the package, not in
`lib/product/network/`.

File: `module/gen/lib/src/model/error/product_error_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vexana/vexana.dart';

part 'product_error_model.freezed.dart';
part 'product_error_model.g.dart';

/// It is the `E` of vexana's `NetworkManager<E extends INetworkModel<E>>`, so
/// vexana parses every error body through [fromJson] on a `const` instance.
@freezed
abstract class ProductErrorModel
    with _$ProductErrorModel
    implements INetworkModel<ProductErrorModel> {
  const factory ProductErrorModel({
    @Default(false) bool success,
    String? message,
    String? errorCode,
    Map<String, dynamic>? details,
  }) = _ProductErrorModel;

  const ProductErrorModel._();

  factory ProductErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ProductErrorModelFromJson(json);

  @override
  ProductErrorModel fromJson(Map<String, dynamic> json) =>
      ProductErrorModel.fromJson(json);
}

final class ErrorCodes {
  const ErrorCodes._();

  static const String invalidCredentials = 'INVALID_CREDENTIALS';
  static const String unauthorized = 'UNAUTHORIZED';
  static const String notFound = 'NOT_FOUND';
  static const String validationError = 'VALIDATION_ERROR';
  static const String serverError = 'SERVER_ERROR';
  static const String networkError = 'NETWORK_ERROR';
}
```

Package layout (barrel `module/gen/lib/gen.dart` exports every model file;
models are added to it, never imported by `src/` path from the app):
```
module/gen/
  build.yaml
  pubspec.yaml
  lib/gen.dart
  lib/src/model/{request,response,error,cache}/*.dart
  test/*.dart
```

### 1.7 Create `module/gen/build.yaml`
File: `module/gen/build.yaml` (there is NO build.yaml for models in the app root)

```yaml
targets:
  $default:
    builders:
      freezed:
        generate_for:
          include:
            - lib/src/model/**.dart
      json_serializable:
        generate_for:
          include:
            - lib/src/model/**.dart
        options:
          explicit_to_json: true
          include_if_null: false
          field_rename: none
```
`explicit_to_json` makes nested models serialize to plain maps (needed for
`request.toJson()` bodies); `include_if_null: false` keeps null fields off the wire.

### 1.8 Generation Script
Codegen goes through the single entry point `scripts/generate.sh`
(do not create a separate build_runner script):
```bash
./scripts/generate.sh --models   # builds module/gen only
./scripts/generate.sh            # everything (models, assets, routes, locale keys)
```

### 1.9 Run Commands
```bash
flutter pub get
./scripts/generate.sh --models
```

---

## Action: MODEL

Generate model from JSON response.

### 2.1 Parse JSON
Ask user for:
- Model name (e.g., `Login`, `Profile`, `Flight`)
- Direction: response (server -> app) or request (app -> server body)
- JSON

Target is always `module/gen/lib/src/model/{response|request}/` (no
`lib/feature/**/model`). Cubit states are NOT models: they stay with their
cubit and are never added to `module/gen`.

### 2.2 Analyze JSON Structure
- Identify top-level response wrapper (success, data, message)
- Identify nested objects (extra freezed classes in the same file)
- Determine types (String, int, bool, List, nested object)

### 2.3 Generate Response Model
File: `module/gen/lib/src/model/response/{model_name}_response_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vexana/vexana.dart';

part '{model_name}_response_model.freezed.dart';
part '{model_name}_response_model.g.dart';

@freezed
abstract class {ModelName}ResponseModel
    with _${ModelName}ResponseModel
    implements INetworkModel<{ModelName}ResponseModel> {
  const factory {ModelName}ResponseModel({
    required bool success,
    required String message,
    required {DataType} data,
  }) = _{ModelName}ResponseModel;

  const {ModelName}ResponseModel._();

  factory {ModelName}ResponseModel.fromJson(Map<String, dynamic> json) =>
      _${ModelName}ResponseModelFromJson(json);

  @override
  {ModelName}ResponseModel fromJson(Map<String, dynamic> json) =>
      {ModelName}ResponseModel.fromJson(json);
}

// Nested objects: same pattern, same file (see UserModel in
// login_response_model.dart).
```
No Equatable: `==`, `hashCode`, `copyWith`, `toString` come from freezed.

### 2.4 Generate Request Model
File: `module/gen/lib/src/model/request/{model_name}_request_model.dart`

Request models are plain freezed + JSON, no `INetworkModel`, no `const X._()`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '{model_name}_request_model.freezed.dart';
part '{model_name}_request_model.g.dart';

/// Body of `POST /{path}`.
@freezed
abstract class {ModelName}RequestModel with _${ModelName}RequestModel {
  const factory {ModelName}RequestModel({
    required String email,
    required String password,
  }) = _{ModelName}RequestModel;

  factory {ModelName}RequestModel.fromJson(Map<String, dynamic> json) =>
      _${ModelName}RequestModelFromJson(json);
}
```
A request that embeds another model imports it by package path
(`package:gen/src/model/response/flights_response_model.dart`), as
`CheckoutRequestModel` does.

### 2.5 Export and Generate
1. Add `export 'src/model/{dir}/{file}.dart';` to `module/gen/lib/gen.dart`.
2. Run:
```bash
./scripts/generate.sh --models
```

### 2.6 Model Tests
File: `module/gen/test/` (extend `model_round_trip_test.dart` /
`request_model_test.dart` or add a file):
- Response: `fromJson -> toJson -> fromJson` equals the original (freezed `==`).
- Request: `toJson()` equals the exact wire map; nested models come out as plain
  `Map`s (guards `explicit_to_json`).
```bash
cd module/gen && flutter test
```

---

## Action: SERVICE

Generate service interface and implementation.

### 3.1 Create Service Interface
File: `lib/product/service/{service_name}_service.dart`

A service takes a request MODEL and never a raw `Map`. Real signatures:
```dart
import 'package:gen/gen.dart';
import 'package:vexana/vexana.dart';

abstract interface class IAuthService {
  Future<NetworkResult<LoginResponseModel, ProductErrorModel>> login(
    LoginRequestModel request,
  );

  Future<NetworkResult<ProfileResponseModel, ProductErrorModel>> getProfile();
}

abstract interface class IFlightService {
  Future<NetworkResult<FlightsResponseModel, ProductErrorModel>> getFlights();

  /// [idempotencyKey] makes a retry of the same payment safe.
  Future<NetworkResult<CheckoutResponseModel, ProductErrorModel>> checkout(
    CheckoutRequestModel request, {
    required String idempotencyKey,
  });
}
```

### 3.2 Create Service Implementation
File: `lib/product/service/impl/{service_name}_service_impl.dart`

```dart
import 'package:flight_booking/product/network/network_constants.dart';
import 'package:flight_booking/product/network/network_manager.dart';
import 'package:flight_booking/product/network/product_network_manager.dart';
import 'package:flight_booking/product/service/flight_service.dart';
import 'package:gen/gen.dart';
import 'package:vexana/vexana.dart';

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

  @override
  Future<NetworkResult<CheckoutResponseModel, ProductErrorModel>> checkout(
    CheckoutRequestModel request, {
    required String idempotencyKey,
  }) {
    return _networkManager
        .sendRequest<CheckoutResponseModel, CheckoutResponseModel>(
          NetworkPaths.checkout,
          parseModel: const CheckoutResponseModel(
            success: false,
            message: '',
            orderId: 0,
            totalPrice: 0,
          ),
          method: RequestType.POST,
          headers: {NetworkConstants.idempotencyKeyHeader: idempotencyKey},
          body: request.toJson(),
        );
  }
}
```
Rules: body is always `request.toJson()` (never `body: {...}`); `parseModel`
is a `const` instance of the response model; register the service in
`ProductContainer` (lib/product/container/product_container.dart) next to the
existing ones:

```dart
..registerLazySingleton<IFlightService>(
  () => FlightServiceImpl(_getIt<IProductNetworkManager>()),
)
```

### 3.3 Idempotency for side-effect POSTs
Any POST that pays or books takes `required String idempotencyKey` and sends it
per request as `NetworkConstants.idempotencyKeyHeader` (the `headers:` argument
above, never `addBaseHeader`). The backend MUST support the `Idempotency-Key`
header (replay the first result for the same key), otherwise the key is
decoration.

- Generation: `IIdempotencyKeyGenerator` (`lib/product/util/idempotency/idempotency_key_generator.dart`),
  production impl `SecureIdempotencyKeyGenerator`. Inject it; never call
  `Random` in a service.
- Lifetime: a key identifies one payment INTENT, so the owner of that intent
  holds it, not the service. Example, `CartCubit.ensureCheckoutKey()`:
```dart
String? _checkoutKey; // not in CartState (Equatable would drop a lazy set)
String ensureCheckoutKey() => _checkoutKey ??= _keyGenerator.generate();

@override
void emit(CartState state) {
  _checkoutKey = null; // every cart mutation starts a new payment intent
  super.emit(state);
}
```
  The caller reads `cart.ensureCheckoutKey()` and passes the SAME key on every
  retry of that cart; a changed cart gets a new key.

### 3.4 Create Service Unit Test (no server)
File: `test/product/service/{service_name}_service_idempotency_test.dart`

Use a capturing fake `IProductNetworkManager` and assert path, headers and body
(`noSuchMethod` covers the members the test does not use):
```dart
final class _CapturingNetwork implements IProductNetworkManager {
  Map<String, String>? lastHeaders;
  String? lastPath;
  dynamic lastBody;

  @override
  Future<NetworkResult<R, ProductErrorModel>>
  sendRequest<T extends INetworkModel<T>, R>(
    String path, {
    required T parseModel,
    required RequestType method,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    lastPath = path;
    lastHeaders = headers;
    lastBody = body;
    return const NetworkErrorResult(ErrorModel(description: 'captured'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

test('checkout sends the key as the Idempotency-Key header', () async {
  final network = _CapturingNetwork();
  await FlightServiceImpl(network).checkout(
    CheckoutRequestModel(cartItems: const <FlightModel>[], userEmail: 'user@test.com'),
    idempotencyKey: 'abc123',
  );
  expect(network.lastPath, '/checkout');
  expect(network.lastHeaders, {'Idempotency-Key': 'abc123'});
  expect(network.lastBody, {'cartItems': <Map<String, dynamic>>[], 'userEmail': 'user@test.com'});
});
```
Imports: `network_manager.dart`, the impl, `flutter_test`, `package:gen/gen.dart`,
`package:vexana/vexana.dart`.

### 3.5 Create Integration Test (backend required)
File: `test/product/service/{service_name}_service_test.dart`

```dart
import 'package:flight_booking/product/network/product_network_manager.dart';
import 'package:flight_booking/product/service/{service_name}_service.dart';
import 'package:flight_booking/product/service/impl/{service_name}_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';

void main() {
  late I{ServiceName}Service service;

  setUpAll(() {
    ProductNetworkManager.reset();
    ProductNetworkManager.setup(baseUrl: 'http://localhost:8080');
    service = {ServiceName}ServiceImpl();
  });

  group('{ServiceName} Integration Tests', () {
    // Add tests. Side-effect POSTs: use a UNIQUE idempotency key per run
    // (e.g. SecureIdempotencyKeyGenerator().generate()); a fixed key replays
    // the first stored result and the test silently stops testing anything.
  });
}
```
These tests need the backend running on `localhost:8080`.

---

## Action: ENDPOINT

Add endpoint to existing service.

### 4.1 Update NetworkPaths
Add to `lib/product/network/network_constants.dart`:
```dart
static const String {pathName} = '/{path}';
```

### 4.2 Update Service Interface
Add method to interface. It takes a request model (add it per MODEL action if
missing); a side-effect POST also takes `required String idempotencyKey`.

### 4.3 Update Service Implementation
Add method implementation: `body: request.toJson()`, plus
`headers: {NetworkConstants.idempotencyKeyHeader: idempotencyKey}` for
side-effect POSTs.

### 4.4 Add Test Cases
Add success and error test cases, plus a capturing-fake unit test for path/headers/body.

---

## Code Style Rules

1. **Services, managers, constants are `final class`; models are `@freezed abstract class`**
2. **Constructors are `const`** (freezed `const factory`)
3. **Models live in `module/gen`, imported via `package:gen/gen.dart`**
4. **Response models implement `INetworkModel<T>`** (with `const X._()`); request models do not
5. **No Equatable on models** (freezed provides equality); cubit states stay with cubits
6. **Service constructors: nullable network manager with default**
7. **Services take a request model and send `request.toJson()`, never a raw map**
8. **Side-effect POSTs take `required String idempotencyKey`**
9. **Use `NetworkResult.fold()` pattern for responses**
10. **Import package paths, not relative paths**

---

## Checklist After Generation

- [ ] `flutter pub get` executed
- [ ] `./scripts/generate.sh --models` executed
- [ ] New model exported from `module/gen/lib/gen.dart`
- [ ] Generated `.freezed.dart` / `.g.dart` files exist in `module/gen`
- [ ] `flutter analyze` passes
- [ ] `cd module/gen && flutter test` passes
- [ ] Service unit test (capturing fake) passes
- [ ] Integration tests compile (backend required to run, unique idempotency key per run)
