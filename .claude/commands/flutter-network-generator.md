# /flutter-network-generator - Network Layer & Service Generator

Generates network layer, models, services, and tests from JSON responses.
Uses vexana package with static singleton pattern.

## Usage
```
/flutter-network-generator <action> <arguments>
```

**Actions:**
- `setup` - Initialize network layer for the project
- `model <json>` - Generate model from JSON response
- `service <name>` - Generate service with interface
- `endpoint <service> <method> <path>` - Add endpoint to existing service

**Examples:**
- `/flutter-network-generator setup`
- `/flutter-network-generator model {"success": true, "data": {...}}`
- `/flutter-network-generator service auth`
- `/flutter-network-generator endpoint auth login /login POST`

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
Add if not exists:
```yaml
dependencies:
  vexana: ^5.0.3
  json_annotation: ^4.9.0
  equatable: ^2.0.8

dev_dependencies:
  build_runner: ^2.9.0
  json_serializable: ^6.9.0
```

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
}

/// API endpoint paths
final class NetworkPaths {
  const NetworkPaths._();

  // Add endpoints here
  // static const String login = '/login';
}
```

### 1.4 Create Network Manager Interface
File: `lib/product/network/network_manager.dart`

```dart
import 'package:flight_booking/product/network/error_model.dart';
import 'package:vexana/vexana.dart';

/// Abstract interface for network operations
abstract interface class IProductNetworkManager {
  Future<NetworkResult<R, ProductErrorModel>> sendRequest<
      T extends INetworkModel<T>, R>(
    String path, {
    required T parseModel,
    required RequestType method,
    dynamic body,
  });

  void setAuthToken(String token);
  void clearAuthToken();
  bool get isAuthenticated;
  void addBaseHeader(MapEntry<String, String> header);
  void removeHeader(String key);
  void clearHeaders();
}
```

### 1.5 Create Network Manager Implementation
File: `lib/product/network/product_network_manager.dart`

```dart
import 'dart:io';
import 'package:flight_booking/product/network/error_model.dart';
import 'package:flight_booking/product/network/network_constants.dart';
import 'package:flight_booking/product/network/network_manager.dart';
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
  Future<NetworkResult<R, ProductErrorModel>> sendRequest<
      T extends INetworkModel<T>, R>(
    String path, {
    required T parseModel,
    required RequestType method,
    dynamic body,
  }) async {
    return _networkManager.sendRequest<T, R>(
      path,
      parseModel: parseModel,
      method: method,
      data: body,
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
}
```

### 1.6 Create Error Model
File: `lib/product/network/error_model.dart`

```dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part 'error_model.g.dart';

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
  ProductErrorModel fromJson(Map<String, dynamic> json) =>
      ProductErrorModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProductErrorModelToJson(this);

  @override
  List<Object?> get props => [success, message, errorCode, details];
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

### 1.7 Create build.yaml
File: `build.yaml`

```yaml
targets:
  $default:
    builders:
      json_serializable:
        generate_for:
          include:
            - lib/feature/**/model/*.dart
            - lib/feature/**/*_model.dart
            - lib/feature/**/*_response_model.dart
            - lib/product/network/error_model.dart
        options:
          explicit_to_json: true
          include_if_null: false
          field_rename: none
```

### 1.8 Create Build Script
File: `scripts/build_runner.sh`

```bash
#!/bin/bash
set -e
echo "Running build_runner..."
cd "$(dirname "$0")/.."
if [ "$1" == "--clean" ]; then
    flutter pub run build_runner clean
fi
flutter pub run build_runner build --delete-conflicting-outputs
echo "Done!"
```

### 1.9 Run Commands
```bash
flutter pub get
chmod +x scripts/build_runner.sh
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Action: MODEL

Generate model from JSON response.

### 2.1 Parse JSON
Ask user for:
- Model name (e.g., `Login`, `Profile`, `Flight`)
- Target path (e.g., `feature/auth/login/model`)
- JSON response

### 2.2 Analyze JSON Structure
- Identify top-level response wrapper (success, data, message)
- Identify nested objects
- Determine types (String, int, bool, List, nested object)

### 2.3 Generate Model File
File: `lib/{target_path}/{model_name}_response_model.dart`

**Template:**
```dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vexana/vexana.dart';

part '{model_name}_response_model.g.dart';

@JsonSerializable()
final class {ModelName}ResponseModel extends Equatable
    implements INetworkModel<{ModelName}ResponseModel> {
  const {ModelName}ResponseModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory {ModelName}ResponseModel.fromJson(Map<String, dynamic> json) =>
      _${ModelName}ResponseModelFromJson(json);

  final bool success;
  final {DataType} data;
  final String message;

  @override
  {ModelName}ResponseModel fromJson(Map<String, dynamic> json) =>
      {ModelName}ResponseModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() => _${ModelName}ResponseModelToJson(this);

  @override
  List<Object?> get props => [success, data, message];
}

// Generate nested classes for each object in data
```

### 2.4 Run Build Runner
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Action: SERVICE

Generate service interface and implementation.

### 3.1 Create Service Interface
File: `lib/product/service/{service_name}_service.dart`

```dart
import 'package:flight_booking/product/network/error_model.dart';
import 'package:vexana/vexana.dart';
// Import response models

abstract interface class I{ServiceName}Service {
  // Add method signatures
}
```

### 3.2 Create Service Implementation
File: `lib/product/service/impl/{service_name}_service_impl.dart`

```dart
import 'package:flight_booking/product/network/error_model.dart';
import 'package:flight_booking/product/network/network_constants.dart';
import 'package:flight_booking/product/network/network_manager.dart';
import 'package:flight_booking/product/network/product_network_manager.dart';
import 'package:flight_booking/product/service/{service_name}_service.dart';
import 'package:vexana/vexana.dart';

final class {ServiceName}ServiceImpl implements I{ServiceName}Service {
  {ServiceName}ServiceImpl([IProductNetworkManager? networkManager])
      : _networkManager = networkManager ?? ProductNetworkManager.instance;

  final IProductNetworkManager _networkManager;

  // Implement methods
}
```

### 3.3 Create Integration Test
File: `test/product/service/{service_name}_service_test.dart`

```dart
import 'package:flight_booking/product/network/product_network_manager.dart';
import 'package:flight_booking/product/service/{service_name}_service.dart';
import 'package:flight_booking/product/service/impl/{service_name}_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late I{ServiceName}Service service;

  setUpAll(() {
    ProductNetworkManager.reset();
    ProductNetworkManager.setup(baseUrl: 'http://localhost:8080');
    service = {ServiceName}ServiceImpl();
  });

  group('{ServiceName} Integration Tests', () {
    // Add tests
  });
}
```

---

## Action: ENDPOINT

Add endpoint to existing service.

### 4.1 Update NetworkPaths
Add to `lib/product/network/network_constants.dart`:
```dart
static const String {pathName} = '/{path}';
```

### 4.2 Update Service Interface
Add method to interface.

### 4.3 Update Service Implementation
Add method implementation.

### 4.4 Add Test Cases
Add success and error test cases.

---

## Code Style Rules

1. **All classes are `final class`**
2. **All constructors are `const`**
3. **Use `@JsonSerializable()` for all models**
4. **Implement `INetworkModel<T>` for vexana compatibility**
5. **Extend `Equatable` for value comparison**
6. **Service constructors: nullable network manager with default**
7. **Use `NetworkResult.fold()` pattern for responses**
8. **Import package paths, not relative paths**

---

## Checklist After Generation

- [ ] `flutter pub get` executed
- [ ] `flutter pub run build_runner build` executed
- [ ] `flutter analyze` passes
- [ ] Generated `.g.dart` files exist
- [ ] Tests compile (backend required to run)
