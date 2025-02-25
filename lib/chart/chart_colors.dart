import 'package:flutter/material.dart';

/// Utility class to generate color shades for the chart bars
class ChartColors {
  /// Creates a list of color shades from a base color
  /// [baseColor] - The starting color
  /// [count] - Number of shades needed
  /// Returns darker shades of the base color
  static List<Color> generateShades(Color baseColor, int count) {
    if (count <= 1) return [baseColor];

    final hslColor = HSLColor.fromColor(baseColor);
    final lightnessStep = 0.3 / (count - 1);

    return List.generate(count, (index) {
      return hslColor.withLightness(0.65 - (lightnessStep * index)).toColor();
    });
  }

  // Predefined colors for income and expenses
  static const incomeColor = Color(0xFF4CAF50);
  static const expenseColor = Color(0xFFF44336);
}
