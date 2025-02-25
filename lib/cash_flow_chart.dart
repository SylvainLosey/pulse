import 'package:flutter/material.dart';
import 'models.dart';
import 'chart/chart_layout.dart';
import 'chart/chart_painter.dart';
import 'chart/chart_tooltip.dart';
import 'chart/chart_colors.dart';
import 'chart/chart_gestures.dart';
import 'chart/segment_data.dart';

/// A chart that displays monthly income and expenses
class CashFlowChart extends StatefulWidget {
  final MonthlyCashFlow cashFlow;
  final ValueChanged<int>? onMonthChanged;

  const CashFlowChart({
    super.key,
    required this.cashFlow,
    this.onMonthChanged,
  });

  @override
  State<CashFlowChart> createState() => _CashFlowChartState();
}

class _CashFlowChartState extends State<CashFlowChart> {
  // State for tooltip
  CategoryAmount? selectedCategory;
  Offset? tooltipPosition;

  // References to the bars for hit testing
  BarData? incomeBar;
  BarData? expensesBar;

  // Gesture handler for month navigation
  late final _gestureHandler = ChartGestureHandler(
    onMonthChanged: widget.onMonthChanged ?? (_) {},
  );

  /// Handles taps on the chart bars
  void _handleTap(Offset position) {
    setState(() {
      final hit =
          incomeBar?.hitTest(position) ?? expensesBar?.hitTest(position);
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
    // Sort categories by amount for consistent display
    final sortedIncome = List<CategoryAmount>.from(widget.cashFlow.income)
      ..sort((a, b) => b.amount.compareTo(a.amount));
    final sortedExpenses = List<CategoryAmount>.from(widget.cashFlow.expenses)
      ..sort((a, b) => b.amount.compareTo(a.amount));

    // Generate color shades for the bars
    final incomeColors = ChartColors.generateShades(
      ChartColors.incomeColor,
      sortedIncome.length,
    );
    final expenseColors = ChartColors.generateShades(
      ChartColors.expenseColor,
      sortedExpenses.length,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final layout = ChartLayout(size: size);

        return GestureDetector(
          onTapDown: (details) => _handleTap(details.localPosition),
          onHorizontalDragStart: _gestureHandler.handleDragStart,
          onHorizontalDragEnd: _gestureHandler.handleDragEnd,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              // Chart bars
              CustomPaint(
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
              // Tooltip
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
          ),
        );
      },
    );
  }
}
