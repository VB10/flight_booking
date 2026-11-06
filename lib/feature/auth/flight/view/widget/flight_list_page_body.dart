part of '../../flight_list_page.dart';

/// Filters on top, state-driven list below.
final class _FlightListBody extends StatelessWidget {
  const _FlightListBody({
    required this.searchController,
    required this.onAddToCart,
    required this.onClearFilters,
  });

  final TextEditingController searchController;
  final ValueChanged<FlightModel> onAddToCart;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FlightListCubit>();
    return Column(
      children: [
        BlocSelector<FlightListCubit, FlightListState, bool>(
          selector: (state) => state.hasError,
          builder: (context, hasError) => hasError
              ? const SizedBox.shrink()
              : _FlightListFilters(searchController: searchController),
        ),
        Expanded(
          child: BlocBuilder<FlightListCubit, FlightListState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const LoadingState(skeleton: FlightCardSkeleton());
              }
              if (state.hasError) {
                return ErrorState(
                  title: LocaleKeys.flight_error_title.translate,
                  message: LocaleKeys.flight_error_message.translate,
                  retryLabel: LocaleKeys.general_retry.translate,
                  onRetry: () => unawaited(cubit.loadFlights()),
                );
              }
              final flights = state.visibleFlights;
              if (flights.isEmpty) {
                return EmptyState(
                  icon: Icons.search,
                  title: LocaleKeys.flight_empty_title.translate,
                  message: LocaleKeys.flight_empty_message.translate,
                  actionLabel: state.flights.isEmpty
                      ? null
                      : LocaleKeys.flight_clear_filters.translate,
                  onAction: state.flights.isEmpty ? null : onClearFilters,
                );
              }
              return _FlightList(flights: flights, onAddToCart: onAddToCart);
            },
          ),
        ),
      ],
    );
  }
}

final class _FlightList extends StatelessWidget {
  const _FlightList({required this.flights, required this.onAddToCart});

  final List<FlightModel> flights;
  final ValueChanged<FlightModel> onAddToCart;

  @override
  Widget build(BuildContext context) {
    final locale = context.productLocale.toLanguageTag();
    return ListView.separated(
      padding: const AppPagePadding.all20(),
      itemCount: flights.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.spacingM),
      itemBuilder: (context, index) {
        final flight = flights[index];
        return FlightCard.full(
          airline: flight.airline,
          date: ProductFormat.date(flight.date, locale: locale),
          price: ProductFormat.price(flight.price, locale: locale),
          from: flight.from,
          to: flight.to,
          departureTime: flight.departureTime,
          arrivalTime: flight.arrivalTime,
          duration: flight.duration,
          onDetails: () => FlightDetailRoute(
            flightId: '${flight.id}',
            $extra: flight.toJson(),
          ).go(context),
          onAddToCart: () => onAddToCart(flight),
        );
      },
    );
  }
}
