import 'package:flight_booking/product/network/network_manager.dart';
import 'package:flight_booking/product/service/impl/flight_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';
import 'package:vexana/vexana.dart';

/// Captures what the service hands to the network layer; no server needed.
final class _CapturingNetwork implements IProductNetworkManager {
  Map<String, String>? lastHeaders;
  String? lastPath;
  dynamic lastBody;

  @override
  Future<NetworkResult<R, ProductErrorModel>>
  sendRequest<T extends INetworkModel<T>, R>(
    String path, {
    required T parseModel,
    required RequestType method,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    lastPath = path;
    lastHeaders = headers;
    lastBody = body;
    return const NetworkErrorResult(ErrorModel(description: 'captured'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

FlightModel _flight() => FlightModel.fromJson(const {
  'id': 1,
  'airline': 'Turkish Airlines',
  'from': 'Istanbul',
  'to': 'Ankara',
  'departureTime': '08:00',
  'arrivalTime': '09:10',
  'price': 1250,
  'duration': '1h 10m',
  'date': '2026-11-20',
});

void main() {
  test('checkout sends the key as the Idempotency-Key header', () async {
    final network = _CapturingNetwork();
    await FlightServiceImpl(network).checkout(
      CheckoutRequestModel(
        cartItems: const <FlightModel>[],
        userEmail: 'user@test.com',
      ),
      idempotencyKey: 'abc123',
    );
    expect(network.lastPath, '/checkout');
    expect(network.lastHeaders, {'Idempotency-Key': 'abc123'});
    expect(network.lastBody, {
      'cartItems': <Map<String, dynamic>>[],
      'userEmail': 'user@test.com',
    });
  });

  test('checkout body carries each cart flight as a plain map', () async {
    final network = _CapturingNetwork();
    final flight = _flight();
    await FlightServiceImpl(network).checkout(
      CheckoutRequestModel(
        cartItems: [flight],
        userEmail: 'user@test.com',
      ),
      idempotencyKey: 'abc123',
    );
    expect(network.lastBody, {
      'cartItems': [flight.toJson()],
      'userEmail': 'user@test.com',
    });
  });
}
