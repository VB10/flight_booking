import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';

/// Icon action used in `AppTopBar` and rows. 48 × 48 target,
/// `onSurfaceVariant`, always carries a [tooltip] (also the semantics label).
final class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: AppSizes.iconMedium),
      tooltip: tooltip,
      onPressed: onPressed,
      color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
      constraints: const BoxConstraints.tightFor(
        width: AppSizes.iconButton,
        height: AppSizes.iconButton,
      ),
    );
  }
}
