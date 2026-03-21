# Network & Service Layer Generator Prompt

Bu prompt'u kullanarak projene vexana tabanlı network ve service katmanı ekleyebilirsin.

---

## PROMPT

```
Projeme network ve service katmanı ekle.

Backend endpoint bilgileri:
- Base URL: {BASE_URL}
- Endpoints: {ENDPOINT_LISTESI}

Hedef yapı:
lib/product/
├── network/
│   ├── network_constants.dart      # Base URL, timeout, endpoint paths
│   ├── network_manager.dart        # IProductNetworkManager interface
│   ├── product_network_manager.dart # Vexana implementation (static instance)
│   └── error_model.dart            # ProductErrorModel + ErrorCodes
├── service/
│   ├── {service_name}_service.dart # Interface (abstract interface class)
│   └── impl/
│       └── {service_name}_service_impl.dart # Implementation

test/product/service/
└── {service_name}_service_test.dart # Integration tests

Gereksinimler:
1. pubspec.yaml'a ekle:
   - vexana: ^5.0.3
   - json_annotation: ^4.9.0 (dependencies)
   - json_serializable: ^6.9.0 (dev_dependencies)

2. Network Manager:
   - Static singleton instance pattern
   - ProductNetworkManager.setup(baseUrl: 'xxx') ile initialize
   - ProductNetworkManager.instance ile erişim
   - Token yönetimi: setAuthToken(), clearAuthToken(), isAuthenticated

3. Service'ler:
   - Constructor'da nullable network manager, default static instance
   - Örnek: AuthServiceImpl([IProductNetworkManager? networkManager])

4. Model'ler:
   - @JsonSerializable() annotation
   - INetworkModel<T> implement et
   - Equatable extend et
   - part 'xxx.g.dart' ekle

5. Error Model:
   - ProductErrorModel: success, message, errorCode, details
   - ErrorCodes: invalidCredentials, unauthorized, notFound, serverError

6. build.yaml oluştur (sadece model dosyalarında generation):
   targets:
     $default:
       builders:
         json_serializable:
           generate_for:
             include:
               - lib/feature/**/model/*.dart
               - lib/feature/**/*_response_model.dart
               - lib/product/network/error_model.dart

7. scripts/build_runner.sh oluştur

Kullanım örnekleri:

// main.dart
ProductNetworkManager.setup(baseUrl: 'https://api.example.com');

// Service kullanımı
final authService = AuthServiceImpl();
final result = await authService.login(email: 'x', password: 'y');

result.fold(
  onSuccess: (response) {
    ProductNetworkManager.instance.setAuthToken(response.token);
  },
  onError: (error) {
    print(error.model?.message);
  },
);

// Test için mock injection
final mockManager = MockNetworkManager();
final authService = AuthServiceImpl(mockManager);
```

---

## MODEL GENERATION PROMPT

```
Bu JSON response için model oluştur: {JSON_RESPONSE}

Hedef dosya: lib/feature/{path}/model/{model_name}_response_model.dart

Kurallar:
1. @JsonSerializable() annotation
2. INetworkModel<T> implement et
3. Equatable extend et
4. part '{filename}.g.dart' ekle
5. const constructor
6. factory fromJson -> _$ModelFromJson(json)
7. toJson -> _$ModelToJson(this)
8. İç içe objeler için ayrı class (aynı dosyada)

Örnek çıktı:

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
  final {DataModel} data;
  final String message;

  @override
  {ModelName}ResponseModel fromJson(Map<String, dynamic> json) =>
      {ModelName}ResponseModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() => _${ModelName}ResponseModelToJson(this);

  @override
  List<Object?> get props => [success, data, message];
}
```

---

## SERVICE GENERATION PROMPT

```
Bu endpoint için service oluştur:
- Endpoint: {ENDPOINT}
- Method: {GET/POST/PUT/DELETE}
- Request Body: {REQUEST_JSON}
- Response Model: {RESPONSE_MODEL_NAME}

Hedef dosyalar:
1. lib/product/service/{service_name}_service.dart (interface)
2. lib/product/service/impl/{service_name}_service_impl.dart (implementation)
3. test/product/service/{service_name}_service_test.dart (integration test)

Interface örneği:
abstract interface class I{ServiceName}Service {
  Future<NetworkResult<{ResponseModel}, ProductErrorModel>> {methodName}({params});
}

Implementation örneği:
final class {ServiceName}ServiceImpl implements I{ServiceName}Service {
  {ServiceName}ServiceImpl([IProductNetworkManager? networkManager])
      : _networkManager = networkManager ?? ProductNetworkManager.instance;

  final IProductNetworkManager _networkManager;

  @override
  Future<NetworkResult<{ResponseModel}, ProductErrorModel>> {methodName}({params}) {
    return _networkManager.sendRequest<{ResponseModel}, {ResponseModel}>(
      NetworkPaths.{pathConstant},
      parseModel: const {ResponseModel}(...),
      method: RequestType.{METHOD},
      body: {...},
    );
  }
}
```

---

## TEST GENERATION PROMPT

```
Bu service için integration test oluştur: {SERVICE_NAME}

Test dosyası: test/product/service/{service_name}_service_test.dart

Test yapısı:
- setUpAll: ProductNetworkManager.reset() + setup(baseUrl)
- Her endpoint için success ve error case test et
- NetworkResult.fold pattern kullan

Örnek:
void main() {
  late I{ServiceName}Service service;

  setUpAll(() {
    ProductNetworkManager.reset();
    ProductNetworkManager.setup(baseUrl: 'http://localhost:8080');
    service = {ServiceName}ServiceImpl();
  });

  group('{ServiceName} Integration Tests', () {
    test('{methodName} should return success', () async {
      final result = await service.{methodName}(...);

      result.fold(
        onSuccess: (response) {
          expect(response.success, isTrue);
          // field assertions
        },
        onError: (error) {
          fail('Expected success but got error: \${error.description}');
        },
      );
    });

    test('{methodName} should fail with invalid data', () async {
      final result = await service.{methodName}(...);

      result.fold(
        onSuccess: (_) => fail('Expected error'),
        onError: (error) {
          expect(error.statusCode, equals(400));
          expect(error.model?.errorCode, equals(ErrorCodes.xxx));
        },
      );
    });
  });
}
```

---

## CHECKLIST

- [ ] pubspec.yaml güncellendi (vexana, json_annotation, json_serializable)
- [ ] network_constants.dart oluşturuldu
- [ ] network_manager.dart (interface) oluşturuldu
- [ ] product_network_manager.dart (static instance) oluşturuldu
- [ ] error_model.dart oluşturuldu
- [ ] Service interface'leri oluşturuldu
- [ ] Service implementation'ları oluşturuldu
- [ ] Model'ler @JsonSerializable ile güncellendi
- [ ] build.yaml oluşturuldu
- [ ] scripts/build_runner.sh oluşturuldu
- [ ] `flutter pub get` çalıştırıldı
- [ ] `flutter pub run build_runner build` çalıştırıldı
- [ ] Integration test'ler yazıldı
- [ ] `flutter analyze` hatasız geçti
