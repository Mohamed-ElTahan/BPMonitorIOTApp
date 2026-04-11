import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class EcgChart extends StatefulWidget {
  final List<double> dataPoints;
  final double samplingRate;

  const EcgChart({
    super.key,
    required this.dataPoints,
    this.samplingRate = 100.0,
  });

  @override
  State<EcgChart> createState() => _EcgChartState();
}

class _EcgChartState extends State<EcgChart> {
  final ScrollController _scrollController = ScrollController();
  bool _autoScroll = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    if (_autoScroll && _scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());

    // ── Grid Constants (Standard ECG Paper) ──────────────────────────────────
    final double smallBoxX = widget.samplingRate * 0.04;
    final double largeBoxX = widget.samplingRate * 0.20;
    const double smallBoxY = 0.1;
    const double largeBoxY = 0.5;

    final Color smallGridColor = Colors.red.withValues(alpha: 0.15);
    final Color largeGridColor = Colors.red.withValues(alpha: 0.4);

    // Horizontal Scale: How many pixels per data point?
    // Let's aim for 1 small box (0.04s) = 8 Logical Pixels (approx 1-2mm on typical screen)
    final double pixelsPerPoint = 8.0 / smallBoxX;
    final double minWidth = MediaQuery.sizeOf(context).width - 32;
    final double calculatedWidth = widget.dataPoints.length * pixelsPerPoint;
    final double chartWidth = calculatedWidth > minWidth
        ? calculatedWidth
        : minWidth;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0), // Clinical ECG Paper Pink Tint
        borderRadius: BorderRadius.circular(12),
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            final isAtEnd =
                _scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 10;
            if (_autoScroll != isAtEnd) {
              setState(() => _autoScroll = isAtEnd);
            }
          }
          return false;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: chartWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: true,
                    horizontalInterval: smallBoxY,
                    verticalInterval: smallBoxX,
                    getDrawingHorizontalLine: (value) {
                      final isLargeBox =
                          (value / largeBoxY).roundToDouble() * largeBoxY ==
                          value;
                      return FlLine(
                        color: isLargeBox ? largeGridColor : smallGridColor,
                        strokeWidth: isLargeBox ? 1.0 : 0.4,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      final isLargeBox =
                          (value / largeBoxX).roundToDouble() * largeBoxX ==
                          value;
                      return FlLine(
                        color: isLargeBox ? largeGridColor : smallGridColor,
                        strokeWidth: isLargeBox ? 1.0 : 0.4,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles: AxisTitles(
                      axisNameWidget: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'mV',
                          style: AppTheme.textTheme.labelSmall?.copyWith(
                            color: Colors.red.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      axisNameSize: 22,
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 0.5,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: TextStyle(
                              color: Colors.red.shade900.withValues(alpha: 0.6),
                              fontSize: 9,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text(
                        'Time (s)',
                        style: AppTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.red.shade800,
                        ),
                      ),
                      axisNameSize: 20,
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: widget.samplingRate, // Every 1 second
                        reservedSize: 24,
                        getTitlesWidget: (value, meta) {
                          final seconds = (value / widget.samplingRate).toInt();
                          return Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '${seconds}s',
                              style: TextStyle(
                                color: Colors.red.shade900.withValues(
                                  alpha: 0.6,
                                ),
                                fontSize: 9,
                              ),
                            ),
                          );
                        },
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
                  maxX: widget.dataPoints.length < 100
                      ? 105
                      : widget.dataPoints.length.toDouble(),
                  minY: -2,
                  maxY: 3.3,
                  lineBarsData: [
                    LineChartBarData(
                      spots: widget.dataPoints
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: false,
                      color: const Color(0xFF212121),
                      barWidth: 1.5,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
