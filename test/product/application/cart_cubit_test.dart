import 'package:flight_booking/product/application/cart/cart_cubit.dart';
import 'package:flight_booking/product/util/idempotency/idempotency_key_generator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';

FlightModel _flight(int id, int price) => FlightModel(
  id: id,
  airline: 'Skyline Air',
  from: 'Istanbul',
  to: 'Ankara',
  departureTime: '08:30',
  arrivalTime: '09:45',
  price: price,
  duration: '1h 15m',
  date: '2026-12-12',
);

/// Hands out 'k1', 'k2', … so tests can assert exact keys and count calls.
final class _SequentialKeyGenerator implements IIdempotencyKeyGenerator {
  int calls = 0;

  @override
  String generate() => 'k${++calls}';
}

void main() {
  late _SequentialKeyGenerator keys;
  late CartCubit cubit;

  setUp(() {
    keys = _SequentialKeyGenerator();
    cubit = CartCubit(keys);
  });
  tearDown(() => cubit.close());

  test('add accumulates items, count and total', () {
    cubit
      ..add(_flight(1, 650))
      ..add(_flight(2, 499));
    expect(cubit.state.count, 2);
    expect(cubit.state.totalPrice, 1149);
  });

  test('removeAt + restore puts the item back at the same index', () {
    cubit
      ..add(_flight(1, 650))
      ..add(_flight(2, 499))
      ..add(_flight(3, 720));
    final removed = cubit.removeAt(1);
    expect(removed?.id, 2);
    expect(cubit.state.items.map((f) => f.id), [1, 3]);
    cubit.restore(1, removed!);
    expect(cubit.state.items.map((f) => f.id), [1, 2, 3]);
  });

  test('removeAt ignores an invalid index', () {
    expect(cubit.removeAt(0), isNull);
    expect(cubit.state.isEmpty, isTrue);
  });

  test('clear empties the cart', () {
    cubit
      ..add(_flight(1, 650))
      ..clear();
    expect(cubit.state.isEmpty, isTrue);
  });

  group('checkout key', () {
    test('is generated lazily, not on cart changes', () {
      cubit
        ..add(_flight(1, 650))
        ..add(_flight(2, 499));
      expect(keys.calls, 0);
    });

    test('is stable until the cart changes', () {
      cubit.add(_flight(1, 650));
      expect(cubit.ensureCheckoutKey(), 'k1');
      expect(cubit.ensureCheckoutKey(), 'k1');
      expect(keys.calls, 1);
    });

    test('add, removeAt, restore and clear reset it', () {
      cubit.add(_flight(1, 650));
      expect(cubit.ensureCheckoutKey(), 'k1');

      cubit.add(_flight(2, 499));
      expect(cubit.ensureCheckoutKey(), 'k2');

      final removed = cubit.removeAt(0)!;
      expect(cubit.ensureCheckoutKey(), 'k3');

      cubit.restore(0, removed);
      expect(cubit.ensureCheckoutKey(), 'k4');

      cubit.clear();
      expect(cubit.ensureCheckoutKey(), 'k5');
      expect(cubit.ensureCheckoutKey(), 'k5');
      expect(keys.calls, 5);
    });

    test('an invalid removeAt keeps the key', () {
      cubit.add(_flight(1, 650));
      expect(cubit.ensureCheckoutKey(), 'k1');
      expect(cubit.removeAt(5), isNull);
      expect(cubit.ensureCheckoutKey(), 'k1');
    });

    test('defaults to a secure 128-bit hex key', () {
      final real = CartCubit();
      addTearDown(real.close);
      expect(real.ensureCheckoutKey(), matches(RegExp(r'^[0-9a-f]{32}$')));
    });
  });
}
