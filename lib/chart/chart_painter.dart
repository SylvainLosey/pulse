import 'package:flutter/material.dart';
import '../models.dart';
import 'segment_data.dart';
import 'chart_layout.dart';
import 'segment_geometry.dart';

class ChartPainter extends CustomPainter {
  final List<CategoryAmount> income;
  final List<CategoryAmount> expenses;
  final double totalIncome;
  final double totalExpenses;
  final List<Color> greenShades;
  final List<Color> redShades;
  final ChartLayout layout;
  final Function(BarData income, BarData expenses) onBarsCreated;

  ChartPainter({
    required this.income,
    required this.expenses,
    required this.totalIncome,
    required this.totalExpenses,
    required this.greenShades,
    required this.redShades,
    required this.layout,
    required this.onBarsCreated,
  });

  void _drawGrid(Canvas canvas, double maxAmount) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    final textStyle = TextStyle(
      color: Colors.grey[400],
      fontSize: 14,
    );

    final axisLabelMargin = 60.0;

    for (int i = 0; i <= 5; i++) {
      final y = layout.chartHeight * (1 - i / 5);
      canvas.drawLine(
        Offset(axisLabelMargin, y),
        Offset(layout.usableWidth - 40, y),
        paint,
      );

      final amount = (maxAmount * i / 5);
      final formattedAmount = amount >= 1000
          ? '${(amount / 1000).toStringAsFixed(1)}k'
          : amount.toInt().toString();

      final textSpan = TextSpan(
        text: formattedAmount,
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(4, y - textPainter.height / 2),
      );
    }
  }

  BarData _createAndDrawBar({
    required Canvas canvas,
    required List<CategoryAmount> items,
    required double x,
    required double total,
    required double maxAmount,
    required List<Color> colors,
    required bool isIncome,
    required String label,
  }) {
    final barRect = layout.getBarRect(x);
    final segmentPadding = 4.0;
    final totalPadding = (items.length - 1) * segmentPadding;
    final adjustedHeight = barRect.height - totalPadding;
    final segments = <ChartSegment>[];

    double currentY = barRect.bottom;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final segmentHeight = (item.amount / maxAmount) * adjustedHeight;
      final yOffset = i * segmentPadding;

      final bounds = Rect.fromLTWH(
        barRect.left,
        currentY - segmentHeight - yOffset,
        barRect.width,
        segmentHeight,
      );

      final geometry = ChartSegmentGeometry.withMargin(
        bounds: bounds,
        margin: layout.margin,
        borderRadius: 8,
      );

      final segment = ChartSegment(
        category: item,
        color: colors[i],
        geometry: geometry,
      );

      segments.add(segment);
      segment.draw(canvas);

      // Draw the text
      _drawSegmentLabel(
        canvas: canvas,
        text: item.category,
        bounds: bounds,
        height: segmentHeight,
      );

      currentY -= segmentHeight + segmentPadding;
    }

    return BarData(
      segments: segments,
      x: x + layout.margin,
      width: barRect.width,
      label: label,
      isIncome: isIncome,
    );
  }

  void _drawSegmentLabel({
    required Canvas canvas,
    required String text,
    required Rect bounds,
    required double height,
  }) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: height < 60 ? 12 : 14,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(maxWidth: bounds.width - 16);

    textPainter.paint(
      canvas,
      Offset(
        bounds.left + (bounds.width - textPainter.width) / 2,
        bounds.top + (bounds.height - textPainter.height) / 2,
      ),
    );
  }

  void _drawLabels(Canvas canvas) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    final incomePainter = TextPainter(
      text: TextSpan(text: 'Income', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final expensesPainter = TextPainter(
      text: TextSpan(text: 'Expenses', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    incomePainter.paint(
      canvas,
      Offset(layout.incomeX - incomePainter.width / 2,
          layout.chartHeight + layout.margin / 2),
    );

    expensesPainter.paint(
      canvas,
      Offset(layout.expensesX - expensesPainter.width / 2,
          layout.chartHeight + layout.margin / 2),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final maxAmount = totalIncome > totalExpenses ? totalIncome : totalExpenses;

    canvas.save();
    canvas.translate(layout.margin, layout.margin);

    _drawGrid(canvas, maxAmount);

    final incomeBar = _createAndDrawBar(
      canvas: canvas,
      items: income,
      x: layout.incomeX,
      total: totalIncome,
      maxAmount: maxAmount,
      colors: greenShades,
      isIncome: true,
      label: 'Income',
    );

    final expensesBar = _createAndDrawBar(
      canvas: canvas,
      items: expenses,
      x: layout.expensesX,
      total: totalExpenses,
      maxAmount: maxAmount,
      colors: redShades,
      isIncome: false,
      label: 'Expenses',
    );

    _drawLabels(canvas);

    canvas.restore();

    // Notify the widget of the created bars
    onBarsCreated(incomeBar, expensesBar);
  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) => true;
}
