import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class BpChart extends StatelessWidget {
  final List<double> dataPoints;

  const BpChart({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    const double maxPoints = 300.0;
    const double gridIntervalY = 25.0; // Large grid every 20 mmHg
    const double smallGridIntervalY = 10.0; // Small grid every 10 mmHg

    const double gridIntervalX = 50.0; // Large grid every 50 points
    const double smallGridIntervalX = 10.0; // Small grid every 10 points

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 25, 10),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: true,
              horizontalInterval: smallGridIntervalY,
              verticalInterval: smallGridIntervalX,
              getDrawingHorizontalLine: (value) {
                final isLarge = (value % gridIntervalY).abs() < 0.01;
                return FlLine(
                  color: isLarge
                      ? Colors.grey.withValues(alpha: 0.15)
                      : Colors.grey.withValues(alpha: 0.03),
                  strokeWidth: isLarge ? 1 : 0.5,
                );
              },
              getDrawingVerticalLine: (value) {
                final isLarge = (value % gridIntervalX).abs() < 0.01;
                return FlLine(
                  color: isLarge
                      ? Colors.grey.withValues(alpha: 0.15)
                      : Colors.grey.withValues(alpha: 0.03),
                  strokeWidth: isLarge ? 1 : 0.5,
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                axisNameWidget: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    'mmHg',
                    style: AppTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                axisNameSize: 22,
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: gridIntervalY,
                  getTitlesWidget: (value, meta) {
                    if (value < 0 || value > 200) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        value.toInt().toString(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                  reservedSize: 28,
                ),
              ),
              bottomTitles: AxisTitles(
                axisNameWidget: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'number of points',
                    style: AppTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                axisNameSize: 22,
                sideTitleAlignment: SideTitleAlignment.outside,
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: gridIntervalX,
                  getTitlesWidget: (value, meta) {
                    if (value < 0 || value > maxPoints) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 9,
                        ),
                      ),
                    );
                  },
                  reservedSize: 22,
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: maxPoints,
            minY: 0,
            maxY: 200,
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value))
                    .toList(),
                isCurved: true,
                curveSmoothness: 0.4,
                color: AppColors.bpAmber,
                barWidth: 2.2,
                shadow: Shadow(
                  color: AppColors.bpAmber.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.bpAmber.withValues(alpha: 0.12),
                      AppColors.bpAmber.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
