import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';

void main() {
  final flight = FlightModel.fromJson(const {
    'id': 1,
    'airline': 'Turkish Airlines',
    'from': 'Istanbul',
    'to': 'Ankara',
    'departureTime': '08:00',
    'arrivalTime': '09:10',
    'price': 1250,
    'duration': '1h 10m',
    'date': '2026-11-20',
  });

  group('CheckoutRequestModel', () {
    test('serializes cartItems as plain maps and userEmail as a string', () {
      final model = CheckoutRequestModel(
        cartItems: [flight],
        userEmail: 'u@t.com',
      );
      expect(model.toJson(), {
        'cartItems': [flight.toJson()],
        'userEmail': 'u@t.com',
      });
      expect(
        (model.toJson()['cartItems'] as List).first,
        isA<Map<String, dynamic>>(),
      );
    });

    test('round-trips through fromJson and toJson', () {
      final model = CheckoutRequestModel(
        cartItems: [flight],
        userEmail: 'u@t.com',
      );
      expect(CheckoutRequestModel.fromJson(model.toJson()), model);
    });
  });

  group('LoginRequestModel', () {
    test('serializes email and password', () {
      const model = LoginRequestModel(email: 'a@b.com', password: '123456');
      expect(model.toJson(), {'email': 'a@b.com', 'password': '123456'});
    });

    test('round-trips through fromJson and toJson', () {
      const model = LoginRequestModel(email: 'a@b.com', password: '123456');
      expect(LoginRequestModel.fromJson(model.toJson()), model);
    });
  });
}
