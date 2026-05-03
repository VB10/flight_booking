import 'package:flight_booking/feature/sub_feature/main/main_app.dart';
import 'package:flight_booking/product/container/product_container.dart';
import 'package:flight_booking/product/initialize/app_initializer.dart';
import 'package:flutter/material.dart';

void main() async {
  AppInitializer.run();
  await AppInitializer().prepare();
  ProductContainer.instance.setup();

  runApp(const MainApp());
}
