import 'dart:io';

import 'package:cache_manager/cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late HiveCacheStrategy strategy;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_cache_test');
    Hive.init(tempDir.path);
    // Inject an already-open box so init() skips Flutter-only initFlutter().
    final box = await Hive.openBox<dynamic>('test_box');
    strategy = HiveCacheStrategy(box: box);
    await strategy.init();
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk('test_box');
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('HiveCacheStrategy', () {
    test('writes and reads primitives', () async {
      await strategy.writeString('name', 'VB10');
      await strategy.writeInt('id', 7);
      await strategy.writeBool('flag', false);
      expect(strategy.readString('name'), 'VB10');
      expect(strategy.readInt('id'), 7);
      expect(strategy.readBool('flag'), isFalse);
    });

    test('writes and reads an object (Map, no adapter needed)', () async {
      final session = <String, dynamic>{'token': 'abc', 'userId': 42};
      await strategy.writeObject('session', session);

      final read = strategy.readObject<Map<dynamic, dynamic>>('session');
      expect(read, isNotNull);
      expect(read!['token'], 'abc');
      expect(read['userId'], 42);
    });

    test('type mismatch reads as null', () async {
      await strategy.writeInt('id', 7);
      expect(strategy.readString('id'), isNull);
      expect(strategy.readObject<Map<dynamic, dynamic>>('id'), isNull);
    });

    test('remove and clear', () async {
      await strategy.writeString('token', 'abc');
      await strategy.remove('token');
      expect(strategy.readString('token'), isNull);

      await strategy.writeString('a', '1');
      await strategy.clear();
      expect(strategy.readString('a'), isNull);
    });

    test('throws before init', () {
      final fresh = HiveCacheStrategy(boxName: 'never_opened');
      expect(() => fresh.readString('x'), throwsStateError);
    });
  });
}
