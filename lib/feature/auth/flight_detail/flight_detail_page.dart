import 'dart:async';

import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/feature/auth/flight/flights_response_model.dart';
import 'package:flight_booking/feature/auth/flight_detail/cubit/flight_detail_cubit.dart';
import 'package:flight_booking/feature/auth/flight_detail/cubit/flight_detail_state.dart';
import 'package:flight_booking/product/application/cart/cart_cubit.dart';
import 'package:flight_booking/product/container/product_container.dart';
import 'package:flight_booking/product/gen/locale_keys.g.dart';
import 'package:flight_booking/product/localization/localization_extension.dart';
import 'package:flight_booking/product/navigation/app_routes.dart';
import 'package:flight_booking/product/service/flight_service.dart';
import 'package:flight_booking/product/util/format/product_format.dart';
import 'package:flight_booking/product/widget/flight/airline_mark.dart';
import 'package:flight_booking/product/widget/flight/route_visual.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'view/flight_detail_page_mixin.dart';
part 'view/widget/_flight_detail_skeleton.dart';
part 'view/widget/_flight_info_tiles.dart';
part 'view/widget/flight_detail_page_body.dart';

final class FlightDetailPage extends StatefulWidget {
  const FlightDetailPage({required this.flightId, this.flight, super.key});

  final String flightId;

  /// Flight handed over by the list; null on deep link / refresh.
  final Map<String, dynamic>? flight;

  @override
  State<FlightDetailPage> createState() => _FlightDetailPageState();
}

final class _FlightDetailPageState extends State<FlightDetailPage>
    with FlightDetailPageMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => flightDetailCubit,
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        appBar: AppTopBar(
          title: LocaleKeys.flight_detail_title.translate,
          onBack: onBack,
          backTooltip: LocaleKeys.flight_detail_back.translate,
        ),
        body: const _FlightDetailBody(),
        bottomNavigationBar:
            BlocSelector<FlightDetailCubit, FlightDetailState, bool>(
              selector: (state) => state.isContent,
              builder: (context, isContent) => BottomActionBar(
                child: AppButton.primary(
                  label: LocaleKeys.flight_add_to_cart.translate,
                  icon: Icons.shopping_cart_outlined,
                  expand: true,
                  onPressed: isContent ? () => onAddToCart(context) : null,
                ),
              ),
            ),
      ),
    );
  }
}
