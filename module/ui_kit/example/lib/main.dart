import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// ui_kit gallery — mirrors `States.dc.html` (page 7 · Component states).
/// Run with `flutter run -d chrome` from this folder.
void main() => runApp(const GalleryApp());

class GalleryApp extends StatefulWidget {
  const GalleryApp({super.key});

  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  final ValueNotifier<ThemeMode> _modeNotifier = ValueNotifier(ThemeMode.light);

  @override
  void dispose() {
    _modeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _modeNotifier,
      builder: (context, mode, _) => MaterialApp(
        title: 'ui_kit gallery',
        debugShowCheckedModeBanner: false,
        theme: UiKitTheme.light(),
        darkTheme: UiKitTheme.dark(),
        themeMode: mode,
        home: _GalleryPage(modeNotifier: _modeNotifier),
      ),
    );
  }
}

class _GalleryPage extends StatelessWidget {
  const _GalleryPage({required this.modeNotifier});

  final ValueNotifier<ThemeMode> modeNotifier;

  @override
  Widget build(BuildContext context) {
    final isDark = modeNotifier.value == ThemeMode.dark;
    return Scaffold(
      appBar: AppTopBar(
        title: 'ui_kit · Component states',
        actions: [
          AppIconButton(
            icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            tooltip: 'Toggle theme',
            onPressed: () =>
                modeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            children: const [
              _Section('AppButton', _Buttons()),
              _Section('AppTextField · AppSearchField', _Fields()),
              _Section('AppTopBar · BadgeIconButton', _Bars()),
              _Section('AppChip · StatusBadge · PriceTag', _Chips()),
              _Section(
                'InfoRow · StatTile · AppAvatar · InfoBanner',
                _Display(),
              ),
              _Section('AppDialog · AppSnackbar', _Feedback()),
              _Section(
                'SettingsRow · AppSwitch · SegmentedToggle',
                _Settings(),
              ),
              _Section('SummaryBar', _Summary()),
              _Section('LoadingState', _Loading()),
              _Section(
                'EmptyState',
                _Sized(
                  EmptyState(
                    title: 'Your cart is empty',
                    message: 'Find a flight and add it to your cart.',
                    icon: Icons.shopping_cart_outlined,
                    actionLabel: 'Browse Flights',
                    onAction: _noop,
                  ),
                ),
              ),
              _Section(
                'ErrorState',
                _Sized(
                  ErrorState(
                    title: 'Connection error',
                    message: 'Check your connection and try again.',
                    retryLabel: 'Try Again',
                    onRetry: _noop,
                  ),
                ),
              ),
              _Section(
                'LoadingOverlay',
                _Sized(
                  LoadingOverlay(
                    visible: true,
                    message: 'Processing payment...',
                    child: SizedBox.expand(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _noop() {}

class _Section extends StatelessWidget {
  const _Section(this.title, this.child);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacingXXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductText.labelLarge(
            context,
            title.toUpperCase(),
            color: context.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.spacingM),
          child,
        ],
      ),
    );
  }
}

class _Sized extends StatelessWidget {
  const _Sized(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: EdgeInsets.zero,
    child: SizedBox(height: 340, child: child),
  );
}

class _Buttons extends StatelessWidget {
  const _Buttons();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: AppSizes.spacingXs,
      runSpacing: AppSizes.spacingXs,
      children: [
        AppButton.primary(label: 'Login', onPressed: _noop),
        AppButton.primary(label: 'Login', isLoading: true, onPressed: _noop),
        AppButton.primary(label: 'Login', onPressed: null),
        AppButton.secondary(label: 'Details', onPressed: _noop),
        AppButton.secondary(label: 'Details', onPressed: null),
        AppButton.text(label: 'Show test account', onPressed: _noop),
        AppButton.warning(label: 'Update', onPressed: _noop),
        AppButton.primary(
          label: 'Add to Cart',
          icon: Icons.add_shopping_cart,
          expand: true,
          onPressed: _noop,
        ),
      ],
    );
  }
}

class _Fields extends StatefulWidget {
  const _Fields();

  @override
  State<_Fields> createState() => _FieldsState();
}

class _FieldsState extends State<_Fields> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppTextField(label: 'Email', leadingIcon: Icons.mail_outline),
        const SizedBox(height: AppSizes.spacingM),
        AppTextField(
          label: 'Password',
          leadingIcon: Icons.lock_outline,
          obscureText: true,
          controller: TextEditingController(text: 'secret12'),
          trailingActionLabel: 'Show',
          onTrailingAction: _noop,
        ),
        const SizedBox(height: AppSizes.spacingM),
        const AppTextField(
          label: 'Email',
          leadingIcon: Icons.mail_outline,
          errorText: 'Enter a valid email',
        ),
        const SizedBox(height: AppSizes.spacingM),
        const AppTextField(label: 'Email', enabled: false),
        const SizedBox(height: AppSizes.spacingM),
        AppSearchField(
          hintText: 'Search city or airline',
          controller: _search,
          clearTooltip: 'Clear search',
        ),
      ],
    );
  }
}

class _Bars extends StatelessWidget {
  const _Bars();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          AppTopBar(
            title: 'Flights',
            actions: [
              AppIconButton(
                icon: Icons.person_outline,
                tooltip: 'Profile',
                onPressed: _noop,
              ),
              BadgeIconButton(
                icon: Icons.shopping_cart_outlined,
                count: 2,
                tooltip: 'Cart',
                onPressed: _noop,
              ),
            ],
          ),
          const Divider(),
          const AppTopBar(title: 'Flight details', onBack: _noop),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final c in [0, 1, 12])
                BadgeIconButton(
                  icon: Icons.shopping_cart_outlined,
                  count: c,
                  tooltip: 'Cart',
                  onPressed: _noop,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  const _Chips();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: AppSizes.spacingXs,
      runSpacing: AppSizes.spacingXs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppChip(
          label: '12 Dec',
          icon: Icons.calendar_today_outlined,
          selected: true,
          onTap: _noop,
        ),
        AppChip(
          label: 'Sort: Price',
          icon: Icons.sort,
          selected: false,
          onTap: _noop,
        ),
        StatusBadge(label: 'Gold', tone: AppTone.warning, icon: Icons.star),
        StatusBadge(label: 'Silver'),
        StatusBadge(label: 'Confirmed', tone: AppTone.success),
        StatusBadge(label: 'Info', tone: AppTone.info),
        StatusBadge(label: 'Failed', tone: AppTone.error),
        PriceTag.small('650 ₺'),
        PriceTag('1.250 ₺'),
        PriceTag.large('1.250 ₺'),
      ],
    );
  }
}

class _Display extends StatelessWidget {
  const _Display();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const InfoRow(
          icon: Icons.flight_takeoff,
          label: 'Departure',
          value: '08:30',
        ),
        const InfoRow(
          icon: Icons.calendar_today_outlined,
          label: 'Date',
          value: '12 Dec 2026',
          showDivider: false,
        ),
        const SizedBox(height: AppSizes.spacingM),
        const Row(
          children: [
            Expanded(
              child: StatTile(value: '12', label: 'Total bookings'),
            ),
            SizedBox(width: AppSizes.spacingM),
            Expanded(
              child: StatTile(value: 'Mar 2024', label: 'Member since'),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacingM),
        Row(
          children: [
            AppAvatar(initials: AppAvatar.initialsOf('Ayşe Demir')),
            const SizedBox(width: AppSizes.spacingM),
            const Expanded(
              child: InfoBanner(
                message: 'Test account: demo@flightbooking.app / Demo1234',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.spacingXs,
      runSpacing: AppSizes.spacingXs,
      children: [
        AppButton.secondary(
          label: 'Confirm dialog',
          onPressed: () => AppDialog.show(
            context,
            title: 'Payment Confirmation',
            message: 'Are you sure you want to pay a total of 1.250 ₺?',
            cancelLabel: 'Cancel',
            confirmLabel: 'Confirm',
          ),
        ),
        AppButton.secondary(
          label: 'Warning dialog',
          onPressed: () => AppDialog.show(
            context,
            title: 'Update Required',
            message: 'A new version is available! Please update the app.',
            cancelLabel: 'Later',
            confirmLabel: 'Update',
            variant: AppDialogVariant.warning,
          ),
        ),
        for (final tone in [
          AppTone.success,
          AppTone.error,
          AppTone.info,
          AppTone.warning,
        ])
          AppButton.text(
            label: 'Snackbar ${tone.name}',
            onPressed: () => AppSnackbar.show(
              context,
              message: 'This is the ${tone.name} snackbar.',
              tone: tone,
              actionLabel: tone == AppTone.info ? 'Undo' : null,
            ),
          ),
      ],
    );
  }
}

class _Settings extends StatefulWidget {
  const _Settings();

  @override
  State<_Settings> createState() => _SettingsState();
}

class _SettingsState extends State<_Settings> {
  final ValueNotifier<bool> _darkNotifier = ValueNotifier(false);
  final ValueNotifier<String> _langNotifier = ValueNotifier('en');

  @override
  void dispose() {
    _darkNotifier.dispose();
    _langNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _darkNotifier,
          builder: (_, v, _) => SettingsRow(
            icon: Icons.dark_mode_outlined,
            title: 'Dark theme',
            trailing: AppSwitch(
              value: v,
              semanticLabel: 'Dark theme',
              onChanged: (n) => _darkNotifier.value = n,
            ),
          ),
        ),
        ValueListenableBuilder<String>(
          valueListenable: _langNotifier,
          builder: (_, v, _) => SettingsRow(
            icon: Icons.translate,
            title: 'Language',
            trailing: SegmentedToggle<String>(
              options: const {'en': 'EN', 'tr': 'TR'},
              selected: v,
              onChanged: (n) => _langNotifier.value = n,
            ),
          ),
        ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      padding: EdgeInsets.zero,
      child: SummaryBar(
        label: 'Total:',
        price: PriceTag.large('1.250 ₺'),
        action: AppButton.primary(label: 'Pay', onPressed: _noop),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 260,
        child: LoadingState(
          itemCount: 2,
          skeleton: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: 120),
              SizedBox(height: AppSizes.spacingM),
              ShimmerBox(height: 40),
              SizedBox(height: AppSizes.spacingM),
              ShimmerBox(height: 48, borderRadius: AppRadius.medium),
            ],
          ),
        ),
      ),
    );
  }
}
