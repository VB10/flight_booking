import 'package:flight_booking/product/util/format/product_format.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(initializeDateFormatting);

  test('groupedNumber follows the locale', () {
    expect(ProductFormat.groupedNumber(1250, 'tr'), '1.250');
    expect(ProductFormat.groupedNumber(1250, 'en'), '1,250');
    expect(ProductFormat.groupedNumber(650, 'tr'), '650');
  });

  test('date formats ISO dates per locale', () {
    expect(ProductFormat.date('2026-12-12', locale: 'en'), '12 Dec 2026');
    expect(ProductFormat.date('2026-12-12', locale: 'tr'), '12 Ara 2026');
    expect(ProductFormat.shortDate('2026-12-12', locale: 'en'), '12 Dec');
  });

  test('date returns bad input unchanged', () {
    expect(ProductFormat.date('soon', locale: 'en'), 'soon');
  });
}
