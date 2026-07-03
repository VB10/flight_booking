import 'package:cache_manager/cache_manager.dart';

/// App-wide cache holder.
///
/// Owns two independent stores:
/// - [manager] — the main, model-capable cache (`ICacheManager`, Hive-backed
///   inside the package; the app imports no Hive).
/// - [fallback] — a small SharedPreferences store for a few critical keys
///   (the auth token), kept outside the cache strategy as a safety net.
///
/// Access them only after [init] has completed once.
final class ProductCache {
  ProductCache._();

  static final ProductCache instance = ProductCache._();

  final ICacheManager _manager = ProductCacheManager(
    strategy: HiveCacheStrategy(),
  );

  final IFallbackStore _fallback = SharedPrefsFallbackStore();

  bool _initialized = false;

  ICacheManager get manager => _manager;

  IFallbackStore get fallback => _fallback;

  /// Initialize both backends (the manager sets up Hive internally).
  /// Idempotent; call once at app start before `ProductContainer.setup`.
  Future<void> init() async {
    if (_initialized) return;
    await _manager.init();
    await _fallback.init();
    _initialized = true;
  }
}
