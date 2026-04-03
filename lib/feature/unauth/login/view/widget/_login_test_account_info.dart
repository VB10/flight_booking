part of '../../login_page.dart';

/// Test account info widget
final class _LoginTestAccountInfo extends StatelessWidget {
  const _LoginTestAccountInfo();

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      'Test hesabı: user@test.com / 123456',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface,
          ),
    );
  }
}
