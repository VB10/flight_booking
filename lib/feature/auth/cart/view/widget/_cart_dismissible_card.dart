part of '../../cart_page.dart';

/// Compact ticket card: trailing remove icon plus swipe-to-dismiss.
final class _CartDismissibleCard extends StatelessWidget {
  const _CartDismissibleCard({
    required this.flight,
    required this.locale,
    required this.onRemove,
    super.key,
  });

  final FlightModel flight;
  final String locale;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Dismissible(
      key: ObjectKey(flight),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: AppRadius.medium,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: AppSizes.spacingL),
            child: Icon(
              Icons.delete_outline,
              color: scheme.onErrorContainer,
              semanticLabel: LocaleKeys.cart_remove_tooltip.translate,
            ),
          ),
        ),
      ),
      child: FlightCard.compact(
        airline: flight.airline,
        date: ProductFormat.date(flight.date, locale: locale),
        price: ProductFormat.price(flight.price, locale: locale),
        from: flight.from,
        to: flight.to,
        departureTime: flight.departureTime,
        arrivalTime: flight.arrivalTime,
        duration: flight.duration,
        onRemove: onRemove,
      ),
    );
  }
}
