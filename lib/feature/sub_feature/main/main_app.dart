import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/feature/unauth/splash/splash_page.dart';
import 'package:flutter/material.dart';

final class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Booking',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
