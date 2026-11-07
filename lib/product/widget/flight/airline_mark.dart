import 'package:flight_booking/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Kit `AirlineMark` — 40px primaryContainer circle with the aircraft glyph.
/// No real logos: every airline gets the same neutral mark.
final class AirlineMark extends StatelessWidget {
  const AirlineMark({this.size = 40, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.flight,
        size: size / 2,
        color: scheme.onPrimaryContainer,
      ),
    );
  }
}
