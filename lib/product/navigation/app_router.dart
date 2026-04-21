import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/navigation/app_routes.dart';
import 'package:flight_booking/product/navigation/guards/auth_guard.dart';
import 'package:flight_booking/product/navigation/helpers/go_router_refresh_stream.dart';
import 'package:go_router/go_router.dart';

final class AppRouter {
  AppRouter(this._authCubit);

  final AuthCubit _authCubit;

  late final GoRouter config = GoRouter(
    initialLocation: const SplashRoute().location,
    refreshListenable: GoRouterRefreshStream(_authCubit.stream),
    redirect: (context, state) => AuthGuard.start(state, _authCubit.state),
    routes: $appRoutes,
  );
}
