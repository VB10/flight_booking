import 'package:flutter/material.dart';
import 'package:ui_kit/src/widget/button/app_icon_button.dart';
import 'package:ui_kit/src/widget/input/app_text_field.dart';

/// Kit `AppSearchField` — `AppTextField` tokens with a leading search icon.
/// Shows a clear button while [controller] has text.
final class AppSearchField extends StatelessWidget {
  const AppSearchField({
    required this.hintText,
    required this.controller,
    required this.clearTooltip,
    this.onChanged,
    super.key,
  });

  final String hintText;
  final TextEditingController controller;

  /// Semantics label of the clear button, e.g. "Clear search".
  final String clearTooltip;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) => AppTextField(
        hintText: hintText,
        controller: controller,
        leadingIcon: Icons.search,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
        trailing: value.text.isEmpty
            ? null
            : AppIconButton(
                icon: Icons.close,
                tooltip: clearTooltip,
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                },
              ),
      ),
    );
  }
}
