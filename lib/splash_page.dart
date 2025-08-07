import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'login_page.dart';
import 'flight_list_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkUserLogin();
  }

  // Kötü pratik: Tüm cache logic burada sayfaya gömülü
  void checkUserLogin() async {
    await Future.delayed(Duration(seconds: 2)); // Fake splash delay
    
    // SharedPreferences'i her seferinde al - kötü pratik
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Hard coded key'ler - kötü praktik
    String? token = prefs.getString('user_token');
    String? userEmail = prefs.getString('user_email');
    String? userName = prefs.getString('user_name');
    int? userId = prefs.getInt('user_id');
    
    // Basit kontrol - proper validation yok
    if (token != null && token.isNotEmpty && userEmail != null) {
      // User logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FlightListPage()),
      );
    } else {
      // User not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animasyonu - kötü pratik: Hard coded path
            Lottie.asset(
              'assets/Animation - 1716380534233.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 30),
            Text(
              'Flight Booking',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Roboto', // Kötü pratik: Hard coded font
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Uçak Bileti Rezervasyon Uygulaması',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 50),
            // Loading indicator yerine boş alan - animasyon yeterli
            SizedBox(height: 40),
            Text(
              'Yükleniyor...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}