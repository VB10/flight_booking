import 'dart:convert';
import 'dart:io';

void main() async {
  final client = HttpClient();
  
  print('Testing Flight Booking Server...\n');
  
  // Test health endpoint
  await testHealthEndpoint(client);
  
  // Test login endpoint
  await testLoginEndpoint(client);
  
  // Test flights endpoint
  await testFlightsEndpoint(client);
  
  // Test checkout endpoint
  await testCheckoutEndpoint(client);
  
  client.close();
}

Future<void> testHealthEndpoint(HttpClient client) async {
  try {
    print('1. Testing Health Endpoint...');
    final request = await client.getUrl(Uri.parse('http://localhost:8080/health'));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('   Status: ${response.statusCode}');
    print('   Response: $responseBody\n');
  } catch (e) {
    print('   Error: $e\n');
  }
}

Future<void> testLoginEndpoint(HttpClient client) async {
  try {
    print('2. Testing Login Endpoint...');
    final request = await client.postUrl(Uri.parse('http://localhost:8080/login'));
    request.headers.set('content-type', 'application/json');
    
    final loginData = {
      'email': 'user@test.com',
      'password': '123456'
    };
    
    request.add(utf8.encode(jsonEncode(loginData)));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('   Status: ${response.statusCode}');
    print('   Response: $responseBody\n');
  } catch (e) {
    print('   Error: $e\n');
  }
}

Future<void> testFlightsEndpoint(HttpClient client) async {
  try {
    print('3. Testing Flights Endpoint...');
    final request = await client.getUrl(Uri.parse('http://localhost:8080/flights'));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('   Status: ${response.statusCode}');
    print('   Response length: ${responseBody.length} characters\n');
  } catch (e) {
    print('   Error: $e\n');
  }
}

Future<void> testCheckoutEndpoint(HttpClient client) async {
  try {
    print('4. Testing Checkout Endpoint...');
    final request = await client.postUrl(Uri.parse('http://localhost:8080/checkout'));
    request.headers.set('content-type', 'application/json');
    
    final checkoutData = {
      'cartItems': [
        {
          'id': 1,
          'airline': 'Turkish Airlines',
          'from': 'Istanbul',
          'to': 'Ankara',
          'price': 299
        },
        {
          'id': 2,
          'airline': 'Pegasus',
          'from': 'Istanbul', 
          'to': 'Izmir',
          'price': 199
        }
      ],
      'userEmail': 'user@test.com'
    };
    
    request.add(utf8.encode(jsonEncode(checkoutData)));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('   Status: ${response.statusCode}');
    print('   Response: $responseBody\n');
  } catch (e) {
    print('   Error: $e\n');
  }
}