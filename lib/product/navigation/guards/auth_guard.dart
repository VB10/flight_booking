import 'package:flight_booking/product/application/auth/auth_state.dart';
import 'package:go_router/go_router.dart';

const String _splashLocation = '/splash';
const String _loginLocation = '/login';
const String _flightsLocation = '/flights';

/// GoRouter redirect guard'ı. Saf fonksiyon — [authState] ve [state] üzerinden
/// karar verir; dışarıdan `AuthCubit.stream` `refreshListenable` ile tetiklenir.
String? authGuard(GoRouterState state, AuthState authState) {
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
