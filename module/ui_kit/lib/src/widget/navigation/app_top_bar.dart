import 'package:flutter/material.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';
import 'package:ui_kit/src/widget/button/app_icon_button.dart';

/// Kit `AppTopBar` — surface, titleLarge, height 64, 20 left padding
/// (4 when there is a back button), trailing action icons.
final class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    required this.title,
    this.actions = const [],
    this.onBack,
    this.backTooltip,
    super.key,
  });

  final String title;
  final List<Widget> actions;

  /// When set, a back button is shown and calls this.
  final VoidCallback? onBack;

  /// Semantics label of the back button (localized by the app).
  final String? backTooltip;

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final hasBack = onBack != null;
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: AppSizes.appBarHeight,
      titleSpacing: hasBack ? 4 : AppSizes.pagePadding,
      leading: hasBack
          ? AppIconButton(
              icon: Icons.arrow_back,
              tooltip:
                  backTooltip ??
                  MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: onBack,
              color: Theme.of(context).colorScheme.onSurface,
            )
          : null,
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [...actions, const SizedBox(width: 4)],
    );
  }
}
