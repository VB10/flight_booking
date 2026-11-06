import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

import 'helpers.dart';

void main() {
  group('theme', () {
    test('light and dark expose the kit extension and tokens', () {
      for (final theme in [UiKitTheme.light(), UiKitTheme.dark()]) {
        final ext = theme.extension<AppThemeExtension>();
        expect(ext, isNotNull);
        expect(theme.colorScheme.primary, isNot(ext!.brandPrimary));
      }
      expect(UiKitTheme.light().colorScheme.primary, AppColors.light.primary);
      expect(UiKitTheme.dark().colorScheme.surface, AppColors.dark.surface);
      expect(AppRadius.medium, BorderRadius.circular(12));
    });
  });

  group('AppButton', () {
    testWidgets('calls onPressed', (tester) async {
      var taps = 0;
      await pumpKit(
        tester,
        AppButton.primary(label: 'Login', onPressed: () => taps++),
      );
      await tester.tap(find.text('Login'));
      expect(taps, 1);
    });

    testWidgets('loading shows a spinner and swallows taps', (tester) async {
      var taps = 0;
      await pumpKit(
        tester,
        AppButton.primary(
          label: 'Login',
          isLoading: true,
          onPressed: () => taps++,
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.text('Login'));
      expect(taps, 0);
    });

    testWidgets('disabled when onPressed is null', (tester) async {
      await pumpKit(
        tester,
        const AppButton.secondary(label: 'Details', onPressed: null),
      );
      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.onPressed, isNull);
    });
  });

  group('BadgeIconButton', () {
    test('caps the label at 9+', () {
      expect(BadgeIconButton.badgeLabel(1), '1');
      expect(BadgeIconButton.badgeLabel(9), '9');
      expect(BadgeIconButton.badgeLabel(12), '9+');
    });

    testWidgets('hides the badge at 0', (tester) async {
      await pumpKit(
        tester,
        BadgeIconButton(
          icon: Icons.shopping_cart_outlined,
          count: 0,
          tooltip: 'Cart',
          onPressed: () {},
        ),
      );
      final badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.isLabelVisible, isFalse);
      expect(find.byTooltip('Cart'), findsOneWidget);
    });
  });

  group('AppAvatar', () {
    test('initialsOf', () {
      expect(AppAvatar.initialsOf('Ayşe Demir'), 'AD');
      expect(AppAvatar.initialsOf('  mehmet  '), 'M');
      expect(AppAvatar.initialsOf(''), '?');
      expect(AppAvatar.initialsOf('ışık özgür'), 'IÖ');
    });
  });

  group('AppTextField', () {
    testWidgets('shows the error text and the trailing action', (tester) async {
      var toggled = false;
      await pumpKit(
        tester,
        AppTextField(
          label: 'Password',
          errorText: 'Required',
          trailingActionLabel: 'Show',
          onTrailingAction: () => toggled = true,
        ),
      );
      expect(find.text('Required'), findsOneWidget);
      await tester.tap(find.text('Show'));
      expect(toggled, isTrue);
    });
  });

  group('AppDialog', () {
    Future<bool?> open(WidgetTester tester, String tapLabel) async {
      bool? result;
      await pumpKit(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await AppDialog.show(
                context,
                title: 'Payment Confirmation',
                message: 'Pay 1.250 ₺?',
                cancelLabel: 'Cancel',
                confirmLabel: 'Confirm',
              );
            },
            child: const Text('open'),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Payment Confirmation'), findsOneWidget);
      await tester.tap(find.text(tapLabel));
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('resolves true on confirm', (tester) async {
      expect(await open(tester, 'Confirm'), isTrue);
    });

    testWidgets('resolves false on cancel', (tester) async {
      expect(await open(tester, 'Cancel'), isFalse);
    });
  });

  group('AppSnackbar', () {
    testWidgets('shows message and runs the action', (tester) async {
      var undone = false;
      await pumpKit(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => AppSnackbar.show(
              context,
              message: 'Ticket removed from cart!',
              actionLabel: 'Undo',
              onAction: () => undone = true,
            ),
            child: const Text('show'),
          ),
        ),
      );
      await tester.tap(find.text('show'));
      await tester.pumpAndSettle();
      expect(find.text('Ticket removed from cart!'), findsOneWidget);
      await tester.tap(find.text('Undo'));
      expect(undone, isTrue);
    });
  });

  group('states', () {
    testWidgets('EmptyState action', (tester) async {
      var tapped = false;
      await pumpKit(
        tester,
        EmptyState(
          title: 'Your cart is empty',
          actionLabel: 'Browse Flights',
          onAction: () => tapped = true,
        ),
      );
      await tester.tap(find.text('Browse Flights'));
      expect(tapped, isTrue);
    });

    testWidgets('ErrorState retry', (tester) async {
      var retried = false;
      await pumpKit(
        tester,
        ErrorState(
          title: 'Connection error',
          retryLabel: 'Try Again',
          onRetry: () => retried = true,
        ),
        dark: true,
      );
      await tester.tap(find.text('Try Again'));
      expect(retried, isTrue);
    });

    testWidgets('LoadingOverlay blocks the page while visible', (
      tester,
    ) async {
      var taps = 0;
      await pumpKit(
        tester,
        SizedBox(
          width: 300,
          height: 300,
          child: LoadingOverlay(
            visible: true,
            message: 'Processing payment...',
            child: Center(
              child: TextButton(
                onPressed: () => taps++,
                child: const Text('pay'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Processing payment...'), findsOneWidget);
      await tester.tap(find.text('pay'), warnIfMissed: false);
      expect(taps, 0);
    });
  });

  group('SegmentedToggle', () {
    testWidgets('reports the new value', (tester) async {
      String? picked;
      await pumpKit(
        tester,
        SegmentedToggle<String>(
          options: const {'en': 'EN', 'tr': 'TR'},
          selected: 'en',
          onChanged: (v) => picked = v,
        ),
      );
      await tester.tap(find.text('TR'));
      expect(picked, 'tr');
    });
  });
}
