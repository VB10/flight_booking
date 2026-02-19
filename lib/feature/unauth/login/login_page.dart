import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/product/initialize/firebase/custom_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/flight/flight_list_page.dart';
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

      Response response = await dio.post('$baseUrl/login', data: requestBody);

      // Status code kontrolü her yerde tekrar yazılıyor
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.data);
        LoginResponseModel loginResponse = LoginResponseModel.fromJson(
          jsonResponse,
        );

        if (loginResponse.success) {
          // Kötü pratik: Cache logic burada sayfaya gömülü
          await saveUserToCache(loginResponse);

          // Analytics - Login başarılı olunca logla
          await _logSuccessfulLogin(loginResponse);

          setState(() {
            isLoading = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FlightListPage()),
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

  // Kötü pratik: Analytics method'u da buraya gömülü
  Future<void> _logSuccessfulLogin(LoginResponseModel loginResponse) async {
    try {
      // Analytics - Login event'i logla
      await CustomRemoteConfig.instance.analytics.logLogin(
        loginMethod: 'email', // Kötü pratik: Hard coded method
      );

      // User properties set et - kötü pratik: PII data
      await CustomRemoteConfig.instance.analytics.setUserId(
        id: loginResponse.user.id.toString(),
      );
      await CustomRemoteConfig.instance.analytics.setUserProperty(
        name: 'user_email', // Kötü pratik: Email saklamak
        value: loginResponse.user.email,
      );
      await CustomRemoteConfig.instance.analytics.setUserProperty(
        name: 'user_name',
        value: loginResponse.user.name,
      );

      // Custom event - kötü pratik: Hard coded parameters
      await CustomRemoteConfig.instance.analytics.logEvent(
        name: 'successful_login',
        parameters: {
          'login_timestamp': DateTime.now().millisecondsSinceEpoch,
          'user_id': loginResponse.user.id,
          'user_email': loginResponse.user.email, // PII bilgi
          'platform': 'mobile',
        },
      );

      debugPrint('Analytics: Login event logged');
    } catch (e) {
      // Kötü pratik: Silent fail
      debugPrint('Analytics logging failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        /// TODO: locaizaiton
        title: ProductText.h3(context, 'Flight Booking'),
        centerTitle: true,
        backgroundColor: context.colorScheme.primary,
      ),
      body: Padding(
        padding: AppPagePadding.all20(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SVG ikonu kullan - kötü pratik: Hard coded path
            SvgPicture.asset(
              'assets/undraw_aircraft_usu4.svg',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: AppSizes.spacingL),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: AppSizes.spacingL),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: AppSizes.spacingS),
            if (errorMessage.isNotEmpty)
              ProductText.bodySmall(
                context,
                errorMessage,
                color: context.colorScheme.error,
              ),
            const SizedBox(height: AppSizes.spacingL),
            if (isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appTheme.brandPrimary,
                ),
                child: Center(
                  child: ProductText.bodyMedium(
                    context,
                    'Login',
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            ProductText.bodySmall(
              context,
              'Test hesabı: user@test.com / 123456',
              color: context.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
