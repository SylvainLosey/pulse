import 'package:flutter/material.dart';
import '../models.dart';
import 'chart_layout.dart';

class ChartHitDetector {
  final ChartLayout layout;
  final MonthlyCashFlow cashFlow;

  ChartHitDetector({
    required this.layout,
    required this.cashFlow,
  });

  double get maxAmount => cashFlow.totalIncome > cashFlow.totalExpenses
      ? cashFlow.totalIncome
      : cashFlow.totalExpenses;

  CategoryHit? detectHit(Offset position) {
    // Check if tap is within any bar's bounds
    if ((position.dx - layout.incomeX).abs() < layout.barWidth / 2) {
      final category = _findTappedCategory(position.dy, cashFlow.income);
      if (category != null) {
        return CategoryHit(category: category, isIncome: true);
      }
    } else if ((position.dx - layout.expensesX).abs() < layout.barWidth / 2) {
      final category = _findTappedCategory(position.dy, cashFlow.expenses);
      if (category != null) {
        return CategoryHit(category: category, isIncome: false);
      }
    }
    return null;
  }

  CategoryAmount? _findTappedCategory(
    double tapY,
    List<CategoryAmount> categories,
  ) {
    double currentY = layout.margin + layout.chartHeight;

    for (int i = categories.length - 1; i >= 0; i--) {
      final category = categories[i];
      final segmentHeight = (category.amount / maxAmount) * layout.chartHeight;
      final yOffset = (categories.length - 1 - i) * 4.0;

      final segmentBottom = currentY - yOffset;
      final segmentTop = segmentBottom - segmentHeight;

      if (tapY >= segmentTop && tapY <= segmentBottom) {
        return category;
      }

      currentY -= segmentHeight;
    }
    return null;
  }
}

class CategoryHit {
  final CategoryAmount category;
  final bool isIncome;

  CategoryHit({required this.category, required this.isIncome});
}
