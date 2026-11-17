import 'dart:async';

import 'package:cache_manager/cache_manager.dart';
import 'package:flight_booking/feature/auth/cart/cubit/cart_checkout_cubit.dart';
import 'package:flight_booking/feature/auth/cart/cubit/cart_checkout_state.dart';
import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/application/cart/cart_cubit.dart';
import 'package:flight_booking/product/network/network_manager.dart';
import 'package:flight_booking/product/service/flight_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';
import 'package:vexana/vexana.dart';

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

/// Checkout completes when the test completes [gate].
final class _FakeFlightService implements IFlightService {
  final Completer<NetworkResult<CheckoutResponseModel, ProductErrorModel>>
  gate = Completer();
  int checkoutCalls = 0;
  final List<String> keys = [];

  @override
  Future<NetworkResult<CheckoutResponseModel, ProductErrorModel>> checkout(
    CheckoutRequestModel request, {
    required String idempotencyKey,
  }) {
    checkoutCalls++;
    keys.add(idempotencyKey);
    return gate.future;
  }

  @override
  Future<NetworkResult<FlightsResponseModel, ProductErrorModel>> getFlights() =>
      throw UnimplementedError();
}

/// AuthCubit's dependencies are never touched here — only `state.email`.
final class _UnusedCache implements ICacheManager {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

final class _UnusedFallback implements IFallbackStore {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

final class _UnusedNetwork implements IProductNetworkManager {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

const _ok = CheckoutResponseModel(
  success: true,
  message: 'ok',
  orderId: 1,
  totalPrice: 1149,
  bookingReference: 'FB-7K2M9Q',
);

void main() {
  late _FakeFlightService service;
  late CartCubit cart;
  late AuthCubit auth;

  setUp(() {
    service = _FakeFlightService();
    cart = CartCubit()
      ..add(_flight(1, 650))
      ..add(_flight(2, 499));
    auth = AuthCubit(_UnusedNetwork(), _UnusedCache(), _UnusedFallback());
  });

  test(
    'success clears the cart and keeps the paid items + reference',
    () async {
      final cubit = CartCheckoutCubit(service, cart, auth);
      final paying = cubit.pay();
      expect(cubit.state.isProcessing, isTrue);
      service.gate.complete(const NetworkSuccessResult(_ok));
      await paying;
      expect(cubit.state.status, CartCheckoutStatus.success);
      expect(cubit.state.paidItems, hasLength(2));
      expect(cubit.state.response?.bookingReference, 'FB-7K2M9Q');
      expect(cart.state.isEmpty, isTrue);
    },
  );

  test('a second pay while processing does not call checkout again', () async {
    final cubit = CartCheckoutCubit(service, cart, auth);
    final first = cubit.pay();
    await cubit.pay();
    service.gate.complete(const NetworkSuccessResult(_ok));
    await first;
    expect(service.checkoutCalls, 1);
  });

  test('page closed mid-payment: cart still cleared, no StateError', () async {
    final cubit = CartCheckoutCubit(service, cart, auth);
    final paying = cubit.pay();
    await cubit.close();
    service.gate.complete(const NetworkSuccessResult(_ok));
    await expectLater(paying, completes);
    expect(cart.state.isEmpty, isTrue);
  });

  test(
    'transport error keeps the cart and shows the localized message',
    () async {
      final cubit = CartCheckoutCubit(service, cart, auth);
      final paying = cubit.pay();
      service.gate.complete(
        const NetworkErrorResult(ErrorModel(description: 'Connection refused')),
      );
      await paying;
      expect(cubit.state.status, CartCheckoutStatus.error);
      expect(cubit.state.errorMessage, isEmpty);
      expect(cart.state.count, 2);
    },
  );

  group('idempotency key', () {
    // Transport error first (server may have committed), then success.
    Future<void> failThenRetry(CartCheckoutCubit cubit) async {
      final first = cubit.pay();
      service.gate.complete(
        const NetworkErrorResult(ErrorModel(description: 'timeout')),
      );
      await first;
    }

    test('retry after an error sends the SAME key', () async {
      final cubit = CartCheckoutCubit(service, cart, auth);
      await failThenRetry(cubit);
      await cubit.pay(); // the error state IS the retry button
      expect(service.keys, hasLength(2));
      expect(service.keys.first, isNotEmpty);
      expect(service.keys[1], service.keys.first);
    });

    test('a reopened page (new cubit, same cart) reuses the key', () async {
      final first = CartCheckoutCubit(service, cart, auth);
      await failThenRetry(first);
      final second = CartCheckoutCubit(service, cart, auth);
      final retry = second.pay();
      await retry;
      expect(service.keys, hasLength(2));
      expect(service.keys.first, isNotEmpty);
      expect(service.keys[1], service.keys.first);
    });

    test(
      'success clears the cart, so the next payment gets a new key',
      () async {
        final cubit = CartCheckoutCubit(service, cart, auth);
        final paying = cubit.pay();
        service.gate.complete(const NetworkSuccessResult(_ok));
        await paying;
        final used = service.keys.single;
        cart.add(_flight(3, 720));
        expect(cart.ensureCheckoutKey(), isNot(used));
      },
    );
  });
}
