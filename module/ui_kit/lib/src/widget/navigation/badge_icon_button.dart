import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';

/// Kit `BadgeIconButton` — icon with a count badge (error / onError,
/// labelSmall). 0 hides the badge, above 9 shows "9+".
final class BadgeIconButton extends StatelessWidget {
  const BadgeIconButton({
    required this.icon,
    required this.count,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final int count;
  final String tooltip;
  final VoidCallback? onPressed;

  static String badgeLabel(int count) => count > 9 ? '9+' : '$count';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      color: scheme.onSurfaceVariant,
      constraints: const BoxConstraints.tightFor(
        width: AppSizes.iconButton,
        height: AppSizes.iconButton,
      ),
      icon: Badge(
        isLabelVisible: count > 0,
        backgroundColor: scheme.error,
        textColor: scheme.onError,
        textStyle: Theme.of(context).textTheme.labelSmall,
        label: Text(badgeLabel(count)),
        child: Icon(icon, size: AppSizes.iconMedium),
      ),
    );
  }
}
