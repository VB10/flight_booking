import 'package:cache_manager/src/fallback/i_fallback_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [IFallbackStore] backed by [SharedPreferences].
///
/// Holds a few critical string keys (the auth token) so a Hive failure never
/// loses the session. A ready `preferences` instance can be injected for tests.
final class SharedPrefsFallbackStore implements IFallbackStore {
  SharedPrefsFallbackStore({SharedPreferences? preferences})
      : _prefs = preferences;

  SharedPreferences? _prefs;

  SharedPreferences get _requirePrefs {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError(
        'SharedPrefsFallbackStore.init() must be called before use.',
      );
    }
    return prefs;
  }

  @override
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<void> write(String key, String value) =>
      _requirePrefs.setString(key, value);

  @override
  String? read(String key) => _requirePrefs.getString(key);

  @override
  Future<void> remove(String key) => _requirePrefs.remove(key);

  @override
  Future<void> clear() async {
    await _requirePrefs.clear();
  }
}
