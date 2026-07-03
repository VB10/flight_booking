import 'package:cache_manager/cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPrefsFallbackStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = SharedPrefsFallbackStore();
    await store.init();
  });

  group('SharedPrefsFallbackStore', () {
    test('writes and reads a critical string', () async {
      await store.write('user_token', 'abc123');
      expect(store.read('user_token'), 'abc123');
    });

    test('missing key returns null', () {
      expect(store.read('missing'), isNull);
    });

    test('remove deletes a key', () async {
      await store.write('user_token', 'abc');
      await store.remove('user_token');
      expect(store.read('user_token'), isNull);
    });

    test('clear wipes everything', () async {
      await store.write('a', '1');
      await store.write('b', '2');
      await store.clear();
      expect(store.read('a'), isNull);
      expect(store.read('b'), isNull);
    });

    test('throws before init', () {
      final fresh = SharedPrefsFallbackStore();
      expect(() => fresh.read('x'), throwsStateError);
    });
  });
}
