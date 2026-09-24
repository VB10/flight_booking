part of '../../login_page.dart';

/// Demo credentials served by the sample backend. They are **data**, not
/// translatable content, so they are injected into the key as named args
/// instead of being baked into every language file.
abstract final class _TestAccount {
  static const String email = 'user@test.com';
  static const String password = '123456';
}

/// Test account info widget
final class _LoginTestAccountInfo extends StatelessWidget {
  const _LoginTestAccountInfo();

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      LocaleKeys.login_test_account_info.translateNamed({
        'email': _TestAccount.email,
        'password': _TestAccount.password,
      }),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface,
          ),
    );
  }
}
