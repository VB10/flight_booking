import 'package:flight_booking/product/application/auth/auth_state.dart';
import 'package:flight_booking/product/network/network_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._network) : super(const AuthState.unauthenticated());

  final IProductNetworkManager _network;

  /// TODO: Will be refactored to use secure storage in the future for better security.
  static const _kToken = 'user_token';
  static const _kEmail = 'user_email';
  static const _kName = 'user_name';
  static const _kUserId = 'user_id';

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_kToken);
    final email = prefs.getString(_kEmail);

    if (token == null || token.isEmpty || email == null) {
      emit(const AuthState.unauthenticated());
      return;
    }

    _network.setAuthToken(token);
    emit(
      AuthState(
        isLoggedIn: true,
        token: token,
        email: email,
        name: prefs.getString(_kName),
        userId: prefs.getInt(_kUserId),
      ),
    );
  }

  Future<void> setSession({
    required String token,
    required String email,
    required String name,
    required int userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_kToken, token),
      prefs.setString(_kEmail, email),
      prefs.setString(_kName, name),
      prefs.setInt(_kUserId, userId),
    ]);
    _network.setAuthToken(token);
    emit(
      AuthState(
        isLoggedIn: true,
        token: token,
        email: email,
        name: name,
        userId: userId,
      ),
    );
  }

  Future<void> logout() async {
    if (!state.isLoggedIn) return;
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_kToken),
      prefs.remove(_kEmail),
      prefs.remove(_kName),
      prefs.remove(_kUserId),
    ]);
    _network.clearAuthToken();
    emit(const AuthState.unauthenticated());
  }
}
