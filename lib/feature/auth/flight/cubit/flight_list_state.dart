import 'package:equatable/equatable.dart';
import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';

final class FlightListState extends Equatable {
  const FlightListState({
    this.isLoading = false,
    this.errorMessage = '',
    this.flights = const [],
  });

  final bool isLoading;
  final String errorMessage;
  final List<FlightModel> flights;

  FlightListState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<FlightModel>? flights,
  }) {
    return FlightListState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      flights: flights ?? this.flights,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, flights];
}
