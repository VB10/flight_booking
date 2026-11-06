import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_radius.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';

/// Kit `AppChip` — filter / sort chip. Height 44, radiusSmall, labelLarge.
/// Selected: secondaryContainer fill · unselected: outline border.
final class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? scheme.secondaryContainer : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.small,
          side: selected ? BorderSide.none : BorderSide(color: scheme.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: AppSizes.chipHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingM),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: fg),
                  const SizedBox(width: AppSizes.spacingXs),
                ],
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: fg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
