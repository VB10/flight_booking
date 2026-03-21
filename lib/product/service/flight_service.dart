import 'package:flight_booking/feature/auth/cart/checkout_response_model.dart';
import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flight_booking/product/network/error_model.dart';
import 'package:vexana/vexana.dart';

/// Abstract interface for flight-related operations
abstract interface class IFlightService {
  /// Get all available flights
  Future<NetworkResult<FlightsResponseModel, ProductErrorModel>> getFlights();

  /// Checkout with cart items
  Future<NetworkResult<CheckoutResponseModel, ProductErrorModel>> checkout({
    required List<FlightModel> cartItems,
    required String userEmail,
  });
}
