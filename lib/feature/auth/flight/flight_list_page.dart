import 'dart:async';

import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/feature/auth/flight/cubit/flight_list_cubit.dart';
import 'package:flight_booking/feature/auth/flight/cubit/flight_list_state.dart';
import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flight_booking/product/application/application_cubit.dart';
import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/container/product_container.dart';
import 'package:flight_booking/product/gen/assets.gen.dart';
import 'package:flight_booking/product/gen/locale_keys.g.dart';
import 'package:flight_booking/product/initialize/firebase/custom_remote_config.dart';
import 'package:flight_booking/product/localization/localization_extension.dart';
import 'package:flight_booking/product/navigation/app_routes.dart';
import 'package:flight_booking/product/service/flight_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shimmer/shimmer.dart';

final class FlightListPage extends StatelessWidget {
  const FlightListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = FlightListCubit(
          ProductContainer.instance.get<IFlightService>(),
        );
        unawaited(cubit.loadFlights());
        return cubit;
      },
      child: const _FlightListBody(),
    );
  }
}

final class _FlightListBody extends StatefulWidget {
  const _FlightListBody();

  @override
  State<_FlightListBody> createState() => _FlightListBodyState();
}

final class _FlightListBodyState extends State<_FlightListBody> {
  late final ValueNotifier<List<Map<String, dynamic>>> _cartNotifier;

  @override
  void initState() {
    super.initState();
    _cartNotifier = ValueNotifier([]);
    unawaited(_logScreenView());
    unawaited(_checkAppVersion());
  }

  @override
  void dispose() {
    _cartNotifier.dispose();
    super.dispose();
  }

  Future<void> _logScreenView() async {
    try {
      await CustomRemoteConfig.instance.analytics.logScreenView(
        screenName: 'flight_list',
        screenClass: 'FlightListPage',
      );

      await CustomRemoteConfig.instance.analytics.logEvent(
        name: 'screen_view_flight_list',
        parameters: {
          'screen_name': 'flight_list',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'previous_screen': 'login',
        },
      );

      debugPrint('Analytics: Flight list screen view logged');
    } catch (e) {
      debugPrint('Analytics screen view failed: $e');
    }
  }

  Future<void> _checkAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final minimumVersion = CustomRemoteConfig.instance.remoteConfig.getString(
        'minimum_app_version',
      );
      final forceUpdate = CustomRemoteConfig.instance.remoteConfig.getBool(
        'force_update_required',
      );
      final updateMessage = CustomRemoteConfig.instance.remoteConfig.getString(
        'update_message_tr',
      );

      if (_isVersionOlder(currentVersion, minimumVersion)) {
        if (!mounted) return;
        _showUpdateDialog(forceUpdate, updateMessage);
      }
    } catch (e) {
      debugPrint('Version check failed: $e');
    }
  }

  bool _isVersionOlder(String current, String minimum) {
    final currentParts = current.split('.').map(int.parse).toList();
    final minimumParts = minimum.split('.').map(int.parse).toList();

    for (var i = 0; i < 3; i++) {
      if (currentParts[i] < minimumParts[i]) return true;
      if (currentParts[i] > minimumParts[i]) return false;
    }
    return false;
  }

  void _showUpdateDialog(bool forceUpdate, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: !forceUpdate,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.system_update, color: dialogContext.appTheme.warning),
              const SizedBox(width: AppSizes.spacingS),
              ProductText.titleLarge(
                dialogContext,
                LocaleKeys.flight_update_required_title.translate,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.icon.svg.icConnectedWorld.svg(
                width: 100,
                height: 100,
              ),
              const SizedBox(height: AppSizes.spacingL),
              ProductText.bodyLarge(
                dialogContext,
                message.isEmpty
                    ? LocaleKeys.flight_update_required_message.translate
                    : message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            if (!forceUpdate)
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: ProductText.bodyMedium(
                  dialogContext,
                  LocaleKeys.general_later.translate,
                  color: dialogContext.colorScheme.onSurfaceVariant,
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: dialogContext.appTheme.warning,
                foregroundColor: dialogContext.colorScheme.onPrimary,
              ),
              onPressed: () {
                debugPrint(
                  "Store'a yönlendir - URL: https://play.google.com/store/apps/details?id=com.example.flight_booking",
                );
                if (!forceUpdate) Navigator.of(dialogContext).pop();
              },
              child: ProductText.labelLarge(
                dialogContext,
                LocaleKeys.flight_update.translate,
                style: dialogContext.appTextTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addToCart(FlightModel flight) {
    HapticFeedback.mediumImpact();

    final flightMap = flight.toJson();
    _cartNotifier.value = [..._cartNotifier.value, flightMap];

    unawaited(_logAddToCart(flight));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ProductText.bodyMedium(
          context,
          // Plural key: the language picks the branch, we only pass the count.
          LocaleKeys.flight_added_to_cart.translatePlural(
            _cartNotifier.value.length,
          ),
        ),
        backgroundColor: context.appTheme.success,
      ),
    );
  }

  Future<void> _logAddToCart(FlightModel flight) async {
    try {
      final cartSize = _cartNotifier.value.length;

      await CustomRemoteConfig.instance.analytics.logAddToCart(
        currency: 'TRY',
        value: flight.price.toDouble(),
        parameters: {
          'item_id': flight.id.toString(),
          'item_name': flight.airline,
          'item_category': 'flight_ticket',
          'price': flight.price,
          'from': flight.from,
          'to': flight.to,
          'departure_time': flight.departureTime,
          'arrival_time': flight.arrivalTime,
          'flight_date': flight.date,
          'duration': flight.duration,
        },
      );

      await CustomRemoteConfig.instance.analytics.logEvent(
        name: 'flight_added_to_cart',
        parameters: {
          'flight_id': flight.id,
          'airline': flight.airline,
          'price': flight.price,
          'route': '${flight.from}-${flight.to}',
          'cart_size': cartSize,
          'add_timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      debugPrint('Analytics: Add to cart logged for ${flight.airline}');
    } catch (e) {
      debugPrint('Analytics add to cart failed: $e');
    }
  }

  Future<void> _logout() => context.read<AuthCubit>().logout();

  Widget _buildShimmerLoading(BuildContext context) {
    final appTheme = context.appTheme;
    final surfaceColor = context.colorScheme.surface;
    return ListView.builder(
      padding: AppPagePadding.all10(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: appTheme.shimmerBase,
          highlightColor: appTheme.shimmerHighlight,
          child: Card(
            margin: AppPagePadding.marginBottom15(),
            elevation: 3,
            child: Padding(
              padding: AppPagePadding.all20(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: AppRadius.circular4,
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 18,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: AppRadius.circular4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingS),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 16,
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: AppRadius.circular4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 50,
                              height: 14,
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: AppRadius.circular4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: AppRadius.circular4,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 80,
                              height: 16,
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: AppRadius.circular4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 50,
                              height: 14,
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: AppRadius.circular4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingS),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 70,
                        height: 12,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: AppRadius.circular4,
                        ),
                      ),
                      Container(
                        width: 90,
                        height: 12,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: AppRadius.circular4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingM),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: AppSizes.buttonHeightSmall,
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: AppRadius.circular4,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacingS),
                      Expanded(
                        child: Container(
                          height: AppSizes.buttonHeightSmall,
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: AppRadius.circular4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ProductText.titleMedium(
          context,
          LocaleKeys.flight_list_title.translate,
        ),
        backgroundColor: context.colorScheme.primary,
        actions: [
          IconButton(
            tooltip: LocaleKeys.flight_theme_tooltip.translate,
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => context.read<ApplicationCubit>().toggleTheme(),
          ),
          IconButton(
            tooltip: LocaleKeys.flight_language_tooltip.translate,
            icon: const Icon(Icons.translate),
            onPressed: () => unawaited(
              context.read<ApplicationCubit>().toggleLocale(context),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => const ProfileRoute().push<void>(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: ProductText.titleLarge(
                      dialogContext,
                      LocaleKeys.flight_logout.translate,
                    ),
                    content: ProductText.bodyMedium(
                      dialogContext,
                      LocaleKeys.flight_logout_confirm.translate,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: ProductText.labelLarge(
                          dialogContext,
                          LocaleKeys.general_cancel.translate,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          unawaited(_logout());
                        },
                        child: ProductText.labelLarge(
                          dialogContext,
                          LocaleKeys.flight_logout.translate,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: _cartNotifier,
            builder: (context, cart, _) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () =>
                        CartRoute($extra: List.of(cart)).go(context),
                  ),
                  if (cart.isNotEmpty)
                    Positioned(
                      right: AppSizes.spacingXs,
                      top: AppSizes.spacingXs,
                      child: Container(
                        padding: AppPagePadding.all10(),
                        decoration: BoxDecoration(
                          color: context.colorScheme.error,
                          borderRadius: AppRadius.circular8,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: AppSizes.iconSmall,
                          minHeight: AppSizes.iconSmall,
                        ),
                        child: ProductText.labelSmall(
                          context,
                          cart.length.toString(),
                          style: context.appTextTheme.labelSmall?.copyWith(
                            color: context.colorScheme.onError,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<FlightListCubit, FlightListState>(
        builder: (context, listState) {
          if (listState.isLoading) {
            return _buildShimmerLoading(context);
          }
          if (listState.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.icon.svg.icFastLoading.svg(
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: AppSizes.spacingXl),
                  ProductText.bodyLarge(
                    context,
                    LocaleKeys.general_error_message.translateArgs([
                      listState.errorMessage,
                    ]),
                    style: context.appTextTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingL),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<FlightListCubit>().loadFlights(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.primary,
                      foregroundColor: context.colorScheme.onPrimary,
                    ),
                    child: ProductText.labelLarge(
                      context,
                      LocaleKeys.general_retry.translate,
                    ),
                  ),
                ],
              ),
            );
          }

          final flights = listState.flights;
          return ListView.builder(
            padding: AppPagePadding.all10(),
            itemCount: flights.length,
            itemBuilder: (context, index) {
              final flight = flights[index];
              final scheme = context.colorScheme;
              final appTheme = context.appTheme;
              return Card(
                margin: AppPagePadding.marginBottom15(),
                elevation: 3,
                child: Padding(
                  padding: AppPagePadding.all20(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProductText.titleMedium(
                            context,
                            flight.airline,
                            style: context.appTextTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: scheme.primary,
                            ),
                          ),
                          ProductText.titleLarge(
                            context,
                            LocaleKeys.flight_price.translateArgs([
                              flight.price.toString(),
                            ]),
                            style: context.appTextTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: appTheme.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingS),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProductText.titleMedium(
                                  context,
                                  flight.from,
                                  style: context.appTextTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                ProductText.bodyMedium(
                                  context,
                                  flight.departureTime,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: scheme.onSurfaceVariant,
                            size: AppSizes.iconMedium,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ProductText.titleMedium(
                                  context,
                                  flight.to,
                                  style: context.appTextTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                ProductText.bodyMedium(
                                  context,
                                  flight.arrivalTime,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingS),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProductText.labelSmall(
                            context,
                            LocaleKeys.flight_duration.translateArgs([
                              flight.duration,
                            ]),
                            style: context.appTextTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          ProductText.labelSmall(
                            context,
                            LocaleKeys.flight_date.translateArgs([
                              flight.date,
                            ]),
                            style: context.appTextTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingM),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => FlightDetailRoute(
                                flightId: flight.id.toString(),
                                $extra: flight.toJson(),
                              ).go(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: scheme.surfaceContainerHighest,
                                foregroundColor: scheme.onSurface,
                              ),
                              child: ProductText.labelLarge(
                                context,
                                LocaleKeys.flight_details.translate,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.spacingS),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _addToCart(flight),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appTheme.brandPrimary,
                                foregroundColor: scheme.onPrimary,
                              ),
                              child: ProductText.labelLarge(
                                context,
                                LocaleKeys.flight_add_to_cart.translate,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
