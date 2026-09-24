import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/product/application/application_cubit.dart';
import 'package:flight_booking/product/application/application_state.dart';
import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/container/product_container.dart';
import 'package:flight_booking/product/gen/locale_keys.g.dart';
import 'package:flight_booking/product/localization/localization_extension.dart';
import 'package:flight_booking/product/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = ProductContainer.instance.get<AppRouter>().config;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductContainer.instance.get<ApplicationCubit>(),
        ),
        BlocProvider(
          create: (_) => ProductContainer.instance.get<AuthCubit>(),
        ),
      ],
      child: BlocSelector<ApplicationCubit, ApplicationState, ThemeMode>(
        selector: (state) => state.themeMode,
        builder: (context, themeMode) {
          return MaterialApp.router(
            // Not `title:` — that is evaluated on the very first build, before
            // the translation assets finish loading (the package then logs
            // "key not found"). onGenerateTitle runs under Localizations and
            // re-runs on every locale change.
            onGenerateTitle: (context) => LocaleKeys.general_app_name.translate,
            localizationsDelegates: context.productDelegates,
            supportedLocales: context.productSupportedLocales,
            locale: context.productLocale,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
