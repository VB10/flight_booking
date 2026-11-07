part of '../cart_page.dart';

/// Cart screen: payment cubit, remove / undo, pay confirmation, navigation
/// and analytics. The cart itself is the app-wide [CartCubit].
mixin CartPageMixin on State<CartPage> {
  CartCubit get cartCubit => ProductContainer.instance.get<CartCubit>();

  late final CartCheckoutCubit checkoutCubit = CartCheckoutCubit(
    ProductContainer.instance.get<IFlightService>(),
    cartCubit,
    ProductContainer.instance.get<AuthCubit>(),
  );

  @override
  void initState() {
    super.initState();
    unawaited(_logScreenView());
  }

  void onBackPressed(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      const FlightListRoute().go(context);
    }
  }

  void onBrowseFlights(BuildContext context) =>
      const FlightListRoute().go(context);

  /// Remove icon and swipe both end up here; "Undo" puts the ticket back.
  void onRemove(BuildContext context, int index) {
    final removed = cartCubit.removeAt(index);
    if (removed == null) return;
    unawaited(_logRemoveFromCart(removed));
    AppSnackbar.show(
      context,
      message: LocaleKeys.cart_removed_snackbar.translate,
      actionLabel: LocaleKeys.cart_undo.translate,
      onAction: () => cartCubit.restore(index, removed),
    );
  }

  Future<void> onPayPressed(BuildContext context) async {
    // A pending "Undo" must not resurrect a ticket after it was paid.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final total = cartCubit.state.totalPrice;
    if (cartCubit.state.isEmpty) {
      AppSnackbar.show(
        context,
        message: LocaleKeys.cart_checkout_empty_warning.translate,
        tone: AppTone.warning,
      );
      return;
    }
    final confirmed = await AppDialog.show(
      context,
      title: LocaleKeys.cart_checkout_confirm_title.translate,
      message: LocaleKeys.cart_checkout_confirm_message.translateArgs([
        ProductFormat.price(
          total,
          locale: context.productLocale.toLanguageTag(),
        ),
      ]),
      confirmLabel: LocaleKeys.cart_confirm.translate,
      cancelLabel: LocaleKeys.general_cancel.translate,
    );
    if (confirmed != true) return;
    await checkoutCubit.pay();
  }

  Future<void> _logScreenView() async {
    try {
      final analytics = CustomRemoteConfig.instance.analytics;
      await analytics.logScreenView(
        screenName: 'cart',
        screenClass: 'CartPage',
      );
      await analytics.logEvent(
        name: 'cart_view',
        parameters: {
          'cart_item_count': cartCubit.state.count,
          'cart_total_value': cartCubit.state.totalPrice.toDouble(),
          'currency': 'TRY',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } on Exception catch (e) {
      debugPrint('Analytics cart screen view failed: $e');
    }
  }

  Future<void> _logRemoveFromCart(FlightModel flight) async {
    try {
      await CustomRemoteConfig.instance.analytics.logEvent(
        name: 'remove_from_cart',
        parameters: {
          'item_id': flight.id.toString(),
          'item_name': flight.airline,
          'item_category': 'flight_ticket',
          'price': flight.price,
          'currency': 'TRY',
          'from': flight.from,
          'to': flight.to,
        },
      );
    } on Exception catch (e) {
      debugPrint('Analytics remove from cart failed: $e');
    }
  }

  Future<void> logPurchase(List<FlightModel> paid) async {
    try {
      final analytics = CustomRemoteConfig.instance.analytics;
      final total = paid.fold<int>(0, (sum, f) => sum + f.price).toDouble();
      await analytics.logPurchase(
        currency: 'TRY',
        value: total,
        parameters: {
          'transaction_id': DateTime.now().millisecondsSinceEpoch.toString(),
          'item_count': paid.length,
        },
      );
      await analytics.logEvent(
        name: 'checkout_completed',
        parameters: {
          'total_amount': total,
          'item_count': paid.length,
          'checkout_timestamp': DateTime.now().millisecondsSinceEpoch,
          'platform': 'mobile',
        },
      );
    } on Exception catch (e) {
      debugPrint('Analytics checkout logging failed: $e');
    }
  }
}
