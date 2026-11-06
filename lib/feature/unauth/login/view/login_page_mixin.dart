part of '../login_page.dart';

/// Login ekranı: controller yaşam döngüsü ve aksiyonlar.
mixin LoginPageMixin on State<LoginPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  late final LoginCubit loginCubit = LoginCubit(
    ProductContainer.instance.get<IAuthService>(),
    ProductContainer.instance.get<AuthCubit>(),
  );

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onLoginPressed(BuildContext context) {
    unawaited(
      loginCubit.login(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
  }

  /// "Show test account" also fills the form, so the demo account is one tap
  /// away instead of retyped.
  void onShowTestAccount() {
    emailController.text = _TestAccount.email;
    passwordController.text = _TestAccount.password;
    loginCubit.clearFieldErrors();
  }
}
