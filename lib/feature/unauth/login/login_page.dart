import 'dart:async';

import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/feature/auth/flight/flight_list_page.dart';
import 'package:flight_booking/feature/unauth/login/cubit/login_cubit.dart';
import 'package:flight_booking/feature/unauth/login/cubit/login_state.dart';
import 'package:flight_booking/product/container/product_container.dart';
import 'package:flight_booking/product/network/network_manager.dart';
import 'package:flight_booking/product/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'view/login_page_mixin.dart';
part 'view/widget/_login_test_account_info.dart';
part 'view/widget/login_page_body.dart';

final class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final class _LoginPageState extends State<LoginPage> with LoginPageMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => loginCubit,
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) =>
            current.isSuccess && !previous.isSuccess,
        listener: (context, state) {
          if (state.isSuccess) navigateToFlightList();
        },
        child: Scaffold(
          backgroundColor: context.colorScheme.surface,
          appBar: AppBar(
            title: ProductText.h3(context, 'Flight Booking'),
            centerTitle: true,
            backgroundColor: context.colorScheme.primary,
          ),
          body: _LoginPageBody(
            emailController: emailController,
            passwordController: passwordController,
            obscurePassword: obscurePasswordNotifier,
            testAccountExpanded: testAccountExpandedNotifier,
            onLogin: () => onLoginPressed(context),
            onToggleTestAccount: toggleTestAccountSection,
          ),
        ),
      ),
    );
  }
}
