import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_radius.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';
import 'package:ui_kit/src/theme/app_theme_extension.dart';
import 'package:ui_kit/src/widget/display/app_tone.dart';

/// Kit `InfoBanner` — tonal box (info by default), radiusMedium, padding 16,
/// gap 10, bodyMedium; the icon takes the tone's accent color (`info` for the
/// info tone). Used for the login test-account helper.
final class InfoBanner extends StatelessWidget {
  const InfoBanner({
    required this.message,
    this.tone = AppTone.info,
    this.icon,
    super.key,
  });

  final String message;
  final AppTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = tone.colors(context);
    final iconColor = _accent(context) ?? fg;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingM),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.medium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? tone.defaultIcon, size: 20, color: iconColor),
          const SizedBox(width: AppSizes.spacingS),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: fg),
            ),
          ),
        ],
      ),
    );
  }

  /// Accent of the tone where the kit defines one (board: `color:var(--info)`).
  Color? _accent(BuildContext context) {
    final ext = context.appTheme;
    final scheme = Theme.of(context).colorScheme;
    return switch (tone) {
      AppTone.info => ext.info,
      AppTone.success => ext.success,
      AppTone.warning => ext.warning,
      AppTone.error => scheme.error,
      AppTone.neutral || AppTone.brand => null,
    };
  }
}
