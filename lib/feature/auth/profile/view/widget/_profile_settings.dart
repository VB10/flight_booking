part of '../../profile_page.dart';

/// Settings section (moved from the Flights top bar): theme + language.
class _ProfileSettings extends StatelessWidget {
  const _ProfileSettings({
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<Locales> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProductText.labelMedium(
          context,
          LocaleKeys.profile_settings.translate.toUpperCase(),
          color: context.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: AppSizes.spacingXs),
        AppCard(
          child: BlocBuilder<ApplicationCubit, ApplicationState>(
            builder: (context, state) {
              return Column(
                children: [
                  SettingsRow(
                    icon: Icons.dark_mode_outlined,
                    title: LocaleKeys.profile_dark_theme.translate,
                    trailing: AppSwitch(
                      value: state.themeMode == ThemeMode.dark,
                      onChanged: onThemeChanged,
                      semanticLabel: LocaleKeys.profile_dark_theme.translate,
                    ),
                  ),
                  const Divider(),
                  SettingsRow(
                    icon: Icons.language,
                    title: LocaleKeys.profile_language.translate,
                    trailing: SegmentedToggle<Locales>(
                      options: {
                        Locales.en: Locales.en.code.toUpperCase(),
                        Locales.tr: Locales.tr.code.toUpperCase(),
                      },
                      selected: state.locale,
                      onChanged: onLocaleChanged,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
