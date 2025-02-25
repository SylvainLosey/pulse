import 'package:flutter/material.dart';

class ChartSegmentGeometry {
  final Rect drawBounds;
  final Rect hitBounds;
  final RRect drawRRect;
  final RRect hitRRect;

  ChartSegmentGeometry({
    required this.drawBounds,
    required this.hitBounds,
    required double borderRadius,
  })  : drawRRect = RRect.fromRectAndRadius(
          drawBounds,
          Radius.circular(borderRadius),
        ),
        hitRRect = RRect.fromRectAndRadius(
          hitBounds,
          Radius.circular(borderRadius),
        );

  /// Creates geometry that accounts for canvas translation
  factory ChartSegmentGeometry.withMargin({
    required Rect bounds,
    required double margin,
    required double borderRadius,
  }) {
    return ChartSegmentGeometry(
      drawBounds: bounds,
      hitBounds: bounds.translate(margin, margin),
      borderRadius: borderRadius,
    );
  }
}
