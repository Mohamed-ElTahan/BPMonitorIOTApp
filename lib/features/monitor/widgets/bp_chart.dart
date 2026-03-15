import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class BpChart extends StatelessWidget {
  final List<double> dataPoints;

  const BpChart({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20,
          verticalInterval: 25,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: AppColors.lightCardBorder, strokeWidth: 1),
          getDrawingVerticalLine: (value) =>
              FlLine(color: AppColors.lightCardBorder, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(color: Colors.white54, fontSize: 8),
              ),
              reservedSize: 20,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: AppColors.lightCardBorder.withValues(alpha: 1),
          ),
        ),
        minX: 0,
        maxX: 150,
        minY: -5,
        maxY: 200,
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            curveSmoothness: 0.35,
            color: AppColors.bpAmber,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.bpAmber.withValues(alpha: 0.3),
                  AppColors.bpAmber.withValues(alpha: 0.0),
                ],
              ),
            ),
            shadow: const Shadow(
              color: AppColors.bpAmber,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ),
        ],
      ),
    );
  }
}
