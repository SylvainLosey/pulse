import 'package:flutter/material.dart';
import '../models.dart';
import 'segment_data.dart';
import 'chart_layout.dart';

class ChartPainter extends CustomPainter {
  final List<CategoryAmount> income;
  final List<CategoryAmount> expenses;
  final double totalIncome;
  final double totalExpenses;
  final List<Color> greenShades;
  final List<Color> redShades;
  final ChartLayout layout;

  late final List<ChartSegment> _segments;

  ChartPainter({
    required this.income,
    required this.expenses,
    required this.totalIncome,
    required this.totalExpenses,
    required this.greenShades,
    required this.redShades,
    required this.layout,
  }) {
    _segments = [];
  }

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

  void _drawBar(
    Canvas canvas,
    Rect barRect,
    List<CategoryAmount> items,
    double total,
    double maxAmount,
    List<Color> colors,
  ) {
    double currentHeight = barRect.height; // Start from the top
    final segmentPadding = 4.0;
    final totalPadding = (items.length - 1) * segmentPadding;
    final adjustedHeight = barRect.height - totalPadding;

    // Draw segments from bottom to top
    for (int i = items.length - 1; i >= 0; i--) {
      final item = items[i];
      final segmentHeight = (item.amount / maxAmount) * adjustedHeight;
      final yOffset = (items.length - 1 - i) * segmentPadding;

      currentHeight -= segmentHeight;

      final segmentRect = Rect.fromLTWH(
        barRect.left,
        currentHeight - yOffset,
        barRect.width,
        segmentHeight,
      );

      final rrect = RRect.fromRectAndRadius(
        segmentRect,
        Radius.circular(8),
      );

      // Store the segment with its RRect for precise hit testing
      final segment = ChartSegment(
        bounds: segmentRect,
        category: item,
        color: colors[i % colors.length],
        roundedBounds: rrect,
      );
      _segments.add(segment);

      // Draw the segment
      canvas.drawRRect(
        rrect,
        Paint()..color = colors[i % colors.length],
      );

      // Draw the text
      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: segmentHeight < 60 ? 12 : 14,
        fontWeight: FontWeight.bold,
      );

      final textSpan = TextSpan(
        text: item.category,
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout(maxWidth: barRect.width - 16);

      textPainter.paint(
        canvas,
        Offset(
          segmentRect.left + (segmentRect.width - textPainter.width) / 2,
          segmentRect.center.dy - textPainter.height / 2,
        ),
      );
    }
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
    _drawBars(canvas, maxAmount);
    _drawLabels(canvas);

    canvas.restore();
  }

  void _drawBars(Canvas canvas, double maxAmount) {
    _drawBar(
      canvas,
      layout.getBarRect(layout.incomeX),
      income,
      totalIncome,
      maxAmount,
      greenShades,
    );

    _drawBar(
      canvas,
      layout.getBarRect(layout.expensesX),
      expenses,
      totalExpenses,
      maxAmount,
      redShades,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
