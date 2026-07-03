/// Model-capable Hive cache (fully encapsulated) + a standalone critical-key
/// fallback store (SharedPreferences). Models are stored as JSON via
/// `CacheModel` — no Hive types leak to consumers.
library;

export 'src/fallback/i_fallback_store.dart';
export 'src/fallback/shared_prefs_fallback_store.dart';
export 'src/i_cache_manager.dart';
export 'src/model/cache_key.dart';
export 'src/model/cache_model.dart';
export 'src/product_cache_manager.dart';
export 'src/strategy/hive_cache_strategy.dart';
export 'src/strategy/i_cache_strategy.dart';
