import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/product/gen/locale_keys.g.dart';
import 'package:flight_booking/product/localization/localization_extension.dart';
import 'package:flight_booking/product/widget/flight/airline_mark.dart';
import 'package:flight_booking/product/widget/flight/route_line.dart';
import 'package:flutter/material.dart';

/// Kit `FlightCard` — full (Flights list) and compact (Cart, booking
/// confirmation, history).
///
/// Takes display-ready values, not a model: the product layer must not
/// import a feature's model. [price] is already formatted ("650 ₺").
final class FlightCard extends StatelessWidget {
  /// Full card: airline + date + price · times, cities, duration, route
  /// line · "Details" (secondary) + "Add to Cart" (primary).
  const FlightCard.full({
    required this.airline,
    required this.date,
    required this.price,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required VoidCallback this.onDetails,
    required VoidCallback this.onAddToCart,
    this.isAdding = false,
    super.key,
  }) : compact = false,
       onRemove = null,
       onTap = null;

  /// Compact card: "from → to", "airline · date", "dep – arr · duration",
  /// small price and an optional remove action.
  const FlightCard.compact({
    required this.airline,
    required this.date,
    required this.price,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    this.onRemove,
    this.onTap,
    super.key,
  }) : compact = true,
       onDetails = null,
       onAddToCart = null,
       isAdding = false;

  final String airline;
  final String date;
  final String price;
  final String from;
  final String to;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final VoidCallback? onDetails;
  final VoidCallback? onAddToCart;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  /// "Add to Cart" shows its loading state.
  final bool isAdding;
  final bool compact;

  @override
  Widget build(BuildContext context) =>
      compact ? _buildCompact(context) : _buildFull(context);

  Widget _buildFull(BuildContext context) {
    final muted = context.colorScheme.onSurfaceVariant;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const AirlineMark(),
              const SizedBox(width: AppSizes.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductText.titleMedium(context, airline, maxLines: 1),
                    ProductText.bodySmall(context, date, color: muted),
                  ],
                ),
              ),
              PriceTag(price),
            ],
          ),
          const SizedBox(height: AppSizes.spacingM),
          Row(
            children: [
              _TimeCity(time: departureTime, city: from),
              const SizedBox(width: AppSizes.spacingS),
              Expanded(
                child: Column(
                  children: [
                    ProductText.labelSmall(context, duration, color: muted),
                    const SizedBox(height: 2),
                    const RouteLine(),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.spacingS),
              _TimeCity(time: arrivalTime, city: to, end: true),
            ],
          ),
          const SizedBox(height: AppSizes.spacingM),
          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  label: LocaleKeys.flight_details.translate,
                  onPressed: onDetails,
                  expand: true,
                ),
              ),
              const SizedBox(width: AppSizes.spacingXs),
              Expanded(
                child: AppButton.primary(
                  label: LocaleKeys.flight_add_to_cart.translate,
                  onPressed: onAddToCart,
                  isLoading: isAdding,
                  expand: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    final muted = context.colorScheme.onSurfaceVariant;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductText.titleMedium(context, '$from → $to', maxLines: 1),
                const SizedBox(height: 2),
                ProductText.bodyMedium(
                  context,
                  '$airline · $date',
                  color: muted,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: ProductText.bodyMedium(
                        context,
                        '$departureTime – $arrivalTime · $duration',
                        color: muted,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PriceTag.small(price),
                  ],
                ),
              ],
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: AppSizes.spacingXs),
            AppIconButton(
              icon: Icons.delete_outline,
              tooltip: LocaleKeys.cart_remove_tooltip.translate,
              onPressed: onRemove,
            ),
          ],
        ],
      ),
    );
  }
}

final class _TimeCity extends StatelessWidget {
  const _TimeCity({required this.time, required this.city, this.end = false});

  final String time;
  final String city;
  final bool end;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        ProductText.titleLarge(
          context,
          time,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        ProductText.bodyMedium(
          context,
          city,
          color: context.colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}

/// Skeleton of [FlightCard.full] for `LoadingState(skeleton: ...)`.
final class FlightCardSkeleton extends StatelessWidget {
  const FlightCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        children: [
          Row(
            children: [
              ShimmerBox(
                width: 40,
                height: 40,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              SizedBox(width: AppSizes.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 120, height: 14),
                    SizedBox(height: AppSizes.spacingXs),
                    ShimmerBox(width: 72, height: 12),
                  ],
                ),
              ),
              ShimmerBox(width: 64, height: 24),
            ],
          ),
          SizedBox(height: AppSizes.spacingM),
          Row(
            children: [
              ShimmerBox(width: 56, height: 36),
              SizedBox(width: AppSizes.spacingS),
              Expanded(child: ShimmerBox(height: 8)),
              SizedBox(width: AppSizes.spacingS),
              ShimmerBox(width: 56, height: 36),
            ],
          ),
          SizedBox(height: AppSizes.spacingM),
          Row(
            children: [
              Expanded(
                child: ShimmerBox(height: 48, borderRadius: AppRadius.medium),
              ),
              SizedBox(width: AppSizes.spacingXs),
              Expanded(
                child: ShimmerBox(height: 48, borderRadius: AppRadius.medium),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
