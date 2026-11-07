import 'dart:async';

import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/feature/unauth/splash/cubit/splash_cubit.dart';
import 'package:flight_booking/feature/unauth/splash/cubit/splash_state.dart';
import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/container/product_container.dart';
import 'package:flight_booking/product/gen/locale_keys.g.dart';
import 'package:flight_booking/product/localization/localization_extension.dart';
import 'package:flight_booking/product/navigation/app_routes.dart';
import 'package:flight_booking/product/service/app_update_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'view/splash_page_mixin.dart';
part 'view/widget/_splash_app_mark.dart';
part 'view/widget/splash_page_body.dart';

final class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

final class _SplashPageState extends State<SplashPage> with SplashPageMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: splashCubit,
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: onStatusChanged,
        child: Scaffold(
          backgroundColor: context.colorScheme.surface,
          body: const _SplashPageBody(),
        ),
      ),
    );
  }
}
