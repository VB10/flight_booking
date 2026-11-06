import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';
import 'package:ui_kit/src/widget/display/app_tone.dart';

/// 96px tonal circle with a 40px icon — the illustration of EmptyState
/// (brand), ErrorState (error) and the booking confirmation (success).
final class StateIcon extends StatelessWidget {
  const StateIcon({required this.icon, required this.tone, super.key});

  final IconData icon;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = tone.colors(context);
    return Container(
      width: AppSizes.stateIllustration,
      height: AppSizes.stateIllustration,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, size: 40, color: fg),
    );
  }
}

/// Shared layout of the full-page states: icon, titleMedium, bodyMedium,
/// optional action, gap 16, horizontal padding 32, centered.
final class StateMessage extends StatelessWidget {
  const StateMessage({
    required this.icon,
    required this.tone,
    required this.title,
    this.message,
    this.action,
    super.key,
  });

  final IconData icon;
  final AppTone tone;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingXXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StateIcon(icon: icon, tone: tone),
            const SizedBox(height: AppSizes.spacingM),
            Text(title, style: text.titleMedium, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: AppSizes.spacingXs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSizes.spacingXl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
