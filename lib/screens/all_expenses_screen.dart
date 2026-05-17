import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import '../utils/theme.dart';
import '../utils/formatters.dart';
import '../widgets/expense_list_item.dart';

class AllExpensesScreen extends StatefulWidget {
  const AllExpensesScreen({super.key});

  @override
  State<AllExpensesScreen> createState() => _AllExpensesScreenState();
}

class _AllExpensesScreenState extends State<AllExpensesScreen> {
  ExpenseCategory? _filterCategory;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, _) {
        final filtered = provider.expenses.where((e) {
          final matchesCategory =
              _filterCategory == null || e.category == _filterCategory;
          final matchesSearch = _searchQuery.isEmpty ||
              e.title
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
          return matchesCategory && matchesSearch;
        }).toList();

        return Scaffold(
          backgroundColor: AppTheme.bgDark,
          appBar: AppBar(
            backgroundColor: AppTheme.bgDark,
            title: ShaderMask(
              shaderCallback: (b) =>
                  AppTheme.warningGradient.createShader(b),
              child: Text(
                'ALL EXPENSES',
                style: GoogleFonts.rajdhani(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                ),
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: GoogleFonts.spaceGrotesk(
                      color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search expenses...',
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppTheme.textSecondary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded,
                                color: AppTheme.textSecondary),
                            onPressed: () =>
                                setState(() => _searchQuery = ''),
                          )
                        : null,
                  ),
                ),
              ),
              // Category filter chips
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _filterChip('All', null),
                    ...ExpenseCategory.values
                        .map((c) => _filterChip(c.name, c)),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Total bar
              if (filtered.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.neonCyan.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${filtered.length} expense${filtered.length > 1 ? 's' : ''}',
                          style: GoogleFonts.spaceGrotesk(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          Formatters.currency(filtered.fold(
                              0.0, (s, e) => s + e.amount)),
                          style: GoogleFonts.spaceMono(
                            color: AppTheme.neonCyan,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off_rounded,
                                color: AppTheme.textSecondary, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              'No expenses found',
                              style: GoogleFonts.spaceGrotesk(
                                  color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) => ExpenseListItem(
                          expense: filtered[i],
                          onDelete: () =>
                              provider.deleteExpense(filtered[i].id),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip(String label, ExpenseCategory? category) {
    final isSelected = _filterCategory == category;
    final color = category?.color ?? AppTheme.neonPink;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _filterCategory = category),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : AppTheme.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : color.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (category != null) ...[
                Icon(category.icon, color: color, size: 14),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: GoogleFonts.rajdhani(
                  color: isSelected ? color : AppTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
