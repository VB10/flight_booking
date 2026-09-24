import 'dart:async';

import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/gen/assets.gen.dart';
import 'package:flight_booking/product/gen/locale_keys.g.dart';
import 'package:flight_booking/product/localization/localization_extension.dart';
import 'package:flight_booking/product/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const _splashDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    unawaited(_routeAfterDelay());
  }

  Future<void> _routeAfterDelay() async {
    final authCubit = context.read<AuthCubit>();
    await Future.wait<void>([
      Future<void>.delayed(_splashDuration),
      authCubit.restoreSession(),
    ]);
    if (!mounted) return;
    if (authCubit.state.isLoggedIn) {
      const FlightListRoute().go(context);
    } else {
      const LoginRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.animation.lottie.lottieLoading.lottie(
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: AppSizes.spacingXl),
            ProductText.h2(
              context,
              LocaleKeys.general_app_name.translate,
              style: context.appTextTheme.headlineLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.spacingL),
            ProductText.bodyLarge(
              context,
              LocaleKeys.general_app_tagline.translate,
              style: context.appTextTheme.bodyLarge?.copyWith(
                color: colorScheme.onPrimary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 50),
            const SizedBox(height: 40),
            ProductText.bodyLarge(
              context,
              'Yükleniyor...',
              style: context.appTextTheme.bodyLarge?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
