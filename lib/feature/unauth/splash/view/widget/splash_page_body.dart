part of '../../splash_page.dart';

final class _SplashPageBody extends StatelessWidget {
  const _SplashPageBody();

  static const double _progressWidth = 120;
  static const double _progressHeight = 4;
  static const double _bottomGap = 120;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _SplashAppMark(),
                const SizedBox(height: AppSizes.spacingXl),
                ProductText.h1(
                  context,
                  LocaleKeys.general_app_name.translate,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                ProductText.bodyLarge(
                  context,
                  LocaleKeys.general_app_tagline.translate,
                  color: colorScheme.onSurfaceVariant,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: _bottomGap,
          child: Center(
            child: SizedBox(
              width: _progressWidth,
              height: _progressHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_progressHeight / 2),
                child: LinearProgressIndicator(
                  color: colorScheme.primary,
                  backgroundColor: colorScheme.outlineVariant,
                  semanticsLabel: LocaleKeys.splash_loading.translate,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
