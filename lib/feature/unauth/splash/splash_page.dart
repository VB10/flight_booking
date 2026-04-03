import 'package:flight_booking/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/flight/flight_list_page.dart';
import '../login/login_page.dart';

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
        MaterialPageRoute(builder: (context) => const FlightListPage()),
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
    final colorScheme = context.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animation/lottie/lottie_loading.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: AppSizes.spacingXl),
            ProductText.h2(
              context,
              'Flight Booking',
              style: context.appTextTheme.headlineLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.spacingL),
            ProductText.bodyLarge(
              context,
              'Uçak Bileti Rezervasyon Uygulaması',
              style: context.appTextTheme.bodyLarge?.copyWith(
                color: colorScheme.onPrimary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 50),
            const SizedBox(height: 40),
            ProductText.bodyLarge(
              context,
              'Yükleniyor...',
              style: context.appTextTheme.bodyLarge?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
