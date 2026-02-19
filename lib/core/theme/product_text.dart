import 'package:flight_booking/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

/// Theme-backed text widget. Use named constructors (e.g. [ProductText.h1])
/// for consistent typography; style is taken from [BuildContext] theme.
final class ProductText extends Text {
  const ProductText(
    super.data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.maxLines,
    super.textWidthBasis,
    super.textHeightBehavior,
  }) : super();

  /// Display Large
  /// fontSize: 57
  /// fontWeight: FontWeight.w400
  /// letterSpacing: -0.25
  ProductText.h1(
    BuildContext context,
    super.data, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    Color? color,
  }) : super(
         style: Theme.of(context).textTheme.displayLarge?.copyWith(
           color: color ?? context.colorScheme.onPrimary,
         ),
       );

  /// Headline Large
  /// fontSize: 32
  /// fontWeight: FontWeight.w400
  /// letterSpacing: 0.0
  ProductText.h2(
    BuildContext context,
    super.data, {
    super.key,
    TextStyle? style,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(
         style: Theme.of(context).textTheme.headlineLarge?.copyWith(
           color: context.colorScheme.onPrimary,
         ),
       );

  /// Headline Medium
  /// fontSize: 28
  /// fontWeight: FontWeight.w400
  /// letterSpacing: 0.0
  ProductText.h3(
    BuildContext context,
    super.data, {
    super.key,
    TextStyle? style,
    super.textAlign,
    super.maxLines,
    super.overflow,
    Color? color,
  }) : super(
         style: style ??
             Theme.of(context).textTheme.headlineMedium?.copyWith(
               color: color ?? context.colorScheme.onPrimary,
             ),
       );

  /// Headline Small
  /// fontSize: 24
  /// fontWeight: FontWeight.w400
  /// letterSpacing: 0.0
  ProductText.h4(
    BuildContext context,
    super.data, {
    super.key,
    TextStyle? style,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(
         style: style ?? Theme.of(context).textTheme.headlineSmall,
       );

  /// Title Large
  /// fontSize: 22
  /// fontWeight: FontWeight.w500
  /// letterSpacing: 0.0
  ProductText.titleLarge(
    BuildContext context,
    super.data, {
    super.key,
    TextStyle? style,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(
         style: style ?? Theme.of(context).textTheme.titleLarge,
       );

  /// Title Medium
  /// fontSize: 16
  /// fontWeight: FontWeight.w500
  /// letterSpacing: 0.15
  ProductText.titleMedium(
    BuildContext context,
    super.data, {
    super.key,
    TextStyle? style,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(
         style: style ?? Theme.of(context).textTheme.titleMedium,
       );

  /// Title Small
  /// fontSize: 14
  /// fontWeight: FontWeight.w500
  /// letterSpacing: 0.1
  ProductText.titleSmall(
    BuildContext context,
    super.data, {
    super.key,
    TextStyle? style,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(
         style: style ?? Theme.of(context).textTheme.titleSmall,
       );

  /// Body Large
  /// fontSize: 16
  /// fontWeight: FontWeight.w400
  /// letterSpacing: 0.5
  ProductText.bodyLarge(
    BuildContext context,
    super.data, {
    super.key,
    TextStyle? style,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(
         style: style ?? Theme.of(context).textTheme.bodyLarge,
       );

  /// Body Medium
  /// fontSize: 14
  /// fontWeight: FontWeight.w400
  /// letterSpacing: 0.25
  ProductText.bodyMedium(
    BuildContext context,
    super.data, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    Color? color,
  }) : super(
         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
           color: color ?? context.colorScheme.onPrimary,
         ),
       );

  /// Body Small
  /// fontSize: 12
  /// fontWeight: FontWeight.w400
  /// letterSpacing: 0.4
  ProductText.bodySmall(
    BuildContext context,
    super.data, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    Color? color,
  }) : super(
         style: Theme.of(context).textTheme.bodySmall?.copyWith(
           color: color ?? context.colorScheme.onPrimary,
         ),
       );

  /// Label Large
  /// fontSize: 14
  /// fontWeight: FontWeight.w500
  /// letterSpacing: 0.1
  ProductText.labelLarge(
    BuildContext context,
    super.data, {
    super.key,
    TextStyle? style,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(
         style: style ?? Theme.of(context).textTheme.labelLarge,
       );

  ProductText.labelMedium(
    BuildContext context,
    super.data, {
    super.key,
    TextStyle? style,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(
         style: style ?? Theme.of(context).textTheme.labelMedium,
       );

  ProductText.labelSmall(
    BuildContext context,
    super.data, {
    super.key,
    TextStyle? style,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(
         style: style ?? Theme.of(context).textTheme.labelSmall,
       );
}
