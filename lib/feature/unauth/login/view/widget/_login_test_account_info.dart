part of '../../login_page.dart';

/// Test account info widget
final class _LoginTestAccountInfo extends StatelessWidget {
  const _LoginTestAccountInfo();

  @override
  Widget build(BuildContext context) {
    // TODO: Code gen ile localization
    return ProductText.bodySmall(
      context,
      'Test hesabı: user@test.com / 123456',
      color: context.colorScheme.onSurface,
    );
  }
}
