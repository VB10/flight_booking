# Network & Service Layer Generator Prompt

Bu prompt'u kullanarak projene vexana tabanlı network ve service katmanı ekleyebilirsin.

> **Bu repoda (v14'ten beri):** modeller feature klasörlerinde değil; tüm request/response/error/cache
> modelleri freezed ile `module/gen` paketinde yaşar (`package:gen/gen.dart`). Ayrıntı:
> [codegen_and_localization.md](../codegen_and_localization.md). Prompt aşağıda güncel yerleşimi anlatır
> (v8 ilk kurulumundaki `error_model.dart` / `lib/feature/**/model` / Equatable artık yok).

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
│   ├── network_constants.dart      # Base URL, timeout, endpoint paths, idempotencyKeyHeader
│   ├── network_manager.dart        # IProductNetworkManager (sendRequest + per-request headers)
│   └── product_network_manager.dart # Vexana implementation (static instance)
├── service/
│   ├── {service_name}_service.dart # Interface (abstract interface class)
│   └── impl/
│       └── {service_name}_service_impl.dart # Implementation
└── util/idempotency/
    └── idempotency_key_generator.dart # IIdempotencyKeyGenerator (yalnızca yan etkili POST için)

module/gen/                          # yerel paket: tüm modeller
├── build.yaml
├── pubspec.yaml
├── lib/gen.dart                     # barrel: tek public giriş
├── lib/src/model/
│   ├── request/{name}_request_model.dart
│   ├── response/{name}_response_model.dart
│   ├── error/product_error_model.dart # ProductErrorModel + ErrorCodes
│   └── cache/
└── test/                            # model round-trip / toJson testleri

test/product/service/
├── {service_name}_service_test.dart             # Integration (backend gerekir)
└── {service_name}_service_idempotency_test.dart # Unit (capturing fake, backend yok)

Gereksinimler:
1. Uygulama pubspec.yaml'a ekle:
   - vexana: ^5.0.3
   - gen: path: module/gen
   (freezed_annotation, json_annotation, freezed, json_serializable, build_runner
   module/gen/pubspec.yaml'da durur; uygulamada json_serializable/equatable yok)

2. Network Manager:
   - Static singleton instance pattern
   - ProductNetworkManager.setup(baseUrl: 'xxx') ile initialize
   - ProductNetworkManager.instance ile erişim
   - Token yönetimi: setAuthToken(), clearAuthToken(), isAuthenticated
   - sendRequest(..., Map<String, String>? headers): sadece o isteğe giden header
     (paylaşılan base header'a yazma, singleton'da yarış olur)

3. Service'ler:
   - Constructor'da nullable network manager, default static instance
   - Örnek: AuthServiceImpl([IProductNetworkManager? networkManager])
   - Request MODEL alır, body: request.toJson() gönderir; ham `body: {...}` map yok
   - Ödeme/rezervasyon gibi yan etkili POST: `required String idempotencyKey`,
     NetworkConstants.idempotencyKeyHeader ile `headers:` içinde gider.
     Anahtarı IIdempotencyKeyGenerator üretir; ömrü ödeme niyetinin sahibindedir
     (örnek: CartCubit.ensureCheckoutKey). Backend Idempotency-Key header'ını desteklemeli.

4. Model'ler (module/gen):
   - @freezed abstract class, part 'x.freezed.dart' + 'x.g.dart'
   - Response: `with _$X implements INetworkModel<X>`, `const X._()`, factory fromJson,
     `@override X fromJson(json) => X.fromJson(json)`
   - Request: freezed + fromJson, INetworkModel yok
   - Equatable yok; Cubit state'leri model değildir, cubit'iyle birlikte kalır
   - lib/gen.dart barrel'ına export ekle

5. Error Model (module/gen/lib/src/model/error/):
   - ProductErrorModel: @Default(false) success, message, errorCode, details
   - ErrorCodes: invalidCredentials, unauthorized, notFound, serverError

6. module/gen/build.yaml oluştur:
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

7. Codegen: ./scripts/generate.sh --models (module/gen'i build eder)

Kullanım örnekleri:

// main.dart
ProductNetworkManager.setup(baseUrl: 'https://api.example.com');

// Service kullanımı
final authService = AuthServiceImpl();
final result = await authService.login(
  const LoginRequestModel(email: 'x', password: 'y'),
);

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
Bu JSON için model oluştur: {JSON}   (yön: response | request)

Hedef dosya:
  module/gen/lib/src/model/response/{model_name}_response_model.dart
  module/gen/lib/src/model/request/{model_name}_request_model.dart

Kurallar:
1. @freezed abstract class; part '{file}.freezed.dart' ve part '{file}.g.dart'
2. const factory X({...}) = _X;  factory X.fromJson -> _$XFromJson(json)
3. Response: `implements INetworkModel<X>` + `const X._()` + `@override X fromJson(json) => X.fromJson(json)`
4. Request: INetworkModel yok, `const X._()` yok
5. Equatable yok (== / copyWith freezed'den)
6. İç içe objeler için ayrı freezed class (aynı dosyada)
7. module/gen/lib/gen.dart barrel'ına export ekle
8. ./scripts/generate.sh --models çalıştır
9. module/gen/test/ altına round-trip (response) veya toJson (request) testi ekle

Örnek çıktı (response):

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
    required {DataModel} data,
    required String message,
  }) = _{ModelName}ResponseModel;

  const {ModelName}ResponseModel._();

  factory {ModelName}ResponseModel.fromJson(Map<String, dynamic> json) =>
      _${ModelName}ResponseModelFromJson(json);

  @override
  {ModelName}ResponseModel fromJson(Map<String, dynamic> json) =>
      {ModelName}ResponseModel.fromJson(json);
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
  Future<NetworkResult<{ResponseModel}, ProductErrorModel>> {methodName}(
    {RequestModel} request, {
    required String idempotencyKey, // sadece yan etkili POST'ta
  });
}

Implementation örneği:
final class {ServiceName}ServiceImpl implements I{ServiceName}Service {
  {ServiceName}ServiceImpl([IProductNetworkManager? networkManager])
      : _networkManager = networkManager ?? ProductNetworkManager.instance;

  final IProductNetworkManager _networkManager;

  @override
  Future<NetworkResult<{ResponseModel}, ProductErrorModel>> {methodName}(
    {RequestModel} request, {
    required String idempotencyKey,
  }) {
    return _networkManager.sendRequest<{ResponseModel}, {ResponseModel}>(
      NetworkPaths.{pathConstant},
      parseModel: const {ResponseModel}(...),
      method: RequestType.{METHOD},
      headers: {NetworkConstants.idempotencyKeyHeader: idempotencyKey},
      body: request.toJson(),
    );
  }
}
```

---

## TEST GENERATION PROMPT

```
Bu service için integration test oluştur: {SERVICE_NAME}

Test dosyaları:
- Unit (backend yok): test/product/service/{service_name}_service_idempotency_test.dart
  IProductNetworkManager'ı taklit eden capturing fake (lastPath/lastHeaders/lastBody;
  `noSuchMethod` -> UnimplementedError); path, headers ve body (request.toJson()) assert et
- Integration (backend çalışmalı): test/product/service/{service_name}_service_test.dart
  Yan etkili POST'larda her çalıştırmada BENZERSİZ idempotency key kullan
  (sabit key ilk sonucu replay eder, test hiçbir şey ölçmez)
- Model testleri: module/gen/test/ (round-trip / toJson)

Integration test yapısı:
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

- [ ] pubspec.yaml güncellendi (vexana, gen: path: module/gen)
- [ ] network_constants.dart oluşturuldu (idempotencyKeyHeader dahil)
- [ ] network_manager.dart (interface, per-request headers) oluşturuldu
- [ ] product_network_manager.dart (static instance) oluşturuldu
- [ ] module/gen paketi: build.yaml, lib/gen.dart barrel, ProductErrorModel
- [ ] Request/response model'ler freezed ile module/gen'de, barrel'dan export
- [ ] Service interface'leri request model alıyor, `request.toJson()` gönderiyor
- [ ] Yan etkili POST'lar idempotencyKey alıyor (backend header'ı destekliyor)
- [ ] Service implementation'ları oluşturuldu
- [ ] `flutter pub get` çalıştırıldı
- [ ] `./scripts/generate.sh --models` çalıştırıldı
- [ ] module/gen model testleri + service unit testi (capturing fake) yazıldı
- [ ] Integration test'ler yazıldı (benzersiz idempotency key)
- [ ] `flutter analyze` hatasız geçti
