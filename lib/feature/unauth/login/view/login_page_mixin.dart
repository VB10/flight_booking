part of '../login_page.dart';

mixin LoginPageMixin on State<LoginPage> {
  // ViewModel
  late final LoginViewModel _viewModel;

  // Controllers
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  // UI State with ValueNotifier
  late final ValueNotifier<LoginPageState> state;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    state = ValueNotifier(const LoginPageState());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    state.dispose();
    super.dispose();
  }

  Future<void> onLoginPressed() async {
    state.value = state.value.copyWith(
      isLoading: true,
      errorMessage: '',
    );

    try {
      final response = await _viewModel.login(
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.success) {
        await _viewModel.saveUserToCache(response);
        await _viewModel.logSuccessfulLogin(response);

        if (!mounted) return;
        state.value = state.value.copyWith(isLoading: false);

        await Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(builder: (_) => FlightListPage()),
        );
      } else {
        state.value = state.value.copyWith(
          isLoading: false,
          errorMessage: response.message,
        );
      }
    } on Exception catch (e) {
      state.value = state.value.copyWith(
        isLoading: false,
        errorMessage: 'Bağlantı hatası: $e',
      );
    }
  }
}
