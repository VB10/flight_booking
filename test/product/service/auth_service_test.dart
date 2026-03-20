import 'package:flight_booking/product/network/error_model.dart';
import 'package:flight_booking/product/network/product_network_manager.dart';
import 'package:flight_booking/product/service/auth_service.dart';
import 'package:flight_booking/product/service/impl/auth_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';

/// Integration tests for AuthService
///
/// Requires backend to be running: dart run backend/bin/server.dart
void main() {
  late IAuthService authService;

  setUpAll(() {
    ProductNetworkManager.reset();
    ProductNetworkManager.setup(baseUrl: 'http://localhost:8080');
    authService = AuthServiceImpl();
  });

  group('AuthService Integration Tests', () {
    test('login with valid credentials should succeed and set token', () async {
      // Verify not authenticated before login
      expect(ProductNetworkManager.instance.isAuthenticated, isFalse);

      final result = await authService.login(
        email: 'user@test.com',
        password: '123456',
      );

      result.fold(
        onSuccess: (response) {
          expect(response.success, isTrue);
          expect(response.token, isNotEmpty);
          expect(response.token, equals('fake_token_12345'));
          expect(response.user.email, equals('user@test.com'));
          expect(response.user.name, equals('Test User'));
          expect(response.message, equals('Login successful'));

          // Set token after successful login
          ProductNetworkManager.instance.setAuthToken(response.token);
          expect(ProductNetworkManager.instance.isAuthenticated, isTrue);
        },
        onError: (error) {
          fail('Expected success but got error: ${error.description}');
        },
      );
    });

    test('login with invalid credentials should fail with ProductErrorModel',
        () async {
      final result = await authService.login(
        email: 'wrong@test.com',
        password: 'wrongpassword',
      );

      result.fold(
        onSuccess: (_) {
          fail('Expected error but got success');
        },
        onError: (error) {
          expect(error.statusCode, equals(400));
          // Check ProductErrorModel fields
          expect(error.model, isA<ProductErrorModel>());
          expect(error.model?.message, equals('Email veya şifre hatalı!'));
          expect(error.model?.errorCode, equals(ErrorCodes.invalidCredentials));
        },
      );
    });

    test('login with empty credentials should fail', () async {
      final result = await authService.login(
        email: '',
        password: '',
      );

      result.fold(
        onSuccess: (_) {
          fail('Expected error but got success');
        },
        onError: (error) {
          expect(error.statusCode, equals(400));
          expect(error.model?.errorCode, equals(ErrorCodes.invalidCredentials));
        },
      );
    });

    test('getProfile should return user data', () async {
      final result = await authService.getProfile();

      result.fold(
        onSuccess: (response) {
          expect(response.success, isTrue);
          expect(response.data.email, equals('user@test.com'));
          expect(response.data.name, equals('Test User'));
          expect(response.data.membershipLevel, equals('Silver'));
          expect(response.data.totalBookings, equals(5));
          expect(response.message, equals('Profile retrieved successfully'));
        },
        onError: (error) {
          fail('Expected success but got error: ${error.description}');
        },
      );
    });

    test('clearAuthToken should remove authentication', () async {
      // First login and set token
      ProductNetworkManager.instance.setAuthToken('test_token');
      expect(ProductNetworkManager.instance.isAuthenticated, isTrue);

      // Clear token (logout)
      ProductNetworkManager.instance.clearAuthToken();
      expect(ProductNetworkManager.instance.isAuthenticated, isFalse);
    });
  });
}
