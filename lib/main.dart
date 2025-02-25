import 'package:flutter/material.dart';
import 'cash_flow_chart.dart';
import 'models.dart';
import 'month_scale.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cashFlows = [
      MonthlyCashFlow(
        month: 'February 2025',
        income: [
          CategoryAmount(category: 'Salary', amount: 7200),
          CategoryAmount(category: 'Side Project', amount: 500),
          CategoryAmount(category: 'Investments', amount: 350),
        ],
        expenses: [
          CategoryAmount(category: 'Rent', amount: 2400),
          CategoryAmount(category: 'Groceries', amount: 900),
          CategoryAmount(category: 'Health Insurance', amount: 420),
          CategoryAmount(category: 'Transport', amount: 280),
          CategoryAmount(category: 'Restaurants', amount: 450),
          CategoryAmount(category: 'Entertainment', amount: 350),
          CategoryAmount(category: 'Internet & Phone', amount: 140),
        ],
      ),
      MonthlyCashFlow(
        month: 'January 2025',
        income: [
          CategoryAmount(category: 'Salary', amount: 7200),
          CategoryAmount(category: 'Side Project', amount: 450),
          CategoryAmount(category: 'Investments', amount: 320),
        ],
        expenses: [
          CategoryAmount(category: 'Rent', amount: 2400),
          CategoryAmount(category: 'Groceries', amount: 880),
          CategoryAmount(category: 'Health Insurance', amount: 420),
          CategoryAmount(category: 'Transport', amount: 270),
          CategoryAmount(category: 'Restaurants', amount: 420),
          CategoryAmount(category: 'Entertainment', amount: 380),
          CategoryAmount(category: 'Internet & Phone', amount: 140),
        ],
      ),
      MonthlyCashFlow(
        month: 'December 2024',
        income: [
          CategoryAmount(category: 'Salary', amount: 7100),
          CategoryAmount(category: 'Side Project', amount: 600),
          CategoryAmount(category: 'Investments', amount: 300),
        ],
        expenses: [
          CategoryAmount(category: 'Rent', amount: 2400),
          CategoryAmount(category: 'Groceries', amount: 950),
          CategoryAmount(category: 'Health Insurance', amount: 420),
          CategoryAmount(category: 'Transport', amount: 260),
          CategoryAmount(category: 'Restaurants', amount: 500),
          CategoryAmount(category: 'Entertainment', amount: 400),
          CategoryAmount(category: 'Internet & Phone', amount: 140),
        ],
      ),
    ];

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1F2B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1F2B),
          elevation: 0,
        ),
      ),
      home: _HomeScreen(cashFlows: cashFlows),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  final List<MonthlyCashFlow> cashFlows;

  const _HomeScreen({required this.cashFlows});

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  void _handleMonthChange(int direction) {
    final newIndex = currentIndex + direction;
    if (newIndex >= 0 && newIndex < widget.cashFlows.length) {
      _pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                reverse: true,
                itemCount: widget.cashFlows.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return CashFlowChart(
                    cashFlow: widget.cashFlows[index],
                    onMonthChanged: _handleMonthChange,
                  );
                },
              ),
            ),
            MonthScale(
              cashFlows: widget.cashFlows,
              currentIndex: currentIndex,
            ),
          ],
        ),
      ),
    );
  }
}
