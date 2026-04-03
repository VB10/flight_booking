import 'package:flight_booking/feature/unauth/login/cubit/login_state.dart';
import 'package:flight_booking/feature/unauth/login/model/login_response_model.dart';
import 'package:flight_booking/product/initialize/firebase/custom_remote_config.dart';
import 'package:flight_booking/product/network/network_manager.dart';
import 'package:flight_booking/product/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authService, this._networkManager)
    : super(const LoginState());

  final IAuthService _authService;
  final IProductNetworkManager _networkManager;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));

    final result = await _authService.login(email: email, password: password);

    LoginResponseModel? successResponse;
    String? failureMessage;

    result.fold(
      onSuccess: (LoginResponseModel data) {
        if (data.success) {
          _networkManager.setAuthToken(data.token);
          successResponse = data;
        } else {
          failureMessage = data.message;
        }
      },
      onError: (error) {
        failureMessage =
            error.model?.message ?? error.description ?? 'Giriş başarısız';
      },
    );

    if (successResponse != null) {
      await _saveUserToCache(successResponse!);
      await _logSuccessfulLogin(successResponse!);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } else {
      emit(
        state.copyWith(
          isLoading: false,

          ///TODO: Localization
          errorMessage: failureMessage ?? 'Giriş başarısız',
        ),
      );
    }
  }

  Future<void> _saveUserToCache(LoginResponseModel loginResponse) async {
    /// TODO: Database
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', loginResponse.token);
    await prefs.setString('user_email', loginResponse.user.email);
    await prefs.setString('user_name', loginResponse.user.name);
    await prefs.setInt('user_id', loginResponse.user.id);
    await prefs.setBool('is_logged_in', true);
  }

  Future<void> _logSuccessfulLogin(LoginResponseModel loginResponse) async {
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
