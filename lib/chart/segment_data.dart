import 'package:flutter/material.dart';
import '../models.dart';

class ChartSegment {
  final Rect bounds;
  final CategoryAmount category;
  final Color color;
  final RRect roundedBounds;

  ChartSegment({
    required this.bounds,
    required this.category,
    required this.color,
    required this.roundedBounds,
  });
}

class BarData {
  final List<ChartSegment> segments;
  final double x;
  final double width;
  final String label;

  BarData({
    required this.segments,
    required this.x,
    required this.width,
    required this.label,
  });
}
