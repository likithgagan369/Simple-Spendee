import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/budget.dart';
import '../utils/theme.dart';
import '../utils/formatters.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ExpenseProvider>();
    _budgetController = TextEditingController(
        text: provider.budget.monthlyBudget.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

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
                  AppTheme.successGradient.createShader(b),
              child: Text(
                'SETTINGS',
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
              // Budget Section
              _sectionHeader('BUDGET', AppTheme.neonGreen),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppTheme.neonGreen.withOpacity(0.3), width: 1),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MONTHLY BUDGET LIMIT',
                      style: GoogleFonts.rajdhani(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₹ ',
                          style: GoogleFonts.spaceMono(
                            color: AppTheme.neonGreen,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _budgetController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: GoogleFonts.spaceMono(
                              color: AppTheme.textPrimary,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              hintText: '50000',
                              hintStyle: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF2A2A3E)),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        final val = double.tryParse(_budgetController.text);
                        if (val != null && val > 0) {
                          await provider.updateBudget(Budget(
                            monthlyBudget: val,
                            categoryBudgets:
                                provider.budget.categoryBudgets,
                          ));
                          HapticFeedback.mediumImpact();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Budget updated!',
                                  style: GoogleFonts.spaceGrotesk(),
                                ),
                                backgroundColor: AppTheme.neonGreen
                                    .withOpacity(0.9),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.successGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'SAVE BUDGET',
                            style: GoogleFonts.rajdhani(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // App info section
              _sectionHeader('APP INFO', AppTheme.neonCyan),
              const SizedBox(height: 12),
              Container(
                decoration: AppTheme.cyanCardDecoration,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _infoRow('Version', '1.0.0'),
                    _infoRow('Total Expenses',
                        provider.expenses.length.toString()),
                    _infoRow('This Month',
                        Formatters.currency(provider.totalThisMonth)),
                    _infoRow('Budget',
                        Formatters.currency(provider.budget.monthlyBudget)),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Danger Zone
              _sectionHeader('DANGER ZONE', AppTheme.neonPink),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppTheme.neonPink.withOpacity(0.3), width: 1),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clear all expense data permanently. This cannot be undone.',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _confirmClear(context, provider),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.neonPink.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppTheme.neonPink.withOpacity(0.5)),
                        ),
                        child: Center(
                          child: Text(
                            'CLEAR ALL DATA',
                            style: GoogleFonts.rajdhani(
                              color: AppTheme.neonPink,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Credits
              Center(
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (b) =>
                          AppTheme.primaryGradient.createShader(b),
                      child: Text(
                        'SPENDIX',
                        style: GoogleFonts.rajdhani(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                    Text(
                      'Smart Expense Tracker',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.rajdhani(
            color: AppTheme.textSecondary,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.spaceMono(
              color: AppTheme.neonCyan,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClear(BuildContext context, ExpenseProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side:
              BorderSide(color: AppTheme.neonPink.withOpacity(0.3), width: 1),
        ),
        title: Text(
          'Clear All Data?',
          style: GoogleFonts.rajdhani(
            color: AppTheme.neonPink,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'This will permanently delete all your expense records. This action cannot be undone.',
          style: GoogleFonts.spaceGrotesk(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'CANCEL',
              style: GoogleFonts.rajdhani(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Clear by deleting all
              for (final e in List.from(provider.expenses)) {
                await provider.deleteExpense(e.id);
              }
              if (context.mounted) Navigator.pop(ctx);
            },
            child: Text(
              'DELETE ALL',
              style: GoogleFonts.rajdhani(
                color: AppTheme.neonPink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
