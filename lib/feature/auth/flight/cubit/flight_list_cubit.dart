import 'package:flight_booking/feature/auth/flight/cubit/flight_list_state.dart';
import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flight_booking/product/service/flight_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class FlightListCubit extends Cubit<FlightListState> {
  FlightListCubit(this._flightService)
    : super(const FlightListState(isLoading: true));

  final IFlightService _flightService;

  Future<void> loadFlights() async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));
    final result = await _flightService.getFlights();
    if (isClosed) return;
    result.fold(
      onSuccess: (FlightsResponseModel response) {
        if (response.success) {
          emit(
            state.copyWith(
              isLoading: false,
              flights: response.data,
              errorMessage: '',
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: response.message,
            ),
          );
        }
      },
      onError: (error) {
        emit(
          state.copyWith(
            isLoading: false,
            // The page shows the localized `flight_error_message`; this is
            // only the "has error" flag plus the technical detail.
            errorMessage: error.description ?? 'network_error',
          ),
        );
      },
    );
  }

  void setQuery(String query) => emit(state.copyWith(query: query));

  /// Selecting the active date again clears the filter.
  void toggleDate(String date) => emit(
    state.selectedDate == date
        ? state.copyWith(clearSelectedDate: true)
        : state.copyWith(selectedDate: date),
  );

  void cycleSort() => emit(state.copyWith(sort: state.sort.next));

  void clearFilters() => emit(
    state.copyWith(query: '', clearSelectedDate: true, sort: FlightSort.none),
  );
}
