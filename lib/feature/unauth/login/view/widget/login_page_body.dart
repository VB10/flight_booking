part of '../../login_page.dart';

/// Ana body widget
final class _LoginPageBody extends StatelessWidget {
  const _LoginPageBody({
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

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
          _LoginPasswordField(controller: passwordController),
          const SizedBox(height: AppSizes.spacingS),
          _LoginStateSection(onLogin: onLogin),
          const SizedBox(height: AppSizes.spacingM),
          const _LoginTestAccountButtonSection(),
        ],
      ),
    );
  }
}

/// İç buton + test bilgisi: kendi ValueNotifier'ını yönetir
final class _LoginTestAccountButtonSection extends StatefulWidget {
  const _LoginTestAccountButtonSection();

  @override
  State<_LoginTestAccountButtonSection> createState() =>
      _LoginTestAccountButtonSectionState();
}

class _LoginTestAccountButtonSectionState
    extends State<_LoginTestAccountButtonSection> {
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
          children: [
            OutlinedButton.icon(
              onPressed: () => expandedNotifier.value = !expandedNotifier.value,
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

/// Password field — kendi ValueNotifier'ını yönetir (setState yok)
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
    return ValueListenableBuilder<bool>(
      valueListenable: obscureNotifier,
      builder: (context, obscure, _) {
        return TextField(
          controller: widget.controller,
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
              onPressed: () => obscureNotifier.value = !obscureNotifier.value,
            ),
          ),
        );
      },
    );
  }
}

/// Error text widget — BlocSelector ile sadece errorMessage dinler
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

/// Login button widget — BlocSelector ile sadece isLoading dinler
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
