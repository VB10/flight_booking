import 'package:flutter/material.dart';
import 'package:ui_kit/src/widget/display/app_tone.dart';

/// Kit `AppSnackbar` — success / error / info / warning tonal snackbar,
/// radiusSmall, margin 20, 24 from the bottom, optional action (e.g. "Undo").
///
/// Show it with [AppSnackbar.show]; it replaces the current snackbar.
final class AppSnackbar {
  AppSnackbar._();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context, {
    required String message,
    AppTone tone = AppTone.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    final (bg, fg) = tone.colors(context);
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    return messenger.showSnackBar(
      SnackBar(
        backgroundColor: bg,
        duration: duration,
        content: Row(
          children: [
            Icon(tone.defaultIcon, size: 20, color: fg),
            const SizedBox(width: 12),
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
        action: actionLabel == null
            ? null
            : SnackBarAction(
                label: actionLabel,
                textColor: fg,
                onPressed: onAction ?? () {},
              ),
      ),
    );
  }
}
