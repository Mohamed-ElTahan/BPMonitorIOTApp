import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ecg_chart.dart';

class EcgChartCardWidget extends StatelessWidget {
  final bool isConnected;
  final DateTime? lastDataReceived;
  final List<double> ecgHistory;

  const EcgChartCardWidget({
    super.key,
    required this.isConnected,
    this.lastDataReceived,
    required this.ecgHistory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ECG Waveform",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Builder(
                  builder: (context) {
                    if (isConnected && lastDataReceived != null) {
                      String timeStr = DateFormat(
                        'HH:mm:ss',
                      ).format(lastDataReceived!);
                      return Text(
                        "Last update: $timeStr",
                        style: theme.textTheme.labelSmall,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (isConnected) {
                    return EcgChart(dataPoints: ecgHistory);
                  }
                  return Center(
                    child: Text(
                      "Waiting for signal...",
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
