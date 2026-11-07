import 'dart:async';

import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/feature/unauth/login/cubit/login_cubit.dart';
import 'package:flight_booking/feature/unauth/login/cubit/login_state.dart';
import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/container/product_container.dart';
import 'package:flight_booking/product/gen/assets.gen.dart';
import 'package:flight_booking/product/gen/locale_keys.g.dart';
import 'package:flight_booking/product/localization/localization_extension.dart';
import 'package:flight_booking/product/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        listenWhen: (p, c) =>
            p.errorMessage != c.errorMessage && c.errorMessage.isNotEmpty,
        listener: (context, state) => AppSnackbar.show(
          context,
          message: state.errorMessage,
          tone: AppTone.error,
        ),
        child: Scaffold(
          backgroundColor: context.colorScheme.surface,
          body: _LoginPageBody(
            emailController: emailController,
            passwordController: passwordController,
            onLogin: () => onLoginPressed(context),
            onShowTestAccount: onShowTestAccount,
          ),
        ),
      ),
    );
  }
}
