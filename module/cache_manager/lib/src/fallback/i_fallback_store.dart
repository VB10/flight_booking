/// A small, standalone store that lives OUTSIDE the cache strategy.
///
/// Its only job is to keep a handful of critical primitive keys (e.g. the auth
/// token) reliably, as a safety net if the main Hive cache is unavailable,
/// cleared, or corrupted. String-only by design — it is intentionally dumb.
///
/// This is deliberately not an `ICacheStrategy`: it is not part of the cache
/// pipeline, it is a separate redundancy layer the caller reaches for
/// explicitly for a few keys.
abstract interface class IFallbackStore {
  Future<void> init();

  Future<void> write(String key, String value);
  String? read(String key);

  Future<void> remove(String key);
  Future<void> clear();
}
