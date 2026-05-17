import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme.dart';
import '../utils/formatters.dart';

class WeeklyBarChart extends StatefulWidget {
  final List<double> dailyExpenses;

  const WeeklyBarChart({super.key, required this.dailyExpenses});

  @override
  State<WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart> {
  int? _touchedIndex;

  List<String> get _days {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return Formatters.dayOfWeek(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxVal = widget.dailyExpenses.isEmpty
        ? 1000.0
        : widget.dailyExpenses.reduce((a, b) => a > b ? a : b);
    final chartMax = maxVal <= 0 ? 1000.0 : maxVal * 1.3;

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
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'WEEKLY SPENDING',
                style: GoogleFonts.rajdhani(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '7 DAYS',
                  style: GoogleFonts.rajdhani(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: chartMax,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    setState(() {
                      if (response != null &&
                          response.spot != null &&
                          event is! FlPointerExitEvent) {
                        _touchedIndex =
                            response.spot!.touchedBarGroupIndex;
                      } else {
                        _touchedIndex = null;
                      }
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppTheme.bgCardLight,
                    tooltipRoundedRadius: 10,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        Formatters.currencyCompact(rod.toY),
                        GoogleFonts.spaceMono(
                          color: AppTheme.neonPink,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox();
                        return Text(
                          Formatters.currencyCompact(value),
                          style: GoogleFonts.spaceMono(
                            color: AppTheme.textSecondary,
                            fontSize: 9,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _days.length) {
                          return const SizedBox();
                        }
                        final isToday = idx == 6;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _days[idx],
                            style: GoogleFonts.rajdhani(
                              color: isToday
                                  ? AppTheme.neonCyan
                                  : AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: isToday
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: chartMax / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withOpacity(0.05),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: widget.dailyExpenses
                    .asMap()
                    .entries
                    .map(
                      (entry) => BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value <= 0 ? 0.01 : entry.value,
                            width: 22,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            gradient: _touchedIndex == entry.key
                                ? AppTheme.accentGradient
                                : entry.key == 6
                                    ? AppTheme.primaryGradient
                                    : LinearGradient(
                                        colors: [
                                          AppTheme.neonPurple
                                              .withOpacity(0.7),
                                          AppTheme.neonPink.withOpacity(0.4),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
              swapAnimationDuration: const Duration(milliseconds: 500),
              swapAnimationCurve: Curves.easeInOutCubic,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statChip('Today', Formatters.currencyCompact(
                  widget.dailyExpenses.isNotEmpty
                      ? widget.dailyExpenses.last
                      : 0), AppTheme.neonCyan),
              _statChip(
                'Peak',
                widget.dailyExpenses.isEmpty
                    ? '₹0'
                    : Formatters.currencyCompact(widget.dailyExpenses
                        .reduce((a, b) => a > b ? a : b)),
                AppTheme.neonPink,
              ),
              _statChip(
                'Avg',
                widget.dailyExpenses.isEmpty
                    ? '₹0'
                    : Formatters.currencyCompact(widget.dailyExpenses
                            .reduce((a, b) => a + b) /
                        widget.dailyExpenses.length),
                AppTheme.neonYellow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.spaceMono(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.rajdhani(
              color: AppTheme.textSecondary,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
