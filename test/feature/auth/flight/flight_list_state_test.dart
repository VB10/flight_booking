import 'package:flight_booking/feature/auth/flight/cubit/flight_list_state.dart';
import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

FlightModel _f(
  int id,
  String airline,
  String from,
  String to,
  int price,
  String dep,
  String date,
) => FlightModel(
  id: id,
  airline: airline,
  from: from,
  to: to,
  departureTime: dep,
  arrivalTime: '23:59',
  price: price,
  duration: '1h',
  date: date,
);

final List<FlightModel> _flights = [
  _f(1, 'Skyline Air', 'Istanbul', 'Ankara', 650, '08:30', '2026-12-12'),
  _f(2, 'Nordwind', 'Istanbul', 'Izmir', 499, '10:30', '2026-12-12'),
  _f(3, 'Azure Jet', 'Ankara', 'Antalya', 720, '07:15', '2026-12-13'),
];

List<int> _ids(FlightListState s) => s.visibleFlights.map((f) => f.id).toList();

void main() {
  const base = FlightListState();
  final state = base.copyWith(flights: _flights);

  test('no filters keeps backend order', () {
    expect(_ids(state), [1, 2, 3]);
    expect(state.hasActiveFilters, isFalse);
  });

  test('search matches city or airline, case-insensitive', () {
    expect(_ids(state.copyWith(query: 'ankara')), [1, 3]);
    expect(_ids(state.copyWith(query: '  NORD ')), [2]);
  });

  test('date filter and distinct sorted dates', () {
    expect(state.availableDates, ['2026-12-12', '2026-12-13']);
    expect(_ids(state.copyWith(selectedDate: '2026-12-13')), [3]);
  });

  test('sort by price and by departure', () {
    expect(_ids(state.copyWith(sort: FlightSort.price)), [2, 1, 3]);
    expect(_ids(state.copyWith(sort: FlightSort.departure)), [3, 1, 2]);
  });

  test('sort cycles none → price → departure → none', () {
    expect(FlightSort.none.next, FlightSort.price);
    expect(FlightSort.departure.next, FlightSort.none);
  });
}
