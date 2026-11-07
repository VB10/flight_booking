import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_radius.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';

/// Kit `LoadingOverlay` — blocking scrim with a surfaceContainerHighest card,
/// primary spinner and a message ("Processing payment..."). Put it over the
/// page with [visible]; it absorbs every touch while shown.
final class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.visible,
    required this.message,
    required this.child,
    super.key,
  });

  final bool visible;
  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        child,
        if (visible)
          Positioned.fill(
            child: ColoredBox(
              color: scheme.scrim,
              child: Center(
                child: Semantics(
                  liveRegion: true,
                  label: message,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacingXXl,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacingXl,
                      vertical: AppSizes.spacingL,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: AppRadius.large,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                        const SizedBox(width: AppSizes.spacingM),
                        Flexible(
                          child: Text(
                            message,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
