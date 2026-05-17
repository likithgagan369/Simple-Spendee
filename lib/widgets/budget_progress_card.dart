import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../utils/theme.dart';
import '../utils/formatters.dart';

class BudgetProgressCard extends StatelessWidget {
  final double spent;
  final double budget;
  final double percentage;

  const BudgetProgressCard({
    super.key,
    required this.spent,
    required this.budget,
    required this.percentage,
  });

  Color get _progressColor {
    if (percentage < 0.5) return AppTheme.neonGreen;
    if (percentage < 0.75) return AppTheme.neonYellow;
    if (percentage < 0.9) return AppTheme.neonOrange;
    return AppTheme.neonPink;
  }

  String get _statusText {
    if (percentage < 0.5) return 'ON TRACK 🚀';
    if (percentage < 0.75) return 'CAREFUL ⚡';
    if (percentage < 0.9) return 'WARNING 🔥';
    return 'OVERSPENT 💥';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.bgCard,
            AppTheme.bgCardLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _progressColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _progressColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MONTHLY BUDGET',
                    style: GoogleFonts.rajdhani(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.currency(budget),
                    style: GoogleFonts.spaceMono(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _progressColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _progressColor.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Text(
                  _statusText,
                  style: GoogleFonts.rajdhani(
                    color: _progressColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LinearPercentIndicator(
            lineHeight: 12,
            percent: percentage.clamp(0.0, 1.0),
            backgroundColor: AppTheme.bgCardLight,
            linearGradient: LinearGradient(
              colors: percentage > 0.9
                  ? [AppTheme.neonOrange, AppTheme.neonPink]
                  : [_progressColor.withOpacity(0.7), _progressColor],
            ),
            barRadius: const Radius.circular(6),
            padding: EdgeInsets.zero,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SPENT',
                    style: GoogleFonts.rajdhani(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    Formatters.currency(spent),
                    style: GoogleFonts.spaceMono(
                      color: _progressColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '${(percentage * 100).toStringAsFixed(0)}%',
                style: GoogleFonts.rajdhani(
                  color: _progressColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'REMAINING',
                    style: GoogleFonts.rajdhani(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    Formatters.currency((budget - spent).clamp(0, budget)),
                    style: GoogleFonts.spaceMono(
                      color: AppTheme.neonCyan,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
