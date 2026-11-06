import 'dart:async';

import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/feature/auth/cart/cubit/cart_checkout_cubit.dart';
import 'package:flight_booking/feature/auth/cart/cubit/cart_checkout_state.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'view/cart_page_mixin.dart';
part 'view/widget/_cart_booking_confirmation.dart';
part 'view/widget/_cart_dismissible_card.dart';
part 'view/widget/cart_page_body.dart';

final class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

final class _CartPageState extends State<CartPage> with CartPageMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCheckoutCubit>(create: (_) => checkoutCubit),
        BlocProvider<CartCubit>.value(value: cartCubit),
      ],
      child: BlocListener<CartCheckoutCubit, CartCheckoutState>(
        listenWhen: (p, c) =>
            p.status != c.status && c.status == CartCheckoutStatus.success,
        listener: (context, state) => unawaited(logPurchase(state.paidItems)),
        child: BlocBuilder<CartCheckoutCubit, CartCheckoutState>(
          buildWhen: (p, c) => p.status != c.status,
          builder: (context, state) {
            final isSuccess = state.status == CartCheckoutStatus.success;
            // Payment in flight: no back (top bar or system) until it settles.
            return PopScope(
              canPop: !state.isProcessing,
              child: Scaffold(
                backgroundColor: context.colorScheme.surface,
                appBar: isSuccess
                    ? null
                    : AppTopBar(
                        title: LocaleKeys.cart_title.translate,
                        backTooltip: LocaleKeys.flight_detail_back.translate,
                        onBack: state.isProcessing
                            ? null
                            : () => onBackPressed(context),
                      ),
                body: LoadingOverlay(
                  visible: state.isProcessing,
                  message: LocaleKeys.cart_processing_payment.translate,
                  child: _CartPageBody(
                    onRemove: (index) => onRemove(context, index),
                    onPay: () => unawaited(onPayPressed(context)),
                    onBrowseFlights: () => onBrowseFlights(context),
                    onRetry: () => unawaited(checkoutCubit.pay()),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
