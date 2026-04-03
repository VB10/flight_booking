import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/feature/unauth/splash/splash_page.dart';
import 'package:flight_booking/product/application/application_cubit.dart';
import 'package:flight_booking/product/application/application_state.dart';
import 'package:flight_booking/product/container/product_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductContainer.instance.get<ApplicationCubit>(),
        ),
      ],
      child: BlocSelector<ApplicationCubit, ApplicationState, ThemeMode>(
        selector: (state) => state.themeMode,
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Flight Booking',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: SplashPage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
