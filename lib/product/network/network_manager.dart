import 'package:flight_booking/product/network/error_model.dart';
import 'package:vexana/vexana.dart';

/// Abstract interface for network operations
/// This allows for easy testing and mocking
abstract interface class IProductNetworkManager {
  /// Send a network request using sealed NetworkResult pattern
  ///
  /// - [T] is the model type that implements INetworkModel
  /// - [R] is the expected return type (can be T or List of T)
  /// - [path] is the API endpoint path
  /// - [parseModel] is instance of the model for JSON parsing
  /// - [method] is HTTP method (GET, POST, PUT, DELETE, etc.)
  /// - [body] is optional request body (for POST/PUT)
  Future<NetworkResult<R, ProductErrorModel>> sendRequest<
      T extends INetworkModel<T>, R>(
    String path, {
    required T parseModel,
    required RequestType method,
    dynamic body,
  });

  /// Set authentication token for all subsequent requests
  ///
  /// Call this after successful login
  void setAuthToken(String token);

  /// Remove authentication token (for logout)
  void clearAuthToken();

  /// Check if user is authenticated (has token)
  bool get isAuthenticated;

  /// Add a header to all requests
  void addBaseHeader(MapEntry<String, String> header);

  /// Remove a specific header
  void removeHeader(String key);

  /// Clear all custom headers
  void clearHeaders();
}
