part of '../../flight_detail_page.dart';

/// Shimmer twin of the content: hero, four info rows, tiles, price.
final class _FlightDetailSkeleton extends StatelessWidget {
  const _FlightDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return LoadingState.custom(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(height: 176, borderRadius: AppRadius.large),
          const SizedBox(height: AppSizes.spacingM),
          for (var i = 0; i < 4; i++)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  ShimmerBox(
                    width: AppSizes.touchTarget - 4,
                    height: AppSizes.touchTarget - 4,
                    borderRadius: AppRadius.large,
                  ),
                  SizedBox(width: AppSizes.spacingM),
                  ShimmerBox(width: 80, height: 14),
                  Spacer(),
                  ShimmerBox(width: 56, height: 14),
                ],
              ),
            ),
          const SizedBox(height: AppSizes.spacingS),
          const Row(
            children: [
              Expanded(
                child: ShimmerBox(height: 64, borderRadius: AppRadius.medium),
              ),
              SizedBox(width: AppSizes.spacingXs),
              Expanded(
                child: ShimmerBox(height: 64, borderRadius: AppRadius.medium),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingL),
          const ShimmerBox(width: 48, height: 12),
          const SizedBox(height: AppSizes.spacingXs),
          const ShimmerBox(width: 104, height: 28),
        ],
      ),
    );
  }
}
