part of '../../profile_page.dart';

/// Header card, stat tiles and account details of a loaded profile.
class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.profile});

  final ProfileData profile;

  AppTone get _membershipTone =>
      switch (profile.membershipLevel.toLowerCase()) {
        'gold' => AppTone.warning,
        'silver' => AppTone.neutral,
        _ => AppTone.info,
      };

  @override
  Widget build(BuildContext context) {
    final joined = ProductFormat.date(
      profile.joinDate,
      locale: context.productLocale.toLanguageTag(),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Row(
            children: [
              AppAvatar(initials: AppAvatar.initialsOf(profile.name)),
              const SizedBox(width: AppSizes.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductText.h2(context, profile.name),
                    const SizedBox(height: 4),
                    ProductText.bodyMedium(
                      context,
                      profile.email,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 4),
                    StatusBadge(
                      label: profile.membershipLevel,
                      tone: _membershipTone,
                      icon: Icons.workspace_premium_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spacingXs),
        Row(
          children: [
            Expanded(
              child: StatTile(
                value: '${profile.totalBookings}',
                label: LocaleKeys.profile_total_bookings.translate,
              ),
            ),
            const SizedBox(width: AppSizes.spacingXs),
            Expanded(
              child: StatTile(
                value: joined,
                label: LocaleKeys.profile_member_since.translate,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spacingM),
        AppCard(
          child: Column(
            children: [
              InfoRow(
                icon: Icons.tag,
                label: LocaleKeys.profile_account_id.translate,
                value: '${profile.id}',
              ),
              InfoRow(
                icon: Icons.mail_outline,
                label: LocaleKeys.profile_email.translate,
                value: profile.email,
              ),
              InfoRow(
                icon: Icons.calendar_today_outlined,
                label: LocaleKeys.profile_joined.translate,
                value: joined,
              ),
              InfoRow(
                icon: Icons.workspace_premium_outlined,
                label: LocaleKeys.profile_membership.translate,
                value: profile.membershipLevel,
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
