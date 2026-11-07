part of '../../profile_page.dart';

class _ProfilePageBody extends StatelessWidget {
  const _ProfilePageBody({
    required this.onRetry,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  final VoidCallback onRetry;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<Locales> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        switch (state.status) {
          case ProfileStatus.loading:
            return const _ProfileLoading();
          case ProfileStatus.failure:
            return ErrorState(
              title: LocaleKeys.profile_error_title.translate,
              message: LocaleKeys.profile_error_message.translate,
              retryLabel: LocaleKeys.general_retry.translate,
              onRetry: onRetry,
            );
          case ProfileStatus.success:
            if (profile == null) return const _ProfileLoading();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProfileContent(profile: profile),
                  const SizedBox(height: AppSizes.spacingM),
                  _ProfileSettings(
                    onThemeChanged: onThemeChanged,
                    onLocaleChanged: onLocaleChanged,
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
