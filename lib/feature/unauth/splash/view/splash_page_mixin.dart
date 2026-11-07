part of '../splash_page.dart';

/// Splash: cubit creation, start-up trigger and one-shot effects.
mixin SplashPageMixin on State<SplashPage> {
  late final SplashCubit splashCubit = SplashCubit(
    ProductContainer.instance.get<AuthCubit>(),
    ProductContainer.instance.get<IAppUpdateService>(),
  );

  @override
  void initState() {
    super.initState();
    unawaited(splashCubit.start());
  }

  @override
  void dispose() {
    unawaited(splashCubit.close());
    super.dispose();
  }

  void onStatusChanged(BuildContext context, SplashState state) {
    switch (state.status) {
      case SplashStatus.checking:
        break;
      case SplashStatus.updateRequired:
        unawaited(_showUpdateDialog(context, state));
      case SplashStatus.ready:
        if (state.isLoggedIn) {
          const FlightListRoute().go(context);
        } else {
          const LoginRoute().go(context);
        }
    }
  }

  Future<void> _showUpdateDialog(
    BuildContext context,
    SplashState state,
  ) async {
    final confirmed = await AppDialog.show(
      context,
      title: LocaleKeys.flight_update_required_title.translate,
      message: state.updateMessage.isEmpty
          ? LocaleKeys.flight_update_required_message.translate
          : state.updateMessage,
      confirmLabel: LocaleKeys.flight_update.translate,
      cancelLabel: state.forceUpdate
          ? null
          : LocaleKeys.general_later.translate,
      variant: AppDialogVariant.warning,
      barrierDismissible: !state.forceUpdate,
    );
    // No store URL / url_launcher in the project yet: "Update" cannot open
    // the store. A forced update must stay blocking, so the dialog comes back
    // (same as the legacy page, which never let the user through).
    if (!context.mounted) return;
    if (state.forceUpdate) {
      unawaited(_showUpdateDialog(context, state));
      return;
    }
    if (confirmed ?? false) {
      // TODO(v13): open the store once a store URL / url_launcher exists.
    }
    splashCubit.continueAfterUpdate();
  }
}
