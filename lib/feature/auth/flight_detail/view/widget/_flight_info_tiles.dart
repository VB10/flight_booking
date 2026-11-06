part of '../../flight_detail_page.dart';

/// 2x2 grid of optional flight facts; a tile shows only when its value
/// exists and the grid hides when none does.
final class _FlightInfoTiles extends StatelessWidget {
  const _FlightInfoTiles({required this.flight});

  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    final entries = <(String, String)>[
      if (flight.flightNumber case final value?)
        (LocaleKeys.flight_detail_tile_flight.translate, value),
      if (flight.aircraftType case final value?)
        (LocaleKeys.flight_detail_tile_aircraft.translate, value),
      if (flight.seatClass case final value?)
        (LocaleKeys.flight_detail_tile_class.translate, value),
      if (flight.baggageAllowance case final value?)
        (LocaleKeys.flight_detail_tile_baggage.translate, value),
    ];
    if (entries.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.spacingM),
      child: Wrap(
        spacing: AppSizes.spacingXs,
        runSpacing: AppSizes.spacingXs,
        children: [
          for (final (label, value) in entries)
            _FlightInfoTile(label: label, value: value),
        ],
      ),
    );
  }
}

final class _FlightInfoTile extends StatelessWidget {
  const _FlightInfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    // Two columns: half of the page width minus the gap between tiles.
    final width =
        (MediaQuery.sizeOf(context).width -
            AppSizes.pagePadding * 2 -
            AppSizes.spacingXs) /
        2;
    return SizedBox(
      width: width,
      child: AppCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingM,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductText.bodySmall(
              context,
              label,
              color: context.colorScheme.onSurfaceVariant,
            ),
            ProductText.titleMedium(context, value),
          ],
        ),
      ),
    );
  }
}
