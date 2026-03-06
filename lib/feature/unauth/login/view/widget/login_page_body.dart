part of '../../login_page.dart';

/// Ana body widget
final class _LoginPageBody extends StatelessWidget {
  const _LoginPageBody({
    required this.emailController,
    required this.passwordController,
    required this.state,
    required this.onLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueNotifier<LoginPageState> state;
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
          _LoginStateSection(state: state, onLogin: onLogin),
          const SizedBox(height: AppSizes.spacingL),
          const _LoginTestAccountInfo(),
        ],
      ),
    );
  }
}

/// State dependent section with ValueListenableBuilder
final class _LoginStateSection extends StatelessWidget {
  const _LoginStateSection({
    required this.state,
    required this.onLogin,
  });

  final ValueNotifier<LoginPageState> state;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LoginPageState>(
      valueListenable: state,
      builder: (context, currentState, _) {
        return Column(
          children: [
            if (currentState.errorMessage.isNotEmpty)
              _LoginErrorText(message: currentState.errorMessage),
            const SizedBox(height: AppSizes.spacingL),
            _LoginButton(
              isLoading: currentState.isLoading,
              onPressed: onLogin,
            ),
          ],
        );
      },
    );
  }
}

/// Logo widget
final class _LoginLogo extends StatelessWidget {
  const _LoginLogo();

  // TODO: AppSizes'a logo boyutu eklenecek
  static const double _logoSize = 120;

  @override
  Widget build(BuildContext context) {
    // TODO: Code gen ile asset path
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
    // TODO: Code gen ile localization
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

/// Password field widget
final class _LoginPasswordField extends StatelessWidget {
  const _LoginPasswordField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    // TODO: Code gen ile localization
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          Icons.lock,
          color: context.colorScheme.primary,
        ),
      ),
      obscureText: true,
    );
  }
}

/// Error text widget
final class _LoginErrorText extends StatelessWidget {
  const _LoginErrorText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ProductText.bodySmall(
      context,
      message,
      color: context.colorScheme.error,
    );
  }
}

/// Login button widget
final class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator();
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.appTheme.brandPrimary,
      ),
      // TODO: Code gen ile localization
      child: Center(
        child: ProductText.bodyMedium(
          context,
          'Login',
          color: context.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
