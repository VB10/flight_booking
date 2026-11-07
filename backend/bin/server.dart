import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// Hard coded data - kötü praktik!
List<Map<String, dynamic>> flights = [
  // Fictional airlines only (v13 design kit). fromCode, toCode, flightNumber,
  // aircraftType, seatClass and baggageAllowance are the design's NEW DATA.
  {
    'id': 1,
    'airline': 'Skyline Air',
    'from': 'Istanbul',
    'fromCode': 'IST',
    'to': 'Ankara',
    'toCode': 'ESB',
    'departureTime': '08:30',
    'arrivalTime': '09:45',
    'price': 650,
    'duration': '1h 15m',
    'date': '2026-12-12',
    'flightNumber': 'SK 1042',
    'aircraftType': 'Airbus A321neo',
    'seatClass': 'Economy',
    'baggageAllowance': '20 kg',
  },
  {
    'id': 2,
    'airline': 'Nordwind',
    'from': 'Istanbul',
    'fromCode': 'SAW',
    'to': 'Izmir',
    'toCode': 'ADB',
    'departureTime': '10:30',
    'arrivalTime': '11:45',
    'price': 499,
    'duration': '1h 15m',
    'date': '2026-12-12',
    'flightNumber': 'NW 318',
    'aircraftType': 'Boeing 737-800',
    'seatClass': 'Economy',
    'baggageAllowance': '15 kg',
  },
  {
    'id': 3,
    'airline': 'Azure Jet',
    'from': 'Ankara',
    'fromCode': 'ESB',
    'to': 'Antalya',
    'toCode': 'AYT',
    'departureTime': '14:00',
    'arrivalTime': '15:20',
    'price': 720,
    'duration': '1h 20m',
    'date': '2026-12-13',
    'flightNumber': 'AZ 77',
    'aircraftType': 'Airbus A320',
    'seatClass': 'Economy',
    'baggageAllowance': '20 kg',
  },
  {
    'id': 4,
    'airline': 'Skyline Air',
    'from': 'Istanbul',
    'fromCode': 'IST',
    'to': 'Trabzon',
    'toCode': 'TZX',
    'departureTime': '16:45',
    'arrivalTime': '18:15',
    'price': 890,
    'duration': '1h 30m',
    'date': '2026-12-13',
    'flightNumber': 'SK 2210',
    'aircraftType': 'Airbus A321neo',
    'seatClass': 'Business',
    'baggageAllowance': '30 kg',
  },
  {
    'id': 5,
    'airline': 'Nordwind',
    'from': 'Izmir',
    'fromCode': 'ADB',
    'to': 'Istanbul',
    'toCode': 'IST',
    'departureTime': '19:10',
    'arrivalTime': '20:25',
    'price': 560,
    'duration': '1h 15m',
    'date': '2026-12-14',
    'flightNumber': 'NW 905',
    'aircraftType': 'Boeing 737 MAX 8',
    'seatClass': 'Economy',
    'baggageAllowance': '15 kg',
  },
  {
    'id': 6,
    'airline': 'Azure Jet',
    'from': 'Antalya',
    'fromCode': 'AYT',
    'to': 'Ankara',
    'toCode': 'ESB',
    'departureTime': '07:15',
    'arrivalTime': '08:35',
    'price': 610,
    'duration': '1h 20m',
    'date': '2026-12-14',
    'flightNumber': 'AZ 12',
    'aircraftType': 'Airbus A320',
    'seatClass': 'Economy',
    'baggageAllowance': '20 kg',
  },
];

// Global değişken - kötü praktik!
List<Map<String, dynamic>> orders = [];

class FlightServer {
  final Router _router = Router();

  static const _jsonHeaders = {'Content-Type': 'application/json'};

  FlightServer() {
    _setupRoutes();
  }

  /// Standard error response format
  Response _errorResponse(
    int statusCode,
    String message,
    String errorCode, {
    Map<String, dynamic>? details,
  }) {
    return Response(
      statusCode,
      body: jsonEncode({
        'success': false,
        'message': message,
        'errorCode': errorCode,
        'details': details,
      }),
      headers: _jsonHeaders,
    );
  }

  void _setupRoutes() {
    // Login endpoint
    _router.post('/login', _loginHandler);

    // Flights endpoint
    _router.get('/flights', _flightsHandler);

    // Cart/Checkout endpoint
    _router.post('/checkout', _checkoutHandler);

    // Profile endpoint - fake
    _router.get('/profile', _profileHandler);

    // Health check
    _router.get('/health', (Request request) {
      return Response.ok(
        jsonEncode({'status': 'OK', 'message': 'Server is running'}),
        headers: _jsonHeaders,
      );
    });
  }

  // Kötü login logic - hiç güvenlik yok!
  Future<Response> _loginHandler(Request request) async {
    try {
      final bodyString = await request.readAsString();
      final Map<String, dynamic> body = jsonDecode(bodyString);

      String email = body['email'] ?? '';
      String password = body['password'] ?? '';

      // Hard coded credentials - kötü praktik!
      if (email == 'user@test.com' && password == '123456') {
        return Response.ok(
          jsonEncode({
            'success': true,
            'message': 'Login successful',
            'token': 'fake_token_12345', // Fake token
            'user': {'id': 1, 'email': email, 'name': 'Test User'},
          }),
          headers: _jsonHeaders,
        );
      } else {
        return _errorResponse(
          400,
          'Email veya şifre hatalı!',
          'INVALID_CREDENTIALS',
          details: {'field': 'email/password'},
        );
      }
    } catch (e) {
      return _errorResponse(
        500,
        'Server error: $e',
        'SERVER_ERROR',
      );
    }
  }

  Response _flightsHandler(Request request) {
    // Hiç authentication check yok - kötü praktik!
    try {
      return Response.ok(
        jsonEncode({
          'success': true,
          'data': flights,
          'message': 'Flights retrieved successfully',
        }),
        headers: _jsonHeaders,
      );
    } catch (e) {
      return _errorResponse(500, 'Server error: $e', 'SERVER_ERROR');
    }
  }

  Future<Response> _checkoutHandler(Request request) async {
    try {
      final bodyString = await request.readAsString();
      final Map<String, dynamic> body = jsonDecode(bodyString);

      List<dynamic> cartItems = body['cartItems'] ?? [];
      String userEmail = body['userEmail'] ?? 'unknown@test.com';

      // Basit toplam hesaplama
      int totalPrice = 0;
      for (var item in cartItems) {
        totalPrice += (item['price'] as int);
      }

      // Fake order oluştur
      final orderId = orders.length + 1;
      Map<String, dynamic> order = {
        'id': orderId,
        // NEW DATA (v13): human-readable booking reference, e.g. FB-7K2M9Q.
        'bookingReference': _bookingReference(orderId),
        'userEmail': userEmail,
        'items': cartItems,
        'totalPrice': totalPrice,
        'orderDate': DateTime.now().toIso8601String(),
        'status': 'confirmed',
      };

      orders.add(order);

      // Fake delay
      await Future.delayed(Duration(seconds: 1));

      return Response.ok(
        jsonEncode({
          'success': true,
          'message':
              'Ödeme başarılı! Biletleriniz e-posta adresinize gönderildi.',
          'orderId': order['id'],
          'bookingReference': order['bookingReference'],
          'totalPrice': totalPrice,
        }),
        headers: _jsonHeaders,
      );
    } catch (e) {
      return _errorResponse(500, 'Server error: $e', 'SERVER_ERROR');
    }
  }

  // Fake profile endpoint - gereksiz ama demo için
  Response _profileHandler(Request request) {
    try {
      // Hiç authentication check yok - kötü praktik!
      // Fake profile data döndür
      return Response.ok(
        jsonEncode({
          'success': true,
          'data': {
            'id': 1,
            'email': 'user@test.com',
            'name': 'Test User',
            'joinDate': '2024-01-01',
            'totalBookings': 5,
            'membershipLevel': 'Silver',
          },
          'message': 'Profile retrieved successfully',
        }),
        headers: _jsonHeaders,
      );
    } catch (e) {
      return _errorResponse(500, 'Server error: $e', 'SERVER_ERROR');
    }
  }

  Handler get handler {
    return Pipeline()
        .addMiddleware(corsHeaders())
        .addMiddleware(logRequests())
        .addHandler(_router);
  }
}

void main(List<String> args) async {
  final server = FlightServer();
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final handler = server.handler;

  final httpServer = await serve(handler, 'localhost', port);
  print('Server started on localhost:${httpServer.port}');
  print('Available endpoints:');
  print('POST http://localhost:${httpServer.port}/login');
  print('GET  http://localhost:${httpServer.port}/flights');
  print('POST http://localhost:${httpServer.port}/checkout');
  print('GET  http://localhost:${httpServer.port}/profile');
  print('GET  http://localhost:${httpServer.port}/health');
}

/// Deterministic-looking reference: "FB-" + 6 chars from the order id and time.
String _bookingReference(int orderId) {
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  var seed = DateTime.now().millisecondsSinceEpoch ^ (orderId * 7919);
  final buffer = StringBuffer('FB-');
  for (var i = 0; i < 6; i++) {
    buffer.write(alphabet[seed % alphabet.length]);
    seed = seed ~/ alphabet.length + orderId * 31 + i;
  }
  return buffer.toString();
}
