part of '../flight_detail_page.dart';

/// Flight detail: cubit creation and actions.
mixin FlightDetailPageMixin on State<FlightDetailPage> {
  late final FlightDetailCubit flightDetailCubit = FlightDetailCubit(
    ProductContainer.instance.get<IFlightService>(),
    flightId: widget.flightId,
    flight: widget.flight == null ? null : FlightModel.fromJson(widget.flight!),
  );

  CartCubit get cartCubit => ProductContainer.instance.get<CartCubit>();

  @override
  void initState() {
    super.initState();
    unawaited(flightDetailCubit.load());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      const FlightListRoute().go(context);
    }
  }

  void onAddToCart(BuildContext context) {
    final flight = flightDetailCubit.state.flight;
    if (flight == null) return;
    cartCubit.add(flight);
    AppSnackbar.show(
      context,
      message: LocaleKeys.flight_added_to_cart.translatePlural(
        cartCubit.state.count,
      ),
      tone: AppTone.success,
    );
  }
}
