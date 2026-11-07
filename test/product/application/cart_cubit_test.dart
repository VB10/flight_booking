import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flight_booking/product/application/cart/cart_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

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

void main() {
  late CartCubit cubit;

  setUp(() => cubit = CartCubit());
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
}
