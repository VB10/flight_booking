import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';

/// Pinned bottom bar — surface, outlineVariant top border, padding 16 / 20,
/// respects the bottom safe area. Used by Detail ("Add to Cart") and as the
/// shell of [SummaryBar]-like bars.
final class BottomActionBar extends StatelessWidget {
  const BottomActionBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.pagePadding,
            vertical: AppSizes.spacingM,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Kit `SummaryBar` — "Total:" label + PriceTag + primary action, on a
/// [BottomActionBar].
final class SummaryBar extends StatelessWidget {
  const SummaryBar({
    required this.label,
    required this.price,
    required this.action,
    super.key,
  });

  /// e.g. "Total:".
  final String label;

  /// Usually a `PriceTag.large`.
  final Widget price;

  /// Usually an `AppButton.primary` ("Pay").
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BottomActionBar(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style:
                      Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                price,
              ],
            ),
          ),
          const SizedBox(width: AppSizes.spacingM),
          action,
        ],
      ),
    );
  }
}
