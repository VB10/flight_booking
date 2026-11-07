part of '../../flight_detail_page.dart';

/// State-driven body: skeleton, error with retry, or the flight.
final class _FlightDetailBody extends StatelessWidget {
  const _FlightDetailBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightDetailCubit, FlightDetailState>(
      builder: (context, state) {
        switch (state.status) {
          case FlightDetailStatus.loading:
            return const _FlightDetailSkeleton();
          case FlightDetailStatus.error:
            return ErrorState(
              title: LocaleKeys.flight_detail_error_title.translate,
              message: LocaleKeys.flight_error_message.translate,
              retryLabel: LocaleKeys.general_retry.translate,
              onRetry: () =>
                  unawaited(context.read<FlightDetailCubit>().load()),
            );
          case FlightDetailStatus.content:
            final flight = state.flight;
            if (flight == null) return const SizedBox.shrink();
            return _FlightDetailContent(flight: flight);
        }
      },
    );
  }
}

final class _FlightDetailContent extends StatelessWidget {
  const _FlightDetailContent({required this.flight});

  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    final locale = context.productLocale.toLanguageTag();
    return ListView(
      padding: const AppPagePadding.all20(),
      children: [
        Row(
          children: [
            const AirlineMark(),
            const SizedBox(width: AppSizes.spacingS),
            ProductText.titleMedium(context, flight.airline),
          ],
        ),
        const SizedBox(height: AppSizes.spacingM),
        RouteVisual(
          fromCity: flight.from,
          toCity: flight.to,
          fromCode: flight.fromCode,
          toCode: flight.toCode,
          caption: flight.duration,
        ),
        const SizedBox(height: AppSizes.spacingM),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingM),
          child: Column(
            children: [
              InfoRow(
                icon: Icons.schedule,
                label: LocaleKeys.flight_detail_departure.translate,
                value: flight.departureTime,
              ),
              InfoRow(
                icon: Icons.schedule,
                label: LocaleKeys.flight_detail_arrival.translate,
                value: flight.arrivalTime,
              ),
              InfoRow(
                icon: Icons.hourglass_empty,
                label: LocaleKeys.flight_detail_duration.translate,
                value: flight.duration,
              ),
              InfoRow(
                icon: Icons.calendar_today_outlined,
                label: LocaleKeys.flight_detail_date.translate,
                value: ProductFormat.date(flight.date, locale: locale),
                showDivider: false,
              ),
            ],
          ),
        ),
        _FlightInfoTiles(flight: flight),
        const SizedBox(height: AppSizes.spacingL),
        ProductText.labelLarge(
          context,
          LocaleKeys.flight_detail_price.translate,
          color: context.colorScheme.onSurfaceVariant,
        ),
        PriceTag.large(ProductFormat.price(flight.price, locale: locale)),
      ],
    );
  }
}
