class Budget {
  final double monthlyBudget;
  final Map<int, double> categoryBudgets; // category index -> amount

  Budget({
    required this.monthlyBudget,
    required this.categoryBudgets,
  });

  Map<String, dynamic> toJson() {
    return {
      'monthlyBudget': monthlyBudget,
      'categoryBudgets':
          categoryBudgets.map((k, v) => MapEntry(k.toString(), v)),
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    final catBudgets = <int, double>{};
    if (json['categoryBudgets'] != null) {
      (json['categoryBudgets'] as Map<String, dynamic>).forEach((k, v) {
        catBudgets[int.parse(k)] = v.toDouble();
      });
    }
    return Budget(
      monthlyBudget: json['monthlyBudget'].toDouble(),
      categoryBudgets: catBudgets,
    );
  }
}
