import 'dart:async';

import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/feature/auth/profile/cubit/profile_cubit.dart';
import 'package:flight_booking/feature/auth/profile/cubit/profile_state.dart';
import 'package:flight_booking/feature/auth/profile/profile_response_model.dart';
import 'package:flight_booking/product/application/application_cubit.dart';
import 'package:flight_booking/product/application/application_state.dart';
import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/container/product_container.dart';
import 'package:flight_booking/product/gen/locale_keys.g.dart';
import 'package:flight_booking/product/localization/locales.dart';
import 'package:flight_booking/product/localization/localization_extension.dart';
import 'package:flight_booking/product/navigation/app_routes.dart';
import 'package:flight_booking/product/service/auth_service.dart';
import 'package:flight_booking/product/util/format/product_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'view/profile_page_mixin.dart';
part 'view/widget/_profile_content.dart';
part 'view/widget/_profile_loading.dart';
part 'view/widget/_profile_settings.dart';
part 'view/widget/profile_page_body.dart';

final class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

final class _ProfilePageState extends State<ProfilePage> with ProfilePageMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(create: (_) => profileCubit),
        BlocProvider<ApplicationCubit>.value(value: applicationCubit),
      ],
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: AppTopBar(
          title: LocaleKeys.profile_title.translate,
          backTooltip: LocaleKeys.flight_detail_back.translate,
          onBack: () => onBackPressed(context),
          actions: [
            AppIconButton(
              icon: Icons.refresh,
              tooltip: LocaleKeys.profile_refresh_tooltip.translate,
              onPressed: () => unawaited(profileCubit.load()),
            ),
            AppIconButton(
              icon: Icons.logout,
              tooltip: LocaleKeys.flight_logout.translate,
              onPressed: () => unawaited(onLogoutPressed(context)),
            ),
          ],
        ),
        body: _ProfilePageBody(
          onRetry: () => unawaited(profileCubit.load()),
          onThemeChanged: (_) => applicationCubit.toggleTheme(),
          onLocaleChanged: (value) => unawaited(
            applicationCubit.changeLocale(context: context, value: value),
          ),
        ),
      ),
    );
  }
}
