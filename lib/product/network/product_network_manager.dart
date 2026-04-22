import 'dart:io';

import 'package:flight_booking/product/network/error_model.dart';
import 'package:flight_booking/product/network/network_constants.dart';
import 'package:flight_booking/product/network/network_manager.dart';
import 'package:vexana/vexana.dart';

/// Concrete implementation of network manager using Vexana
///
/// Features:
/// - Global error handling with [ProductErrorModel]
/// - Token-based authentication header management
/// - Configurable base URL for different environments
/// - Static singleton instance for easy access
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

  /// Singleton instance of the network manager
  ///
  /// Call [setup] before accessing this to configure base URL
  static ProductNetworkManager get instance {
    _instance ??= ProductNetworkManager._();
    return _instance!;
  }

  /// Initialize network manager with custom base URL
  ///
  /// Call this in main.dart before runApp():
  /// ```dart
  /// ProductNetworkManager.setup(baseUrl: 'https://api.example.com');
  /// ```
  static void setup({String? baseUrl}) {
    _instance = ProductNetworkManager._(baseUrl: baseUrl);
  }

  /// Reset instance for testing purposes
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

  /// Set authentication token for all subsequent requests
  ///
  /// Call this after successful login:
  /// ```dart
  /// ProductNetworkManager.instance.setAuthToken(loginResponse.token);
  /// ```
  @override
  void setAuthToken(String token) {
    _networkManager.addBaseHeader(
      MapEntry(HttpHeaders.authorizationHeader, 'Bearer $token'),
    );
  }

  /// Remove authentication token (for logout)
  @override
  void clearAuthToken() {
    _networkManager.removeHeader(HttpHeaders.authorizationHeader);
  }

  /// Check if user is authenticated (has token)
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
