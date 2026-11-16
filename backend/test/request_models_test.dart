import 'package:flight_booking_server/model/checkout_request.dart';
import 'package:flight_booking_server/model/login_request.dart';
import 'package:test/test.dart';

void main() {
  group('LoginRequest.fromJson', () {
    test('reads email and password', () {
      final r = LoginRequest.fromJson({'email': 'a@b.com', 'password': 'x'});
      expect(r.email, 'a@b.com');
      expect(r.password, 'x');
    });

    test('missing keys default to empty strings', () {
      final r = LoginRequest.fromJson({});
      expect(r.email, '');
      expect(r.password, '');
    });
  });

  group('CheckoutRequest.fromJson', () {
    test('reads cart items, email and computes total price', () {
      final r = CheckoutRequest.fromJson({
        'cartItems': [
          {'id': 1, 'price': 650},
        ],
        'userEmail': 'u@t.com',
      });
      expect(r.cartItems, hasLength(1));
      expect(r.userEmail, 'u@t.com');
      expect(r.totalPrice, 650);
    });

    test('total price sums every item', () {
      final r = CheckoutRequest.fromJson({
        'cartItems': [
          {'id': 1, 'price': 650},
          {'id': 2, 'price': 499},
        ],
      });
      expect(r.totalPrice, 1149);
    });

    test('missing userEmail defaults to unknown@test.com', () {
      final r = CheckoutRequest.fromJson({
        'cartItems': [
          {'id': 1, 'price': 650},
        ],
      });
      expect(r.userEmail, 'unknown@test.com');
    });

    test('missing cartItems gives an empty list and total 0', () {
      final r = CheckoutRequest.fromJson({'userEmail': 'u@t.com'});
      expect(r.cartItems, isEmpty);
      expect(r.totalPrice, 0);
    });
  });
}
