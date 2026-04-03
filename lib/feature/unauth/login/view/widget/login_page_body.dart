part of '../../login_page.dart';

/// Ana body widget
final class _LoginPageBody extends StatelessWidget {
  const _LoginPageBody({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.testAccountExpanded,
    required this.onLogin,
    required this.onToggleTestAccount,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueNotifier<bool> obscurePassword;
  final ValueNotifier<bool> testAccountExpanded;
  final VoidCallback onLogin;
  final VoidCallback onToggleTestAccount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppPagePadding.all20(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _LoginLogo(),
          const SizedBox(height: AppSizes.spacingL),
          _LoginEmailField(controller: emailController),
          const SizedBox(height: AppSizes.spacingL),
          _LoginPasswordField(
            controller: passwordController,
            obscurePassword: obscurePassword,
          ),
          const SizedBox(height: AppSizes.spacingS),
          _LoginStateSection(onLogin: onLogin),
          const SizedBox(height: AppSizes.spacingM),
          _LoginTestAccountButtonSection(
            testAccountExpanded: testAccountExpanded,
            onToggle: onToggleTestAccount,
          ),
        ],
      ),
    );
  }
}

/// İç buton + test bilgisi: tek ValueListenableBuilder (setState yok)
final class _LoginTestAccountButtonSection extends StatelessWidget {
  const _LoginTestAccountButtonSection({
    required this.testAccountExpanded,
    required this.onToggle,
  });

  final ValueNotifier<bool> testAccountExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: testAccountExpanded,
      builder: (context, expanded, _) {
        return Column(
          children: [
            OutlinedButton.icon(
              onPressed: onToggle,
              icon: Icon(
                expanded ? Icons.expand_less : Icons.expand_more,
                color: context.colorScheme.primary,
              ),
              label: ProductText.labelLarge(
                context,
                expanded ? 'Test bilgisini gizle' : 'Test hesabını göster',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
            ),
            if (expanded) ...[
              const SizedBox(height: AppSizes.spacingS),
              const _LoginTestAccountInfo(),
            ],
          ],
        );
      },
    );
  }
}

/// Cubit state: hata + yükleme + buton
final class _LoginStateSection extends StatelessWidget {
  const _LoginStateSection({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _LoginErrorText(),
        const SizedBox(height: AppSizes.spacingL),
        _LoginButton(
          onPressed: onLogin,
        ),
      ],
    );
  }
}

/// Logo widget
final class _LoginLogo extends StatelessWidget {
  const _LoginLogo();

  static const double _logoSize = 120;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/undraw_aircraft_usu4.svg',
      width: _logoSize,
      height: _logoSize,
    );
  }
}

/// Email field widget
final class _LoginEmailField extends StatelessWidget {
  const _LoginEmailField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Email',
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          Icons.email,
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}

/// Password field — şifre görünürlüğü ValueListenable ile (setState yok)
final class _LoginPasswordField extends StatelessWidget {
  const _LoginPasswordField({
    required this.controller,
    required this.obscurePassword,
  });

  final TextEditingController controller;
  final ValueNotifier<bool> obscurePassword;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscurePassword,
      builder: (context, obscure, _) {
        return TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(
              Icons.lock,
              color: context.colorScheme.primary,
            ),
            suffixIcon: IconButton(
              tooltip: obscure ? 'Göster' : 'Gizle',
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: context.colorScheme.primary,
              ),
              onPressed: () => obscurePassword.value = !obscurePassword.value,
            ),
          ),
        );
      },
    );
  }
}

/// Error text widget
final class _LoginErrorText extends StatelessWidget {
  const _LoginErrorText();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginCubit, LoginState, String>(
      selector: (state) {
        return state.errorMessage;
      },
      builder: (context, state) {
        if (state.isEmpty) return const SizedBox.shrink();
        return ProductText.bodySmall(
          context,
          state,
          color: context.colorScheme.error,
        );
      },
    );
  }
}

/// Login button widget
final class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LoginCubit, LoginState, bool>(
      selector: (state) {
        return state.isLoading;
      },
      builder: (context, state) {
        if (state) return const CircularProgressIndicator();
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.appTheme.brandPrimary,
          ),
          child: Center(
            child: ProductText.bodyMedium(
              context,
              'Login',
              color: context.colorScheme.onPrimary,
            ),
          ),
        );
      },
    );
  }
}
