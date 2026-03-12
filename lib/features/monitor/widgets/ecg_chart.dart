import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EcgChart extends StatelessWidget {
  final List<double> dataPoints;

  const EcgChart({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) =>
              const FlLine(color: AppColors.lightCardBorder, strokeWidth: 1),
          getDrawingVerticalLine: (value) =>
              const FlLine(color: AppColors.lightCardBorder, strokeWidth: 1),
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppColors.lightCardBorder),
        ),
        minX: 0,
        maxX: 150, // Fixed window size
        minY: -4, // Adjust based on expected ECG voltage range
        maxY: 4, // Adjust based on expected ECG voltage range
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: AppColors.ecgGreen,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.ecgGreen.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
