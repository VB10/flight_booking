import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flight_booking/product/network/product_network_manager.dart';
import 'package:flight_booking/product/service/flight_service.dart';
import 'package:flight_booking/product/service/impl/flight_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';

/// Integration tests for FlightService
///
/// Requires backend to be running: dart run backend/bin/server.dart
void main() {
  late IFlightService flightService;

  setUpAll(() {
    ProductNetworkManager.reset();
    ProductNetworkManager.setup(baseUrl: 'http://localhost:8080');
    flightService = FlightServiceImpl();
  });

  group('FlightService Integration Tests', () {
    test('getFlights should return flight list', () async {
      final result = await flightService.getFlights();

      result.fold(
        onSuccess: (response) {
          expect(response.success, isTrue);
          expect(response.data, isNotEmpty);
          expect(response.data.first.airline, isNotEmpty);
          expect(response.data.first.id, greaterThan(0));
          expect(response.data.first.price, greaterThan(0));
          expect(response.message, equals('Flights retrieved successfully'));
        },
        onError: (error) {
          fail('Expected success but got error: ${error.description}');
        },
      );
    });

    test('checkout should complete order successfully', () async {
      final cartItems = [
        const FlightModel(
          id: 1,
          airline: 'Turkish Airlines',
          from: 'Istanbul',
          to: 'Ankara',
          departureTime: '08:00',
          arrivalTime: '09:30',
          price: 299,
          duration: '1h 30m',
          date: '2024-01-15',
        ),
      ];

      final result = await flightService.checkout(
        cartItems: cartItems,
        userEmail: 'user@test.com',
      );

      result.fold(
        onSuccess: (response) {
          expect(response.success, isTrue);
          expect(response.orderId, greaterThan(0));
          expect(response.totalPrice, equals(299));
          expect(response.message, contains('başarılı'));
        },
        onError: (error) {
          fail('Expected success but got error: ${error.description}');
        },
      );
    });

    test('checkout with multiple items should calculate total', () async {
      final cartItems = [
        const FlightModel(
          id: 1,
          airline: 'Turkish Airlines',
          from: 'Istanbul',
          to: 'Ankara',
          departureTime: '08:00',
          arrivalTime: '09:30',
          price: 299,
          duration: '1h 30m',
          date: '2024-01-15',
        ),
        const FlightModel(
          id: 2,
          airline: 'Pegasus',
          from: 'Istanbul',
          to: 'Izmir',
          departureTime: '10:30',
          arrivalTime: '11:45',
          price: 199,
          duration: '1h 15m',
          date: '2024-01-15',
        ),
      ];

      final result = await flightService.checkout(
        cartItems: cartItems,
        userEmail: 'user@test.com',
      );

      result.fold(
        onSuccess: (response) {
          expect(response.success, isTrue);
          expect(response.totalPrice, equals(498)); // 299 + 199
        },
        onError: (error) {
          fail('Expected success but got error: ${error.description}');
        },
      );
    });
  });
}
