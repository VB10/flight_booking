part of '../../cart_page.dart';

/// Payment status decides the page: confirmation / error / cart.
final class _CartPageBody extends StatelessWidget {
  const _CartPageBody({
    required this.onRemove,
    required this.onPay,
    required this.onBrowseFlights,
    required this.onRetry,
  });

  final ValueChanged<int> onRemove;
  final VoidCallback onPay;
  final VoidCallback onBrowseFlights;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCheckoutCubit, CartCheckoutState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) => switch (state.status) {
        CartCheckoutStatus.success => _CartBookingConfirmation(
          onBackToFlights: onBrowseFlights,
        ),
        CartCheckoutStatus.error => ErrorState(
          title: LocaleKeys.cart_connection_error.translate,
          message: state.errorMessage.isEmpty
              ? LocaleKeys.cart_error_message.translate
              : state.errorMessage,
          retryLabel: LocaleKeys.general_retry.translate,
          onRetry: onRetry,
        ),
        CartCheckoutStatus.idle || CartCheckoutStatus.processing => Column(
          children: [
            Expanded(
              child: _CartContent(
                onRemove: onRemove,
                onBrowseFlights: onBrowseFlights,
              ),
            ),
            _CartSummary(onPay: onPay),
          ],
        ),
      },
    );
  }
}

/// Ticket list, or the empty state.
final class _CartContent extends StatelessWidget {
  const _CartContent({required this.onRemove, required this.onBrowseFlights});

  final ValueChanged<int> onRemove;
  final VoidCallback onBrowseFlights;

  @override
  Widget build(BuildContext context) {
    final locale = context.productLocale.toLanguageTag();
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.isEmpty) {
          return EmptyState(
            icon: Icons.shopping_cart_outlined,
            title: LocaleKeys.cart_empty.translate,
            message: LocaleKeys.cart_empty_message.translate,
            actionLabel: LocaleKeys.cart_browse_flights.translate,
            onAction: onBrowseFlights,
          );
        }
        return ListView.separated(
          padding: const AppPagePadding.all20(),
          itemCount: state.items.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSizes.spacingS),
          itemBuilder: (context, index) {
            final flight = state.items[index];
            return _CartDismissibleCard(
              key: ObjectKey(flight),
              flight: flight,
              locale: locale,
              onRemove: () => onRemove(index),
            );
          },
        );
      },
    );
  }
}

/// "Total:" + grand total + Pay (visible with total 0 ₺ when empty).
final class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.onPay});

  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    final locale = context.productLocale.toLanguageTag();
    return BlocSelector<CartCubit, CartState, int>(
      selector: (state) => state.totalPrice,
      builder: (context, total) => SummaryBar(
        label: LocaleKeys.cart_total_label.translate,
        price: PriceTag.large(ProductFormat.price(total, locale: locale)),
        action: AppButton.primary(
          label: LocaleKeys.cart_pay_button.translate,
          onPressed: onPay,
        ),
      ),
    );
  }
}
