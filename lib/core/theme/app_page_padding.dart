import 'package:flutter/material.dart';

/// Page-level padding and margin. Extends [EdgeInsets] with const constructors
/// to avoid getter allocation. Use for screen-edge insets and list/card spacing.
final class AppPagePadding extends EdgeInsets {
  /// [10] padding all
  const AppPagePadding.all10() : super.all(_spacingS);

  /// [15] padding all
  const AppPagePadding.all15() : super.all(15);

  /// [16] padding all
  const AppPagePadding.all16() : super.all(_spacingM);

  /// [20] padding all
  const AppPagePadding.all20() : super.all(_spacingL);

  /// [24] padding all
  const AppPagePadding.all24() : super.all(_spacingXl);

  /// [32] padding all
  const AppPagePadding.all32() : super.all(_spacingXXl);

  /// [20] horizontal symmetric
  const AppPagePadding.horizontalSymmetric()
    : super.symmetric(horizontal: _spacingL);

  /// [16] horizontal symmetric
  const AppPagePadding.horizontalSymmetricMedium()
    : super.symmetric(horizontal: _spacingM);

  /// [24] horizontal symmetric
  const AppPagePadding.horizontalSymmetricLarge()
    : super.symmetric(horizontal: _spacingXl);

  /// [20] vertical symmetric
  const AppPagePadding.verticalSymmetric()
    : super.symmetric(vertical: _spacingL);

  /// [8] vertical symmetric (alias: page vertical 8)
  const AppPagePadding.verticalSymmetricSmall()
    : super.symmetric(vertical: _spacingXs);

  /// [8] page vertical (same as verticalSymmetricSmall)
  const AppPagePadding.pageVertical8() : super.symmetric(vertical: _spacingXs);

  /// [16] vertical symmetric
  const AppPagePadding.verticalSymmetricMedium()
    : super.symmetric(vertical: _spacingM);

  /// [24] vertical symmetric
  const AppPagePadding.verticalSymmetricLarge()
    : super.symmetric(vertical: _spacingXl);

  /// [8] margin bottom
  const AppPagePadding.marginBottom8() : super.only(bottom: _spacingXs);

  /// [10] margin bottom
  const AppPagePadding.marginBottom10() : super.only(bottom: _spacingS);

  /// [12] margin bottom
  const AppPagePadding.marginBottom12() : super.only(bottom: 12);

  /// [15] margin bottom
  const AppPagePadding.marginBottom15() : super.only(bottom: 15);

  /// [16] margin bottom
  const AppPagePadding.marginBottom16() : super.only(bottom: _spacingM);

  /// [20] margin bottom
  const AppPagePadding.marginBottom20() : super.only(bottom: _spacingL);

  /// [24] margin bottom
  const AppPagePadding.marginBottom24() : super.only(bottom: _spacingXl);

  /// [32] margin bottom
  const AppPagePadding.marginBottom32() : super.only(bottom: _spacingXXl);

  // ignore: prefer_const_constructors_in_immutables -- runtime value
  /// [8] horizontal symmetric free
  AppPagePadding.horizontalSymmetricFree(double horizontal)
    : super.symmetric(horizontal: horizontal);
  // ignore: prefer_const_constructors_in_immutables -- runtime value
  AppPagePadding.verticalSymmetricFree(double vertical)
    : super.symmetric(vertical: vertical);

  static const double _spacingXs = 8;
  static const double _spacingS = 10;
  static const double _spacingM = 16;
  static const double _spacingL = 20;
  static const double _spacingXl = 24;
  static const double _spacingXXl = 32;
}
