import 'dart:async';

import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/feature/auth/flight/cubit/flight_list_cubit.dart';
import 'package:flight_booking/feature/auth/flight/cubit/flight_list_state.dart';
import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/application/cart/cart_cubit.dart';
import 'package:flight_booking/product/application/cart/cart_state.dart';
import 'package:flight_booking/product/container/product_container.dart';
import 'package:flight_booking/product/gen/locale_keys.g.dart';
import 'package:flight_booking/product/initialize/firebase/custom_remote_config.dart';
import 'package:flight_booking/product/localization/localization_extension.dart';
import 'package:flight_booking/product/navigation/app_routes.dart';
import 'package:flight_booking/product/service/flight_service.dart';
import 'package:flight_booking/product/util/format/product_format.dart';
import 'package:flight_booking/product/widget/flight/flight_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'view/flight_list_page_mixin.dart';
part 'view/widget/_flight_list_filters.dart';
part 'view/widget/flight_list_page_body.dart';

final class FlightListPage extends StatefulWidget {
  const FlightListPage({super.key});

  @override
  State<FlightListPage> createState() => _FlightListPageState();
}

final class _FlightListPageState extends State<FlightListPage>
    with FlightListPageMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => flightListCubit,
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: AppTopBar(
          title: LocaleKeys.flight_list_title.translate,
          actions: [
            AppIconButton(
              icon: Icons.person_outline,
              tooltip: LocaleKeys.flight_profile_tooltip.translate,
              onPressed: () => const ProfileRoute().push<void>(context),
            ),
            AppIconButton(
              icon: Icons.logout,
              tooltip: LocaleKeys.flight_logout.translate,
              onPressed: () => unawaited(onLogoutPressed(context)),
            ),
            BlocSelector<CartCubit, CartState, int>(
              bloc: cartCubit,
              selector: (state) => state.count,
              builder: (context, count) => BadgeIconButton(
                icon: Icons.shopping_cart_outlined,
                count: count,
                tooltip: LocaleKeys.flight_cart_tooltip.translate,
                onPressed: () => const CartRoute().go(context),
              ),
            ),
          ],
        ),
        body: _FlightListBody(
          searchController: searchController,
          onAddToCart: (flight) => onAddToCart(context, flight),
          onClearFilters: onClearFilters,
        ),
      ),
    );
  }
}
