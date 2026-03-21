import 'package:flight_booking/feature/unauth/login/model/login_response_model.dart';
import 'package:flight_booking/product/initialize/firebase/custom_remote_config.dart';
import 'package:flight_booking/product/network/product_network_manager.dart';
import 'package:flight_booking/product/service/impl/auth_service_impl.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class LoginViewModel {
  LoginViewModel();

  final _authService = AuthServiceImpl();

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final result = await _authService.login(email: email, password: password);

    LoginResponseModel? response;
    String? errorMessage;

    result.fold(
      onSuccess: (data) {
        // Set auth token for subsequent requests
        ProductNetworkManager.instance.setAuthToken(data.token);
        response = data;
      },
      onError: (error) {
        errorMessage = error.model?.message ?? 'Giriş başarısız';
      },
    );

    if (response != null) {
      return response!;
    }
    throw Exception(errorMessage);
  }

  Future<void> saveUserToCache(LoginResponseModel loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    // TODO: Code gen ile cache key'leri
    await prefs.setString('user_token', loginResponse.token);
    await prefs.setString('user_email', loginResponse.user.email);
    await prefs.setString('user_name', loginResponse.user.name);
    await prefs.setInt('user_id', loginResponse.user.id);
    await prefs.setBool('is_logged_in', true);
  }

  Future<void> logSuccessfulLogin(LoginResponseModel loginResponse) async {
    try {
      await CustomRemoteConfig.instance.analytics.logLogin(
        loginMethod: 'email',
      );
      await CustomRemoteConfig.instance.analytics.setUserId(
        id: loginResponse.user.id.toString(),
      );
      await CustomRemoteConfig.instance.analytics.setUserProperty(
        name: 'user_email',
        value: loginResponse.user.email,
      );
      await CustomRemoteConfig.instance.analytics.setUserProperty(
        name: 'user_name',
        value: loginResponse.user.name,
      );
      await CustomRemoteConfig.instance.analytics.logEvent(
        name: 'successful_login',
        parameters: {
          'login_timestamp': DateTime.now().millisecondsSinceEpoch,
          'user_id': loginResponse.user.id,
          'user_email': loginResponse.user.email,
          'platform': 'mobile',
        },
      );
      debugPrint('Analytics: Login event logged');
    } on Exception catch (e) {
      debugPrint('Analytics logging failed: $e');
    }
  }
}
