import 'package:flutter/material.dart';

enum PriceTagSize { small, medium, large }

/// Kit `PriceTag` — primary, weight 700 (the one sanctioned weight override).
/// small: titleMedium size · medium: titleLarge · large: 32/40.
///
/// [price] is already formatted by the app (e.g. "1.250 ₺").
final class PriceTag extends StatelessWidget {
  const PriceTag(this.price, {this.size = PriceTagSize.medium, super.key});

  const PriceTag.small(this.price, {super.key}) : size = PriceTagSize.small;

  const PriceTag.large(this.price, {super.key}) : size = PriceTagSize.large;

  final String price;
  final PriceTagSize size;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final base = switch (size) {
      PriceTagSize.small => text.titleMedium,
      PriceTagSize.medium => text.titleLarge,
      PriceTagSize.large => text.headlineLarge,
    };
    return Text(
      price,
      maxLines: 1,
      softWrap: false,
      style: base?.copyWith(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
