part of '../../cart_page.dart';

/// Payment success: reference, status, paid tickets, total and the way out.
final class _CartBookingConfirmation extends StatelessWidget {
  const _CartBookingConfirmation({required this.onBackToFlights});

  final VoidCallback onBackToFlights;

  @override
  Widget build(BuildContext context) {
    final locale = context.productLocale.toLanguageTag();
    final muted = context.colorScheme.onSurfaceVariant;
    return SafeArea(
      child: BlocBuilder<CartCheckoutCubit, CartCheckoutState>(
        builder: (context, state) {
          final reference = state.response?.bookingReference;
          final total =
              state.response?.totalPrice ??
              state.paidItems.fold<int>(0, (sum, f) => sum + f.price);
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.pagePadding,
                    AppSizes.spacingXXl,
                    AppSizes.pagePadding,
                    AppSizes.spacingM,
                  ),
                  children: [
                    Column(
                      children: [
                        const StateIcon(
                          icon: Icons.check_circle_outline,
                          tone: AppTone.success,
                        ),
                        const SizedBox(height: AppSizes.spacingM),
                        ProductText.h2(
                          context,
                          LocaleKeys.cart_success_title.translate,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        ProductText.bodyMedium(
                          context,
                          LocaleKeys.cart_success_message.translatePlural(
                            state.paidItems.length,
                          ),
                          color: muted,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spacingXl),
                    if (reference != null) ...[
                      AppCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProductText.bodySmall(
                                    context,
                                    LocaleKeys.cart_booking_reference.translate,
                                    color: muted,
                                  ),
                                  ProductText.titleLarge(context, reference),
                                ],
                              ),
                            ),
                            StatusBadge(
                              label: LocaleKeys.cart_confirmed.translate,
                              tone: AppTone.success,
                              icon: Icons.check,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacingS),
                    ],
                    for (final flight in state.paidItems) ...[
                      FlightCard.compact(
                        airline: flight.airline,
                        date: ProductFormat.date(flight.date, locale: locale),
                        price: ProductFormat.price(
                          flight.price,
                          locale: locale,
                        ),
                        from: flight.from,
                        to: flight.to,
                        departureTime: flight.departureTime,
                        arrivalTime: flight.arrivalTime,
                        duration: flight.duration,
                      ),
                      const SizedBox(height: AppSizes.spacingS),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: ProductText.labelLarge(
                              context,
                              LocaleKeys.cart_total_paid.translate,
                              color: muted,
                            ),
                          ),
                          PriceTag(ProductFormat.price(total, locale: locale)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.pagePadding,
                  0,
                  AppSizes.pagePadding,
                  AppSizes.spacingXl,
                ),
                child: AppButton.primary(
                  label: LocaleKeys.cart_back_to_flights.translate,
                  onPressed: onBackToFlights,
                  expand: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
