part of '../../splash_page.dart';

/// 96x96 rounded brand square with the aircraft glyph.
final class _SplashAppMark extends StatelessWidget {
  const _SplashAppMark();

  static const double _glyphSize = 56;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.stateIllustration,
      height: AppSizes.stateIllustration,
      decoration: BoxDecoration(
        color: context.appTheme.brandPrimary,
        borderRadius: AppRadius.large,
      ),
      child: Icon(
        Icons.flight,
        size: _glyphSize,
        color: context.colorScheme.surface,
      ),
    );
  }
}
