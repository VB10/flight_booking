import 'dart:math';

/// Produces idempotency keys for non-repeatable requests (any POST).
///
/// An idempotency key identifies one *intent* — e.g. "pay for this cart" —
/// not one HTTP call. The client creates it once per intent and sends the
/// SAME key on every retry of that intent (timeout, lost response, reopened
/// page), in the `Idempotency-Key` header. The server stores the first
/// result under the key and replays it for later calls with that key, so a
/// retry can never book or charge twice. A new intent gets a new key.
///
/// Deciding *when* a key is reused belongs to the caller (see `CartCubit`);
/// this seam only creates fresh, unguessable ones.
abstract interface class IIdempotencyKeyGenerator {
  /// A new, unique key. Every call returns a different value.
  String generate();
}

/// 128 random bits from a cryptographically secure source, as 32 lowercase
/// hex characters.
final class SecureIdempotencyKeyGenerator implements IIdempotencyKeyGenerator {
  /// [random] is for tests only; production uses `Random.secure()`.
  SecureIdempotencyKeyGenerator({Random? random})
    : _random = random ?? Random.secure();

  static const int _byteLength = 16;

  final Random _random;

  @override
  String generate() => List.generate(
    _byteLength,
    (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}
