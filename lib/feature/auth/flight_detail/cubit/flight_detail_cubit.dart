import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flight_booking/feature/auth/flight_detail/cubit/flight_detail_state.dart';
import 'package:flight_booking/product/service/flight_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows content at once when the flight came with the route, otherwise
/// fetches the list and picks [flightId].
final class FlightDetailCubit extends Cubit<FlightDetailState> {
  FlightDetailCubit(
    this._flightService, {
    required this.flightId,
    FlightModel? flight,
  }) : super(
         flight == null
             ? const FlightDetailState()
             : FlightDetailState(
                 status: FlightDetailStatus.content,
                 flight: flight,
               ),
       );

  final IFlightService _flightService;
  final String flightId;

  Future<void> load() async {
    if (state.isContent) return;
    emit(const FlightDetailState());
    final id = int.tryParse(flightId);
    if (id == null) {
      emit(const FlightDetailState(status: FlightDetailStatus.error));
      return;
    }
    final result = await _flightService.getFlights();
    if (isClosed) return;
    result.fold(
      onSuccess: (FlightsResponseModel response) {
        final matches = response.data.where((f) => f.id == id);
        if (response.success && matches.isNotEmpty) {
          emit(
            FlightDetailState(
              status: FlightDetailStatus.content,
              flight: matches.first,
            ),
          );
        } else {
          emit(const FlightDetailState(status: FlightDetailStatus.error));
        }
      },
      onError: (_) =>
          emit(const FlightDetailState(status: FlightDetailStatus.error)),
    );
  }
}
