import 'package:flutter/material.dart';
import '../models.dart';
import 'segment_geometry.dart';

class ChartSegment {
  final CategoryAmount category;
  final Color color;
  final ChartSegmentGeometry geometry;

  const ChartSegment({
    required this.category,
    required this.color,
    required this.geometry,
  });

  bool containsPoint(Offset point) {
    return geometry.hitRRect.contains(point);
  }

  void draw(Canvas canvas) {
    canvas.drawRRect(
      geometry.drawRRect,
      Paint()..color = color,
    );
  }
}

class BarData {
  final List<ChartSegment> segments;
  final double x;
  final double width;
  final String label;
  final bool isIncome;

  BarData({
    required this.segments,
    required this.x,
    required this.width,
    required this.label,
    required this.isIncome,
  });

  ChartSegment? hitTest(Offset point) {
    return segments.cast<ChartSegment?>().firstWhere(
          (segment) => segment!.containsPoint(point),
          orElse: () => null,
        );
  }
}
