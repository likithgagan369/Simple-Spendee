import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/expense_provider.dart';
import '../utils/theme.dart';
import '../utils/formatters.dart';
import '../widgets/weekly_bar_chart.dart';
import '../widgets/expense_list_item.dart';
import '../widgets/budget_progress_card.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppTheme.bgDark,
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, provider),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Stats Row
                    _buildStatsRow(provider),
                    const SizedBox(height: 16),

                    // Budget Progress
                    BudgetProgressCard(
                      spent: provider.totalThisMonth,
                      budget: provider.budget.monthlyBudget,
                      percentage: provider.budgetUsedPercentage,
                    ),
                    const SizedBox(height: 16),

                    // Weekly Chart
                    WeeklyBarChart(
                        dailyExpenses: provider.last7DaysExpenses),
                    const SizedBox(height: 16),

                    // Recent Transactions header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              'RECENT',
                              style: GoogleFonts.rajdhani(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        if (provider.expenses.isNotEmpty)
                          Text(
                            '${provider.expenses.length} total',
                            style: GoogleFonts.spaceMono(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Expense list
                    if (provider.isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                            color: AppTheme.neonPink),
                      )
                    else if (provider.expenses.isEmpty)
                      _buildEmptyState(context)
                    else
                      AnimationLimiter(
                        child: Column(
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 375),
                            childAnimationBuilder: (widget) =>
                                SlideAnimation(
                              verticalOffset: 50.0,
                              child:
                                  FadeInAnimation(child: widget),
                            ),
                            children: provider.recentExpenses
                                .map((expense) => ExpenseListItem(
                                      expense: expense,
                                      onDelete: () =>
                                          provider.deleteExpense(expense.id),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 80),
                  ]),
                ),
              ),
            ],
          ),
          floatingActionButton: _buildFAB(context),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, ExpenseProvider provider) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.bgDark,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.bgDark,
                AppTheme.neonPink.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_greeting()},',
                    style: GoogleFonts.spaceGrotesk(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        AppTheme.primaryGradient.createShader(bounds),
                    child: Text(
                      'SPENDIX',
                      style: GoogleFonts.rajdhani(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'THIS MONTH',
                    style: GoogleFonts.rajdhani(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    Formatters.currencyCompact(provider.totalThisMonth),
                    style: GoogleFonts.spaceMono(
                      color: AppTheme.neonCyan,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(ExpenseProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            'TODAY',
            Formatters.currencyCompact(provider.totalToday),
            Icons.today_rounded,
            AppTheme.neonCyan,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            'THIS WEEK',
            Formatters.currencyCompact(provider.totalThisWeek),
            Icons.date_range_rounded,
            AppTheme.neonPurple,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            'DAILY AVG',
            Formatters.currencyCompact(provider.averageDailySpend),
            Icons.analytics_rounded,
            AppTheme.neonYellow,
          ),
        ),
      ],
    );
  }

  Widget _statCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.07),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.spaceMono(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.rajdhani(
              color: AppTheme.textSecondary,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                AppTheme.primaryGradient.createShader(bounds),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'NO EXPENSES YET',
            style: GoogleFonts.rajdhani(
              color: AppTheme.textSecondary,
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first expense',
            style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textSecondary.withOpacity(0.6),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonPink.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, color: Colors.black, size: 22),
                SizedBox(width: 8),
                Text(
                  'ADD EXPENSE',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
