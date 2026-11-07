part of '../profile_page.dart';

/// Profile screen: profile cubit, back / log out actions. Theme and language
/// live in the app-wide [ApplicationCubit].
mixin ProfilePageMixin on State<ProfilePage> {
  ApplicationCubit get applicationCubit =>
      ProductContainer.instance.get<ApplicationCubit>();

  late final ProfileCubit profileCubit = ProfileCubit(
    ProductContainer.instance.get<IAuthService>(),
  );

  @override
  void initState() {
    super.initState();
    unawaited(profileCubit.load());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onBackPressed(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      const FlightListRoute().go(context);
    }
  }

  Future<void> onLogoutPressed(BuildContext context) async {
    final confirmed = await AppDialog.show(
      context,
      title: LocaleKeys.flight_logout.translate,
      message: LocaleKeys.flight_logout_confirm.translate,
      confirmLabel: LocaleKeys.flight_logout.translate,
      cancelLabel: LocaleKeys.general_cancel.translate,
    );
    if (confirmed != true) return;
    await ProductContainer.instance.get<AuthCubit>().logout();
  }
}
