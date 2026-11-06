part of '../../flight_list_page.dart';

/// Search field + date chips + sort chip.
final class _FlightListFilters extends StatelessWidget {
  const _FlightListFilters({required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FlightListCubit>();
    final locale = context.productLocale.toLanguageTag();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.pagePadding,
        AppSizes.spacingXs,
        AppSizes.pagePadding,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSearchField(
            controller: searchController,
            hintText: LocaleKeys.flight_search_hint.translate,
            clearTooltip: LocaleKeys.flight_search_clear.translate,
            onChanged: cubit.setQuery,
          ),
          const SizedBox(height: AppSizes.spacingM),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: BlocBuilder<FlightListCubit, FlightListState>(
              buildWhen: (p, c) =>
                  p.flights != c.flights ||
                  p.selectedDate != c.selectedDate ||
                  p.sort != c.sort,
              builder: (context, state) {
                return Row(
                  children: [
                    for (final date in state.availableDates) ...[
                      AppChip(
                        label: ProductFormat.shortDate(date, locale: locale),
                        icon: Icons.calendar_today_outlined,
                        selected: state.selectedDate == date,
                        onTap: () => cubit.toggleDate(date),
                      ),
                      const SizedBox(width: AppSizes.spacingXs),
                    ],
                    AppChip(
                      label: switch (state.sort) {
                        FlightSort.none => LocaleKeys.flight_sort_none,
                        FlightSort.price => LocaleKeys.flight_sort_price,
                        FlightSort.departure =>
                          LocaleKeys.flight_sort_departure,
                      }.translate,
                      icon: Icons.tune,
                      selected: state.sort != FlightSort.none,
                      onTap: cubit.cycleSort,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
