part of '../../profile_page.dart';

/// Shimmer skeleton: header card, two stat tiles and four account rows.
class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) {
    return LoadingState.custom(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppCard(
            child: Row(
              children: [
                ShimmerBox(
                  width: AppSizes.avatarLarge,
                  height: AppSizes.avatarLarge,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppSizes.avatarLarge),
                  ),
                ),
                SizedBox(width: AppSizes.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 140, height: 20),
                      SizedBox(height: AppSizes.spacingXs),
                      ShimmerBox(width: 180, height: 14),
                      SizedBox(height: AppSizes.spacingXs),
                      ShimmerBox(
                        width: 64,
                        height: AppSizes.statusBadgeHeight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spacingXs),
          const Row(
            children: [
              Expanded(
                child: ShimmerBox(height: 128, borderRadius: AppRadius.medium),
              ),
              SizedBox(width: AppSizes.spacingXs),
              Expanded(
                child: ShimmerBox(height: 128, borderRadius: AppRadius.medium),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingM),
          AppCard(
            child: Column(
              children: [
                for (var i = 0; i < 4; i++)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        ShimmerBox(
                          width: 40,
                          height: 40,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        SizedBox(width: AppSizes.spacingM),
                        ShimmerBox(width: 90, height: 14),
                        Spacer(),
                        ShimmerBox(width: 80, height: 14),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
