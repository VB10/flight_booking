import 'package:cache_manager/src/model/cache_key.dart';
import 'package:cache_manager/src/model/cache_model.dart';

/// App-facing cache contract, backed by Hive (fully encapsulated).
///
/// Handles primitives and whole models. Models are stored as plain JSON maps —
/// consumers implement [CacheModel] (`toJson`) and pass a `fromJson` factory to
/// [readModel]. No Hive types leak to callers. Critical primitive keys that
/// must survive a Hive problem live separately in an `IFallbackStore`.
abstract interface class ICacheManager {
  /// Initialize the underlying backend. Call once at app start.
  Future<void> init();

  Future<void> writeString(CacheKey key, String value);
  Future<void> writeInt(CacheKey key, int value);
  Future<void> writeBool(CacheKey key, {required bool value});

  /// Persist a whole model as JSON (via [CacheModel.toJson]).
  Future<void> writeModel<T extends CacheModel>(CacheKey key, T value);

  String? readString(CacheKey key);
  int? readInt(CacheKey key);
  bool? readBool(CacheKey key);

  /// Read a stored model, rebuilding it with [fromJson]. Returns `null` if the
  /// key is absent.
  T? readModel<T>(
    CacheKey key, {
    required T Function(Map<String, dynamic> json) fromJson,
  });

  Future<void> remove(CacheKey key);

  /// Wipe the cache (e.g. on logout).
  Future<void> clear();
}
