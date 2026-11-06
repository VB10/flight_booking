import 'package:flutter/material.dart';
import 'package:ui_kit/src/widget/layout/app_card.dart';

/// Kit `StatTile` — card, value in headlineSmall, label in bodySmall.
final class StatTile extends StatelessWidget {
  const StatTile({required this.value, required this.label, super.key});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: text.headlineSmall, maxLines: 1),
          const SizedBox(height: 4),
          Text(
            label,
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
