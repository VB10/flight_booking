import 'package:flight_booking/product/gen/locale_keys.g.dart';
import 'package:flight_booking/product/localization/localization_extension.dart';
import 'package:intl/intl.dart';

/// Display formatting shared by every screen (v13) so "12 Dec 2026" and
/// "1.250 ₺" look the same on Flights, Detail, Cart and the confirmation.
///
/// Locale-aware: pass `context.productLocale.toLanguageTag()` (EN → "1,250 ₺",
/// "12 Dec 2026"; TR → "1.250 ₺", "12 Ara 2026"). Locale data is loaded once
/// in `AppInitializer` (`initializeDateFormatting`).
final class ProductFormat {
  ProductFormat._();

  /// 1250 → "1.250 ₺" (grouping by [locale]) through `LocaleKeys.flight_price`.
  static String price(int value, {required String locale}) =>
      LocaleKeys.flight_price.translateArgs([groupedNumber(value, locale)]);

  /// 1250 → "1.250" / "1,250".
  static String groupedNumber(int value, String locale) =>
      NumberFormat.decimalPattern(locale).format(value);

  /// "2026-12-12" → "12 Dec 2026" / "12 Ara 2026". Unparseable input is
  /// returned unchanged, so bad backend data never crashes a screen.
  static String date(String isoDate, {required String locale}) {
    final parsed = DateTime.tryParse(isoDate);
    if (parsed == null) return isoDate;
    return DateFormat('d MMM y', locale).format(parsed);
  }

  /// Short form for chips: "2026-12-12" → "12 Dec" / "12 Ara".
  static String shortDate(String isoDate, {required String locale}) {
    final parsed = DateTime.tryParse(isoDate);
    if (parsed == null) return isoDate;
    return DateFormat('d MMM', locale).format(parsed);
  }
}
