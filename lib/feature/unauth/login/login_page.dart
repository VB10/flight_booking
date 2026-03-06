import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/feature/auth/flight/flight_list_page.dart';
import 'package:flight_booking/feature/unauth/login/view/login_page_state.dart';
import 'package:flight_booking/feature/unauth/login/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        // TODO: Code gen ile localization
        title: ProductText.h3(context, 'Flight Booking'),
        centerTitle: true,
        backgroundColor: context.colorScheme.primary,
      ),
      body: _LoginPageBody(
        emailController: emailController,
        passwordController: passwordController,
        state: state,
        onLogin: onLoginPressed,
      ),
    );
  }
}
