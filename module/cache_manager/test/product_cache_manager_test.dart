import 'package:cache_manager/cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory [ICacheStrategy] fake — no Hive needed for manager-level tests.
final class FakeCacheStrategy implements ICacheStrategy {
  final Map<String, Object?> store = <String, Object?>{};

  @override
  Future<void> init() async {}

  @override
  Future<void> writeString(String key, String value) async =>
      store[key] = value;

  @override
  Future<void> writeInt(String key, int value) async => store[key] = value;

  @override
  Future<void> writeBool(String key, bool value) async => store[key] = value;

  @override
  Future<void> writeObject(String key, Object value) async =>
      store[key] = value;

  @override
  String? readString(String key) => store[key] as String?;

  @override
  int? readInt(String key) => store[key] as int?;

  @override
  bool? readBool(String key) => store[key] as bool?;

  @override
  T? readObject<T>(String key) {
    final value = store[key];
    return value is T ? value : null;
  }

  @override
  Future<void> remove(String key) async => store.remove(key);

  @override
  Future<void> clear() async => store.clear();
}

/// A pure model implementing the [CacheModel] contract — no Hive.
final class _Session implements CacheModel {
  const _Session(this.token, this.userId);

  factory _Session.fromJson(Map<String, dynamic> json) =>
      _Session(json['token'] as String, json['userId'] as int);

  final String token;
  final int userId;

  @override
  Map<String, dynamic> toJson() => {'token': token, 'userId': userId};
}

void main() {
  const key = CacheKey('session');
  const tokenKey = CacheKey('token');

  late FakeCacheStrategy strategy;
  late ProductCacheManager manager;

  setUp(() {
    strategy = FakeCacheStrategy();
    manager = ProductCacheManager(strategy: strategy);
  });

  group('ProductCacheManager primitives', () {
    test('round-trips string / int / bool through the strategy', () async {
      await manager.writeString(tokenKey, 'abc');
      await manager.writeInt(const CacheKey('id'), 42);
      await manager.writeBool(const CacheKey('flag'), value: true);

      expect(manager.readString(tokenKey), 'abc');
      expect(manager.readInt(const CacheKey('id')), 42);
      expect(manager.readBool(const CacheKey('flag')), isTrue);
    });

    test('missing key returns null', () {
      expect(manager.readString(const CacheKey('nope')), isNull);
    });
  });

  group('ProductCacheManager models (JSON contract)', () {
    test('writeModel stores JSON and readModel rebuilds via fromJson', () async {
      await manager.writeModel(key, const _Session('t', 7));

      // Stored as a plain map — no Hive adapter involved.
      expect(strategy.store['session'], isA<Map<String, dynamic>>());

      final read = manager.readModel(key, fromJson: _Session.fromJson);
      expect(read, isNotNull);
      expect(read!.token, 't');
      expect(read.userId, 7);
    });

    test('readModel returns null for a missing key', () {
      expect(
        manager.readModel(key, fromJson: _Session.fromJson),
        isNull,
      );
    });
  });

  group('ProductCacheManager remove/clear', () {
    test('remove deletes a key', () async {
      await manager.writeString(tokenKey, 'abc');
      await manager.remove(tokenKey);
      expect(manager.readString(tokenKey), isNull);
    });

    test('clear wipes the backend', () async {
      await manager.writeString(tokenKey, 'abc');
      await manager.writeModel(key, const _Session('t', 7));
      await manager.clear();
      expect(strategy.store, isEmpty);
    });
  });
}
