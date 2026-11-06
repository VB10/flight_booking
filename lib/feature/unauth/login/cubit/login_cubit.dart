import 'package:flight_booking/feature/unauth/login/cubit/login_state.dart';
import 'package:flight_booking/feature/unauth/login/model/login_response_model.dart';
import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/gen/locale_keys.g.dart';
import 'package:flight_booking/product/initialize/firebase/custom_remote_config.dart';
import 'package:flight_booking/product/localization/localization_extension.dart';
import 'package:flight_booking/product/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authService, this._authCubit) : super(const LoginState());

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final IAuthService _authService;
  final AuthCubit _authCubit;

  /// Fields were filled programmatically (test account): stale validation
  /// errors under them must go.
  void clearFieldErrors() {
    if (state.emailError.isEmpty && state.passwordError.isEmpty) return;
    emit(state.copyWith(emailError: '', passwordError: ''));
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    final emailError = _emailPattern.hasMatch(trimmedEmail)
        ? ''
        : LocaleKeys.login_email_invalid.translate;
    final passwordError = password.isEmpty
        ? LocaleKeys.login_password_required.translate
        : '';
    if (emailError.isNotEmpty || passwordError.isNotEmpty) {
      emit(
        state.copyWith(
          emailError: emailError,
          passwordError: passwordError,
          errorMessage: '',
          isSuccess: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: '',
        emailError: '',
        passwordError: '',
        isSuccess: false,
      ),
    );

    final result = await _authService.login(
      email: trimmedEmail,
      password: password,
    );

    LoginResponseModel? successResponse;
    String? failureMessage;

    result.fold(
      onSuccess: (LoginResponseModel data) {
        if (data.success) {
          successResponse = data;
        } else {
          failureMessage = data.message;
        }
      },
      onError: (error) {
        failureMessage =
            error.model?.message ??
            error.description ??
            LocaleKeys.login_failed.translate;
      },
    );

    if (successResponse != null) {
      final response = successResponse!;
      await _authCubit.setSession(
        token: response.token,
        email: response.user.email,
        name: response.user.name,
        userId: response.user.id,
      );
      await _logSuccessfulLogin(response);
      // setSession triggers the router redirect, which may already have
      // disposed this page (and closed the cubit).
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: failureMessage ?? LocaleKeys.login_failed.translate,
        ),
      );
    }
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
