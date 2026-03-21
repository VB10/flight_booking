import 'package:flight_booking/feature/auth/cart/checkout_response_model.dart';
import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flight_booking/product/network/error_model.dart';
import 'package:flight_booking/product/network/network_constants.dart';
import 'package:flight_booking/product/network/network_manager.dart';
import 'package:flight_booking/product/network/product_network_manager.dart';
import 'package:flight_booking/product/service/flight_service.dart';
import 'package:vexana/vexana.dart';

/// Concrete implementation of flight service
final class FlightServiceImpl implements IFlightService {
  FlightServiceImpl([IProductNetworkManager? networkManager])
    : _networkManager = networkManager ?? ProductNetworkManager.instance;

  final IProductNetworkManager _networkManager;

  @override
  Future<NetworkResult<FlightsResponseModel, ProductErrorModel>> getFlights() {
    return _networkManager
        .sendRequest<FlightsResponseModel, FlightsResponseModel>(
          NetworkPaths.flights,
          parseModel: const FlightsResponseModel(
            success: false,
            data: [],
            message: '',
          ),
          method: RequestType.GET,
        );
  }

  @override
  Future<NetworkResult<CheckoutResponseModel, ProductErrorModel>> checkout({
    required List<FlightModel> cartItems,
    required String userEmail,
  }) {
    return _networkManager
        .sendRequest<CheckoutResponseModel, CheckoutResponseModel>(
          NetworkPaths.checkout,
          parseModel: const CheckoutResponseModel(
            success: false,
            message: '',
            orderId: 0,
            totalPrice: 0,
          ),
          method: RequestType.POST,

          /// TODO: Request paramater
          body: {
            'cartItems': cartItems.map((item) => item.toJson()).toList(),
            'userEmail': userEmail,
          },
        );
  }
}
