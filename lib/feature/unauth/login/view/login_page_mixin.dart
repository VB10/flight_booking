part of '../login_page.dart';

/// Login ekranı: controller yaşam döngüsü ve aksiyonlar.
mixin LoginPageMixin on State<LoginPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  late final LoginCubit loginCubit = LoginCubit(
    ProductContainer.instance.get<IAuthService>(),
    ProductContainer.instance.get<IProductNetworkManager>(),
  );

  void navigateToFlightList() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const FlightListPage()),
    );
  }

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
}
