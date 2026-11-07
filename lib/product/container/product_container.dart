import 'package:cache_manager/cache_manager.dart';
import 'package:flight_booking/product/application/application_cubit.dart';
import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/application/cart/cart_cubit.dart';
import 'package:flight_booking/product/cache/product_cache.dart';
import 'package:flight_booking/product/navigation/app_router.dart';
import 'package:flight_booking/product/network/interceptor/auth_interceptor.dart';
import 'package:flight_booking/product/network/network_manager.dart';
import 'package:flight_booking/product/network/product_network_manager.dart';
import 'package:flight_booking/product/service/app_update_service.dart';
import 'package:flight_booking/product/service/auth_service.dart';
import 'package:flight_booking/product/service/flight_service.dart';
import 'package:flight_booking/product/service/impl/app_update_service_impl.dart';
import 'package:flight_booking/product/service/impl/auth_service_impl.dart';
import 'package:flight_booking/product/service/impl/flight_service_impl.dart';
import 'package:get_it/get_it.dart';

/// Uygulama geneli DI kayıtları. `setup` bir kez, `runApp` öncesi çağrılır.
final class ProductContainer {
  ProductContainer._();

  static final ProductContainer instance = ProductContainer._();

  final GetIt _getIt = GetIt.instance;

  /// GetIt üzerinden kayıtlı servis / cubit çözümü.
  T get<T extends Object>() => _getIt<T>();

  void setup() {
    if (_getIt.isRegistered<IProductNetworkManager>()) {
      return;
    }

    _getIt
      ..registerLazySingleton<ICacheManager>(
        () => ProductCache.instance.manager,
      )
      ..registerLazySingleton<IFallbackStore>(
        () => ProductCache.instance.fallback,
      )
      ..registerLazySingleton<IProductNetworkManager>(
        () => ProductNetworkManager.instance,
      )
      ..registerLazySingleton<IAuthService>(
        () => AuthServiceImpl(_getIt<IProductNetworkManager>()),
      )
      ..registerLazySingleton<IFlightService>(
        () => FlightServiceImpl(_getIt<IProductNetworkManager>()),
      )
      ..registerLazySingleton<IAppUpdateService>(AppUpdateServiceImpl.new)
      ..registerLazySingleton<ApplicationCubit>(
        () => ApplicationCubit(_getIt<ICacheManager>()),
      )
      ..registerLazySingleton<AuthCubit>(
        () => AuthCubit(
          _getIt<IProductNetworkManager>(),
          _getIt<ICacheManager>(),
          _getIt<IFallbackStore>(),
        ),
      )
      ..registerLazySingleton<CartCubit>(CartCubit.new)
      ..registerLazySingleton<AppRouter>(
        () => AppRouter(_getIt<AuthCubit>()),
      );

    // Any logout (button, 401 interceptor, expired session) empties the cart,
    // so a previous user's tickets never reach the next session.
    _getIt<AuthCubit>().stream
        .where((auth) => !auth.isLoggedIn)
        .listen((_) => _getIt<CartCubit>().clear());

    _getIt<IProductNetworkManager>().registerInterceptor(
      AuthInterceptor(onUnauthorized: () => _getIt<AuthCubit>().logout()),
    );
  }
}
