import 'package:flutter/material.dart';

/// Theme-backed text. Pick the role by constructor; color defaults to the
/// theme (`onSurface`), pass `color` only for a semantic override such as
/// `colorScheme.onSurfaceVariant`.
///
/// Headings follow the design mapping: h1 → headlineMedium,
/// h2 → headlineSmall, h3 → titleLarge, h4 → titleMedium.
final class ProductText extends Text {
  const ProductText(
    super.data, {
    super.key,
    super.style,
    super.textAlign,
    super.maxLines,
    super.overflow,
  });

  ProductText._role(
    TextStyle? base,
    super.data, {
    super.key,
    Color? color,
    TextStyle? style,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(
         style: (base ?? const TextStyle()).merge(style).copyWith(color: color),
       );

  ProductText.h1(
    BuildContext context,
    String data, {
    Key? key,
    Color? color,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) : this._role(
         Theme.of(context).textTheme.headlineMedium,
         data,
         key: key,
         color: color,
         style: style,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
       );

  ProductText.h2(
    BuildContext context,
    String data, {
    Key? key,
    Color? color,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) : this._role(
         Theme.of(context).textTheme.headlineSmall,
         data,
         key: key,
         color: color,
         style: style,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
       );

  ProductText.h3(
    BuildContext context,
    String data, {
    Key? key,
    Color? color,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) : this._role(
         Theme.of(context).textTheme.titleLarge,
         data,
         key: key,
         color: color,
         style: style,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
       );

  ProductText.h4(
    BuildContext context,
    String data, {
    Key? key,
    Color? color,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) : this._role(
         Theme.of(context).textTheme.titleMedium,
         data,
         key: key,
         color: color,
         style: style,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
       );

  ProductText.titleLarge(
    BuildContext context,
    String data, {
    Key? key,
    Color? color,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) : this._role(
         Theme.of(context).textTheme.titleLarge,
         data,
         key: key,
         color: color,
         style: style,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
       );

  ProductText.titleMedium(
    BuildContext context,
    String data, {
    Key? key,
    Color? color,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) : this._role(
         Theme.of(context).textTheme.titleMedium,
         data,
         key: key,
         color: color,
         style: style,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
       );

  ProductText.titleSmall(
    BuildContext context,
    String data, {
    Key? key,
    Color? color,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) : this._role(
         Theme.of(context).textTheme.titleSmall,
         data,
         key: key,
         color: color,
         style: style,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
       );

  ProductText.bodyLarge(
    BuildContext context,
    String data, {
    Key? key,
    Color? color,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) : this._role(
         Theme.of(context).textTheme.bodyLarge,
         data,
         key: key,
         color: color,
         style: style,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
       );

  ProductText.bodyMedium(
    BuildContext context,
    String data, {
    Key? key,
    Color? color,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) : this._role(
         Theme.of(context).textTheme.bodyMedium,
         data,
         key: key,
         color: color,
         style: style,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
       );

  ProductText.bodySmall(
    BuildContext context,
    String data, {
    Key? key,
    Color? color,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) : this._role(
         Theme.of(context).textTheme.bodySmall,
         data,
         key: key,
         color: color,
         style: style,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
       );

  ProductText.labelLarge(
    BuildContext context,
    String data, {
    Key? key,
    Color? color,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) : this._role(
         Theme.of(context).textTheme.labelLarge,
         data,
         key: key,
         color: color,
         style: style,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
       );

  ProductText.labelMedium(
    BuildContext context,
    String data, {
    Key? key,
    Color? color,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) : this._role(
         Theme.of(context).textTheme.labelMedium,
         data,
         key: key,
         color: color,
         style: style,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
       );

  ProductText.labelSmall(
    BuildContext context,
    String data, {
    Key? key,
    Color? color,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) : this._role(
         Theme.of(context).textTheme.labelSmall,
         data,
         key: key,
         color: color,
         style: style,
         textAlign: textAlign,
         maxLines: maxLines,
         overflow: overflow,
       );
}
