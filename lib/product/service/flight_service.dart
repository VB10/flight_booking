import 'package:gen/gen.dart';
import 'package:vexana/vexana.dart';

/// Abstract interface for flight-related operations
abstract interface class IFlightService {
  /// Get all available flights
  Future<NetworkResult<FlightsResponseModel, ProductErrorModel>> getFlights();

  /// Checkout with cart items. [idempotencyKey] makes a retry of the same
  /// payment safe: the server replays the first order instead of a new one.
  Future<NetworkResult<CheckoutResponseModel, ProductErrorModel>> checkout(
    CheckoutRequestModel request, {
    required String idempotencyKey,
  });
}
