import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EcgChart extends StatelessWidget {
  final List<double> dataPoints;

  const EcgChart({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: theme.dividerColor, strokeWidth: 1),
          getDrawingVerticalLine: (value) =>
              FlLine(color: theme.dividerColor, strokeWidth: 1),
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: theme.dividerColor),
        ),
        minX: 0,
        maxX: 150, // Fixed window size
        minY: -2, // Adjust based on expected ECG voltage range
        maxY: 2, // Adjust based on expected ECG voltage range
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
