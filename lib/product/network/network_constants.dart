/// Network configuration constants
final class NetworkConstants {
  const NetworkConstants._();

  /// Base URL for the API
  /// Default: localhost:8080 for development
  static const String baseUrl = 'http://localhost:8080';

  /// Connection timeout duration
  static const Duration connectTimeout = Duration(seconds: 30);

  /// Receive timeout duration
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Send timeout duration
  static const Duration sendTimeout = Duration(seconds: 30);
}

/// API endpoint paths
final class NetworkPaths {
  const NetworkPaths._();

  static const String login = '/login';
  static const String flights = '/flights';
  static const String checkout = '/checkout';
  static const String profile = '/profile';
  static const String health = '/health';
}
