import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

// Hard coded data - kötü praktik!
List<Map<String, dynamic>> flights = [
  {
    'id': 1,
    'airline': 'Turkish Airlines',
    'from': 'Istanbul',
    'to': 'Ankara',
    'departureTime': '08:00',
    'arrivalTime': '09:30',
    'price': 299,
    'duration': '1h 30m',
    'date': '2024-01-15'
  },
  {
    'id': 2,
    'airline': 'Pegasus',
    'from': 'Istanbul',
    'to': 'Izmir',
    'departureTime': '10:30',
    'arrivalTime': '11:45',
    'price': 199,
    'duration': '1h 15m',
    'date': '2024-01-15'
  },
  {
    'id': 3,
    'airline': 'AnadoluJet',
    'from': 'Ankara',
    'to': 'Antalya',
    'departureTime': '14:00',
    'arrivalTime': '15:30',
    'price': 349,
    'duration': '1h 30m',
    'date': '2024-01-16'
  },
  {
    'id': 4,
    'airline': 'Turkish Airlines',
    'from': 'Istanbul',
    'to': 'Trabzon',
    'departureTime': '16:45',
    'arrivalTime': '18:15',
    'price': 399,
    'duration': '1h 30m',
    'date': '2024-01-16'
  },
];

// Global değişken - kötü praktik!
List<Map<String, dynamic>> orders = [];

class FlightServer {
  final Router _router = Router();

  FlightServer() {
    _setupRoutes();
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
      return Response.ok(jsonEncode({'status': 'OK', 'message': 'Server is running'}));
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
            'user': {
              'id': 1,
              'email': email,
              'name': 'Test User'
            }
          }),
        );
      } else {
        return Response(400, 
          body: jsonEncode({
            'success': false,
            'message': 'Email veya şifre hatalı!'
          }),
        );
      }
    } catch (e) {
      return Response(500,
        body: jsonEncode({
          'success': false,
          'message': 'Server error: $e'
        }),
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
          'message': 'Flights retrieved successfully'
        }),
      );
    } catch (e) {
      return Response(500,
        body: jsonEncode({
          'success': false,
          'message': 'Server error: $e'
        }),
      );
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
      Map<String, dynamic> order = {
        'id': orders.length + 1,
        'userEmail': userEmail,
        'items': cartItems,
        'totalPrice': totalPrice,
        'orderDate': DateTime.now().toIso8601String(),
        'status': 'confirmed'
      };
      
      orders.add(order);
      
      // Fake delay
      await Future.delayed(Duration(seconds: 1));
      
      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'Ödeme başarılı! Biletleriniz e-posta adresinize gönderildi.',
          'orderId': order['id'],
          'totalPrice': totalPrice
        }),
      );
    } catch (e) {
      return Response(500,
        body: jsonEncode({
          'success': false,
          'message': 'Server error: $e'
        }),
      );
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
            'membershipLevel': 'Silver'
          },
          'message': 'Profile retrieved successfully'
        }),
      );
    } catch (e) {
      return Response(500,
        body: jsonEncode({
          'success': false,
          'message': 'Server error: $e'
        }),
      );
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