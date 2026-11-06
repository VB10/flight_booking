part of '../flight_list_page.dart';

/// Flights screen: cubit creation, search controller, actions, analytics.
mixin FlightListPageMixin on State<FlightListPage> {
  late final TextEditingController searchController;

  late final FlightListCubit flightListCubit = FlightListCubit(
    ProductContainer.instance.get<IFlightService>(),
  );

  CartCubit get cartCubit => ProductContainer.instance.get<CartCubit>();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    unawaited(flightListCubit.loadFlights());
    unawaited(_logScreenView());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onClearFilters() {
    searchController.clear();
    flightListCubit.clearFilters();
  }

  void onAddToCart(BuildContext context, FlightModel flight) {
    unawaited(HapticFeedback.mediumImpact());
    cartCubit.add(flight);
    final count = cartCubit.state.count;
    unawaited(_logAddToCart(flight, count));
    AppSnackbar.show(
      context,
      message: LocaleKeys.flight_added_to_cart.translatePlural(count),
      tone: AppTone.success,
    );
  }

  Future<void> onLogoutPressed(BuildContext context) async {
    final confirmed = await AppDialog.show(
      context,
      title: LocaleKeys.flight_logout.translate,
      message: LocaleKeys.flight_logout_confirm.translate,
      confirmLabel: LocaleKeys.flight_logout.translate,
      cancelLabel: LocaleKeys.general_cancel.translate,
    );
    if (confirmed != true) return;
    await ProductContainer.instance.get<AuthCubit>().logout();
  }

  Future<void> _logScreenView() async {
    try {
      final analytics = CustomRemoteConfig.instance.analytics;
      await analytics.logScreenView(
        screenName: 'flight_list',
        screenClass: 'FlightListPage',
      );
      await analytics.logEvent(
        name: 'screen_view_flight_list',
        parameters: {
          'screen_name': 'flight_list',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'previous_screen': 'login',
        },
      );
    } on Exception catch (e) {
      debugPrint('Analytics screen view failed: $e');
    }
  }

  Future<void> _logAddToCart(FlightModel flight, int cartSize) async {
    try {
      final analytics = CustomRemoteConfig.instance.analytics;
      await analytics.logAddToCart(
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
      await analytics.logEvent(
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
    } on Exception catch (e) {
      debugPrint('Analytics add to cart failed: $e');
    }
  }
}
