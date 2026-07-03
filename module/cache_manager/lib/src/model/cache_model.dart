/// Contract every model persisted through `ICacheManager.writeModel` must obey.
///
/// Forces JSON serialization so the cache can store any model as a plain map
/// (no per-type Hive adapter, no typeId ceremony) and the same shape can be
/// mirrored elsewhere. The reverse — `fromJson` — is a factory and cannot be
/// forced by an interface, so it is passed to `readModel` by the caller.
///
/// Implementers in the app stay pure Dart (Equatable/immutable + a JSON
/// codec); they never depend on Hive.
abstract interface class CacheModel {
  Map<String, dynamic> toJson();
}
