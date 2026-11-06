import 'package:flight_booking/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// The kit route line (`.rt`): dot — line — plane — line — dot.
/// Used inside `FlightCard` and `RouteVisual`.
final class RouteLine extends StatelessWidget {
  const RouteLine({this.color, this.lineColor, super.key});

  final Color? color;
  final Color? lineColor;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final line = lineColor ?? scheme.outlineVariant;
    Widget dot() => Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: lineColor ?? scheme.outline, width: 2),
      ),
    );
    Widget bar() => Expanded(
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          color: line,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
    return ExcludeSemantics(
      child: Row(
        children: [
          dot(),
          bar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Transform.rotate(
              angle: 1.5708,
              child: Icon(
                Icons.flight,
                size: 20,
                color: color ?? scheme.primary,
              ),
            ),
          ),
          bar(),
          dot(),
        ],
      ),
    );
  }
}
