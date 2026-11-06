import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/product/widget/flight/route_line.dart';
import 'package:flutter/material.dart';

/// Kit `RouteVisual` — Detail hero: primaryContainer, radiusLarge,
/// padding 20. Airport codes in headlineLarge (w500) over the city
/// (bodyMedium); the route line and duration in between.
///
/// Codes are NEW DATA (`airportCode`); when missing, the city takes the
/// code's place so the hero still reads.
final class RouteVisual extends StatelessWidget {
  const RouteVisual({
    required this.fromCity,
    required this.toCity,
    this.fromCode,
    this.toCode,
    this.caption,
    super.key,
  });

  final String fromCity;
  final String toCity;
  final String? fromCode;
  final String? toCode;

  /// Small text above the line, e.g. the duration.
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final fg = scheme.onPrimaryContainer;
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacingL),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: AppRadius.large,
      ),
      child: Row(
        children: [
          _End(code: fromCode, city: fromCity, color: fg),
          const SizedBox(width: AppSizes.spacingS),
          Expanded(
            child: Column(
              children: [
                if (caption != null)
                  ProductText.labelSmall(context, caption!, color: fg),
                const SizedBox(height: 2),
                RouteLine(color: fg, lineColor: fg.withValues(alpha: 0.4)),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.spacingS),
          _End(code: toCode, city: toCity, color: fg, end: true),
        ],
      ),
    );
  }
}

final class _End extends StatelessWidget {
  const _End({
    required this.code,
    required this.city,
    required this.color,
    this.end = false,
  });

  final String? code;
  final String city;
  final Color color;
  final bool end;

  @override
  Widget build(BuildContext context) {
    final text = context.appTextTheme;
    return Column(
      crossAxisAlignment: end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (code != null)
          Text(
            code!,
            style: text.headlineLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        Text(
          city,
          style: (code != null ? text.bodyMedium : text.titleLarge)?.copyWith(
            color: color,
          ),
        ),
      ],
    );
  }
}
