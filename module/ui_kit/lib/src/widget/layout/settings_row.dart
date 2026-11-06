import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';

/// Kit `SettingsRow` — icon + title (+ optional subtitle) + trailing control,
/// height 60. Trailing is usually [AppSwitch] or [SegmentedToggle].
final class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.title,
    required this.trailing,
    this.icon,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 60),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: AppSizes.iconMedium,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSizes.spacingM),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: text.bodyLarge),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: text.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.spacingXs),
          trailing,
        ],
      ),
    );
  }
}

/// Kit `AppSwitch` — themed Material 3 switch with a semantics label.
final class AppSwitch extends StatelessWidget {
  const AppSwitch({
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      toggled: value,
      child: Switch(value: value, onChanged: onChanged),
    );
  }
}

/// Kit `SegmentedToggle` — single-select segments (e.g. EN / TR), height 44,
/// outline border, secondaryContainer selected.
final class SegmentedToggle<T> extends StatelessWidget {
  const SegmentedToggle({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  /// value → label, in display order.
  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      showSelectedIcon: false,
      segments: [
        for (final e in options.entries)
          ButtonSegment<T>(value: e.key, label: Text(e.value)),
      ],
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}
