import 'dart:math';

import 'package:flight_booking/product/util/idempotency/idempotency_key_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SecureIdempotencyKeyGenerator', () {
    test('generates 32 lowercase hex chars (128 bits)', () {
      final key = SecureIdempotencyKeyGenerator().generate();
      expect(key, hasLength(32));
      expect(key, matches(RegExp(r'^[0-9a-f]{32}$')));
    });

    test('two calls give different keys', () {
      final generator = SecureIdempotencyKeyGenerator();
      expect(generator.generate(), isNot(generator.generate()));
    });

    test('uses the injected Random', () {
      final a = SecureIdempotencyKeyGenerator(random: Random(42)).generate();
      final b = SecureIdempotencyKeyGenerator(random: Random(42)).generate();
      expect(a, b);
      expect(a, matches(RegExp(r'^[0-9a-f]{32}$')));
    });
  });
}
