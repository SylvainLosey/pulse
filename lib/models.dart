class MonthlyCashFlow {
  final String month;
  final List<CategoryAmount> income;
  final List<CategoryAmount> expenses;

  MonthlyCashFlow({
    required this.month,
    required this.income,
    required this.expenses,
  });

  double get totalIncome => income.fold(0, (sum, item) => sum + item.amount);
  double get totalExpenses =>
      expenses.fold(0, (sum, item) => sum + item.amount);
}

class CategoryAmount {
  final String category;
  final double amount;

  CategoryAmount({
    required this.category,
    required this.amount,
  });
}
