import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_radius.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';
import 'package:ui_kit/src/theme/app_theme_extension.dart';

enum AppButtonVariant { primary, secondary, text, warning }

/// Kit `AppButton` — primary / secondary / text (+ warning for the
/// "Update Required" dialog). Height 48, radiusMedium, labelLarge.
///
/// States: default, pressed (ripple), loading ([isLoading]), disabled
/// ([onPressed] == null).
final class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    super.key,
  });

  const AppButton.primary({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    super.key,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    super.key,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.text({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    super.key,
  }) : variant = AppButtonVariant.text;

  const AppButton.warning({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    super.key,
  }) : variant = AppButtonVariant.warning;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  /// Full width (`width: 100%` in the kit).
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ext = context.appTheme;
    final (Color bg, Color fg) = switch (variant) {
      AppButtonVariant.primary => (scheme.primary, scheme.onPrimary),
      AppButtonVariant.secondary => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      AppButtonVariant.text => (Colors.transparent, scheme.primary),
      AppButtonVariant.warning => (ext.warning, ext.onWarning),
    };
    final isText = variant == AppButtonVariant.text;

    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size(64, AppSizes.buttonHeightMedium),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: isText ? 16 : AppSizes.spacingXl),
      ),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.medium),
      ),
      textStyle: WidgetStatePropertyAll(
        Theme.of(context).textTheme.labelLarge,
      ),
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (isText) return Colors.transparent;
        if (states.contains(WidgetState.disabled)) {
          return scheme.onSurface.withValues(alpha: 0.12);
        }
        return bg;
      }),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? scheme.onSurface.withValues(alpha: 0.38)
            : fg,
      ),
      overlayColor: WidgetStatePropertyAll(fg.withValues(alpha: 0.14)),
    );

    final child = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: fg),
          )
        else if (icon != null)
          Icon(icon, size: 20),
        if (isLoading || icon != null)
          const SizedBox(width: AppSizes.spacingXs),
        Flexible(
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );

    final button = TextButton(
      onPressed: isLoading ? () {} : onPressed,
      style: style,
      child: child,
    );

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: isLoading ? label : null,
      child: expand ? SizedBox(width: double.infinity, child: button) : button,
    );
  }
}
