import 'package:cache_manager/cache_manager.dart';

/// Keys for the main cache ([ICacheManager]).
abstract final class ProductCacheKeys {
  /// The whole auth session, stored as an `AuthSessionCacheModel` (JSON).
  static const CacheKey session = CacheKey('auth_session');

  /// Selected language code (`tr` / `en`). The app persists it itself instead
  /// of letting the localization package keep its own copy.
  static const CacheKey locale = CacheKey('app_locale');
}

/// Keys for the standalone fallback store ([IFallbackStore]).
///
/// Only a few critical primitives live here as a safety net if Hive fails.
abstract final class FallbackKeys {
  static const String token = 'user_token';
}
