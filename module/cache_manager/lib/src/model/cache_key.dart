import 'package:equatable/equatable.dart';

/// A typed cache entry key.
///
/// Whether a value needs the critical-key fallback is no longer a property of
/// the key — that decision is made by the caller by choosing to also write it
/// to the standalone `IFallbackStore`. A [CacheKey] is just a named slot.
final class CacheKey extends Equatable {
  const CacheKey(this.name);

  /// Raw storage key used in the underlying backend.
  final String name;

  @override
  String toString() => name;

  @override
  List<Object?> get props => [name];
}
