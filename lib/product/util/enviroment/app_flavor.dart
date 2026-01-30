import 'package:flight_booking/product/model/constant/string_enviroment_constant.dart';

enum AppFlavor {
  development,
  production;

  static AppFlavor get current {
    final environment = String.fromEnvironment(
      StringEnvironmentConstant.flavor,
    );
    return AppFlavor.values.firstWhere(
      (e) => e.name == environment.toLowerCase(),
      orElse: () => AppFlavor.development,
    );
  }
}
