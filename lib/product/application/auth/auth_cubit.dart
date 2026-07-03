import 'package:cache_manager/cache_manager.dart';
import 'package:flight_booking/product/application/auth/auth_state.dart';
import 'package:flight_booking/product/cache/model/auth_session_cache_model.dart';
import 'package:flight_booking/product/cache/product_cache_keys.dart';
import 'package:flight_booking/product/network/network_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._network, this._cache, this._fallback)
      : super(const AuthState.unauthenticated());

  final IProductNetworkManager _network;
  final ICacheManager _cache;
  final IFallbackStore _fallback;

  Future<void> restoreSession() async {
    // Primary: the whole session model from the cache (JSON in Hive).
    final session = _cache.readModel<AuthSessionCacheModel>(
      ProductCacheKeys.session,
      fromJson: AuthSessionCacheModel.fromJson,
    );
    if (session != null && session.token.isNotEmpty) {
      _network.setAuthToken(session.token);
      emit(
        AuthState(
          isLoggedIn: true,
          token: session.token,
          email: session.email,
          name: session.name,
          userId: session.userId,
        ),
      );
      return;
    }

    // Fallback: Hive lost the session but the token survived in the
    // standalone store — restore a token-only session and let the app refresh
    // the profile from the server.
    final token = _fallback.read(FallbackKeys.token);
    if (token != null && token.isNotEmpty) {
      _network.setAuthToken(token);
      emit(AuthState(isLoggedIn: true, token: token));
      return;
    }

    emit(const AuthState.unauthenticated());
  }

  Future<void> setSession({
    required String token,
    required String email,
    required String name,
    required int userId,
  }) async {
    await Future.wait([
      _cache.writeModel(
        ProductCacheKeys.session,
        AuthSessionCacheModel(
          token: token,
          email: email,
          name: name,
          userId: userId,
        ),
      ),
      _fallback.write(FallbackKeys.token, token),
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
    await Future.wait([
      _cache.remove(ProductCacheKeys.session),
      _fallback.remove(FallbackKeys.token),
    ]);
    _network.clearAuthToken();
    emit(const AuthState.unauthenticated());
  }
}
