import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ui_kit/src/theme/app_radius.dart';
import 'package:ui_kit/src/theme/app_sizes.dart';
import 'package:ui_kit/src/theme/app_theme_extension.dart';

/// One skeleton block (radiusSmall). Only meaningful inside [LoadingState].
final class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    this.width,
    this.height = 16,
    this.borderRadius = AppRadius.small,
    super.key,
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.appTheme.shimmerBase,
        borderRadius: borderRadius,
      ),
    );
  }
}

/// Kit `LoadingState` — shimmer skeleton (shimmerBase → shimmerHighlight).
///
/// Default constructor renders [itemCount] copies of [skeleton] in a list
/// (e.g. three FlightCard skeletons). [LoadingState.custom] shimmers any
/// layout built from [ShimmerBox]es (profile header + tiles, detail hero).
final class LoadingState extends StatelessWidget {
  const LoadingState({
    required Widget this.skeleton,
    this.itemCount = 3,
    this.padding = const EdgeInsets.all(AppSizes.pagePadding),
    super.key,
  }) : child = null;

  const LoadingState.custom({
    required Widget this.child,
    this.padding = const EdgeInsets.all(AppSizes.pagePadding),
    super.key,
  }) : skeleton = null,
       itemCount = 0;

  final Widget? skeleton;
  final Widget? child;
  final int itemCount;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    final body = child != null
        ? SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: padding,
            child: child,
          )
        : ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: padding,
            itemCount: itemCount,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSizes.spacingM),
            itemBuilder: (_, _) => skeleton!,
          );
    return Semantics(
      label: MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
      child: Shimmer.fromColors(
        baseColor: ext.shimmerBase,
        highlightColor: ext.shimmerHighlight,
        child: body,
      ),
    );
  }
}
