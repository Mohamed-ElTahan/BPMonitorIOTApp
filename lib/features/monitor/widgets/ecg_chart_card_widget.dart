import 'package:flutter/material.dart';
import 'ecg_chart.dart';

class EcgChartCardWidget extends StatelessWidget {
  final bool isConnected;
  final List<double> ecgData;

  const EcgChartCardWidget({
    super.key,
    required this.isConnected,
    required this.ecgData,
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
            Text(
              "ECG Waveform",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (isConnected) {
                    return EcgChart(dataPoints: ecgData);
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
