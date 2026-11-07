import 'package:equatable/equatable.dart';
import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';

/// Client-side ordering of the flight list.
enum FlightSort {
  none,
  price,
  departure;

  /// none → price → departure → none.
  FlightSort get next =>
      FlightSort.values[(index + 1) % FlightSort.values.length];
}

final class FlightListState extends Equatable {
  const FlightListState({
    this.isLoading = false,
    this.errorMessage = '',
    this.flights = const [],
    this.query = '',
    this.selectedDate,
    this.sort = FlightSort.none,
  });

  final bool isLoading;
  final String errorMessage;
  final List<FlightModel> flights;
  final String query;
  final String? selectedDate;
  final FlightSort sort;

  bool get hasError => !isLoading && errorMessage.isNotEmpty;

  bool get hasActiveFilters =>
      query.trim().isNotEmpty ||
      selectedDate != null ||
      sort != FlightSort.none;

  /// Distinct flight dates (ISO strings sort chronologically).
  List<String> get availableDates =>
      (flights.map((f) => f.date).toSet().toList()..sort());

  /// [flights] after search, date filter and sort.
  List<FlightModel> get visibleFlights {
    final needle = query.trim().toLowerCase();
    final result = flights.where((f) {
      if (selectedDate != null && f.date != selectedDate) return false;
      if (needle.isEmpty) return true;
      return f.from.toLowerCase().contains(needle) ||
          f.to.toLowerCase().contains(needle) ||
          f.airline.toLowerCase().contains(needle);
    }).toList();
    switch (sort) {
      case FlightSort.none:
        break;
      case FlightSort.price:
        result.sort((a, b) => a.price.compareTo(b.price));
      case FlightSort.departure:
        result.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    }
    return result;
  }

  FlightListState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<FlightModel>? flights,
    String? query,
    String? selectedDate,
    bool clearSelectedDate = false,
    FlightSort? sort,
  }) {
    return FlightListState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      flights: flights ?? this.flights,
      query: query ?? this.query,
      selectedDate: clearSelectedDate
          ? null
          : (selectedDate ?? this.selectedDate),
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    flights,
    query,
    selectedDate,
    sort,
  ];
}
