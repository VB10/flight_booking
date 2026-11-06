import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_theme_extension.dart';

/// Semantic tone shared by StatusBadge, AppSnackbar, InfoBanner and the state
/// icons. Each tone is a tonal container + its on-color.
enum AppTone { neutral, success, warning, info, error, brand }

extension AppToneColors on AppTone {
  /// `(container, onContainer)` for this tone in the current theme.
  (Color, Color) colors(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appTheme;
    return switch (this) {
      AppTone.neutral => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
      AppTone.success => (ext.successContainer, ext.onSuccessContainer),
      AppTone.warning => (ext.warningContainer, ext.onWarningContainer),
      AppTone.info => (ext.infoContainer, ext.onInfoContainer),
      AppTone.error => (scheme.errorContainer, scheme.onErrorContainer),
      AppTone.brand => (scheme.secondaryContainer, scheme.onSecondaryContainer),
    };
  }

  IconData get defaultIcon => switch (this) {
    AppTone.neutral => Icons.info_outline,
    AppTone.success => Icons.check_circle_outline,
    AppTone.warning => Icons.warning_amber_rounded,
    AppTone.info => Icons.info_outline,
    AppTone.error => Icons.error_outline,
    AppTone.brand => Icons.info_outline,
  };
}
