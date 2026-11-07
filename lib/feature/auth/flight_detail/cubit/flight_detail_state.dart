import 'package:equatable/equatable.dart';
import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';

enum FlightDetailStatus { loading, content, error }

final class FlightDetailState extends Equatable {
  const FlightDetailState({
    this.status = FlightDetailStatus.loading,
    this.flight,
  });

  final FlightDetailStatus status;
  final FlightModel? flight;

  bool get isContent => status == FlightDetailStatus.content && flight != null;

  FlightDetailState copyWith({
    FlightDetailStatus? status,
    FlightModel? flight,
  }) {
    return FlightDetailState(
      status: status ?? this.status,
      flight: flight ?? this.flight,
    );
  }

  @override
  List<Object?> get props => [status, flight];
}
