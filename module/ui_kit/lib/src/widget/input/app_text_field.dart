import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/src/theme/app_radius.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';

/// Kit `AppTextField` — outlined, height 56, radiusMedium, bodyLarge.
///
/// States: default, focused (primary 2px), filled, error ([errorText]),
/// disabled ([enabled] false). Optional [leadingIcon] and a text
/// [trailingActionLabel] (e.g. "Show" / "Hide" on the password field).
final class AppTextField extends StatelessWidget {
  const AppTextField({
    this.label,
    this.hintText,
    this.controller,
    this.focusNode,
    this.leadingIcon,
    this.trailingActionLabel,
    this.onTrailingAction,
    this.trailing,
    this.errorText,
    this.helperText,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final IconData? leadingIcon;
  final String? trailingActionLabel;
  final VoidCallback? onTrailingAction;

  /// Custom trailing widget; wins over [trailingActionLabel].
  final Widget? trailing;
  final String? errorText;
  final String? helperText;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide(color: color, width: width),
        );

    var suffix = trailing;
    if (suffix == null && trailingActionLabel != null) {
      suffix = Padding(
        padding: const EdgeInsets.only(right: AppSizes.spacingXs),
        child: TextButton(
          onPressed: enabled ? onTrailingAction : null,
          style: TextButton.styleFrom(
            minimumSize: const Size(0, AppSizes.touchTarget),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.medium,
            ),
            foregroundColor: scheme.primary,
            textStyle: text.labelLarge,
          ),
          child: Text(trailingActionLabel!),
        ),
      );
    }

    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: text.bodyLarge?.copyWith(color: scheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        errorText: errorText,
        helperText: helperText,
        labelStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith(
          (states) => text.bodySmall!.copyWith(
            color: states.contains(WidgetState.error)
                ? scheme.error
                : states.contains(WidgetState.focused)
                ? scheme.primary
                : scheme.onSurfaceVariant,
          ),
        ),
        hintStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        helperStyle: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        errorStyle: text.bodySmall?.copyWith(color: scheme.error),
        prefixIcon: leadingIcon == null
            ? null
            : Icon(leadingIcon, size: AppSizes.iconMedium),
        prefixIconColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.error)
              ? scheme.error
              : scheme.onSurfaceVariant,
        ),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingM,
          vertical: AppSizes.spacingM,
        ),
        constraints: const BoxConstraints(minHeight: AppSizes.textFieldHeight),
        border: border(scheme.outline),
        enabledBorder: border(scheme.outline),
        focusedBorder: border(scheme.primary, 2),
        errorBorder: border(scheme.error, 2),
        focusedErrorBorder: border(scheme.error, 2),
        disabledBorder: border(scheme.onSurface.withValues(alpha: 0.12)),
      ),
    );
  }
}
