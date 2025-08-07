import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flight_list_page.dart';
import 'login_response_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    // Kötü pratik: Her yerde aynı kodu yazmak
    Dio dio = Dio();
    String baseUrl = 'http://localhost:8080'; // Hard coded URL
    
    try {
      // Request body doğrudan yazıldı
      Map<String, String> requestBody = {
        'email': emailController.text,
        'password': passwordController.text,
      };
      
      Response response = await dio.post(
        '$baseUrl/login',
        data: requestBody,
      );
      
      // Status code kontrolü her yerde tekrar yazılıyor
      if (response.statusCode == 200) {
        LoginResponseModel loginResponse = LoginResponseModel.fromJson(response.data);
        
        if (loginResponse.success) {
          // Kötü pratik: Cache logic burada sayfaya gömülü
          await saveUserToCache(loginResponse);
          
          setState(() {
            isLoading = false;
          });
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => FlightListPage())
          );
        } else {
          setState(() {
            isLoading = false;
            errorMessage = loginResponse.message;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Server hatası: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Bağlantı hatası: $e';
      });
    }
  }

  // Kötü pratik: Cache işlemleri sayfaya gömülü
  Future<void> saveUserToCache(LoginResponseModel loginResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Hard coded key'ler - kötü praktik
    await prefs.setString('user_token', loginResponse.token);
    await prefs.setString('user_email', loginResponse.user.email);
    await prefs.setString('user_name', loginResponse.user.name);
    await prefs.setInt('user_id', loginResponse.user.id);
    
    // Basit boolean flag
    await prefs.setBool('is_logged_in', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Flight Booking'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flight_takeoff,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 30),
            isLoading 
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: login,
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
            SizedBox(height: 20),
            Text(
              'Test hesabı: user@test.com / 123456',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}