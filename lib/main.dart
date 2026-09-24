import 'package:flight_booking/feature/sub_feature/main/main_app.dart';
import 'package:flight_booking/product/cache/product_cache.dart';
import 'package:flight_booking/product/cache/product_cache_keys.dart';
import 'package:flight_booking/product/container/product_container.dart';
import 'package:flight_booking/product/initialize/app_initializer.dart';
import 'package:flight_booking/product/localization/locales.dart';
import 'package:flight_booking/product/localization/product_localization.dart';
import 'package:flutter/material.dart';

void main() async {
  AppInitializer.run();
  await AppInitializer().prepare();
  ProductContainer.instance.setup();

  // Language the user picked last time (v11 cache). Null → device locale.
  final startLocale = Locales.fromCodeOrNull(
    ProductCache.instance.manager.readString(ProductCacheKeys.locale),
  );

  runApp(
    ProductLocalization(
      startLocale: startLocale,
      child: const MainApp(),
    ),
  );
}
