import 'package:flutter/material.dart';
import 'models.dart';
import 'chart/chart_layout.dart';
import 'chart/chart_painter.dart';
import 'chart/chart_hit_detector.dart';
import 'chart/chart_tooltip.dart';
import 'chart/segment_data.dart';

class CashFlowChart extends StatefulWidget {
  final MonthlyCashFlow cashFlow;

  const CashFlowChart({super.key, required this.cashFlow});

  @override
  State<CashFlowChart> createState() => _CashFlowChartState();
}

class _CashFlowChartState extends State<CashFlowChart> {
  CategoryAmount? selectedCategory;
  Offset? tooltipPosition;
  BarData? incomeBar;
  BarData? expensesBar;

  List<Color> _generateColorShades(Color baseColor, int count) {
    if (count <= 1) return [baseColor];

    final hslColor = HSLColor.fromColor(baseColor);
    final lightnessStep = 0.3 / (count - 1);

    return List.generate(count, (index) {
      return hslColor.withLightness(0.65 - (lightnessStep * index)).toColor();
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

  void _handleTap(Offset position) {
    setState(() {
      final incomeHit = incomeBar?.hitTest(position);
      final expensesHit = expensesBar?.hitTest(position);

      final hit = incomeHit ?? expensesHit;
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
    final sortedIncome = List<CategoryAmount>.from(widget.cashFlow.income)
      ..sort((a, b) => b.amount.compareTo(a.amount));
    final sortedExpenses = List<CategoryAmount>.from(widget.cashFlow.expenses)
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final layout = ChartLayout(size: size);

        return Stack(
          children: [
            GestureDetector(
              onTapDown: (details) => _handleTap(details.localPosition),
              child: CustomPaint(
                painter: ChartPainter(
                  income: sortedIncome,
                  expenses: sortedExpenses,
                  totalIncome: widget.cashFlow.totalIncome,
                  totalExpenses: widget.cashFlow.totalExpenses,
                  greenShades: incomeColors,
                  redShades: expenseColors,
                  layout: layout,
                  onBarsCreated: (income, expenses) {
                    incomeBar = income;
                    expensesBar = expenses;
                  },
                ),
                size: size,
              ),
            ),
            if (selectedCategory != null && tooltipPosition != null)
              Positioned(
                left: 0,
                top: 0,
                child: ChartTooltip(
                  category: selectedCategory!,
                  onTap: () => setState(() {
                    selectedCategory = null;
                    tooltipPosition = null;
                  }),
                  constraints: constraints,
                  position: tooltipPosition!,
                ),
              ),
          ],
        );
      },
    );
  }
}
