import 'package:flight_booking/feature/auth/cart/cart_page.dart';
import 'package:flight_booking/feature/auth/flight/flight_list_page.dart';
import 'package:flight_booking/feature/auth/flight_detail/flight_detail_page.dart';
import 'package:flight_booking/feature/auth/profile/profile_page.dart';
import 'package:flight_booking/feature/unauth/login/login_page.dart';
import 'package:flight_booking/feature/unauth/splash/splash_page.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'app_routes.g.dart';

@TypedGoRoute<SplashRoute>(path: '/splash')
final class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => SplashPage();
}

@TypedGoRoute<LoginRoute>(path: '/login')
final class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginPage();
}

@TypedGoRoute<FlightListRoute>(
  path: '/flights',
  routes: [
    TypedGoRoute<FlightDetailRoute>(path: ':flightId'),
  ],
)
final class FlightListRoute extends GoRouteData with $FlightListRoute {
  const FlightListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FlightListPage();
}

final class FlightDetailRoute extends GoRouteData with $FlightDetailRoute {
  const FlightDetailRoute({required this.flightId, required this.$extra});

  final String flightId;
  final Map<String, dynamic> $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      FlightDetailPage(flight: $extra);
}

@TypedGoRoute<CartRoute>(path: '/cart')
final class CartRoute extends GoRouteData with $CartRoute {
  const CartRoute({required this.$extra});

  final List<Map<String, dynamic>> $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CartPage(cartItems: $extra);
}

@TypedGoRoute<ProfileRoute>(path: '/profile')
final class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => ProfilePage();
}
