import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';
import 'package:ui_kit/src/widget/button/app_button.dart';
import 'package:ui_kit/src/widget/display/app_tone.dart';

enum AppDialogVariant { confirm, warning }

/// Kit `AppDialog` — surfaceContainerHighest, radiusLarge, padding 24,
/// headlineSmall + bodyMedium, actions right-aligned (text cancel + primary
/// confirm). The warning variant adds a warningContainer icon and a warning
/// confirm button ("Update Required").
///
/// Open it with [AppDialog.show]; it resolves `true` on confirm, `false` on
/// cancel and `null` when dismissed.
final class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.cancelLabel,
    this.variant = AppDialogVariant.confirm,
    this.icon,
    super.key,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String? cancelLabel;
  final AppDialogVariant variant;
  final IconData? icon;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
    AppDialogVariant variant = AppDialogVariant.confirm,
    IconData? icon,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AppDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        variant: variant,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWarning = variant == AppDialogVariant.warning;
    final (bg, fg) = AppTone.warning.colors(context);
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingXXl),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSizes.spacingXl,
        AppSizes.spacingM,
        AppSizes.spacingXl,
        0,
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        AppSizes.spacingXl,
        AppSizes.spacingXl,
        AppSizes.spacingXl,
        0,
      ),
      actionsPadding: const EdgeInsets.all(AppSizes.spacingXl),
      icon: isWarning || icon != null
          ? CircleAvatar(
              radius: 24,
              backgroundColor: isWarning
                  ? bg
                  : Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: isWarning
                  ? fg
                  : Theme.of(context).colorScheme.onPrimaryContainer,
              child: Icon(icon ?? Icons.system_update),
            )
          : null,
      title: Text(title),
      content: Text(message),
      actions: [
        if (cancelLabel != null)
          AppButton.text(
            label: cancelLabel!,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        if (isWarning)
          AppButton.warning(
            label: confirmLabel,
            onPressed: () => Navigator.of(context).pop(true),
          )
        else
          AppButton.primary(
            label: confirmLabel,
            onPressed: () => Navigator.of(context).pop(true),
          ),
      ],
    );
  }
}
