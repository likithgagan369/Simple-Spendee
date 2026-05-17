import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/expense.dart';
import '../utils/theme.dart';
import '../utils/formatters.dart';

class CategoryPieChart extends StatefulWidget {
  final Map<ExpenseCategory, double> categoryTotals;

  const CategoryPieChart({super.key, required this.categoryTotals});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.categoryTotals.isEmpty) {
      return Container(
        decoration: AppTheme.neonCardDecoration,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.pie_chart_outline_rounded,
                  color: AppTheme.textSecondary, size: 48),
              const SizedBox(height: 12),
              Text(
                'No expenses yet',
                style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    final total =
        widget.categoryTotals.values.fold(0.0, (a, b) => a + b);
    final entries = widget.categoryTotals.entries.toList();

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
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'SPENDING BREAKDOWN',
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
              SizedBox(
                width: 140,
                height: 140,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 35,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          if (response != null &&
                              response.touchedSection != null) {
                            _touchedIndex = response
                                .touchedSection!.touchedSectionIndex;
                          } else {
                            _touchedIndex = null;
                          }
                        });
                      },
                    ),
                    centerSpaceColor: AppTheme.bgCard,
                    sections: entries.asMap().entries.map((entry) {
                      final isTouched = entry.key == _touchedIndex;
                      final cat = entry.value.key;
                      final pct = entry.value.value / total;
                      return PieChartSectionData(
                        value: entry.value.value,
                        color: cat.color,
                        radius: isTouched ? 45 : 38,
                        title: pct > 0.08
                            ? '${(pct * 100).toStringAsFixed(0)}%'
                            : '',
                        titleStyle: GoogleFonts.rajdhani(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                        badgeWidget: isTouched
                            ? Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: cat.color,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(cat.icon,
                                    size: 14, color: Colors.black),
                              )
                            : null,
                        badgePositionPercentageOffset: 0.9,
                      );
                    }).toList(),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 300),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: entries.take(5).map((entry) {
                    final pct = entry.value / total;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: entry.key.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.key.name,
                              style: GoogleFonts.spaceGrotesk(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Text(
                            '${(pct * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.spaceMono(
                              color: entry.key.color,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Category breakdown bars
          ...entries.map((entry) {
            final pct = entry.value / total;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(entry.key.icon,
                          color: entry.key.color, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        entry.key.name,
                        style: GoogleFonts.spaceGrotesk(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        Formatters.currency(entry.value),
                        style: GoogleFonts.spaceMono(
                          color: entry.key.color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor:
                          entry.key.color.withOpacity(0.1),
                      valueColor:
                          AlwaysStoppedAnimation(entry.key.color),
                      minHeight: 4,
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
