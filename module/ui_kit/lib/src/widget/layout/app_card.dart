import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_radius.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';
import 'package:ui_kit/src/theme/app_theme_extension.dart';

/// Kit card surface (`.cd`) — cardBackground, 1px outlineVariant border,
/// radiusMedium, padding 16. Base of FlightCard, StatTile, history rows.
final class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSizes.spacingM),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appTheme.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.medium,
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
