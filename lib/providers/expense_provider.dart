import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../models/budget.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [];
  Budget _budget = Budget(monthlyBudget: 50000, categoryBudgets: {});
  bool _isLoading = false;

  final _uuid = const Uuid();

  List<Expense> get expenses => _expenses;
  Budget get budget => _budget;
  bool get isLoading => _isLoading;

  ExpenseProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    // Load expenses
    final expensesJson = prefs.getStringList('expenses') ?? [];
    _expenses = expensesJson
        .map((e) => Expense.fromJson(jsonDecode(e)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    // Load budget
    final budgetJson = prefs.getString('budget');
    if (budgetJson != null) {
      _budget = Budget.fromJson(jsonDecode(budgetJson));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson =
        _expenses.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('expenses', expensesJson);
  }

  Future<void> _saveBudget() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('budget', jsonEncode(_budget.toJson()));
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    String? note,
  }) async {
    final expense = Expense(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      category: category,
      date: date,
      note: note,
    );
    _expenses.insert(0, expense);
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    await _saveExpenses();
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
    await _saveExpenses();
    notifyListeners();
  }

  Future<void> updateBudget(Budget budget) async {
    _budget = budget;
    await _saveBudget();
    notifyListeners();
  }

  // Analytics
  double get totalThisMonth {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.month == now.month && e.date.year == now.year)
        .fold(0, (sum, e) => sum + e.amount);
  }

  double get totalThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDay =
        DateTime(weekStart.year, weekStart.month, weekStart.day);
    return _expenses
        .where((e) => e.date.isAfter(weekStartDay) ||
            e.date.isAtSameMomentAs(weekStartDay))
        .fold(0, (sum, e) => sum + e.amount);
  }

  double get totalToday {
    final now = DateTime.now();
    return _expenses
        .where((e) =>
            e.date.day == now.day &&
            e.date.month == now.month &&
            e.date.year == now.year)
        .fold(0, (sum, e) => sum + e.amount);
  }

  Map<ExpenseCategory, double> get categoryTotals {
    final Map<ExpenseCategory, double> totals = {};
    final now = DateTime.now();
    for (final expense in _expenses.where(
        (e) => e.date.month == now.month && e.date.year == now.year)) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  List<double> get last7DaysExpenses {
    final List<double> daily = List.filled(7, 0);
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: 6 - i));
      daily[i] = _expenses
          .where((e) =>
              e.date.day == day.day &&
              e.date.month == day.month &&
              e.date.year == day.year)
          .fold(0, (sum, e) => sum + e.amount);
    }
    return daily;
  }

  List<Expense> get recentExpenses => _expenses.take(10).toList();

  double get budgetUsedPercentage {
    if (_budget.monthlyBudget <= 0) return 0;
    return (totalThisMonth / _budget.monthlyBudget).clamp(0.0, 1.0);
  }

  List<Expense> getExpensesByCategory(ExpenseCategory category) {
    return _expenses.where((e) => e.category == category).toList();
  }

  double get averageDailySpend {
    if (_expenses.isEmpty) return 0;
    final now = DateTime.now();
    final daysInMonth = now.day;
    return totalThisMonth / daysInMonth;
  }
}
