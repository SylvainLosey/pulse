import 'package:flutter/material.dart';
import 'models.dart';
import 'chart/chart_layout.dart';
import 'chart/chart_painter.dart';
import 'chart/chart_hit_detector.dart';
import 'chart/chart_tooltip.dart';

class CashFlowChart extends StatefulWidget {
  final MonthlyCashFlow cashFlow;

  const CashFlowChart({super.key, required this.cashFlow});

  @override
  State<CashFlowChart> createState() => _CashFlowChartState();
}

class _CashFlowChartState extends State<CashFlowChart> {
  CategoryAmount? selectedCategory;
  Offset? tooltipPosition;

  List<Color> _generateColorShades(Color baseColor, int count) {
    if (count <= 1) return [baseColor];

    final hslColor = HSLColor.fromColor(baseColor);
    final lightnessStep = (0.7 - 0.3) / (count - 1);

    return List.generate(count, (index) {
      return hslColor.withLightness(0.3 + (lightnessStep * index)).toColor();
    });
  }

  List<Color> get incomeColors => _generateColorShades(
        const Color(0xFF4CAF50), // Material Green
        widget.cashFlow.income.length,
      );

  List<Color> get expenseColors => _generateColorShades(
        const Color(0xFFF44336), // Material Red
        widget.cashFlow.expenses.length,
      );

  void _handleTap(Offset position, ChartHitDetector detector) {
    final hit = detector.detectHit(position);
    setState(() {
      if (hit != null) {
        selectedCategory = hit.category;
        tooltipPosition = Offset(position.dx, position.dy - 8);
      } else {
        selectedCategory = null;
        tooltipPosition = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sort the income and expenses lists by amount in ascending order
    final sortedIncome = List<CategoryAmount>.from(widget.cashFlow.income)
      ..sort((a, b) => a.amount.compareTo(b.amount));
    final sortedExpenses = List<CategoryAmount>.from(widget.cashFlow.expenses)
      ..sort((a, b) => a.amount.compareTo(b.amount));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.cashFlow.month,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              final layout = ChartLayout(size: size);
              final detector = ChartHitDetector(
                layout: layout,
                cashFlow: widget.cashFlow,
              );

              return Stack(
                children: [
                  GestureDetector(
                    onTapDown: (details) => _handleTap(
                      details.localPosition,
                      detector,
                    ),
                    child: CustomPaint(
                      painter: ChartPainter(
                        income: sortedIncome,
                        expenses: sortedExpenses,
                        totalIncome: widget.cashFlow.totalIncome,
                        totalExpenses: widget.cashFlow.totalExpenses,
                        greenShades: incomeColors,
                        redShades: expenseColors,
                        layout: layout,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                  if (selectedCategory != null && tooltipPosition != null)
                    Positioned(
                      left: tooltipPosition!.dx,
                      top: tooltipPosition!.dy,
                      child: ChartTooltip(
                        category: selectedCategory!,
                        onTap: () => setState(() {
                          selectedCategory = null;
                          tooltipPosition = null;
                        }),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
