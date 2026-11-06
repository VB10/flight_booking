import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_radius.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';
import 'package:ui_kit/src/widget/display/app_tone.dart';

/// Kit `StatusBadge` — height 28, radiusSmall, labelMedium, tonal fill
/// (e.g. membership "Gold" = warning, "Confirmed" = success).
final class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    this.tone = AppTone.neutral,
    this.icon,
    super.key,
  });

  final String label;
  final AppTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = tone.colors(context);
    return Container(
      height: AppSizes.statusBadgeHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.small),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSizes.iconSmall, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            maxLines: 1,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
