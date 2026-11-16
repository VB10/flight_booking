import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flight_booking/product/network/error_model.dart';
import 'package:flight_booking/product/network/network_manager.dart';
import 'package:flight_booking/product/service/impl/flight_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vexana/vexana.dart';

/// Captures what the service hands to the network layer; no server needed.
final class _CapturingNetwork implements IProductNetworkManager {
  Map<String, String>? lastHeaders;
  String? lastPath;

  @override
  Future<NetworkResult<R, ProductErrorModel>> sendRequest<
    T extends INetworkModel<T>,
    R
  >(
    String path, {
    required T parseModel,
    required RequestType method,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    lastPath = path;
    lastHeaders = headers;
    return const NetworkErrorResult(ErrorModel(description: 'captured'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  test('checkout sends the key as the Idempotency-Key header', () async {
    final network = _CapturingNetwork();
    await FlightServiceImpl(network).checkout(
      cartItems: const <FlightModel>[],
      userEmail: 'user@test.com',
      idempotencyKey: 'abc123',
    );
    expect(network.lastPath, '/checkout');
    expect(network.lastHeaders, {'Idempotency-Key': 'abc123'});
  });
}
