import 'package:cache_manager/cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gen/gen.dart';
import 'package:vexana/vexana.dart';

Map<String, dynamic> _flightJson({int id = 1, bool withOptional = true}) => {
  'id': id,
  'airline': 'Turkish Airlines',
  'from': 'Istanbul',
  'to': 'Ankara',
  'departureTime': '08:00',
  'arrivalTime': '09:10',
  'price': 1250,
  'duration': '1h 10m',
  'date': '2026-11-20',
  if (withOptional) ...{
    'fromCode': 'IST',
    'toCode': 'ESB',
    'flightNumber': 'TK2120',
    'aircraftType': 'A321',
    'seatClass': 'Economy',
    'baggageAllowance': '20kg',
  },
};

/// fromJson -> toJson -> fromJson must give back an equal object, and the
/// re-encoded JSON must be identical to the input.
void _expectRoundTrip<T>(
  Map<String, dynamic> json,
  T Function(Map<String, dynamic>) fromJson,
  Map<String, dynamic> Function(T) toJson,
) {
  final first = fromJson(json);
  final encoded = toJson(first);
  final second = fromJson(encoded);
  expect(second, equals(first));
  expect(second.hashCode, equals(first.hashCode));
  expect(encoded, equals(json));
}

void main() {
  group('FlightModel', () {
    test('round-trips with all optional fields', () {
      _expectRoundTrip(
        _flightJson(),
        FlightModel.fromJson,
        (m) => m.toJson(),
      );
    });

    test('round-trips without optional fields and omits nulls', () {
      final model = FlightModel.fromJson(_flightJson(withOptional: false));
      expect(model.fromCode, isNull);
      expect(model.toJson().containsKey('fromCode'), isFalse);
      _expectRoundTrip(
        _flightJson(withOptional: false),
        FlightModel.fromJson,
        (m) => m.toJson(),
      );
    });

    test('has value equality and is an INetworkModel', () {
      final a = FlightModel.fromJson(_flightJson());
      final b = FlightModel.fromJson(_flightJson());
      expect(a, equals(b));
      expect(a, isNot(equals(FlightModel.fromJson(_flightJson(id: 2)))));
      expect(a, isA<INetworkModel<FlightModel>>());
      expect(a.fromJson(_flightJson()), equals(a));
    });
  });

  group('FlightsResponseModel', () {
    final json = {
      'success': true,
      'data': [_flightJson(), _flightJson(id: 2, withOptional: false)],
      'message': 'ok',
    };

    test('round-trips with a nested FlightModel list', () {
      _expectRoundTrip(json, FlightsResponseModel.fromJson, (m) => m.toJson());
    });

    test('serializes nested flights to plain maps', () {
      final encoded = FlightsResponseModel.fromJson(json).toJson();
      expect(encoded['data'], isA<List<dynamic>>());
      expect((encoded['data'] as List).first, isA<Map<String, dynamic>>());
    });

    test('parses data into FlightModel', () {
      final model = FlightsResponseModel.fromJson(json);
      expect(model.data, hasLength(2));
      expect(model.data.first.fromCode, 'IST');
    });
  });

  group('CheckoutResponseModel', () {
    final base = {
      'success': true,
      'message': 'Booked',
      'orderId': 42,
      'totalPrice': 2500,
    };

    test('round-trips without bookingReference', () {
      final model = CheckoutResponseModel.fromJson(base);
      expect(model.bookingReference, isNull);
      expect(model.toJson().containsKey('bookingReference'), isFalse);
      _expectRoundTrip(base, CheckoutResponseModel.fromJson, (m) => m.toJson());
    });

    test('round-trips with bookingReference', () {
      final json = {...base, 'bookingReference': 'FB-7K2M9Q'};
      expect(
        CheckoutResponseModel.fromJson(json).bookingReference,
        'FB-7K2M9Q',
      );
      _expectRoundTrip(json, CheckoutResponseModel.fromJson, (m) => m.toJson());
    });
  });

  group('LoginResponseModel', () {
    final json = {
      'success': true,
      'message': 'Welcome',
      'token': 'abc.def',
      'user': {'id': 7, 'email': 'user@test.com', 'name': 'Test User'},
    };

    test('round-trips with a nested UserModel', () {
      _expectRoundTrip(json, LoginResponseModel.fromJson, (m) => m.toJson());
    });

    test('serializes nested user to a plain map', () {
      final model = LoginResponseModel.fromJson(json);
      expect(
        model.user,
        const UserModel(id: 7, email: 'user@test.com', name: 'Test User'),
      );
      expect(model.toJson()['user'], isA<Map<String, dynamic>>());
    });
  });

  group('ProfileResponseModel', () {
    final json = {
      'success': true,
      'data': {
        'id': 1,
        'email': 'user@test.com',
        'name': 'Test User',
        'joinDate': '2025-01-01',
        'totalBookings': 3,
        'membershipLevel': 'Gold',
      },
      'message': 'ok',
    };

    test('round-trips with nested ProfileData', () {
      _expectRoundTrip(json, ProfileResponseModel.fromJson, (m) => m.toJson());
      expect(
        ProfileResponseModel.fromJson(json).toJson()['data'],
        isA<Map<String, dynamic>>(),
      );
    });
  });

  group('ProductErrorModel', () {
    test('defaults success to false when absent', () {
      final model = ProductErrorModel.fromJson({'message': 'boom'});
      expect(model.success, isFalse);
      expect(const ProductErrorModel().success, isFalse);
    });

    test('round-trips with details', () {
      final json = {
        'success': false,
        'message': 'Invalid',
        'errorCode': ErrorCodes.invalidCredentials,
        'details': {'field': 'email'},
      };
      _expectRoundTrip(json, ProductErrorModel.fromJson, (m) => m.toJson());
    });

    test('is the vexana error model and keeps its toString', () {
      const model = ProductErrorModel(message: 'm', errorCode: 'C');
      expect(model, isA<INetworkModel<ProductErrorModel>>());
      expect(model.fromJson({'message': 'x'}).message, 'x');
      expect(model.toString(), 'ProductErrorModel(message: m, code: C)');
    });
  });

  group('AuthSessionCacheModel', () {
    final json = {
      'token': 't',
      'email': 'user@test.com',
      'name': 'Test User',
      'userId': 7,
    };

    test('round-trips and is a CacheModel', () {
      _expectRoundTrip(json, AuthSessionCacheModel.fromJson, (m) => m.toJson());
      expect(AuthSessionCacheModel.fromJson(json), isA<CacheModel>());
    });
  });
}
