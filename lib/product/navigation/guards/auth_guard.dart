import 'package:flight_booking/product/application/auth/auth_state.dart';
import 'package:go_router/go_router.dart';

final class AuthGuard {
  AuthGuard._();
  static const String _splashLocation = '/splash';
  static const String _loginLocation = '/login';
  static const String _flightsLocation = '/flights';

  /// GoRouter redirect guard'ı. Saf fonksiyon — [authState] ve [state] üzerinden
  /// karar verir; dışarıdan `AuthCubit.stream` `refreshListenable` ile tetiklenir.
  static String? start(GoRouterState state, AuthState authState) {
    final location = state.matchedLocation;

    if (location == _splashLocation) return null;

    final goingToLogin = location == _loginLocation;

    if (!authState.isLoggedIn && !goingToLogin) {
      return _loginLocation;
    }

    if (authState.isLoggedIn && goingToLogin) {
      return _flightsLocation;
    }

    return null;
  }
}
