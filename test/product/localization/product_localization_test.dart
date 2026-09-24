import 'package:flight_booking/product/gen/locale_keys.g.dart';
import 'package:flight_booking/product/localization/locales.dart';
import 'package:flight_booking/product/localization/localization_extension.dart';
import 'package:flight_booking/product/localization/product_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Proves the localization facade resolves keys — plain, positional, named and
/// plural — without any feature code importing the localization package.
///
/// Two notes this test encodes, both learned the hard way:
/// 1. Translations must be read **under** `MaterialApp`'s `Localizations`.
///    Building them in a parent runs before the assets finish loading: `tr`
///    logs "key not found" and `plural` throws a `LateInitializationError`.
///    That is why the app uses `onGenerateTitle`, not `title`.
/// 2. The package caches loaded translations statically, so pumping the **same**
///    locale twice does not reload them. One pump per language here.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await ProductLocalization.init();
  });

  Future<void> pumpApp(WidgetTester tester, Locales locale) async {
    await tester.pumpWidget(
      ProductLocalization(
        startLocale: locale,
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.productDelegates,
            supportedLocales: context.productSupportedLocales,
            locale: context.productLocale,
            home: Builder(
              builder: (context) => Scaffold(
                body: Column(
                  children: [
                    Text(
                      LocaleKeys.login_test_account_info.translateNamed({
                        'email': 'a@b.c',
                        'password': '42',
                      }),
                    ),
                    Text(LocaleKeys.flight_added_to_cart.translatePlural(1)),
                    Text(LocaleKeys.flight_added_to_cart.translatePlural(3)),
                    Text(
                      LocaleKeys.general_error_message.translateArgs(['boom']),
                    ),
                    Text(LocaleKeys.flight_details.translate),
                    Text(
                      LocaleKeys.cart_checkout_confirm_message.translateArgs([
                        '250',
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Turkish: plain, positional, named and plural keys', (
    tester,
  ) async {
    await pumpApp(tester, Locales.tr);

    expect(find.text('Detaylar'), findsOneWidget);
    expect(find.text('Hata: boom'), findsOneWidget);
    expect(find.text('Test hesabı: a@b.c / 42'), findsOneWidget);
    expect(
      find.text('Bilet eklendi. Sepetinizde 1 bilet var.'),
      findsOneWidget,
    );
    expect(
      find.text('Bilet eklendi. Sepetinizde 3 bilet var.'),
      findsOneWidget,
    );
    expect(
      find.text('Toplam 250 ₺ ödeme yapmak istediğinizden emin misiniz?'),
      findsOneWidget,
    );
  });

  testWidgets('English: same keys resolve in the other language', (
    tester,
  ) async {
    await pumpApp(tester, Locales.en);

    expect(find.text('Details'), findsOneWidget);
    expect(find.text('Error: boom'), findsOneWidget);
    expect(find.text('Test account: a@b.c / 42'), findsOneWidget);
    expect(
      find.text('Ticket added. You have 1 ticket in your cart.'),
      findsOneWidget,
    );
    expect(
      find.text('Ticket added. You have 3 tickets in your cart.'),
      findsOneWidget,
    );
    expect(
      find.text('Are you sure you want to pay a total of 250 ₺?'),
      findsOneWidget,
    );
  });
}
