import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';

/// Kit `InfoRow` — 40px icon circle (primaryContainer), label in bodyMedium
/// onSurfaceVariant, value in labelLarge, optional divider. Height 52.
final class InfoRow extends StatelessWidget {
  const InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: scheme.primaryContainer,
                  foregroundColor: scheme.onPrimaryContainer,
                  child: Icon(icon, size: 20),
                ),
                const SizedBox(width: AppSizes.spacingM),
                Expanded(
                  child: Text(
                    label,
                    style: text.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spacingXs),
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: text.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(),
      ],
    );
  }
}
