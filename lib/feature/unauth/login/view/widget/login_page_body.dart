part of '../../login_page.dart';

/// Ana body widget
final class _LoginPageBody extends StatelessWidget {
  const _LoginPageBody({
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.onShowTestAccount,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

  /// Fills email + password with the demo account.
  final VoidCallback onShowTestAccount;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const AppPagePadding.all20(),
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _LoginIllustration(),
              const SizedBox(height: AppSizes.spacingM),
              const _LoginHeader(),
              const SizedBox(height: AppSizes.spacingM),
              _LoginEmailField(controller: emailController),
              const SizedBox(height: AppSizes.spacingM),
              _LoginPasswordField(controller: passwordController),
              const SizedBox(height: AppSizes.spacingM),
              _LoginButton(onPressed: onLogin),
              const SizedBox(height: AppSizes.spacingXs),
              _LoginTestAccountSection(onShow: onShowTestAccount),
            ],
          ),
        ),
      ),
    );
  }
}

/// Top illustration box.
final class _LoginIllustration extends StatelessWidget {
  const _LoginIllustration();

  static const double _height = 196;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: AppRadius.large,
      ),
      padding: const AppPagePadding.all16(),
      child: Assets.icon.svg.icConnectedWorld.svg(),
    );
  }
}

/// Title + subtitle.
final class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductText.h1(context, LocaleKeys.login_title.translate),
        const SizedBox(height: 4),
        ProductText.bodyMedium(
          context,
          LocaleKeys.login_subtitle.translate,
          color: context.colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}

/// Email field — listens only to its error and the loading flag.
final class _LoginEmailField extends StatelessWidget {
  const _LoginEmailField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (p, c) =>
          p.emailError != c.emailError || p.isLoading != c.isLoading,
      builder: (context, state) {
        return AppTextField(
          controller: controller,
          label: LocaleKeys.login_email.translate,
          leadingIcon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          errorText: state.emailError.isEmpty ? null : state.emailError,
          enabled: !state.isLoading,
        );
      },
    );
  }
}

/// Password field — owns its obscure toggle through a ValueNotifier.
final class _LoginPasswordField extends StatefulWidget {
  const _LoginPasswordField({required this.controller});

  final TextEditingController controller;

  @override
  State<_LoginPasswordField> createState() => _LoginPasswordFieldState();
}

class _LoginPasswordFieldState extends State<_LoginPasswordField> {
  late final ValueNotifier<bool> obscureNotifier;

  @override
  void initState() {
    super.initState();
    obscureNotifier = ValueNotifier(true);
  }

  @override
  void dispose() {
    obscureNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (p, c) =>
          p.passwordError != c.passwordError || p.isLoading != c.isLoading,
      builder: (context, state) {
        return ValueListenableBuilder<bool>(
          valueListenable: obscureNotifier,
          builder: (context, obscure, _) {
            return AppTextField(
              controller: widget.controller,
              label: LocaleKeys.login_password.translate,
              leadingIcon: Icons.lock_outline,
              obscureText: obscure,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              trailingActionLabel: obscure
                  ? LocaleKeys.login_show_password.translate
                  : LocaleKeys.login_hide_password.translate,
              onTrailingAction: () => obscureNotifier.value = !obscure,
              errorText: state.passwordError.isEmpty
                  ? null
                  : state.passwordError,
              enabled: !state.isLoading,
            );
          },
        );
      },
    );
  }
}

/// Primary button — BlocSelector listens only to isLoading.
final class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginCubit, LoginState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) {
        return AppButton.primary(
          label: LocaleKeys.login_submit.translate,
          onPressed: isLoading ? null : onPressed,
          isLoading: isLoading,
          expand: true,
        );
      },
    );
  }
}

/// Test account toggle + banner — own ValueNotifier, no setState.
final class _LoginTestAccountSection extends StatefulWidget {
  const _LoginTestAccountSection({required this.onShow});

  final VoidCallback onShow;

  @override
  State<_LoginTestAccountSection> createState() =>
      _LoginTestAccountSectionState();
}

class _LoginTestAccountSectionState extends State<_LoginTestAccountSection> {
  late final ValueNotifier<bool> expandedNotifier;

  @override
  void initState() {
    super.initState();
    expandedNotifier = ValueNotifier(false);
  }

  @override
  void dispose() {
    expandedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: expandedNotifier,
      builder: (context, expanded, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton.text(
              label: expanded
                  ? LocaleKeys.login_hide_test_account.translate
                  : LocaleKeys.login_show_test_account.translate,
              onPressed: () {
                expandedNotifier.value = !expanded;
                if (!expanded) widget.onShow();
              },
              expand: true,
            ),
            if (expanded) ...[
              const SizedBox(height: AppSizes.spacingXs),
              const _LoginTestAccountInfo(),
            ],
          ],
        );
      },
    );
  }
}
