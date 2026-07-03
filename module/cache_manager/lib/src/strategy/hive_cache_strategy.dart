import 'package:cache_manager/src/strategy/i_cache_strategy.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

/// Primary [ICacheStrategy] backed by a single Hive box.
///
/// Fully encapsulates Hive: [init] runs `Hive.initFlutter()` then opens the
/// box, so the app never imports Hive. Models are stored as plain JSON maps, so
/// no adapters are needed. In tests, inject an already-open `box` (via
/// `Hive.init(tempDir)`) so [init] skips the Flutter-only initialization.
final class HiveCacheStrategy implements ICacheStrategy {
  HiveCacheStrategy({this.boxName = defaultBoxName, Box<dynamic>? box})
      : _box = box;

  static const String defaultBoxName = 'product_cache';

  final String boxName;
  Box<dynamic>? _box;

  Box<dynamic> get _requireBox {
    final box = _box;
    if (box == null || !box.isOpen) {
      throw StateError('HiveCacheStrategy.init() must be called before use.');
    }
    return box;
  }

  @override
  Future<void> init() async {
    if (_box != null && _box!.isOpen) return;
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(boxName);
  }

  @override
  Future<void> writeString(String key, String value) =>
      _requireBox.put(key, value);

  @override
  Future<void> writeInt(String key, int value) => _requireBox.put(key, value);

  @override
  Future<void> writeBool(String key, bool value) => _requireBox.put(key, value);

  @override
  Future<void> writeObject(String key, Object value) =>
      _requireBox.put(key, value);

  @override
  String? readString(String key) {
    final value = _requireBox.get(key);
    return value is String ? value : null;
  }

  @override
  int? readInt(String key) {
    final value = _requireBox.get(key);
    return value is int ? value : null;
  }

  @override
  bool? readBool(String key) {
    final value = _requireBox.get(key);
    return value is bool ? value : null;
  }

  @override
  T? readObject<T>(String key) {
    final value = _requireBox.get(key);
    return value is T ? value : null;
  }

  @override
  Future<void> remove(String key) => _requireBox.delete(key);

  @override
  Future<void> clear() async {
    await _requireBox.clear();
  }
}
