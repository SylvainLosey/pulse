import 'package:flutter/material.dart';

class ChartLayout {
  final Size size;
  final double margin;
  final double barWidth;

  late final double usableWidth;
  late final double usableHeight;
  late final double chartHeight;

  ChartLayout({
    required this.size,
    this.margin = 24.0,
    this.barWidth = 120.0,
  }) {
    usableWidth = size.width - (margin * 2);
    usableHeight = size.height - (margin * 2);
    chartHeight = usableHeight * 0.9;
    print('ChartLayout initialized:');
    print('Size: $size');
    print('Usable size: ${Size(usableWidth, usableHeight)}');
    print('Chart height: $chartHeight');
  }

  double get incomeX => usableWidth * 0.3;
  double get expensesX => usableWidth * 0.7;

  Rect getBarRect(double x) {
    final rect = Rect.fromLTWH(x - barWidth / 2, 0, barWidth, chartHeight);
    print('Bar rect at x=$x: $rect');
    return rect;
  }
}
