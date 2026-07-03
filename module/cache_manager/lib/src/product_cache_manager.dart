import 'package:cache_manager/src/i_cache_manager.dart';
import 'package:cache_manager/src/model/cache_key.dart';
import 'package:cache_manager/src/model/cache_model.dart';
import 'package:cache_manager/src/strategy/i_cache_strategy.dart';

/// Default [ICacheManager]: a single Hive-backed [ICacheStrategy].
///
/// Models are stored as JSON maps, so no Hive adapters are required. The
/// critical-key fallback lives outside this class in an `IFallbackStore`.
final class ProductCacheManager implements ICacheManager {
  ProductCacheManager({required ICacheStrategy strategy}) : _strategy = strategy;

  final ICacheStrategy _strategy;

  @override
  Future<void> init() => _strategy.init();

  @override
  Future<void> writeString(CacheKey key, String value) =>
      _strategy.writeString(key.name, value);

  @override
  Future<void> writeInt(CacheKey key, int value) =>
      _strategy.writeInt(key.name, value);

  @override
  Future<void> writeBool(CacheKey key, {required bool value}) =>
      _strategy.writeBool(key.name, value);

  @override
  Future<void> writeModel<T extends CacheModel>(CacheKey key, T value) =>
      _strategy.writeObject(key.name, value.toJson());

  @override
  String? readString(CacheKey key) => _strategy.readString(key.name);

  @override
  int? readInt(CacheKey key) => _strategy.readInt(key.name);

  @override
  bool? readBool(CacheKey key) => _strategy.readBool(key.name);

  @override
  T? readModel<T>(
    CacheKey key, {
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    final raw = _strategy.readObject<Map<dynamic, dynamic>>(key.name);
    if (raw == null) return null;
    return fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<void> remove(CacheKey key) => _strategy.remove(key.name);

  @override
  Future<void> clear() => _strategy.clear();
}
