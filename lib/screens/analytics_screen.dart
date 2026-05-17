import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../utils/theme.dart';
import '../utils/formatters.dart';
import '../models/expense.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/weekly_bar_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppTheme.bgDark,
          appBar: AppBar(
            backgroundColor: AppTheme.bgDark,
            title: ShaderMask(
              shaderCallback: (b) =>
                  AppTheme.accentGradient.createShader(b),
              child: Text(
                'ANALYTICS',
                style: GoogleFonts.rajdhani(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 4,
                ),
              ),
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Monthly summary cards
              _buildMonthSummary(provider),
              const SizedBox(height: 16),

              // Weekly chart
              WeeklyBarChart(dailyExpenses: provider.last7DaysExpenses),
              const SizedBox(height: 16),

              // Category Breakdown
              CategoryPieChart(
                  categoryTotals: provider.categoryTotals),
              const SizedBox(height: 16),

              // Top expenses by category
              _buildTopCategories(provider),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthSummary(ExpenseProvider provider) {
    return Container(
      decoration: AppTheme.cyanCardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                Formatters.monthYear(DateTime.now()).toUpperCase(),
                style: GoogleFonts.rajdhani(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  'TOTAL SPENT',
                  Formatters.currency(provider.totalThisMonth),
                  AppTheme.neonPink,
                ),
              ),
              Container(width: 1, height: 50, color: AppTheme.bgCardLight),
              Expanded(
                child: _summaryItem(
                  'TRANSACTIONS',
                  provider.expenses
                      .where((e) =>
                          e.date.month == DateTime.now().month &&
                          e.date.year == DateTime.now().year)
                      .length
                      .toString(),
                  AppTheme.neonCyan,
                ),
              ),
              Container(width: 1, height: 50, color: AppTheme.bgCardLight),
              Expanded(
                child: _summaryItem(
                  'DAILY AVG',
                  Formatters.currencyCompact(provider.averageDailySpend),
                  AppTheme.neonYellow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.spaceMono(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.rajdhani(
            color: AppTheme.textSecondary,
            fontSize: 10,
            letterSpacing: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTopCategories(ExpenseProvider provider) {
    final totals = provider.categoryTotals;
    if (totals.isEmpty) return const SizedBox();

    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      decoration: AppTheme.neonCardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: AppTheme.warningGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'TOP CATEGORIES',
                style: GoogleFonts.rajdhani(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...sorted.asMap().entries.map((entry) {
            final rank = entry.key + 1;
            final cat = entry.value.key;
            final amount = entry.value.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: rank == 1
                          ? AppTheme.neonYellow.withOpacity(0.2)
                          : AppTheme.bgCardLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: rank == 1
                            ? AppTheme.neonYellow.withOpacity(0.5)
                            : AppTheme.textSecondary.withOpacity(0.2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '#$rank',
                        style: GoogleFonts.rajdhani(
                          color: rank == 1
                              ? AppTheme.neonYellow
                              : AppTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: cat.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: cat.color.withOpacity(0.3), width: 1),
                    ),
                    child: Icon(cat.icon, color: cat.color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      cat.name,
                      style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    Formatters.currency(amount),
                    style: GoogleFonts.spaceMono(
                      color: cat.color,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
