/// Low-level cache backend contract.
///
/// A strategy knows how to persist values in one concrete store (Hive,
/// in-memory, ...). It handles primitives and — for backends that support it
/// (Hive) — whole objects/models. Policy such as the critical-key fallback
/// lives OUTSIDE this pattern (see `IFallbackStore`), not here.
abstract interface class ICacheStrategy {
  /// Prepare the backend (open box). Idempotent.
  Future<void> init();

  Future<void> writeString(String key, String value);
  Future<void> writeInt(String key, int value);
  Future<void> writeBool(String key, bool value);

  /// Persist a whole object/model. Requires a registered Hive adapter for
  /// custom types (primitives, `Map`, `List` work out of the box).
  Future<void> writeObject(String key, Object value);

  String? readString(String key);
  int? readInt(String key);
  bool? readBool(String key);

  /// Read a stored object/model as [T], or `null` if absent / wrong type.
  T? readObject<T>(String key);

  Future<void> remove(String key);

  /// Clear every entry owned by this backend.
  Future<void> clear();
}
